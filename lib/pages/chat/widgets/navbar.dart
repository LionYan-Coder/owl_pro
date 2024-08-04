import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:owl_common/owl_common.dart';

class ChatNavbar extends StatelessWidget implements PreferredSizeWidget{
  final double? height;
  final Widget? left;
  final Widget? right;
  const ChatNavbar({super.key,this.height,this.left,this.right});

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return Container(
      padding: EdgeInsets.only(top: mq.padding.top),
      decoration: BoxDecoration(
        color:  Styles.c_FFFFFF.adapterDark(Styles.c_0D0D0D),
        border: Border(bottom: BorderSide(color: Styles.c_F6F6F6.adapterDark(Styles.c_161616)))
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (null != left) left!,
          if (null != right) right!,
        ],
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(height ?? 44.h);
}
