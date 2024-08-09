import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:owl_common/owl_common.dart';

class RippleEffectButton extends StatefulWidget {
  const RippleEffectButton({super.key});

  @override
  State<RippleEffectButton> createState() => _RippleEffectButtonState();
}

class _RippleEffectButtonState extends State<RippleEffectButton> with SingleTickerProviderStateMixin  {

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        for (int i = 0; i < 3; i++)
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              double progress = (_controller.value + i * 0.3) % 1;
              double size = 100 + 110 * progress;
              double opacity = 1 - progress;
              return Transform.scale(
                scale: size / 110, // 保证大小的稳定性
                child: Container(
                  width: 110, // 固定容器大小
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Styles.c_FFFFFF.withOpacity(opacity),
                  ),
                ),
              );
            },
          ),
        ClipOval(
          child: Container(
            width: 100.w,
            height: 100.w,
            color: Colors.white,
            child: Center(
              child: "logo".png.toImage..width = 45.w..height = 50.w,
            ),
          ),
        )
      ],
    );
  }
}
