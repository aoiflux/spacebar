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
          colors: [Color(0xFFF0F4FA), Color(0xFFF6F8FC), Color(0xFFEEF3FB)],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: const [
          _SubtleNoise(),
          Positioned(
            top: -200,
            right: -120,
            child: _AccentBlob(size: 520, color: Color(0x0D0B57D0)),
          ),
          Positioned(
            bottom: -160,
            left: -80,
            child: _AccentBlob(size: 400, color: Color(0x080D7A5F)),
          ),
        ],
      ),
    );
  }
}

class _SubtleNoise extends StatelessWidget {
  const _SubtleNoise();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(child: CustomPaint(painter: _DotGridPainter()));
  }
}

class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF0B57D0).withValues(alpha: 0.06)
      ..strokeWidth = 1;
    const step = 32.0;
    for (double x = step; x < size.width; x += step) {
      for (double y = step; y < size.height; y += step) {
        canvas.drawCircle(Offset(x, y), 1.0, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _AccentBlob extends StatelessWidget {
  final double size;
  final Color color;

  const _AccentBlob({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}
