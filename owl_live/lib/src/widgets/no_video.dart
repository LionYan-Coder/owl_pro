import 'dart:math' as math;

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owl_live/src/utils/live_utils.dart';

class NoVideoWidget extends StatelessWidget {
  //
  const NoVideoWidget({super.key});

  @override
  Widget build(BuildContext context) => Container(
        alignment: Alignment.center,
        child: LayoutBuilder(
          builder: (ctx, constraints) => Icon(
            EvaIcons.videoOffOutline,
            color: Styles.c_0C8CE9,
            size: math.min(constraints.maxHeight, constraints.maxWidth) * 0.3,
          ),
        ),
      );
}

class NoVideoAvatarWidget extends StatelessWidget {
  //
  const NoVideoAvatarWidget({super.key, this.faceURL, this.name});
  final String? faceURL;
  final String? name;
  //

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: Colors.grey,
      child: null != faceURL && LiveUtils.isURL(faceURL!)
          ? ImageUtil.networkImage(
              url: faceURL!,
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.width.h / 2,
              width: MediaQuery.of(context).size.width.h / 2)
          : AvatarView(
              url: faceURL,
              text: name,
            ),
    );
  }
}
