import 'package:flutter/material.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';

class TafakkurOverlay extends StatelessWidget {
  const TafakkurOverlay({
    super.key,
    required this.darknessLevel,
  });

  final double darknessLevel;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
      color: Color.lerp(context.colors.bg, Colors.black, darknessLevel),
    );
  }
}
