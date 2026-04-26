import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';

class PhraseDisplay extends StatelessWidget {
  const PhraseDisplay({
    super.key,
    required this.phrase,
    required this.index,
    required this.total,
  });

  final String phrase;
  final int index;
  final int total;

  @override
  Widget build(BuildContext context) {
    final typo = context.typo;
    final colors = context.colors;

    final progress = total > 1 ? index / (total - 1) : 1.0;
    final fontSize = 18.0 + (progress * 8.0);
    final horizontalPadding = 32.0 + (progress * 16.0);

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Text(
          phrase,
          key: ValueKey(index),
          textAlign: TextAlign.center,
          style: typo.bodyLarge.copyWith(
            color: colors.ink,
            fontSize: fontSize,
            height: 1.6,
          ),
        ).animate()
         .fadeIn(duration: 400.ms)
         .slideY(
           begin: 0.1,
           end: 0.0,
           duration: 400.ms,
           curve: Curves.easeOut,
         ),
      ),
    );
  }
}
