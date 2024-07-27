import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

class LoadingSwitcher extends StatelessWidget {
  final bool? loading;
  final Duration? duration;
  final Widget? child;

  const LoadingSwitcher(
      {super.key, this.loading = false, this.duration, this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (loading == true)
          FadeOutUp(
            duration: duration ?? const Duration(milliseconds: 250),
            child: const CircularProgressIndicator.adaptive(),
          ),
        if (loading == null || loading == false)
          FadeInUp(
            duration: duration ?? const Duration(milliseconds: 250),
            child: child ?? const SizedBox.shrink(),
          ),
      ],
    );
  }
}
