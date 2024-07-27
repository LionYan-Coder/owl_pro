import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:owl_common/owl_common.dart';

class GuideDot extends StatelessWidget {
  final AnimationController animationController;
  const GuideDot({super.key, required this.animationController});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0.5.sh,
      left: 0,
      right: 0,
      child: Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            return AnimatedBuilder(
              animation: animationController,
              builder: (context, child) {
                int selectedIndex = 0;

                if (animationController.value >= 0.3) {
                  selectedIndex = 2;
                } else if (animationController.value >= 0.1) {
                  selectedIndex = 1;
                } else if (animationController.value < 0.1) {
                  selectedIndex = 0;
                }

                return Padding(
                  padding: EdgeInsets.only(right: 2.w),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 4.w,
                    width: selectedIndex == index ? 16.w : 4.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.0),
                        color: selectedIndex == index
                            ? Styles.c_0C8CE9
                            : Styles.c_EDEDED.adapterDark(Styles.c_CCCCCC)),
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}
