import 'package:flutter/material.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';
import 'package:sirah_app/features/names/presentation/list/list_screen.dart';
import 'package:sirah_app/features/quiz/presentation/entry/quiz_entry_screen.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typo;
    final l10n = context.l10n;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: colors.bg,
        appBar: AppBar(
          backgroundColor: colors.bg,
          surfaceTintColor: colors.bg,
          elevation: 0,
          title: Text(l10n.navDiscover, style: typo.headline),
          bottom: TabBar(
            indicatorColor: colors.accent,
            labelColor: colors.accent,
            unselectedLabelColor: colors.muted,
            labelStyle: typo.button.copyWith(height: 1.0),
            unselectedLabelStyle: typo.button.copyWith(height: 1.0),
            tabs: [
              Tab(text: l10n.discoverAllNames),
              Tab(text: l10n.discoverQuiz),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ListScreen(),
            QuizEntryScreen(),
          ],
        ),
      ),
    );
  }
}
