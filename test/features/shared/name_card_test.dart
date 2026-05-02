import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sirah_app/core/theme/app_colors.dart';
import 'package:sirah_app/core/theme/app_theme.dart';
import 'package:sirah_app/core/theme/theme_key.dart';
import 'package:sirah_app/features/journey/domain/name_progress_resolver.dart';
import 'package:sirah_app/features/names/data/models/prophet_name.dart';
import 'package:sirah_app/features/shared/name_card.dart';
import 'package:sirah_app/l10n/app_localizations.dart';

const _name = ProphetName(
  number: 1,
  arabic: 'محمد',
  transliteration: 'Muhammad',
  categorySlug: 'praise',
  categoryLabel: 'Louange',
  etymology: 'Loué',
  commentary: 'Commentaire',
  references: '',
  primarySource: '',
  secondarySources: '',
);

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: AppTheme.build(ThemeKey.light),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: const Locale('fr'),
    home: Scaffold(body: child),
  );
}

void main() {
  testWidgets('NameCard uses Journey stage for the number indicator', (
    tester,
  ) async {
    await tester.pumpWidget(
      _wrap(
        NameCard(
          name: _name,
          isFavorite: false,
          stage: JourneyNameStage.recognized,
          onTap: () {},
        ),
      ),
    );

    final context = tester.element(find.byType(NameCard));
    final colors = Theme.of(context).extension<AppColors>()!;
    final numberText = tester.widget<Text>(find.text('#001'));

    expect(numberText.style?.color, colors.accent);
    expect(numberText.style?.fontWeight, FontWeight.w600);
  });
}
