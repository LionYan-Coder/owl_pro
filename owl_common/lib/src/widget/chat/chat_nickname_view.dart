import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:owl_common/owl_common.dart';

class ChatNicknameView extends StatelessWidget {
  const ChatNicknameView({
    super.key,
    this.nickname,
    this.timeStr,
  });
  final String? nickname;
  final String? timeStr;

  @override
  Widget build(BuildContext context) {
    return RichText(
      strutStyle: StrutStyle(fontFamily: Styles.fontFamily,fontSize: 12.sp,),
      text: TextSpan(
        text: '',
        style: Styles.ts_999999_12.adapterDark(Styles.ts_666666_12),

        children: [
          if (null != nickname)
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: Container(
                constraints: BoxConstraints(maxWidth: 100.w),
                margin: EdgeInsets.only(right: 12.w),
                child: nickname!.toText
                  ..style = Styles.ts_999999_12.adapterDark(Styles.ts_666666_12)
                  ..maxLines = 1
                  ..overflow = TextOverflow.ellipsis,
              ),
            ),
          TextSpan(text: timeStr),
        ],
      ),
    );
  }
}
