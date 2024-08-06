import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:owl_common/owl_common.dart';

class Tag extends StatefulWidget {
  final String label;
  final VoidCallback onDismissed;
  const Tag({super.key, required this.label, required this.onDismissed});

  @override
  State<Tag> createState() => _TagState();
}

class _TagState extends State<Tag> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  void _onClose() {
    Logger.print("_onClose");
    _controller.reverse().then((value) {
      widget.onDismissed(); // 动画结束后回调通知外部移除组件
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _controller.drive(Tween(begin: 1.0, end: 0.0)),
      child: FadeTransition(
        opacity: _controller.drive(Tween(begin: 1.0, end: 0.0)),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.r),
                  color: Styles.c_0C8CE9.withOpacity(0.05)),
              child: "#${widget.label}".toText..style = Styles.ts_0C8CE9_14,
            ),
            Positioned(
                right: -8.w,
                top: -10.w,
                child: GestureDetector(
                  onTap: _onClose,
                  child: SizedBox(
                    width: 24.w,
                    height: 24.w,
                    child: Center(
                      child: ClipOval(
                          child: Container(
                        color: Styles.c_DE473E,
                        width: 12.w,
                        height: 12.w,
                        child: Center(
                          child: Icon(
                            Icons.close_rounded,
                            size: 10.sp,
                            color: Styles.c_FFFFFF,
                          ),
                        ),
                      )),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
