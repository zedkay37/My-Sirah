import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sirah_app/core/providers/husna_providers.dart';
import 'package:sirah_app/core/providers/settings_provider.dart';
import 'package:sirah_app/features/asmaul_husna/data/asmaa_notifier.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';

class HusnaDetailScreen extends ConsumerStatefulWidget {
  const HusnaDetailScreen({super.key, required this.id});

  final int id;

  @override
  ConsumerState<HusnaDetailScreen> createState() => _HusnaDetailScreenState();
}

class _HusnaDetailScreenState extends ConsumerState<HusnaDetailScreen> {
  Timer? _learnTimer;

  @override
  void initState() {
    super.initState();
    _learnTimer = Timer(const Duration(seconds: 8), () {
      if (mounted) {
        ref.read(asmaaNotifierProvider).markHusnaLearned(widget.id);
      }
    });
  }

  @override
  void dispose() {
    _learnTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typo;
    final space = context.space;
    final radii = context.radii;
    final l10n = context.l10n;

    final husnaAsync = ref.watch(husnaRepositoryProvider);
    final isLearned = ref.watch(
      settingsProvider.select((s) => s.husnaLearned.contains(widget.id)),
    );

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        backgroundColor: colors.bg,
        surfaceTintColor: colors.bg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colors.ink),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (isLearned)
            Padding(
              padding: EdgeInsets.only(right: space.md),
              child: Icon(Icons.check_circle, color: colors.success, size: 20),
            ),
        ],
      ),
      body: husnaAsync.when(
        data: (repo) {
          final name = repo.getById(widget.id);
          if (name == null) return const SizedBox.shrink();

          return SingleChildScrollView(
            padding: EdgeInsets.all(space.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Numéro
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: space.md,
                    vertical: space.xs,
                  ),
                  decoration: BoxDecoration(
                    color: colors.accent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(radii.pill),
                  ),
                  child: Text(
                    '#${name.id}',
                    style: typo.caption.copyWith(
                      color: colors.accent,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(height: space.lg),

                // Nom arabe
                Text(
                  name.arabic,
                  style: typo.arabicBody.copyWith(
                    fontSize: 48,
                    color: colors.ink,
                  ),
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: space.sm),

                // Translittération
                Text(
                  name.transliteration,
                  style: typo.headline.copyWith(color: colors.muted),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: space.xs),

                // Sens
                Text(
                  name.meaningFr,
                  style: typo.bodyLarge.copyWith(
                    color: colors.accent,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),

                if (name.etymology.isNotEmpty) ...[
                  SizedBox(height: space.xl),
                  _Section(
                    title: l10n.husnaEtymology,
                    child: Text(
                      name.etymology,
                      style: typo.body.copyWith(color: colors.ink, height: 1.6),
                    ),
                  ),
                ],

                if (name.reference.isNotEmpty) ...[
                  SizedBox(height: space.md),
                  _Section(
                    title: l10n.husnaReference,
                    child: Text(
                      name.reference,
                      style: typo.caption.copyWith(color: colors.muted),
                    ),
                  ),
                ],

                SizedBox(height: space.xl),

                // Navigation précédent / suivant
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (name.id > 1)
                      TextButton.icon(
                        onPressed: () => context.pushReplacement(
                          '/library/deck/asmaul_husna/${name.id - 1}',
                        ),
                        icon: const Icon(Icons.chevron_left, size: 18),
                        label: Text(l10n.husnaPrevious),
                        style: TextButton.styleFrom(
                          foregroundColor: colors.muted,
                        ),
                      )
                    else
                      const SizedBox.shrink(),
                    if (name.id < repo.getAll().length)
                      TextButton.icon(
                        onPressed: () => context.pushReplacement(
                          '/library/deck/asmaul_husna/${name.id + 1}',
                        ),
                        icon: const Icon(Icons.chevron_right, size: 18),
                        label: Text(l10n.husnaNext),
                        style: TextButton.styleFrom(
                          foregroundColor: colors.muted,
                        ),
                        iconAlignment: IconAlignment.end,
                      )
                    else
                      const SizedBox.shrink(),
                  ],
                ),
              ],
            ),
          );
        },
        loading: () => Center(
          child: CircularProgressIndicator(
            color: colors.accent,
            strokeWidth: 2,
          ),
        ),
        error: (_, __) => const SizedBox.shrink(),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typo;
    final space = context.space;
    final radii = context.radii;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(space.md),
      decoration: BoxDecoration(
        color: colors.bg2,
        borderRadius: BorderRadius.circular(radii.md),
        border: Border.all(color: colors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: typo.overline.copyWith(color: colors.muted)),
          SizedBox(height: space.xs),
          child,
        ],
      ),
    );
  }
}
