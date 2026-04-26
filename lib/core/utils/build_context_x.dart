import 'package:flutter/material.dart';
import 'package:sirah_app/core/theme/app_colors.dart';
import 'package:sirah_app/core/theme/app_elevation.dart';
import 'package:sirah_app/core/theme/app_radius.dart';
import 'package:sirah_app/core/theme/app_spacing.dart';
import 'package:sirah_app/core/theme/app_typography.dart';
import 'package:sirah_app/l10n/app_localizations.dart';

extension BuildContextX on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
  AppTypography get typo => Theme.of(this).extension<AppTypography>()!;
  AppSpacing get space => Theme.of(this).extension<AppSpacing>()!;
  AppRadius get radii => Theme.of(this).extension<AppRadius>()!;
  AppElevation get elevation => Theme.of(this).extension<AppElevation>()!;
  AppLocalizations get l10n => AppLocalizations.of(this);
}
