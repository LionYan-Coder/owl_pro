import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/core/controller/im_controller.dart';
import 'package:owlpro_app/pages/account/account_logic.dart';
import 'package:owlpro_app/pages/mine/mine_logic.dart';
import 'package:owlpro_app/routes/app_routes.dart';

class AccountPage extends StatelessWidget {
  AccountPage({super.key});

  final mineLogic = Get.find<MineLogic>();
  final imLogic = Get.find<IMController>();
  final logic = Get.find<AccountLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(
        title: "identity_title".tr,
        right: Row(
          children: [
            IconButton(
                onPressed: () {
                  Get.toNamed(AppRoutes.accountInfoEdit, parameters: {
                    "userID": imLogic.userInfo.value.userID ?? ''
                  });
                },
                icon: "nvbar_edit".svg.toSvg
                  ..width = 24.w
                  ..height = 24.w
                  ..color = Styles.c_333333.adapterDark(Styles.c_CCCCCC)),
            16.gaph
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24).w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => userInfo()),
            Obx(() => walletInfo()),
            36.gapv,
            Obx(() => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 64).w,
                child: "identity_del_button".tr.toButton
                  ..loading = logic.loading.value
                  ..onPressed = logic.delAccount
                  ..variants = ButtonVariants.outline
                  ..textStyle = Styles.ts_DE473E_16_medium))
          ],
        ),
      ),
    );
  }

  Widget userInfo() {
    final currentUser = imLogic.userInfo.value;
    return Container(
      padding: const EdgeInsets.only(bottom: 32).w,
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: Styles.c_F6F6F6.adapterDark(Styles.c_161616)))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          userCover(currentUser),
          24.gapv,
          AvatarView(
            radius: 36.w,
            tag: currentUser.nickname ?? 'avatar',
            url: currentUser.faceURL,
            text: currentUser.nickname ?? '',
          ),
          24.gapv,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              "identity_nickname_label".tr.toText
                ..style = Styles.ts_333333_16.adapterDark(Styles.ts_CCCCCC_16),
              (currentUser.nickname ?? '').toText
                ..style = Styles.ts_666666_16.adapterDark(Styles.ts_999999_16)
            ],
          ),
          32.gapv,
          "identity_about_label".tr.toText
            ..style = Styles.ts_333333_16.adapterDark(Styles.ts_CCCCCC_16),
          12.gapv,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              "me_ico_Wisdom".png.toImage
                ..width = 16.w
                ..height = 16.w
                ..adpaterDark = true,
              3.gaph,
              Expanded(
                  child: (currentUser.about != null &&
                              currentUser.about!.isNotEmpty
                          ? currentUser.about
                          : "identity_about_empty".tr)!
                      .toText
                    ..maxLines = 2
                    ..overflow = TextOverflow.ellipsis
                    ..style =
                        Styles.ts_666666_12.adapterDark(Styles.ts_999999_12))
            ],
          )
        ],
      ),
    );
  }

  Widget walletInfo() {
    final currentUser = imLogic.userInfo.value;
    final wallet = mineLogic.currentWallet.value;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16).w,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 14.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                "identity_Id".tr.toText
                  ..style =
                      Styles.ts_333333_16.adapterDark(Styles.ts_CCCCCC_16),
                (currentUser.account?.at ?? '').toText
                  ..style = Styles.ts_666666_16.adapterDark(Styles.ts_999999_16)
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 14.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                "identity_address".tr.toText
                  ..style =
                      Styles.ts_333333_16.adapterDark(Styles.ts_CCCCCC_16),
                AddressCopy(address: currentUser.address ?? '')
              ],
            ),
          ),
          wallet.isFromMnemonic == true
              ? InkWell(
                  onTap: () => logic.showMnemonic(wallet),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 14.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        "identity_show_mnemonic".tr.toText
                          ..style = Styles.ts_333333_16
                              .adapterDark(Styles.ts_CCCCCC_16),
                        "arrow_right".svg.toSvg
                          ..width = 16.w
                          ..fit = BoxFit.cover
                          ..color =
                              Styles.c_333333.adapterDark(Styles.c_CCCCCC),
                      ],
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          InkWell(
            onTap: () => logic.showPrivateKey(wallet),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 14.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  "identity_show_privKey".tr.toText
                    ..style =
                        Styles.ts_333333_16.adapterDark(Styles.ts_CCCCCC_16),
                  "arrow_right".svg.toSvg
                    ..width = 16.w
                    ..fit = BoxFit.cover
                    ..color = Styles.c_333333.adapterDark(Styles.c_CCCCCC),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget userCover(UserFullInfo currentUser) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(12.0.w),
        child:
            (currentUser.coverURL != null && currentUser.coverURL!.isNotEmpty)
                ? Image.network(
                    currentUser.coverURL ?? '',
                    width: double.infinity,
                    fit: BoxFit.fitWidth,
                    height: 140.w,
                  )
                : ("banner_placeholder".png.toImage
                  ..width = double.infinity
                  ..height = 140.w
                  ..fit = BoxFit.fitWidth));
  }
}
