import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sirah_app/core/notifications/notification_service.dart';
import 'package:sirah_app/core/providers/settings_provider.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';
import 'package:sirah_app/features/genealogy/presentation/detail/person_detail_screen.dart';
import 'package:sirah_app/features/genealogy/presentation/list/tree_list_screen.dart';
import 'package:sirah_app/features/genealogy/presentation/tree_screen.dart';
import 'package:sirah_app/features/journey/presentation/constellation_detail_screen.dart';
import 'package:sirah_app/features/journey/presentation/map/constellation_space_map_screen.dart';
import 'package:sirah_app/features/journey/presentation/map/deck_space_map_screen.dart';
import 'package:sirah_app/features/journey/presentation/map/galaxy_map_screen.dart';
import 'package:sirah_app/features/journey/presentation/name_experience_screen.dart';
import 'package:sirah_app/features/library/presentation/library_deck_screen.dart';
import 'package:sirah_app/features/library/presentation/library_screen.dart';
import 'package:sirah_app/features/names/presentation/detail/detail_screen.dart';
import 'package:sirah_app/features/names/presentation/tafakkur/tafakkur_screen.dart';
import 'package:sirah_app/features/names/presentation/home/home_screen.dart';
import 'package:sirah_app/features/asmaul_husna/presentation/detail/husna_detail_screen.dart';
import 'package:sirah_app/features/onboarding/presentation/onboarding_screen.dart';
import 'package:sirah_app/features/profile/presentation/favorites/favorites_screen.dart';
import 'package:sirah_app/features/profile/presentation/profile/profile_screen.dart';
import 'package:sirah_app/features/profile/presentation/settings/settings_screen.dart';
import 'package:sirah_app/features/quiz/data/quiz_generator.dart';
import 'package:sirah_app/features/quiz/presentation/flashcards/flashcards_screen.dart';
import 'package:sirah_app/features/quiz/presentation/qcm/qcm_screen.dart';
import 'package:sirah_app/features/quiz/presentation/result/result_screen.dart';
import 'package:sirah_app/features/study/presentation/entry/study_entry_screen.dart';
import 'package:sirah_app/features/study/presentation/parcours/parcours_detail_screen.dart';
import 'package:sirah_app/features/study/presentation/parcours/parcours_list_screen.dart';
import 'package:sirah_app/features/study/presentation/review/review_screen.dart';

// ── Shell (tab bar) ───────────────────────────────────────────────────────────

class _ShellScaffold extends StatelessWidget {
  const _ShellScaffold({required this.navigationShell});
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.bg,
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        backgroundColor: colors.bg,
        indicatorColor: colors.accent.withValues(alpha: 0.12),
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: colors.accent),
            label: l10n.navHome,
          ),
          NavigationDestination(
            icon: const Icon(Icons.travel_explore_outlined),
            selectedIcon: Icon(Icons.travel_explore, color: colors.accent),
            label: l10n.navJourney,
          ),
          NavigationDestination(
            icon: const Icon(Icons.local_library_outlined),
            selectedIcon: Icon(Icons.local_library, color: colors.accent),
            label: l10n.navLibrary,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: colors.accent),
            label: l10n.navProfile,
          ),
          NavigationDestination(
            icon: const Icon(Icons.account_tree_outlined),
            selectedIcon: Icon(Icons.account_tree, color: colors.accent),
            label: l10n.navTree,
          ),
        ],
      ),
    );
  }
}

// ── Router ────────────────────────────────────────────────────────────────────

final appRouterProvider = Provider<GoRouter>((ref) {
  final onboardingCompletedAt = ref.watch(
    settingsProvider.select((s) => s.onboardingCompletedAt),
  );

  final router = GoRouter(
    initialLocation: '/home',
    errorBuilder: (context, state) => Scaffold(
      backgroundColor: context.colors.bg,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.link_off_outlined,
              size: 48,
              color: context.colors.muted,
            ),
            const SizedBox(height: 16),
            Text(
              context.l10n.errorPageNotFound,
              style: context.typo.headline.copyWith(color: context.colors.ink),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => context.go('/home'),
              child: Text(context.l10n.errorBackHome),
            ),
          ],
        ),
      ),
    ),
    redirect: (context, state) {
      final onboarded = onboardingCompletedAt != null;
      final onOnboarding = state.matchedLocation.startsWith('/onboarding');
      if (!onboarded && !onOnboarding) return '/onboarding';
      if (onboarded && onOnboarding) return '/home';
      return null;
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (_, __) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/discover',
        redirect: (_, __) => '/library',
        routes: [
          GoRoute(
            path: 'prophets',
            redirect: (_, __) => '/library/deck/prophet_names',
          ),
          GoRoute(
            path: 'husna',
            redirect: (_, __) => '/library/deck/asmaul_husna',
            routes: [
              GoRoute(
                path: ':id',
                redirect: (_, state) {
                  final id = state.pathParameters['id'] ?? '1';
                  return '/library/deck/asmaul_husna/$id';
                },
              ),
            ],
          ),
        ],
      ),
      StatefulShellRoute.indexedStack(
        builder: (_, __, shell) => _ShellScaffold(navigationShell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/journey',
                builder: (_, __) => const GalaxyMapScreen(),
                routes: [
                  GoRoute(
                    path: 'deck/:deckId',
                    pageBuilder: (_, state) => _fadeSlide(
                      state,
                      DeckSpaceMapScreen(
                        deckId: state.pathParameters['deckId']!,
                      ),
                    ),
                    routes: [
                      GoRoute(
                        path: 'constellation/:id',
                        pageBuilder: (_, state) => _fadeSlide(
                          state,
                          ConstellationSpaceMapScreen(
                            deckId: state.pathParameters['deckId']!,
                            constellationId: state.pathParameters['id']!,
                          ),
                        ),
                      ),
                    ],
                  ),
                  GoRoute(
                    path: 'constellation/:id',
                    pageBuilder: (_, state) => _fadeSlide(
                      state,
                      ConstellationDetailScreen(
                        constellationId: state.pathParameters['id']!,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/library',
                builder: (_, __) => const LibraryScreen(),
                routes: [
                  GoRoute(
                    path: 'deck/asmaul_husna/:id',
                    pageBuilder: (_, state) {
                      final id =
                          int.tryParse(state.pathParameters['id'] ?? '') ?? 1;
                      return _fadeSlide(state, HusnaDetailScreen(id: id));
                    },
                  ),
                  GoRoute(
                    path: 'deck/:deckId',
                    pageBuilder: (_, state) => _fadeSlide(
                      state,
                      LibraryDeckScreen(
                        deckId: state.pathParameters['deckId']!,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (_, __) => const ProfileScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/tree',
                builder: (_, __) => const TreeScreen(),
                routes: [
                  GoRoute(
                    path: 'person/:id',
                    pageBuilder: (_, state) {
                      final id = state.pathParameters['id']!;
                      return _fadeSlide(
                        state,
                        PersonDetailScreen(memberId: id),
                      );
                    },
                  ),
                  GoRoute(
                    path: 'list',
                    pageBuilder: (_, state) =>
                        _fadeSlide(state, const TreeListScreen()),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/study',
        pageBuilder: (_, state) => _fadeSlide(state, const StudyEntryScreen()),
        routes: [
          GoRoute(
            path: 'review',
            pageBuilder: (_, state) => _fadeSlide(state, const ReviewScreen()),
          ),
          GoRoute(
            path: 'parcours-list',
            pageBuilder: (_, state) =>
                _fadeSlide(state, const ParcoursListScreen()),
          ),
          GoRoute(
            path: 'parcours/:id',
            pageBuilder: (_, state) => _fadeSlide(
              state,
              ParcoursDetailScreen(parcoursId: state.pathParameters['id']!),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/name/:number',
        pageBuilder: (_, state) {
          final number =
              int.tryParse(state.pathParameters['number'] ?? '') ?? 1;
          return _fadeSlide(state, DetailScreen(initialNumber: number));
        },
        routes: [
          GoRoute(
            path: 'experience',
            pageBuilder: (_, state) {
              final number =
                  int.tryParse(state.pathParameters['number'] ?? '') ?? 1;
              return _fadeSlide(
                state,
                NameExperienceScreen(nameNumber: number),
              );
            },
          ),
          GoRoute(
            path: 'tafakkur',
            pageBuilder: (_, state) {
              final number =
                  int.tryParse(state.pathParameters['number'] ?? '') ?? 1;
              return _fadeSlide(state, TafakkurScreen(nameNumber: number));
            },
          ),
        ],
      ),
      GoRoute(
        path: '/quiz/qcm',
        pageBuilder: (_, state) => _fadeSlide(state, const QcmScreen()),
      ),
      GoRoute(
        path: '/quiz/flashcards',
        pageBuilder: (_, state) => _fadeSlide(state, const FlashcardsScreen()),
      ),
      GoRoute(
        path: '/quiz/result',
        pageBuilder: (_, state) {
          final extra = state.extra as Map<String, int>? ?? const {};
          return _fadeSlide(
            state,
            ResultScreen(
              score: extra['score'] ?? 0,
              total: extra['total'] ?? QuizGenerator.quizSize,
            ),
          );
        },
      ),
      GoRoute(
        path: '/settings',
        pageBuilder: (_, state) => _fadeSlide(state, const SettingsScreen()),
      ),
      GoRoute(
        path: '/favorites',
        pageBuilder: (_, state) => _fadeSlide(state, const FavoritesScreen()),
      ),
    ],
  );
  NotificationService.onNavigate = (route) => router.go(route);
  return router;
});

// ── Transition helper ─────────────────────────────────────────────────────────

CustomTransitionPage<void> _fadeSlide(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 260),
    reverseTransitionDuration: const Duration(milliseconds: 200),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeIn),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.04),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
          child: child,
        ),
      );
    },
  );
}
