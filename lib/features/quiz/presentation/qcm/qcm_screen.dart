import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sirah_app/core/providers/settings_provider.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';
import 'package:sirah_app/features/names/data/models/prophet_name.dart';
import 'package:sirah_app/features/quiz/data/quiz_generator.dart';
import 'package:sirah_app/features/quiz/data/quiz_provider.dart';
import 'package:sirah_app/features/shared/arabic_text.dart';

class QcmScreen extends ConsumerStatefulWidget {
  const QcmScreen({super.key});

  @override
  ConsumerState<QcmScreen> createState() => _QcmScreenState();
}

class _QcmScreenState extends ConsumerState<QcmScreen> {
  int _currentQ = 0;
  int? _selectedIndex;
  int _score = 0;
  Timer? _autoAdvanceTimer;

  QuizSession get _session => ref.read(quizSessionProvider)!;

  QcmQuestion get _question => _session.questions[_currentQ];

  bool _isCorrect(int index) =>
      _question.choices[index].number == _question.name.number;

  void _select(int index) {
    if (_selectedIndex != null) return;
    setState(() => _selectedIndex = index);
    if (_isCorrect(index)) {
      _score++;
      ref.read(settingsProvider.notifier).markLearned(_question.name.number);
    }
    _autoAdvanceTimer = Timer(const Duration(milliseconds: 1200), () {
      if (mounted) _next();
    });
  }

  void _next() {
    _autoAdvanceTimer?.cancel();
    final total = _session.questions.length;
    if (_currentQ < total - 1) {
      setState(() {
        _currentQ++;
        _selectedIndex = null;
      });
    } else {
      context.pushReplacement(
        '/quiz/result',
        extra: {'score': _score, 'total': total},
      );
    }
  }

  @override
  void dispose() {
    _autoAdvanceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typo;
    final space = context.space;
    final l10n = context.l10n;
    final total = _session.questions.length;

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        backgroundColor: colors.bg,
        surfaceTintColor: colors.bg,
        elevation: 0,
        title: Text(
          l10n.quizProgress(_currentQ + 1, total),
          style: typo.caption.copyWith(color: colors.muted),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: LinearProgressIndicator(
            value: (_currentQ + 1) / total,
            backgroundColor: colors.line,
            valueColor: AlwaysStoppedAnimation<Color>(colors.accent),
            minHeight: 2,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(space.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: space.md),
            // Commentaire masqué = la question
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(space.lg),
              decoration: BoxDecoration(
                color: colors.bg2,
                borderRadius: context.radii.lgAll,
                border: Border.all(color: colors.line),
              ),
              child: Text(
                _question.maskedCommentary,
                style: typo.bodyLarge,
              ),
            ),
            SizedBox(height: space.xl),
            // Choix
            ...List.generate(
              _question.choices.length,
              (i) => Padding(
                padding: EdgeInsets.only(bottom: space.sm),
                child: _ChoiceButton(
                  name: _question.choices[i],
                  state: _choiceState(i),
                  onTap: () => _select(i),
                ),
              ),
            ),
            // Bouton suivant (visible après réponse — permet d'avancer manuellement)
            if (_selectedIndex != null) ...[
              SizedBox(height: space.md),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _next,
                  child: Text(
                    _currentQ < total - 1 ? l10n.qcmNext : l10n.quizExploreNamesCta,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  _ChoiceState _choiceState(int index) {
    if (_selectedIndex == null) return _ChoiceState.idle;
    if (_isCorrect(index)) return _ChoiceState.correct;
    if (_selectedIndex == index) return _ChoiceState.wrong;
    return _ChoiceState.disabled;
  }
}

enum _ChoiceState { idle, correct, wrong, disabled }

class _ChoiceButton extends StatelessWidget {
  const _ChoiceButton({
    required this.name,
    required this.state,
    required this.onTap,
  });

  final ProphetName name;
  final _ChoiceState state;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typo;
    final space = context.space;
    final radii = context.radii;

    final (bg, border, labelColor) = switch (state) {
      _ChoiceState.correct => (
          colors.success.withValues(alpha: 0.12),
          colors.success,
          colors.success,
        ),
      _ChoiceState.wrong => (
          colors.error.withValues(alpha: 0.12),
          colors.error,
          colors.error,
        ),
      _ChoiceState.disabled => (
          Colors.transparent,
          colors.line,
          colors.muted,
        ),
      _ChoiceState.idle => (
          colors.bg2,
          colors.line,
          colors.ink,
        ),
    };

    return Semantics(
      button: state == _ChoiceState.idle,
      label: name.transliteration,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: radii.lgAll,
          border: Border.all(color: border),
        ),
        child: InkWell(
          onTap: state == _ChoiceState.idle ? onTap : null,
          borderRadius: radii.lgAll,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: space.md,
              vertical: space.sm + 4,
            ),
            child: Row(
              children: [
                ArabicText(
                  text: name.arabic,
                  size: ArabicSize.body,
                  textAlign: TextAlign.start,
                ),
                SizedBox(width: space.md),
                Expanded(
                  child: Text(
                    name.transliteration,
                    style: typo.body.copyWith(
                      fontStyle: FontStyle.italic,
                      color: labelColor,
                    ),
                  ),
                ),
                if (state == _ChoiceState.correct)
                  Icon(Icons.check_circle_outline,
                      color: colors.success, size: 20)
                else if (state == _ChoiceState.wrong)
                  Icon(Icons.cancel_outlined, color: colors.error, size: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
