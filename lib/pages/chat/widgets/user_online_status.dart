import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';

enum UserStatus { online, offline }

class UserOnlineStatus extends StatelessWidget {
  final UserStatus status;
  const UserOnlineStatus({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4).w,
      decoration: BoxDecoration(
          color: status == UserStatus.online
              ? Styles.c_0C8CE9.withOpacity(0.05)
              : Styles.c_DE473E.withOpacity(0.05),
          borderRadius: BorderRadius.circular(4.r)),
      child: Center(
        child: status.name.tr.toText
          ..style = status == UserStatus.online
              ? Styles.ts_0C8CE9_10
              : Styles.ts_DE473E_10,
      ),
    );
  }
}
