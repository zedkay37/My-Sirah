import 'package:flutter/material.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';

enum ArabicSize { hero, large, medium, body }

class ArabicText extends StatelessWidget {
  const ArabicText({
    super.key,
    required this.text,
    this.size = ArabicSize.medium,
    this.withShadow = false,
    this.color,
    this.textAlign = TextAlign.center,
    this.maxLines,
    this.overflow,
  });

  final String text;
  final ArabicSize size;
  final bool withShadow;
  final Color? color;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    final typo = context.typo;

    TextStyle base = switch (size) {
      ArabicSize.hero => typo.arabicHero,
      ArabicSize.large => typo.arabicLarge,
      ArabicSize.medium => typo.arabicMedium,
      ArabicSize.body => typo.arabicBody,
    };

    if (color != null) base = base.copyWith(color: color);

    if (withShadow) {
      final glow = context.elevation.glow;
      if (glow != null) {
        base = base.copyWith(
          shadows: [Shadow(color: glow, blurRadius: 40)],
        );
      }
    }

    return Semantics(
      label: text,
      child: Text(
        text,
        style: base,
        textAlign: textAlign,
        textDirection: TextDirection.rtl,
        maxLines: maxLines,
        overflow: overflow,
      ),
    );
  }
}
