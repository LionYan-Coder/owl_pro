import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:owl_common/owl_common.dart';

class LiveButton extends StatelessWidget {
  const LiveButton({
    super.key,
    required this.text,
    required this.icon,
    required this.enabledCamera,
    this.onTap,
    this.color,
    this.size,
    this.glow,

  });
  final String text;
  final SvgView icon;
  final Color? color;
  final double? size;
  final bool? glow;
  final bool enabledCamera;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AvatarGlow(
          glowCount: glow == true ?  3 : 0,
          animate: glow == true,
          glowColor: color ?? Styles.c_1ED386,
          glowRadiusFactor: 0.3,
          child: InkResponse(
            onTap: onTap,
            child: Container(
              width: size ?? 56.w,
              height: size ?? 56.w,
              decoration: BoxDecoration(
                  color: color ??   (enabledCamera ? Colors.black.withOpacity(0.5) :  Styles.c_FFFFFF.adapterDark(Styles.c_262626)),
                  border: color == null ?  Border.all(color: enabledCamera ? Styles.c_333333 :  Styles.c_EDEDED.adapterDark(Styles.c_161616)) : null,
                  borderRadius: BorderRadius.circular(999)),
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: enabledCamera ? (icon..color = Styles.c_FFFFFF) :  icon,
                ),
              ),
            ),
          ),
        ),
        10.gapv,
        text.toText..style = enabledCamera ? Styles.ts_FFFFFF_10 :  Styles.ts_333333_10.adapterDark(Styles.ts_CCCCCC_10),
      ],
    );
  }

  LiveButton.microphone({
    super.key,
    this.onTap,
    this.color,
    this.size,
    this.glow,
    this.enabledCamera = false,
    bool on = true,
  })  : text = StrRes.microphone,

        icon = on ? ("videocall_ico_mute_nor".svg.toSvg..width = 24.w..height = 24.w..color =  Styles.c_333333.adapterDark(Styles.c_999999)) : ("videocall_ico_mute_act".svg.toSvg..width = 24.w..height = 24.w);

  LiveButton.speaker({
    super.key,
    this.onTap,
    this.color,
    this.size,
    this.glow,
    this.enabledCamera = false,
    bool on = true,
  })  : text = StrRes.speaker,
        icon = on ? ("videocall_ico_loudspeaker_nor".svg.toSvg..width = 24.w..height = 24.w..color =  Styles.c_333333.adapterDark(Styles.c_999999)) : ("videocall_ico_loudspeaker_act".svg.toSvg..width = 24.w..height = 24.w);

  LiveButton.video({
    super.key,
    this.onTap,
    this.color,
    this.size,
    this.glow,
    this.enabledCamera = false,
    bool on = true,
  })  : text = StrRes.video,
        icon = on ? ("videocall_ico_video_nor".svg.toSvg..width = 24.w..height = 24.w..color = Styles.c_333333.adapterDark(Styles.c_999999)) : ("videocall_ico_video_act".svg.toSvg..width = 24.w..height = 24.w);


  LiveButton.hungUp({
    super.key,
    this.onTap,
    this.size,
    this.glow,
    this.enabledCamera = false,
  })  : text = StrRes.hangUp,
        icon = "videocall_ico_end".svg.toSvg..width = 24.w..height = 24.w,
        color = Styles.c_DE473E;

  LiveButton.giveUp({
    super.key,
    this.onTap,
    this.glow,
    this.color,
    this.enabledCamera = false,
  })  : text = StrRes.giveUp,
        icon = "videocall_ico_close".svg.toSvg..width = 24.w..height = 24.w..color = Styles.c_333333.adapterDark(Styles.c_999999),
        size = 64.w;

  LiveButton.reject({
    super.key,
    this.onTap,
    this.glow,
    this.enabledCamera = false,
  })  : text = StrRes.rejectUp,
        icon =  "videocall_ico_end".svg.toSvg..width = 24.w..height = 24.w,
        size = 64.w,
        color = Styles.c_DE473E;


  LiveButton.callAgain({
    super.key,
    this.onTap,
    this.glow,
    this.enabledCamera = false,
  })  : text = StrRes.callAgain,
        size = 64.w,
        icon = "videocall_ico_start".svg.toSvg..width = 24.w..height = 24.w,
        color = Styles.c_1ED386;

  LiveButton.pickUp({
    super.key,
    this.onTap,
    this.enabledCamera = false,
  })  : text = StrRes.pickUp,
        size = 64.w,
        icon =   "videocall_ico_start".svg.toSvg..width = 24.w..height = 24.w,
        color = Styles.c_1ED386,
        glow = true;
}
