import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';
import 'package:sirah_app/features/quiz/data/quiz_generator.dart';
import 'package:sirah_app/features/shared/arabic_text.dart';
import 'package:sirah_app/features/shared/category_chip.dart';

// Carte flashcard retournable — recto: arabe, verso: translittération + étymologie

class QuizCard extends StatefulWidget {
  const QuizCard({
    super.key,
    required this.item,
    required this.isFlipped,
    required this.onFlip,
  });

  final PracticeItem item;
  final bool isFlipped;
  final VoidCallback onFlip;

  @override
  State<QuizCard> createState() => _QuizCardState();
}

class _QuizCardState extends State<QuizCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void didUpdateWidget(QuizCard old) {
    super.didUpdateWidget(old);
    if (widget.isFlipped != old.isFlipped) {
      widget.isFlipped ? _ctrl.forward() : _ctrl.reverse();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onFlip,
      child: AnimatedBuilder(
        animation: _anim,
        builder: (ctx, _) {
          final value = _anim.value;
          final isFront = value <= 0.5;

          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(value * math.pi),
            alignment: Alignment.center,
            child: isFront
                ? _CardFace(item: widget.item, isFront: true)
                : Transform(
                    transform: Matrix4.identity()..rotateY(math.pi),
                    alignment: Alignment.center,
                    child: _CardFace(item: widget.item, isFront: false),
                  ),
          );
        },
      ),
    );
  }
}

// ── Faces ──────────────────────────────────────────────────────────────────────

class _CardFace extends StatelessWidget {
  const _CardFace({required this.item, required this.isFront});

  final PracticeItem item;
  final bool isFront;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final space = context.space;
    final radii = context.radii;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isFront ? colors.bg2 : colors.accent.withValues(alpha: 0.08),
        borderRadius: radii.lgAll,
        border: Border.all(
          color: isFront ? colors.line : colors.accent.withValues(alpha: 0.3),
        ),
      ),
      padding: EdgeInsets.all(space.xl),
      child: isFront ? _Front(item: item) : _Back(item: item),
    );
  }
}

class _Front extends StatelessWidget {
  const _Front({required this.item});
  final PracticeItem item;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final space = context.space;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ArabicText(text: item.arabic, size: ArabicSize.large, withShadow: true),
        SizedBox(height: space.sm),
        Icon(Icons.touch_app_outlined, size: 20, color: colors.muted),
      ],
    );
  }
}

class _Back extends StatelessWidget {
  const _Back({required this.item});
  final PracticeItem item;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typo;
    final space = context.space;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          item.transliteration,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
          style: typo.headline.copyWith(fontStyle: FontStyle.italic),
        ),
        SizedBox(height: space.sm),
        if (item.categorySlug case final slug?) ...[
          CategoryChip(
            slug: slug,
            label: item.categoryLabel ?? '',
            variant: CategoryChipVariant.small,
          ),
        ] else ...[
          Text(
            item.promptText,
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: typo.body.copyWith(color: colors.ink),
          ),
        ],
        SizedBox(height: space.md),
        Text(
          item.detailText,
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
          style: typo.body.copyWith(color: colors.muted),
        ),
      ],
    );
  }
}
