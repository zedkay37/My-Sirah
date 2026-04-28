import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sirah_app/core/providers/journey_providers.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';
import 'package:sirah_app/features/journey/data/repositories/journey_repository.dart';
import 'package:sirah_app/features/journey/domain/name_progress_resolver.dart';
import 'package:sirah_app/features/journey/presentation/map/widgets/starfield_background.dart';

class DeckSpaceMapScreen extends ConsumerWidget {
  const DeckSpaceMapScreen({super.key, required this.deckId});

  final String deckId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final typo = context.typo;
    final journeyAsync = ref.watch(journeyRepositoryProvider);
    final layoutAsync = ref.watch(journeyMapLayoutProvider);
    final progress = ref.watch(journeyProgressResolverProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(
          context.l10n.journeyTitle,
          style: typo.headline.copyWith(color: Colors.white),
        ),
      ),
      body: journeyAsync.when(
        loading: () => _Loading(color: colors.accent),
        error: (_, __) => _Error(message: context.l10n.journeyLoadError),
        data: (journey) => layoutAsync.when(
          loading: () => _Loading(color: colors.accent),
          error: (_, __) => _Error(message: context.l10n.journeyLoadError),
          data: (layout) => _DeckMapContent(
            deckId: deckId,
            journey: journey,
            layout: layout,
            progress: progress,
          ),
        ),
      ),
    );
  }
}

class _DeckMapContent extends StatelessWidget {
  const _DeckMapContent({
    required this.deckId,
    required this.journey,
    required this.layout,
    required this.progress,
  });

  final String deckId;
  final JourneyRepository journey;
  final JourneyMapLayout layout;
  final NameProgressResolver progress;

  @override
  Widget build(BuildContext context) {
    if (layout.deckId != deckId) {
      return _Error(message: context.l10n.journeyNotFound);
    }

    final constellations = journey.getConstellations();

    return StarfieldBackground(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final mapSize = Size(
            constraints.maxWidth.clamp(760.0, 1080.0).toDouble(),
            constraints.maxHeight.clamp(660.0, 860.0).toDouble(),
          );

          return InteractiveViewer(
            minScale: 0.75,
            maxScale: 2.0,
            boundaryMargin: const EdgeInsets.all(140),
            child: Center(
              child: RepaintBoundary(
                child: SizedBox(
                  width: mapSize.width,
                  height: mapSize.height,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _ConstellationLinksPainter(
                            nodes: layout.constellations,
                          ),
                        ),
                      ),
                      for (final constellation in constellations)
                        if (layout.constellationNode(constellation.id) != null)
                          _ConstellationNodeButton(
                            deckId: deckId,
                            constellation: constellation,
                            node: layout.constellationNode(constellation.id)!,
                            mapSize: mapSize,
                            progress: progress
                                .summarize(constellation.nameNumbers)
                                .weightedProgress,
                          ),
                      Positioned(
                        left: 28,
                        right: 28,
                        bottom: 24,
                        child: Text(
                          context.l10n.journeyDeckMapHint,
                          textAlign: TextAlign.center,
                          style: context.typo.caption.copyWith(
                            color: Colors.white.withValues(alpha: 0.62),
                          ),
                        ),
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
}

class _ConstellationNodeButton extends StatelessWidget {
  const _ConstellationNodeButton({
    required this.deckId,
    required this.constellation,
    required this.node,
    required this.mapSize,
    required this.progress,
  });

  final String deckId;
  final NameConstellation constellation;
  final ConstellationMapNode node;
  final Size mapSize;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final color = _hexToColor(constellation.colorHex);
    final diameter = (node.radius * mapSize.shortestSide * 1.95).clamp(
      88.0,
      148.0,
    );
    final center = Offset(node.x * mapSize.width, node.y * mapSize.height);

    return Positioned(
      left: center.dx - diameter / 2,
      top: center.dy - diameter / 2,
      child: GestureDetector(
        onTap: () => context.push(
          '/journey/deck/$deckId/constellation/${constellation.id}',
        ),
        child: SizedBox(
          width: diameter,
          height: diameter + 48,
          child: Column(
            children: [
              CustomPaint(
                size: Size.square(diameter),
                painter: _ConstellationNodePainter(
                  color: color,
                  progress: progress,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                constellation.titleFr,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.typo.caption.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _hexToColor(String hex) {
    final normalized = hex.replaceFirst('#', '');
    return Color(int.parse('FF$normalized', radix: 16));
  }
}

class _ConstellationNodePainter extends CustomPainter {
  const _ConstellationNodePainter({
    required this.color,
    required this.progress,
  });

  final Color color;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2;
    canvas.drawCircle(
      center,
      radius * 0.92,
      Paint()..color = color.withValues(alpha: 0.11),
    );
    canvas.drawCircle(
      center,
      radius * (0.28 + progress * 0.52),
      Paint()..color = color.withValues(alpha: 0.30),
    );
    canvas.drawCircle(
      center,
      radius * 0.92,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.4
        ..color = color.withValues(alpha: 0.58),
    );
    canvas.drawCircle(center, radius * 0.12, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _ConstellationNodePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}

class _ConstellationLinksPainter extends CustomPainter {
  const _ConstellationLinksPainter({required this.nodes});

  final List<ConstellationMapNode> nodes;

  @override
  void paint(Canvas canvas, Size size) {
    if (nodes.length < 2) return;
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.10)
      ..strokeWidth = 1.1;

    for (var i = 0; i < nodes.length; i++) {
      final a = Offset(nodes[i].x * size.width, nodes[i].y * size.height);
      final b = Offset(
        nodes[(i + 1) % nodes.length].x * size.width,
        nodes[(i + 1) % nodes.length].y * size.height,
      );
      canvas.drawLine(a, b, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ConstellationLinksPainter oldDelegate) {
    return oldDelegate.nodes != nodes;
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
