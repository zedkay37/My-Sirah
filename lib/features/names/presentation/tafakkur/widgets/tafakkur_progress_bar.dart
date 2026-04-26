import 'package:flutter/material.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';

class TafakkurProgressBar extends StatelessWidget {
  const TafakkurProgressBar({
    super.key,
    required this.current,
    required this.total,
  });

  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final progress = total > 0 ? (current + 1) / total : 0.0;

    return LinearProgressIndicator(
      value: progress,
      backgroundColor: colors.line.withValues(alpha: 0.1),
      valueColor: AlwaysStoppedAnimation<Color>(
        colors.muted.withValues(alpha: 0.35),
      ),
      minHeight: 2,
    );
  }
}
