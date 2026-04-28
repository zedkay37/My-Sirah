import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';
import 'package:sirah_app/features/asmaul_husna/presentation/list/husna_list_screen.dart';
import 'package:sirah_app/features/names/presentation/list/list_screen.dart';
import 'package:sirah_app/features/quiz/presentation/entry/quiz_entry_screen.dart';
import 'package:sirah_app/features/study/presentation/entry/study_entry_screen.dart';

class LibraryDeckScreen extends StatelessWidget {
  const LibraryDeckScreen({super.key, required this.deckId});

  final String deckId;

  @override
  Widget build(BuildContext context) {
    return switch (deckId) {
      'prophet_names' => const _ProphetNamesDeckScreen(),
      'asmaul_husna' => const HusnaListScreen(),
      _ => const _UnknownDeckScreen(),
    };
  }
}

class _ProphetNamesDeckScreen extends StatelessWidget {
  const _ProphetNamesDeckScreen();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typo;
    final l10n = context.l10n;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: colors.bg,
        appBar: AppBar(
          backgroundColor: colors.bg,
          surfaceTintColor: colors.bg,
          elevation: 0,
          title: Text(l10n.discoverProphetsTitle, style: typo.headline),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: colors.ink),
            onPressed: () => context.pop(),
          ),
          bottom: TabBar(
            indicatorColor: colors.accent,
            labelColor: colors.accent,
            unselectedLabelColor: colors.muted,
            labelStyle: typo.button.copyWith(height: 1.0),
            unselectedLabelStyle: typo.button.copyWith(height: 1.0),
            tabs: [
              Tab(text: l10n.discoverAllNames),
              Tab(text: l10n.libraryLearnTab),
              Tab(text: l10n.discoverQuiz),
            ],
          ),
        ),
        body: const TabBarView(
          children: [ListScreen(), StudyEntryContent(), QuizEntryScreen()],
        ),
      ),
    );
  }
}

class _UnknownDeckScreen extends StatelessWidget {
  const _UnknownDeckScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.bg,
      appBar: AppBar(backgroundColor: context.colors.bg),
      body: Center(
        child: Text(
          context.l10n.errorPageNotFound,
          style: context.typo.bodyLarge.copyWith(color: context.colors.muted),
        ),
      ),
    );
  }
}
