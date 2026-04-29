import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sirah_app/core/providers/journey_providers.dart';
import 'package:sirah_app/core/providers/names_providers.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
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
    final color = _hexToColor(constellation.colorHex);
    final title = constellationDisplayTitle(constellation);
    final arabicTitle = constellationArabicTitle(constellation);
    final selectedNumber =
        _selectedNumber ?? (stars.isEmpty ? null : stars.first.number);
    final selectedName = selectedNumber == null
        ? null
        : _nameByNumber(selectedNumber);
    const mapSize = Size(1560, 1120);
    final screenHeight = MediaQuery.sizeOf(context).height;
    final isCompact = screenHeight < 720;
    final titleTop = isCompact ? 10.0 : 20.0;
    final titleReserve = isCompact ? 108.0 : 132.0;
    final panelReserve = isCompact ? 144.0 : 176.0;

    return StarfieldBackground(
      child: Stack(
        children: [
          Positioned.fill(
            child: SpaceMapViewport(
              mapSize: mapSize,
              initialScale: 0.56,
              minScale: 0.34,
              maxScale: 2.35,
              viewPadding: EdgeInsets.only(
                top: titleReserve,
                bottom: panelReserve,
              ),
              controlsPadding: EdgeInsets.only(top: titleReserve, right: 12),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _StarLinksPainter(stars: stars, color: color),
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
            left: 32,
            right: 32,
            top: titleTop,
            child: IgnorePointer(
              child: Column(
                children: [
                  if (arabicTitle != null) ...[
                    Text(
                      arabicTitle,
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      style: context.typo.arabicLarge.copyWith(
                        color: color,
                        fontSize: isCompact ? 40 : null,
                      ),
                    ),
                    SizedBox(height: isCompact ? 2 : 6),
                  ],
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: context.typo.headline.copyWith(
                      color: Colors.white,
                      fontSize: isCompact ? 18 : null,
                    ),
                  ),
                  SizedBox(height: isCompact ? 4 : 6),
                  Text(
                    constellation.descriptionFr,
                    textAlign: TextAlign.center,
                    maxLines: isCompact ? 1 : 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.typo.caption.copyWith(
                      color: Colors.white.withValues(alpha: 0.62),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (selectedNumber != null && selectedName != null)
            Positioned(
              left: 16,
              right: 16,
              bottom: isCompact ? 10 : 16,
              child: ConstellationStarPanel(
                name: selectedName,
                stage: widget.progress.stageFor(selectedNumber),
                color: color,
                onOpen: () =>
                    context.push('/name/${selectedName.number}/experience'),
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

  Color _hexToColor(String hex) {
    final normalized = hex.replaceFirst('#', '');
    return Color(int.parse('FF$normalized', radix: 16));
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
    final diameter = 42.0 * star.size;
    final hitSize = (diameter + 18).clamp(56.0, 72.0);
    final starColor = isSelected || status != JourneyNameStage.unknown
        ? color
        : Colors.white.withValues(alpha: 0.48);

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
                duration: const Duration(milliseconds: 180),
                width: isSelected ? diameter + 8 : diameter,
                height: isSelected ? diameter + 8 : diameter,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: starColor.withValues(alpha: isSelected ? 0.22 : 0.16),
                  boxShadow: [
                    BoxShadow(
                      color: starColor.withValues(
                        alpha: isSelected ? 0.42 : 0.24,
                      ),
                      blurRadius: isSelected ? 30 : 18,
                      spreadRadius: isSelected ? 4 : 1,
                    ),
                  ],
                  border: Border.all(
                    color: starColor.withValues(
                      alpha: isSelected ? 0.96 : 0.70,
                    ),
                    width: isSelected ? 2.2 : 1.0,
                  ),
                ),
                child: Icon(
                  _iconFor(status),
                  color: starColor,
                  size: diameter * 0.48,
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
  const _StarLinksPainter({required this.stars, required this.color});

  final List<StarMapNode> stars;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (stars.length < 2) return;
    final paint = Paint()
      ..color = color.withValues(alpha: 0.24)
      ..strokeWidth = 1.2;
    for (var i = 0; i < stars.length - 1; i++) {
      final a = Offset(stars[i].x * size.width, stars[i].y * size.height);
      final b = Offset(
        stars[i + 1].x * size.width,
        stars[i + 1].y * size.height,
      );
      canvas.drawLine(a, b, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _StarLinksPainter oldDelegate) {
    return oldDelegate.stars != stars || oldDelegate.color != color;
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
