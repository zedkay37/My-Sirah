import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sirah_app/core/providers/settings_provider.dart';
import 'package:sirah_app/core/theme/text_size.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';
import 'package:sirah_app/features/shared/section_header.dart';
import 'package:sirah_app/features/shared/theme_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final typo = context.typo;
    final space = context.space;
    final l10n = context.l10n;

    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      backgroundColor: colors.bg,
      appBar: AppBar(
        backgroundColor: colors.bg,
        surfaceTintColor: colors.bg,
        elevation: 0,
        title: Text(l10n.settingsTitle, style: typo.headline),
      ),
      body: ListView(
        padding: EdgeInsets.all(space.md),
        children: [
          // ── Thème ──────────────────────────────────────────────────────────
          SectionHeader(title: l10n.settingsSectionTheme),
          SizedBox(height: space.sm),
          ThemePicker(
            current: settings.theme,
            onChanged: notifier.setTheme,
          ),
          SizedBox(height: space.xl),

          // ── Notification ───────────────────────────────────────────────────
          SectionHeader(title: l10n.settingsSectionNotif),
          SizedBox(height: space.sm),
          _NotifTile(
            currentHour: settings.dailyNotifHour,
            onChanged: (hour) => notifier.setNotifHour(hour),
          ),
          SizedBox(height: space.xl),

          // ── Taille du texte ────────────────────────────────────────────────
          SectionHeader(title: l10n.settingsSectionTextSize),
          SizedBox(height: space.sm),
          _TextSizePicker(
            current: settings.textSize,
            onChanged: notifier.setTextSize,
          ),
          SizedBox(height: space.xl),

          // ── À propos ───────────────────────────────────────────────────────
          SectionHeader(title: l10n.settingsSectionAbout),
          SizedBox(height: space.sm),
          const _AboutTile(),
        ],
      ),
    );
  }
}

// ── Taille du texte ───────────────────────────────────────────────────────────

class _TextSizePicker extends StatelessWidget {
  const _TextSizePicker({required this.current, required this.onChanged});

  final TextSize current;
  final void Function(TextSize) onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typo;
    final space = context.space;
    final radii = context.radii;
    final l10n = context.l10n;

    final options = [
      (TextSize.small, l10n.settingsTextSmall),
      (TextSize.medium, l10n.settingsTextMedium),
      (TextSize.large, l10n.settingsTextLarge),
    ];

    return Row(
      children: options.map((opt) {
        final (size, label) = opt;
        final isSelected = current == size;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: space.xs / 2),
            child: GestureDetector(
              onTap: () => onChanged(size),
              child: Semantics(
                label: label,
                selected: isSelected,
                button: true,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(vertical: space.sm + 4),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? colors.accent.withValues(alpha: 0.12)
                        : colors.bg2,
                    borderRadius: BorderRadius.circular(radii.md),
                    border: Border.all(
                      color: isSelected ? colors.accent : colors.line,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: typo.caption.copyWith(
                      color: isSelected ? colors.accent : colors.muted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── Notification ──────────────────────────────────────────────────────────────

class _NotifTile extends StatelessWidget {
  const _NotifTile({required this.currentHour, required this.onChanged});

  final int? currentHour;
  final void Function(int?) onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typo;
    final space = context.space;
    final radii = context.radii;
    final l10n = context.l10n;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: space.md, vertical: space.sm),
      decoration: BoxDecoration(
        color: colors.bg2,
        borderRadius: BorderRadius.circular(radii.lg),
        border: Border.all(color: colors.line),
      ),
      child: Row(
        children: [
          Icon(Icons.notifications_outlined, color: colors.accent, size: 22),
          SizedBox(width: space.md),
          Expanded(
            child: Text(
              currentHour != null
                  ? '${currentHour.toString().padLeft(2, '0')}:00'
                  : l10n.settingsSectionNotif,
              style: typo.body,
            ),
          ),
          TextButton(
            onPressed: () async {
              if (currentHour != null) {
                onChanged(null);
                return;
              }
              final picked = await showTimePicker(
                context: context,
                initialTime: const TimeOfDay(hour: 8, minute: 0),
              );
              if (picked != null) onChanged(picked.hour);
            },
            child: Text(
              currentHour != null
                  ? l10n.settingsNotifDisable
                  : l10n.settingsNotifEnable,
              style: typo.button.copyWith(color: colors.accent),
            ),
          ),
        ],
      ),
    );
  }
}

// ── À propos ──────────────────────────────────────────────────────────────────

class _AboutTile extends StatelessWidget {
  const _AboutTile();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typo;
    final space = context.space;
    final radii = context.radii;
    final l10n = context.l10n;

    return Container(
      padding: EdgeInsets.all(space.md),
      decoration: BoxDecoration(
        color: colors.bg2,
        borderRadius: BorderRadius.circular(radii.lg),
        border: Border.all(color: colors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.appTitle,
            style: typo.headline,
          ),
          SizedBox(height: space.xs),
          Text(
            'v1.0.0',
            style: typo.caption.copyWith(color: colors.muted),
          ),
          SizedBox(height: space.md),
          GestureDetector(
            onTap: () => launchUrl(
              Uri(
                scheme: 'mailto',
                path: 'mohamedw.bechrouri@gmail.com',
                queryParameters: {
                  'subject': 'Signalement erreur — Asmāʾ an-Nabī',
                },
              ),
            ),
            child: Text(
              l10n.settingsReportError,
              style: typo.body.copyWith(color: colors.accent),
            ),
          ),
        ],
      ),
    );
  }
}
