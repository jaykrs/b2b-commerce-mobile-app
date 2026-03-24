import 'package:flutter/material.dart';

class FadeIn extends StatelessWidget {
  final Widget child;

  const FadeIn({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 400),
      builder: (context, value, child) {
        return Opacity(opacity: value as double, child: child);
      },
      child: child,
    );
  }
}
