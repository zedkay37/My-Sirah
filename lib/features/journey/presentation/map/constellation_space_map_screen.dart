import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sirah_app/core/providers/journey_providers.dart';
import 'package:sirah_app/core/providers/names_providers.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';
import 'package:sirah_app/features/journey/data/repositories/journey_repository.dart';
import 'package:sirah_app/features/journey/domain/name_progress_resolver.dart';
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

class _ConstellationMapContent extends StatelessWidget {
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
  Widget build(BuildContext context) {
    if (layout.deckId != deckId) {
      return _Error(message: context.l10n.journeyNotFound);
    }

    final constellation = journey.getConstellationById(constellationId);
    if (constellation == null) {
      return _Error(message: context.l10n.journeyNotFound);
    }
    final stars = layout.starsFor(constellationId);
    final color = _hexToColor(constellation.colorHex);

    return StarfieldBackground(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final mapSize = Size(
            constraints.maxWidth.clamp(720.0, 980.0).toDouble(),
            constraints.maxHeight.clamp(620.0, 820.0).toDouble(),
          );

          return InteractiveViewer(
            minScale: 0.82,
            maxScale: 2.2,
            boundaryMargin: const EdgeInsets.all(120),
            child: Center(
              child: RepaintBoundary(
                child: SizedBox(
                  width: mapSize.width,
                  height: mapSize.height,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _StarLinksPainter(
                            stars: stars,
                            color: color,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 32,
                        right: 32,
                        top: 20,
                        child: Column(
                          children: [
                            Text(
                              constellation.titleFr,
                              textAlign: TextAlign.center,
                              style: context.typo.headline.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              constellation.descriptionFr,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: context.typo.caption.copyWith(
                                color: Colors.white.withValues(alpha: 0.62),
                              ),
                            ),
                          ],
                        ),
                      ),
                      for (final star in stars)
                        _StarButton(
                          star: star,
                          name: _nameByNumber(star.number),
                          mapSize: mapSize,
                          color: color,
                          status: progress.stageFor(star.number),
                        ),
                      Positioned(
                        left: 28,
                        right: 28,
                        bottom: 20,
                        child: _StarStatusLegend(color: color),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  ProphetName? _nameByNumber(int number) {
    for (final name in names) {
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
  });

  final StarMapNode star;
  final ProphetName? name;
  final Size mapSize;
  final Color color;
  final JourneyNameStage status;

  @override
  Widget build(BuildContext context) {
    final center = Offset(star.x * mapSize.width, star.y * mapSize.height);
    final diameter = 42.0 * star.size;
    final starColor = status == JourneyNameStage.unknown
        ? Colors.white.withValues(alpha: 0.48)
        : color;

    return Positioned(
      left: center.dx - diameter / 2,
      top: center.dy - diameter / 2,
      child: GestureDetector(
        onTap: name == null
            ? null
            : () => context.push('/name/${name!.number}/experience'),
        child: SizedBox(
          width: diameter + 72,
          height: diameter + 54,
          child: Column(
            children: [
              Container(
                width: diameter,
                height: diameter,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: starColor.withValues(alpha: 0.16),
                  boxShadow: [
                    BoxShadow(
                      color: starColor.withValues(alpha: 0.30),
                      blurRadius: 22,
                      spreadRadius: 2,
                    ),
                  ],
                  border: Border.all(color: starColor.withValues(alpha: 0.78)),
                ),
                child: Icon(
                  _iconFor(status),
                  color: starColor,
                  size: diameter * 0.48,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                name?.transliteration ?? '#${star.number}',
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.typo.caption.copyWith(color: Colors.white),
              ),
            ],
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

class _StarStatusLegend extends StatelessWidget {
  const _StarStatusLegend({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: [
        _LegendChip(
          icon: Icons.star_border_rounded,
          label: l10n.journeyStarUnknown,
          color: Colors.white.withValues(alpha: 0.58),
        ),
        _LegendChip(
          icon: Icons.star_rounded,
          label: l10n.journeyStarViewed,
          color: color,
        ),
        _LegendChip(
          icon: Icons.self_improvement_rounded,
          label: l10n.journeyStarMeditated,
          color: color,
        ),
        _LegendChip(
          icon: Icons.check_circle_rounded,
          label: l10n.journeyStarPracticed,
          color: color,
        ),
        _LegendChip(
          icon: Icons.workspace_premium_rounded,
          label: l10n.journeyStarRecognized,
          color: color,
        ),
      ],
    );
  }
}

class _LegendChip extends StatelessWidget {
  const _LegendChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.34),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 15),
            const SizedBox(width: 5),
            Text(
              label,
              style: context.typo.caption.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
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
