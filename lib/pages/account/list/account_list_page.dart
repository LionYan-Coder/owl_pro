import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/core/controller/im_controller.dart';
import 'package:owlpro_app/pages/account/list/account_list_logic.dart';
import 'package:owlpro_app/routes/app_routes.dart';

class AccountListPage extends StatelessWidget {
  AccountListPage({super.key});

  final logic = Get.find<AccountListLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(
        title: "id_screen_title".tr,
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        padding: EdgeInsets.only(
            left: 24.w,
            right: 24.w,
            top: 16.w,
            bottom: context.mediaQueryPadding.bottom),
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
                    color: Styles.c_F6F6F6.adapterDark(Styles.c_161616))),
            color: Styles.c_FFFFFF.adapterDark(Styles.c_0D0D0D)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Flexible(
                child: "sign_guide_create_title".tr.toButton
                  ..onPressed = () {
                    Get.toNamed(AppRoutes.loginCreate);
                  }),
            6.gaph,
            Flexible(
                child: "sign_guide_restore_title".tr.toButton
                  ..onPressed = () {
                    Get.toNamed(AppRoutes.loginRestore);
                  })
          ],
        ),
      ),
      body: Obx(() => logic.loading.value
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : ListView.builder(
              itemCount: logic.accounts.length,
              padding: const EdgeInsets.all(24).w,
              itemBuilder: (context, index) {
                return AccountCard(
                  user: logic.accounts[index],
                  onChanged: (user) {
                    logic.onChangeUser(user);
                  },
                );
              },
            )),
    );
  }
}

class AccountCard extends StatelessWidget {
  final UserFullInfo user;
  final Function(UserFullInfo user) onChanged;
  AccountCard({super.key, required this.user, required this.onChanged});

  final imLogic = Get.find<IMController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSelected = user.userID == imLogic.userInfo.value?.userID;
      return GestureDetector(
        onTap: () {
          onChanged(user);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding:
              const EdgeInsets.only(left: 16, right: 12, top: 20, bottom: 20).w,
          margin: const EdgeInsets.only(bottom: 12).w,
          decoration: BoxDecoration(
            border: Border.all(
                color: isSelected
                    ? Styles.c_0C8CE9
                    : Styles.c_EDEDED.adapterDark(Styles.c_262626)),
            color: isSelected
                ? Styles.c_0C8CE9.withOpacity(0.05)
                : Styles.c_FFFFFF.adapterDark(Styles.c_0D0D0D),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      UserAvatar(
                        radius: 12.w,
                        avatar: user.faceURL ?? '',
                        nickname: user.nickname ?? '',
                        fontSize: 10.sp,
                      ),
                      8.gaph,
                      AnimatedDefaultTextStyle(
                        style: isSelected
                            ? Styles.ts_0481DC_16_medium
                            : Styles.ts_333333_16_medium
                                .adapterDark(Styles.ts_CCCCCC_16_medium),
                        duration: const Duration(milliseconds: 250),
                        child: user.nickname!.toText,
                      ),
                    ],
                  ),
                  4.gapv,
                  AddressCopy(
                    address: user.address ?? '',
                    width: 210.w,
                  )
                ],
              ),
              isSelected
                  ? ("selected".svg.toSvg
                    ..width = 24.w
                    ..height = 24.w)
                  : const SizedBox.shrink()
            ],
          ),
        ),
      );
    });
  }
}
