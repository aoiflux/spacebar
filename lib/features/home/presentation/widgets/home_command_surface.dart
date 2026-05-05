import 'package:flutter/material.dart';

class HomeCommandSurface extends StatelessWidget {
  final Widget child;

  const HomeCommandSurface({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white,
        border: Border.all(color: const Color(0xFFDDE5F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x080B57D0),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}
