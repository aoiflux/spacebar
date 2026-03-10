import 'dart:ui';

import 'package:flutter/material.dart';

class HomeCommandSurface extends StatelessWidget {
  final Widget child;

  const HomeCommandSurface({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF2E3A4B).withValues(alpha: 0.12),
            ),
            color: Colors.white.withValues(alpha: 0.58),
          ),
          child: child,
        ),
      ),
    );
  }
}
