import 'package:ellipsized_text/ellipsized_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:owl_common/owl_common.dart';

class AddressCopy extends StatelessWidget {
  const AddressCopy({super.key, required this.address, this.width});
  final double? width;
  final String address;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: width ?? 178.w,
          padding:
              const EdgeInsets.only(top: 3, bottom: 3, left: 4, right: 4).w,
          decoration: BoxDecoration(
              color: Styles.c_0C8CE9.withOpacity(0.05),
              borderRadius: BorderRadius.circular(4.r)),
          child: EllipsizedText(
            address.toOc,
            type: EllipsisType.middle,
            style: Styles.ts_0C8CE9_14,
          ),
        ),
        4.gaph,
        ButtonCopy(
          data: address.toOc,
          single: false,
        )
      ],
    );
  }
}
