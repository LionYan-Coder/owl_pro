import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

bool isValidHexColor(String hexColor) {
  final RegExp regex = RegExp(r'^0x[0-9A-Fa-f]{8}$');
  return regex.hasMatch(hexColor);
}

class UserAvatar extends StatelessWidget {
  final String? avatar;
  final String nickname;
  final double radius;
  final double? fontSize;

  const UserAvatar(
      {super.key,
      this.avatar = '0xFF0C8CE9',
      required this.radius,
      required this.nickname,
      this.fontSize});

  @override
  Widget build(BuildContext context) {
    final isHexColor = isValidHexColor(avatar ?? '');
    final backgroundColor =
        isHexColor ? Color(int.parse(avatar!.substring(2), radix: 16)) : null;

    final foregroundImage = !isHexColor ? NetworkImage(avatar ?? '') : null;
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor,
      foregroundImage: foregroundImage,
      child: Text(
        nickname.substring(0, 2),
        style: TextStyle(fontSize: fontSize ?? 20.0.sp),
      ),
    );
  }
}
