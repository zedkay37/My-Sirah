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
    final targetFontSize = 17.0 + (progress * 14.0); // 17→31sp
    final targetPadding = 28.0 + (progress * 20.0); // 28→48px

    return TweenAnimationBuilder<double>(
      tween: Tween(end: targetFontSize),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      builder: (context, fontSize, _) {
        return TweenAnimationBuilder<double>(
          tween: Tween(end: targetPadding),
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
          builder: (context, padding, _) {
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: padding),
                child:
                    Text(
                          phrase,
                          key: ValueKey(index),
                          textAlign: TextAlign.center,
                          style: typo.bodyLarge.copyWith(
                            color: colors.ink,
                            fontSize: fontSize,
                            height: 1.6,
                          ),
                        )
                        .animate()
                        .fadeIn(duration: 400.ms)
                        .slideY(
                          begin: 0.08,
                          end: 0.0,
                          duration: 400.ms,
                          curve: Curves.easeOut,
                        ),
              ),
            );
          },
        );
      },
    );
  }
}
