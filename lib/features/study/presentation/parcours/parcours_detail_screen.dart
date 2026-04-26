import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sirah_app/core/providers/names_providers.dart';
import 'package:sirah_app/core/providers/settings_provider.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';
import 'package:sirah_app/features/names/data/models/prophet_name.dart';
import 'package:sirah_app/features/shared/arabic_text.dart';
import 'package:sirah_app/features/study/data/parcours_repository.dart';

class ParcoursDetailScreen extends ConsumerStatefulWidget {
  const ParcoursDetailScreen({super.key, required this.parcoursId});
  final String parcoursId;

  @override
  ConsumerState<ParcoursDetailScreen> createState() => _ParcoursDetailScreenState();
}

class _ParcoursDetailScreenState extends ConsumerState<ParcoursDetailScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final parcoursAsync = ref.watch(parcoursProvider);
    final namesAsync = ref.watch(namesProvider);

    return parcoursAsync.when(
      loading: () => Scaffold(
        backgroundColor: context.colors.bg,
        body: Center(child: CircularProgressIndicator(color: context.colors.accent)),
      ),
      error: (_, __) => Scaffold(
        backgroundColor: context.colors.bg,
        body: Center(child: Icon(Icons.error_outline, color: context.colors.muted)),
      ),
      data: (list) {
        final parcours = list.firstWhere((p) => p.id == widget.parcoursId);

        return namesAsync.when(
          loading: () => Scaffold(
            backgroundColor: context.colors.bg,
            body: Center(child: CircularProgressIndicator(color: context.colors.accent)),
          ),
          error: (_, __) => Scaffold(
            backgroundColor: context.colors.bg,
            body: Center(child: Icon(Icons.error_outline, color: context.colors.muted)),
          ),
          data: (names) {
            final parcoursNames = parcours.nameNumbers
                .map((nameNum) => names.firstWhere((n) => n.number == nameNum))
                .toList();

            return _DetailContent(
              parcours: parcours,
              names: parcoursNames,
              currentIndex: _currentIndex,
              onNext: () {
                if (_currentIndex < parcoursNames.length - 1) {
                  setState(() => _currentIndex++);
                } else {
                  ref
                      .read(settingsProvider.notifier)
                      .markParcoursComplete(parcours.id);
                  for (final name in parcoursNames) {
                    ref.read(settingsProvider.notifier).levelUp(name.number);
                  }
                  context.pop();
                }
              },
            );
          },
        );
      },
    );
  }
}

class _DetailContent extends StatelessWidget {
  const _DetailContent({
    required this.parcours,
    required this.names,
    required this.currentIndex,
    required this.onNext,
  });

  final Parcours parcours;
  final List<ProphetName> names;
  final int currentIndex;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typo;
    final space = context.space;
    final l10n = context.l10n;

    final name = names[currentIndex];
    final progress = (currentIndex + 1) / names.length;
    final isLast = currentIndex == names.length - 1;

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        backgroundColor: colors.bg,
        surfaceTintColor: colors.bg,
        elevation: 0,
        title: Text(
          '${currentIndex + 1} / ${names.length}',
          style: typo.caption.copyWith(color: colors.muted),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: colors.line,
            valueColor: AlwaysStoppedAnimation<Color>(colors.accent),
            minHeight: 2,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(space.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ArabicText(
              text: name.arabic,
              size: ArabicSize.hero,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: space.sm),
            Text(
              name.transliteration,
              style: typo.headline.copyWith(
                fontStyle: FontStyle.italic,
                color: colors.accent,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: space.xl),
            Container(
              padding: EdgeInsets.all(space.md),
              decoration: BoxDecoration(
                color: colors.bg2,
                borderRadius: context.radii.lgAll,
                border: Border.all(color: colors.line),
              ),
              child: Text(
                name.commentary,
                style: typo.body.copyWith(color: colors.ink, height: 1.6),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: space.xl),
            FilledButton(
              onPressed: onNext,
              child: Text(isLast ? l10n.studyParcoursComplete : l10n.qcmNext),
            ),
            SizedBox(height: space.xl),
          ],
        ),
      ),
    );
  }
}
