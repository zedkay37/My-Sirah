import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sirah_app/core/providers/journey_providers.dart';
import 'package:sirah_app/core/providers/names_providers.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';
import 'package:sirah_app/core/utils/color_utils.dart';
import 'package:sirah_app/features/journey/data/repositories/journey_repository.dart';
import 'package:sirah_app/features/journey/domain/name_progress_resolver.dart';
import 'package:sirah_app/features/journey/presentation/map/widgets/constellation_star_panel.dart';
import 'package:sirah_app/features/journey/presentation/map/widgets/journey_map_labels.dart';
import 'package:sirah_app/features/journey/presentation/map/widgets/space_map_viewport.dart';
import 'package:sirah_app/features/journey/presentation/map/widgets/starfield_background.dart';
import 'package:sirah_app/features/names/data/models/prophet_name.dart';

class ConstellationSpaceMapScreen extends ConsumerWidget {
  const ConstellationSpaceMapScreen({
    super.key,
    required this.deckId,
    required this.constellationId,
  });

  final String deckId;
  final String constellationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final journeyAsync = ref.watch(journeyRepositoryProvider);
    final layoutAsync = ref.watch(journeyMapLayoutProvider);
    final namesAsync = ref.watch(namesProvider);
    final progress = ref.watch(journeyProgressResolverProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: journeyAsync.when(
        loading: () => _Loading(color: colors.accent),
        error: (_, __) => _Error(message: context.l10n.journeyLoadError),
        data: (journey) => layoutAsync.when(
          loading: () => _Loading(color: colors.accent),
          error: (_, __) => _Error(message: context.l10n.journeyLoadError),
          data: (layout) => namesAsync.when(
            loading: () => _Loading(color: colors.accent),
            error: (_, __) => _Error(message: context.l10n.journeyLoadError),
            data: (names) => _ConstellationMapContent(
              journey: journey,
              layout: layout,
              names: names,
              deckId: deckId,
              constellationId: constellationId,
              progress: progress,
            ),
          ),
        ),
      ),
    );
  }
}

class _ConstellationMapContent extends StatefulWidget {
  const _ConstellationMapContent({
    required this.journey,
    required this.layout,
    required this.names,
    required this.deckId,
    required this.constellationId,
    required this.progress,
  });

  final JourneyRepository journey;
  final JourneyMapLayout layout;
  final List<ProphetName> names;
  final String deckId;
  final String constellationId;
  final NameProgressResolver progress;

  @override
  State<_ConstellationMapContent> createState() =>
      _ConstellationMapContentState();
}

class _ConstellationMapContentState extends State<_ConstellationMapContent> {
  int? _selectedNumber;

  @override
  Widget build(BuildContext context) {
    if (widget.layout.deckId != widget.deckId) {
      return _Error(message: context.l10n.journeyNotFound);
    }

    final constellation = widget.journey.getConstellationById(
      widget.constellationId,
    );
    if (constellation == null) {
      return _Error(message: context.l10n.journeyNotFound);
    }
    final stars = widget.layout.starsFor(widget.constellationId);
    final color = hexToColor(constellation.colorHex);
    final title = constellationDisplayTitle(constellation);
    final arabicTitle = constellationArabicTitle(constellation);
    final selectedNumber =
        _selectedNumber ?? (stars.isEmpty ? null : stars.first.number);
    final selectedName = selectedNumber == null
        ? null
        : _nameByNumber(selectedNumber);
    final stageIntensities = {
      for (final star in stars)
        star.number: _stageIntensity(widget.progress.stageFor(star.number)),
    };
    const mapSize = Size(1560, 1120);
    final screenHeight = MediaQuery.sizeOf(context).height;
    final isCompact = screenHeight < 720;
    final titleTop =
        MediaQuery.paddingOf(context).top + (isCompact ? 4.0 : 12.0);
    final mapViewPadding = EdgeInsets.only(
      top: isCompact ? 98 : 126,
      bottom: isCompact ? 146 : 168,
    );
    final controlsTop = isCompact ? 118.0 : 148.0;

    return StarfieldBackground(
      child: Stack(
        children: [
          Positioned.fill(
            child: SpaceMapViewport(
              mapSize: mapSize,
              initialScale: 0.65,
              minScale: 0.35,
              maxScale: 2.45,
              viewPadding: mapViewPadding,
              controlsPadding: EdgeInsets.only(top: controlsTop, right: 16),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _StarLinksPainter(
                        stars: stars,
                        color: color,
                        stageIntensities: stageIntensities,
                      ),
                    ),
                  ),
                  for (final star in stars)
                    _StarButton(
                      star: star,
                      name: _nameByNumber(star.number),
                      mapSize: mapSize,
                      color: color,
                      status: widget.progress.stageFor(star.number),
                      isSelected: star.number == selectedNumber,
                      onSelected: () => setState(() {
                        _selectedNumber = star.number;
                      }),
                    ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            top: titleTop,
            child: IgnorePointer(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Column(
                  children: [
                    if (arabicTitle != null) ...[
                      Text(
                        arabicTitle,
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.typo.arabicLarge.copyWith(
                          color: color,
                          fontSize: isCompact ? 30 : 38,
                          height: 1.18,
                          shadows: [
                            Shadow(
                              color: color.withValues(alpha: 0.65),
                              blurRadius: 12,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: isCompact ? 6 : 8),
                    ],
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.ltr,
                      style: context.typo.headline.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: isCompact ? 18 : 22,
                        letterSpacing: 0.5,
                        shadows: const [
                          Shadow(
                            color: Colors.black45,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (selectedNumber != null && selectedName != null)
            Positioned(
              left: 20,
              right: 20,
              bottom: isCompact ? 12 : 20,
              child: ConstellationStarPanel(
                name: selectedName,
                stage: widget.progress.stageFor(selectedNumber),
                color: color,
                onOpen: () =>
                    context.push('/name/${selectedName.number}/experience'),
              ),
            ),
          Positioned(
            left: 16,
            top: MediaQuery.paddingOf(context).top + 10,
            child: _FloatingBackButton(
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/journey/deck/${widget.deckId}');
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  ProphetName? _nameByNumber(int number) {
    for (final name in widget.names) {
      if (name.number == number) return name;
    }
    return null;
  }
}

class _StarButton extends StatelessWidget {
  const _StarButton({
    required this.star,
    required this.name,
    required this.mapSize,
    required this.color,
    required this.status,
    required this.isSelected,
    required this.onSelected,
  });

  final StarMapNode star;
  final ProphetName? name;
  final Size mapSize;
  final Color color;
  final JourneyNameStage status;
  final bool isSelected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final center = Offset(star.x * mapSize.width, star.y * mapSize.height);
    final intensity = _stageIntensity(status);
    final diameter = (34.0 + (14.0 * intensity)) * star.size;
    final selectedDiameter = diameter + 8 + (4 * intensity);
    final hitSize = (selectedDiameter + 24).clamp(56.0, 76.0);
    final isLit = intensity > 0;
    final starColor = isLit || isSelected
        ? color
        : Colors.white.withValues(alpha: 0.50);
    final fillAlpha = isSelected
        ? 0.30 + (0.10 * intensity)
        : 0.12 + (0.16 * intensity);
    final glowAlpha = isSelected
        ? 0.48 + (0.12 * intensity)
        : 0.16 + (0.22 * intensity);
    final borderAlpha = isSelected ? 1.0 : 0.46 + (0.34 * intensity);

    return Positioned(
      left: center.dx - hitSize / 2,
      top: center.dy - hitSize / 2,
      child: Semantics(
        button: true,
        selected: isSelected,
        label: name?.transliteration ?? '#${star.number}',
        child: GestureDetector(
          onTap: onSelected,
          child: SizedBox.square(
            dimension: hitSize,
            child: Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 260),
                curve: Curves.easeInOutBack,
                width: isSelected ? selectedDiameter : diameter,
                height: isSelected ? selectedDiameter : diameter,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: starColor.withValues(alpha: fillAlpha),
                  boxShadow: [
                    BoxShadow(
                      color: starColor.withValues(alpha: glowAlpha),
                      blurRadius: isSelected
                          ? 22 + (8 * intensity)
                          : 10 + (14 * intensity),
                      spreadRadius: isSelected
                          ? 4 + (4 * intensity)
                          : 1 + (3 * intensity),
                    ),
                    BoxShadow(
                      color: Colors.white.withValues(
                        alpha: isSelected ? 0.40 : 0.0,
                      ),
                      blurRadius: isSelected ? 10 : 1,
                      spreadRadius: isSelected ? 1 : 0,
                    ),
                  ],
                  border: Border.all(
                    color: starColor.withValues(alpha: borderAlpha),
                    width: isSelected ? 2.5 : 1.2,
                  ),
                ),
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.95, end: 1.05),
                  duration: const Duration(seconds: 2),
                  curve: Curves.easeInOut,
                  builder: (context, animValue, child) {
                    return Transform.scale(
                      scale: isSelected ? animValue : 1.0,
                      child: Icon(
                        _iconFor(status),
                        color: isSelected ? Colors.white : starColor,
                        size: (diameter * 0.48).clamp(16.0, 28.0),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _iconFor(JourneyNameStage status) {
    return switch (status) {
      JourneyNameStage.recognized => Icons.workspace_premium_rounded,
      JourneyNameStage.practiced => Icons.check_circle_rounded,
      JourneyNameStage.meditated => Icons.self_improvement_rounded,
      JourneyNameStage.viewed => Icons.star_rounded,
      JourneyNameStage.unknown => Icons.star_border_rounded,
    };
  }
}

class _StarLinksPainter extends CustomPainter {
  const _StarLinksPainter({
    required this.stars,
    required this.color,
    required this.stageIntensities,
  });

  final List<StarMapNode> stars;
  final Color color;
  final Map<int, double> stageIntensities;

  @override
  void paint(Canvas canvas, Size size) {
    if (stars.length < 2) return;

    for (var i = 0; i < stars.length - 1; i++) {
      final intensityA = stageIntensities[stars[i].number] ?? 0;
      final intensityB = stageIntensities[stars[i + 1].number] ?? 0;
      final linkIntensity = (intensityA + intensityB) / 2;
      final a = Offset(stars[i].x * size.width, stars[i].y * size.height);
      final b = Offset(
        stars[i + 1].x * size.width,
        stars[i + 1].y * size.height,
      );
      final paintHalo = Paint()
        ..color = color.withValues(alpha: 0.06 + (0.10 * linkIntensity))
        ..strokeWidth = 2.4 + (1.5 * linkIntensity)
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      final paintCore = Paint()
        ..color = color.withValues(alpha: 0.16 + (0.28 * linkIntensity))
        ..strokeWidth = 0.9 + (0.6 * linkIntensity)
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      canvas.drawLine(a, b, paintHalo);
      canvas.drawLine(a, b, paintCore);
    }
  }

  @override
  bool shouldRepaint(covariant _StarLinksPainter oldDelegate) {
    return oldDelegate.stars != stars ||
        oldDelegate.color != color ||
        oldDelegate.stageIntensities != stageIntensities;
  }
}

double _stageIntensity(JourneyNameStage stage) {
  return switch (stage) {
    JourneyNameStage.unknown => 0.0,
    JourneyNameStage.viewed => 0.25,
    JourneyNameStage.meditated => 0.50,
    JourneyNameStage.practiced => 0.80,
    JourneyNameStage.recognized => 1.0,
  };
}

class _FloatingBackButton extends StatelessWidget {
  const _FloatingBackButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.arrow_back_ios_new_rounded,
        color: Colors.white,
        size: 22,
      ),
      style: IconButton.styleFrom(
        backgroundColor: Colors.black.withValues(alpha: 0.38),
        shape: const CircleBorder(),
        minimumSize: const Size.square(52),
      ),
      onPressed: onPressed,
    );
  }
}

class _Loading extends StatelessWidget {
  const _Loading({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(color: color, strokeWidth: 2),
    );
  }
}

class _Error extends StatelessWidget {
  const _Error({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        message,
        style: context.typo.bodyLarge.copyWith(color: context.colors.muted),
      ),
    );
  }
}
