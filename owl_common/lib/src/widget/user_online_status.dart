import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';

class UserOnlineDot extends StatelessWidget {
  final bool online;
  const UserOnlineDot({super.key, required this.online});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 16.h,
      padding: const EdgeInsets.symmetric(horizontal: 4).w,
      decoration: BoxDecoration(
          color: online
              ? Styles.c_0C8CE9.withOpacity(0.05)
              : Styles.c_DE473E.withOpacity(0.05),
          borderRadius: BorderRadius.circular(4.r)),
      child: Center(
        child: Row(
          children: [
            ClipOval(
              child: Container(
                width: 6.w,
                height: 6.w,
                color: online ?Styles.c_1ED386 : Styles.c_DE473E,
              ),
            ),
            2.gaph,
            (online ? 'online' : 'offline').tr.toText
              ..style = online ? Styles.ts_0C8CE9_10 : Styles.ts_DE473E_10,
          ],
        ),
      ),
    );
  }
}
