import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';

class TitleBar extends StatelessWidget implements PreferredSizeWidget {
  const TitleBar({
    super.key,
    this.height,
    this.left,
    this.center,
    this.right,
    this.backgroundColor,
    this.showUnderline = false,
  });
  final double? height;
  final Widget? left;
  final Widget? center;
  final Widget? right;
  final Color? backgroundColor;
  final bool showUnderline;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: Get.isDarkMode
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: Container(
        color: backgroundColor ?? Styles.c_FFFFFF.adapterDark(Styles.c_0D0D0D),
        padding: EdgeInsets.only(top: mq.padding.top),
        child: Container(
          height: height,
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Row(
            children: [
              if (null != left) left!,
              if (null != center) center!,
              if (null != left && null != center && null == right)
                SizedBox(width: 24.w),
              if (null != right) right!,
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height ?? 44.h);

  TitleBar.back({
    super.key,
    String? title,
    String? leftTitle,
    TextStyle? titleStyle,
    TextStyle? leftTitleStyle,
    String? result,
    Color? backgroundColor,
    Color? backIconColor,
    this.right,
    this.showUnderline = false,
    Function()? onTap,
  })  : height = 44.h,
        backgroundColor =
            backgroundColor ?? Styles.c_FFFFFF.adapterDark(Styles.c_0D0D0D),
        center = Expanded(
            child: (title ?? '').toText
              ..style = titleStyle ??
                  Styles.ts_333333_18_medium
                      .adapterDark(Styles.ts_CCCCCC_18_medium)
              ..textAlign = TextAlign.center),
        left = GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: onTap ?? (() => Get.back(result: result)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              "nvbar_ico_back".svg.toSvg
                ..width = 24.w
                ..height = 24.h
                ..color = backIconColor ??
                    Styles.c_333333.adapterDark(Styles.c_CCCCCC),
              if (null != leftTitle)
                leftTitle.toText
                  ..style = (leftTitleStyle ??
                      Styles.ts_333333_16_medium
                          .adapterDark(Styles.ts_CCCCCC_16_medium)),
            ],
          ),
        );
}
