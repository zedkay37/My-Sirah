import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sirah_app/core/theme/app_colors.dart';
import 'package:sirah_app/core/theme/app_typography.dart';
import 'package:sirah_app/features/names/data/models/prophet_name.dart';

/// Génère une image 1080×1080 du nom et la partage via share_plus.
class ShareNameService {
  ShareNameService._();

  static Future<void> share({
    required ProphetName name,
    required AppColors colors,
    required AppTypography typo,
  }) async {
    final image = await _renderCard(name, colors, typo);
    final xFile = XFile.fromData(
      image,
      mimeType: 'image/png',
      name: '${name.transliteration}.png',
    );
    await Share.shareXFiles([xFile], text: name.transliteration);
  }

  static Future<Uint8List> _renderCard(
    ProphetName name,
    AppColors colors,
    AppTypography typo,
  ) async {
    const w = 1080.0;
    const h = 1920.0;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, const Rect.fromLTWH(0, 0, w, h));

    // Fond
    canvas.drawRect(
      const Rect.fromLTWH(0, 0, w, h),
      Paint()..color = colors.bg,
    );

    // Ornement horizontal centré (~40% de la hauteur)
    final accentPaint = Paint()
      ..color = colors.accent
      ..strokeWidth = 2;
    canvas.drawLine(
      const Offset(w * 0.3, h * 0.40),
      const Offset(w * 0.7, h * 0.40),
      accentPaint,
    );

    // Texte arabe (~43% de la hauteur)
    final arabicPainter = TextPainter(
      text: TextSpan(
        text: name.arabic,
        style: typo.arabicHero.copyWith(fontSize: 120, color: colors.ink),
      ),
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.center,
    )..layout(maxWidth: w * 0.85);
    arabicPainter.paint(
      canvas,
      Offset((w - arabicPainter.width) / 2, h * 0.43),
    );

    // Translittération
    final translitPainter = TextPainter(
      text: TextSpan(
        text: name.transliteration,
        style: typo.displayMedium.copyWith(
          fontStyle: FontStyle.italic,
          color: colors.muted,
          fontSize: 36,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(maxWidth: w * 0.85);
    translitPainter.paint(
      canvas,
      Offset(
        (w - translitPainter.width) / 2,
        h * 0.43 + arabicPainter.height + 24,
      ),
    );

    // Catégorie
    final categoryPainter = TextPainter(
      text: TextSpan(
        text: name.categoryLabel,
        style: typo.caption.copyWith(
          color: colors.categoryColor(name.categorySlug),
          fontSize: 28,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(maxWidth: w * 0.85);
    categoryPainter.paint(
      canvas,
      Offset(
        (w - categoryPainter.width) / 2,
        h * 0.43 + arabicPainter.height + translitPainter.height + 48,
      ),
    );

    // Pied de page (~90% de la hauteur)
    final footerPainter = TextPainter(
      text: TextSpan(
        text: 'Asmāʾ an-Nabī ﷺ',
        style: typo.caption.copyWith(color: colors.muted, fontSize: 24),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    )..layout(maxWidth: w * 0.85);
    footerPainter.paint(
      canvas,
      Offset((w - footerPainter.width) / 2, h * 0.90),
    );

    final picture = recorder.endRecording();
    final img = await picture.toImage(w.toInt(), h.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }
}
