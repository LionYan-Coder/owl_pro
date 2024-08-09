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
    required this.viewType
  });

  final bool isISend;
  final String content;
  final String type;
  final int viewType;

  @override
  Widget build(BuildContext context) {
    String icon = isISend ?  'chat_ico_call_outgoing' : "chat_ico_call_incoming";
    Color color = isISend ? Styles.c_FFFFFF : Styles.c_333333.adapterDark(Styles.c_FFFFFF);
    if (viewType == CustomMessageType.callingReject){
      color = Styles.c_DE473E;
    } else if (viewType == CustomMessageType.callingHungup){
      color = Styles.c_1ED386;
    }
    return Row(
      children: [
        ClipOval(
          child: Container(
            width: 24.w,
            height: 24.w,
            color: isISend ? Styles.c_FFFFFF.withOpacity(0.2) : Styles.c_FFFFFF,
            child: Center(
              child: icon.svg.toSvg..color = color..width = 12.w..height = 12.w,
            ),
          ),
        ),
        8.gaph,
        content.toText..style = isISend ? Styles.ts_FFFFFF_14 : Styles.ts_333333_14.adapterDark(Styles.ts_CCCCCC_14),
        12.horizontalSpace,
        type == 'audio' ? ("chat_ico_phone_white".svg.toSvg..width = 24.w..height = 24.w..color = isISend ? Styles.c_FFFFFF : Styles.c_333333.adapterDark(Styles.c_CCCCCC) ) : ("chat_ico_video_white".svg.toSvg..width = 24.w..height = 24.w..color = isISend ? Styles.c_FFFFFF : Styles.c_333333.adapterDark(Styles.c_CCCCCC))
      ],
    );
  }
}