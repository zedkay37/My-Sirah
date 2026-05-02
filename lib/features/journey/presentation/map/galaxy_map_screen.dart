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
      child: Stack(
        children: [
          Positioned(
            left: 32,
            right: 32,
            top: MediaQuery.paddingOf(context).top + 22,
            child: IgnorePointer(
              child: Text(
                context.l10n.journeyTitle,
                textAlign: TextAlign.center,
                style: context.typo.displayMedium.copyWith(
                  color: context.colors.accent,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.2,
                  shadows: [
                    Shadow(
                      color: context.colors.accent.withValues(alpha: 0.34),
                      blurRadius: 18,
                    ),
                    const Shadow(
                      color: Colors.black54,
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: RepaintBoundary(
              child: GalaxyNode(
                title: activeDeck.titleFr,
                subtitle: activeDeck.subtitleFr,
                isActive: true,
                onTap: () => context.push('/journey/deck/${activeDeck.id}'),
              ),
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
    );
  }
}
