import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';

class EmptyData extends StatelessWidget {
  final String? text;
  const EmptyData({super.key,this.text});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: SizedBox(
          width: 178.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              "default_ico_none".svg.toSvg..width=  64.w..height = 64.w..color = Styles.c_999999.adapterDark(Styles.c_333333),
              24.gapv,
              ( text ?? "empty".tr).toText..style = Styles.ts_999999_14.adapterDark(Styles.ts_333333_14)..textAlign = TextAlign.center
            ],
          ),
        ),
      ),
    );
  }
}
