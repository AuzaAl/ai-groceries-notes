import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class OrbBackground extends StatelessWidget {
  final Widget child;

  const OrbBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Layer 1: Base white background
        Container(color: bgBase),

        // Layer 2: Orb kiri atas
        Positioned(
          top: -80,
          left: -60,
          child: _GreenOrb(
            size: 280,
            colors: const [orbPrimary, orbSecondary],
            opacity: 0.12,
            blur: 60,
          ),
        ),

        // Layer 3: Orb kanan bawah
        Positioned(
          bottom: -100,
          right: -40,
          child: _GreenOrb(
            size: 240,
            colors: const [orbSecondary, orbTertiary],
            opacity: 0.10,
            blur: 50,
          ),
        ),

        // Layer 4: Konten
        Positioned.fill(child: child),
      ],
    );
  }
}

class _GreenOrb extends StatelessWidget {
  final double size;
  final List<Color> colors;
  final double opacity;
  final double blur;

  const _GreenOrb({
    required this.size,
    required this.colors,
    required this.opacity,
    required this.blur,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: blur, sigmaY: blur, tileMode: TileMode.decal),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: colors,
            ),
          ),
        ),
      ),
    );
  }
}
