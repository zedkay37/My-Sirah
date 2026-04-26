import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sirah_app/core/providers/names_providers.dart';
import 'package:sirah_app/core/providers/settings_provider.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';
import 'package:sirah_app/features/names/presentation/tafakkur/tafakkur_controller.dart';
import 'package:sirah_app/features/names/presentation/tafakkur/widgets/phrase_display.dart';
import 'package:sirah_app/features/names/presentation/tafakkur/widgets/tafakkur_overlay.dart';
import 'package:sirah_app/features/names/presentation/tafakkur/widgets/tafakkur_progress_bar.dart';
import 'package:sirah_app/features/names/presentation/tafakkur/widgets/tafakkur_settings_sheet.dart';

class TafakkurScreen extends ConsumerWidget {
  const TafakkurScreen({super.key, required this.nameNumber});

  final int nameNumber;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final namesAsync = ref.watch(namesProvider);

    return namesAsync.when(
      loading: () => Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: context.colors.accent),
        ),
      ),
      error: (_, __) => Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Icon(Icons.error_outline, color: context.colors.muted),
        ),
      ),
      data: (names) {
        final name = names.firstWhere(
          (n) => n.number == nameNumber,
          orElse: () => names.first,
        );

        return _TafakkurContent(
          commentary: name.commentary,
          nameNumber: nameNumber,
        );
      },
    );
  }
}

class _TafakkurContent extends ConsumerWidget {
  const _TafakkurContent({
    required this.commentary,
    required this.nameNumber,
  });

  final String commentary;
  final int nameNumber;

  Future<bool> _onWillPop(BuildContext context, WidgetRef ref) async {
    final state = ref.read(tafakkurControllerProvider(commentary));
    if (state.isComplete) return true;

    final controller = ref.read(tafakkurControllerProvider(commentary).notifier);
    controller.pause();

    final l10n = context.l10n;
    final colors = context.colors;

    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.bg,
        title: Text(l10n.tafakkurExitConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.tafakkurExitConfirmNo, style: TextStyle(color: colors.ink)),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.tafakkurExitConfirmYes, style: TextStyle(color: colors.error)),
          ),
        ],
      ),
    );

    if (shouldPop != true) {
      controller.resume();
    }
    return shouldPop ?? false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(tafakkurControllerProvider(commentary), (prev, next) {
      if (prev?.isComplete != true && next.isComplete) {
        ref.read(settingsProvider.notifier).levelUp(nameNumber);
      }
    });

    final state = ref.watch(tafakkurControllerProvider(commentary));
    final controller = ref.read(tafakkurControllerProvider(commentary).notifier);
    final colors = context.colors;

    return PopScope(
      canPop: state.isComplete,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _onWillPop(context, ref);
        if (shouldPop && context.mounted) {
          context.pop();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          onTap: () {
            if (!state.isComplete) {
              controller.togglePause();
            }
          },
          behavior: HitTestBehavior.opaque,
          child: Stack(
            children: [
              TafakkurOverlay(darknessLevel: state.darknessLevel),
              SafeArea(
                child: Column(
                  children: [
                    if (!state.isComplete)
                      TafakkurProgressBar(
                        current: state.currentIndex,
                        total: state.phrases.length,
                      ),
                    Expanded(
                      child: state.isComplete
                          ? _CompleteView(phrases: state.phrases)
                          : PhraseDisplay(
                              phrase: state.currentPhrase,
                              index: state.currentIndex,
                              total: state.phrases.length,
                            ),
                    ),
                    if (!state.isComplete)
                      _BottomControls(
                        isPaused: state.isPaused,
                        remaining: state.remaining,
                        paceSeconds: state.paceSeconds,
                        onSettingsTap: () {
                          controller.pause();
                          showModalBottomSheet<void>(
                            context: context,
                            backgroundColor: colors.bg,
                            builder: (ctx) => TafakkurSettingsSheet(
                              currentPace: state.paceSeconds,
                              onPaceChanged: controller.setPace,
                            ),
                          ).then((_) {
                            if (!state.isComplete) controller.resume();
                          });
                        },
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompleteView extends StatelessWidget {
  const _CompleteView({required this.phrases});

  final List<String> phrases;

  @override
  Widget build(BuildContext context) {
    final typo = context.typo;
    final colors = context.colors;
    final l10n = context.l10n;

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 48.0),
            itemCount: phrases.length,
            separatorBuilder: (_, __) => const SizedBox(height: 24),
            itemBuilder: (ctx, i) => Text(
              phrases[i],
              textAlign: TextAlign.center,
              style: typo.bodyLarge.copyWith(
                color: colors.ink,
                height: 1.6,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              Text(
                l10n.tafakkurComplete,
                style: typo.body.copyWith(color: colors.muted),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.accent,
                  foregroundColor: colors.bg,
                ),
                child: Text(l10n.tafakkurReturn),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BottomControls extends StatelessWidget {
  const _BottomControls({
    required this.isPaused,
    required this.remaining,
    required this.paceSeconds,
    required this.onSettingsTap,
  });

  final bool isPaused;
  final int remaining;
  final int paceSeconds;
  final VoidCallback onSettingsTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typo;
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.settings_outlined, color: colors.muted),
            onPressed: onSettingsTap,
          ),
          AnimatedOpacity(
            opacity: isPaused ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: Text(
              l10n.tafakkurPause,
              style: typo.caption.copyWith(color: colors.accent),
            ),
          ),
          Text(
            l10n.tafakkurRemaining(remaining),
            style: typo.caption.copyWith(color: colors.muted),
          ),
        ],
      ),
    );
  }
}
