import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';

class ToastHelper {
  static void showToast(BuildContext context, String text) {
    Widget widget = Positioned(
      top: context.mediaQueryPadding.top + 48.w,
      left: 0,
      right: 0,
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
            decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    offset: const Offset(0, 4),
                    blurRadius: 15,
                  )
                ],
                borderRadius: BorderRadius.circular(12.r)),
            padding:
                const EdgeInsets.symmetric(vertical: 4.0, horizontal: 14.0).w,
            child: text.toText
              ..style = Styles.ts_FFFFFF_12.adapterDark(Styles.ts_CCCCCC_12)),
      ),
    )
        .animate()
        .fadeIn(duration: const Duration(milliseconds: 250))
        .move(
            begin: const Offset(0, 0.15),
            end: const Offset(0, 0),
            duration: const Duration(milliseconds: 250))
        .then(delay: const Duration(seconds: 1500))
        .fadeOut(duration: const Duration(milliseconds: 200))
        .move(
            begin: const Offset(0, 0),
            end: const Offset(0, -0.15),
            duration: const Duration(milliseconds: 500));
    var entry = OverlayEntry(
      builder: (_) => widget,
    );

    Overlay.of(context).insert(entry);

    Timer(const Duration(seconds: 2), () {
      entry.remove();
    });
  }
}
