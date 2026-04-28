import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sirah_app/core/providers/journey_providers.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';
import 'package:sirah_app/features/journey/data/repositories/journey_repository.dart';
import 'package:sirah_app/features/journey/presentation/map/widgets/galaxy_node.dart';
import 'package:sirah_app/features/journey/presentation/map/widgets/starfield_background.dart';

class GalaxyMapScreen extends ConsumerWidget {
  const GalaxyMapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final typo = context.typo;
    final l10n = context.l10n;
    final decksAsync = ref.watch(journeyDecksProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(
          l10n.journeyTitle,
          style: typo.headline.copyWith(color: Colors.white),
        ),
      ),
      body: decksAsync.when(
        loading: () => Center(
          child: CircularProgressIndicator(
            color: colors.accent,
            strokeWidth: 2,
          ),
        ),
        error: (_, __) => Center(
          child: Text(
            l10n.journeyLoadError,
            style: typo.bodyLarge.copyWith(color: colors.muted),
          ),
        ),
        data: (decks) => _GalaxyMapContent(decks: decks),
      ),
    );
  }
}

class _GalaxyMapContent extends StatelessWidget {
  const _GalaxyMapContent({required this.decks});

  final List<JourneyDeck> decks;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final activeDeck = decks.firstWhere(
      (deck) => deck.id == 'prophet_names',
      orElse: () => const JourneyDeck(
        id: 'prophet_names',
        titleFr: 'Noms du Prophète ﷺ',
        subtitleFr: '201 étoiles pour connaître et aimer le Prophète ﷺ',
        itemType: 'prophet_name',
        totalItems: 201,
        status: 'active',
      ),
    );
    return StarfieldBackground(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final mapSize = Size(
            constraints.maxWidth.clamp(720.0, 980.0).toDouble(),
            constraints.maxHeight.clamp(620.0, 820.0).toDouble(),
          );

          return InteractiveViewer(
            minScale: 0.82,
            maxScale: 1.75,
            boundaryMargin: const EdgeInsets.all(120),
            child: Center(
              child: RepaintBoundary(
                child: SizedBox(
                  width: mapSize.width,
                  height: mapSize.height,
                  child: Stack(
                    children: [
                      Positioned(
                        left: mapSize.width * 0.5 - 140,
                        top: mapSize.height * 0.42 - 140,
                        child: GalaxyNode(
                          title: activeDeck.titleFr,
                          subtitle: activeDeck.subtitleFr,
                          isActive: true,
                          onTap: () =>
                              context.push('/journey/deck/${activeDeck.id}'),
                        ),
                      ),
                      Positioned(
                        left: 28,
                        right: 28,
                        bottom: 24,
                        child: Text(
                          l10n.journeyGalaxyHint,
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
