import 'package:flutter/material.dart';

class HomeFluentBackground extends StatelessWidget {
  const HomeFluentBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF8FBFF), Color(0xFFEAF2FD), Color(0xFFF4F8FF)],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: const [
          Positioned(
            top: -120,
            left: -120,
            child: _GlowOrb(size: 360, color: Color(0x993D8DFF)),
          ),
          Positioned(
            right: -100,
            bottom: -140,
            child: _GlowOrb(size: 340, color: Color(0x9933C4A1)),
          ),
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowOrb({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: color, blurRadius: 120, spreadRadius: 26),
          ],
        ),
      ),
    );
  }
}
