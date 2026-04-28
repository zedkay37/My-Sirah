import 'package:flutter/material.dart';
import 'package:sirah_app/core/utils/build_context_x.dart';

class GalaxyNode extends StatelessWidget {
  const GalaxyNode({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isActive,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool isActive;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typo = context.typo;

    return Semantics(
      button: isActive,
      label: title,
      child: GestureDetector(
        onTap: isActive ? onTap : null,
        child: SizedBox(
          width: 280,
          height: 280,
          child: Stack(
            alignment: Alignment.center,
            children: [
              for (final scale in const [1.0, 0.74, 0.48])
                Transform.rotate(
                  angle: scale * 0.55,
                  child: Container(
                    width: 240 * scale,
                    height: 108 * scale,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: colors.accent.withValues(
                          alpha: isActive ? 0.28 : 0.12,
                        ),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: colors.accent.withValues(
                            alpha: isActive ? 0.20 : 0.06,
                          ),
                          blurRadius: 28,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ),
              Container(
                width: 126,
                height: 126,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      colors.accent.withValues(alpha: isActive ? 0.90 : 0.35),
                      colors.accent2.withValues(alpha: isActive ? 0.44 : 0.12),
                      Colors.transparent,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colors.accent.withValues(alpha: 0.38),
                      blurRadius: 48,
                      spreadRadius: 6,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.auto_awesome_rounded,
                  color: isActive ? colors.bg : colors.muted,
                  size: 42,
                ),
              ),
              Positioned(
                top: 214,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: typo.bodyLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: typo.caption.copyWith(
                        color: Colors.white.withValues(alpha: 0.68),
                      ),
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
