import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/core/controller/im_controller.dart';
import 'package:owlpro_app/routes/app_navigator.dart';

class AccountBaseInfo extends StatelessWidget {
  AccountBaseInfo({super.key});
  final logic = Get.find<IMController>();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final currentUser = logic.userInfo;
      if (currentUser.value.account != null) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  currentUser.value!.nickname!.toText
                    ..style = Styles.ts_333333_24_bold
                        .adapterDark(Styles.ts_0C8CE9_24_bold),
                  4.gapv,
                  currentUser.value!.account!.at.toText
                    ..style =
                        Styles.ts_999999_12.adapterDark(Styles.ts_555555_12),
                  9.gapv,
                  AddressCopy(address: currentUser.value.address ?? ''),
                  10.gapv,
                  SizedBox(
                    width: 0.62.sw,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        "me_ico_Wisdom".png.toImage
                          ..width = 16.w
                          ..height = 16.w
                          ..adpaterDark = true,
                        3.gaph,
                        Expanded(
                            child: (currentUser.value.about != null &&
                                        currentUser.value.about!.isNotEmpty
                                    ? currentUser.value.about
                                    : "identity_about_empty".tr)!
                                .toText
                              ..maxLines = 2
                              ..overflow = TextOverflow.ellipsis
                              ..style = Styles.ts_666666_12
                                  .adapterDark(Styles.ts_999999_12))
                      ],
                    ),
                  )
                ],
              ),
            ),
            Column(
              children: [
                GestureDetector(
                    onTap: () {
                      AppNavigator.startMineQRCode();
                    },
                    child: UserAvatar(
                      radius: 32.w,
                      avatar: currentUser.value?.faceURL,
                      nickname: currentUser.value?.nickname ?? '',
                    )),
                26.gapv,
                GestureDetector(
                    onTap: () {
                      AppNavigator.startMineQRCode();
                    },
                    child: "me_ico_code".svg.toSvg
                      ..color = Styles.c_333333.adapterDark(Styles.c_CCCCCC)
                      ..width = 24.w
                      ..height = 24.w)
              ],
            )
          ],
        );
      } else {
        return const Center(
          child: CircularProgressIndicator.adaptive(),
        );
      }
    });
  }
}
