import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';

class ChatCallItemView extends StatelessWidget {
  const ChatCallItemView({
    super.key,
    this.isISend = false,
    required this.type,
    required this.content,
  });
  final bool isISend;
  final String content;
  final String type;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          content.toText..style = isISend ? Styles.ts_FFFFFF_14 : Styles.ts_333333_14.adapterDark(Styles.ts_CCCCCC_14),
          12.horizontalSpace,
          type == 'audio' ? ("chat_ico_phone_white".svg.toSvg..width = 24.w..height = 24.w..color = isISend ? Styles.c_FFFFFF : Styles.c_333333.adapterDark(Styles.c_CCCCCC) ) : ("chat_ico_video_white".svg.toSvg..width = 24.w..height = 24.w..color = isISend ? Styles.c_FFFFFF : Styles.c_333333.adapterDark(Styles.c_CCCCCC))
        ],
      );
}
