import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:owl_common/owl_common.dart';

class ChatTimelineView extends StatelessWidget {
  const ChatTimelineView({
    super.key,
    required this.timeStr,
    this.margin,
  });
  final String timeStr;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 6.w),
      decoration: BoxDecoration(
        color: Styles.c_FFFFFF,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: timeStr.toText..style = Styles.ts_999999_12,
    );
  }
}
