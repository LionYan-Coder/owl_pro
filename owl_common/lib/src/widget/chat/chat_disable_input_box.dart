import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:owl_common/owl_common.dart';

class ChatDisableInputBox extends StatelessWidget {
  const ChatDisableInputBox({Key? key, this.type = 0}) : super(key: key);

  final int type;

  @override
  Widget build(BuildContext context) {
    return type == 0
        ? Container(
            height: 56.h,
            color: Styles.c_0C8CE9,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ImageRes.warn.toImage
                  ..width = 14.w
                  ..height = 14.h,
                6.horizontalSpace,
                StrRes.notSendMessageNotInGroup.toText
                  ..style = Styles.ts_0C8CE9_18_bold,
              ],
            ),
          )
        : Container();
  }
}
