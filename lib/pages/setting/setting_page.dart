import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/pages/mine/mine_logic.dart';
import 'package:owlpro_app/pages/setting/setting_logic.dart';
import 'package:owlpro_app/pages/setting/widgets/setting_menu.dart';
import 'package:owlpro_app/routes/app_navigator.dart';

class SettingPage extends StatelessWidget {
  SettingPage({super.key});

  final logic = Get.find<SettingLogic>();
  final mineLogic = Get.find<MineLogic>();

  @override
  Widget build(BuildContext context) {
    final locale = Get.locale as Locale;
    return Scaffold(
      appBar: TitleBar.back(
        title: "setting_title".tr,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                      left: 24, right: 24, top: 20, bottom: 32)
                  .w,
              child: Column(
                children: [
                  SettingMenu(
                    label: "setting_clear_cache".tr,
                    extra: Padding(
                      padding: EdgeInsets.only(right: 4.w),
                      child: FutureBuilder(
                          future: logic.calculateSharedPreferencesSize(),
                          builder: (context, state) {
                            if (state.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator.adaptive();
                            }
                            if (state.hasError) {
                              return const SizedBox.shrink();
                            }

                            return state.requireData.toText
                              ..style = Styles.ts_0C8CE9_16;
                          }),
                    ),
                    onTap: logic.onClearCache,
                  ),
                  6.gapv,
                  SettingMenu(
                    label: "setting_clear_record".tr,
                  ),
                  6.gapv,
                  SettingMenu(
                    label: "setting_backup_record".tr,
                  ),
                  divider(),
                  SettingMenu(
                    label: "setting_select_lang".tr,
                    extra: Padding(
                        padding: EdgeInsets.only(right: 4.w),
                        child: trMap[
                                "${locale.languageCode}_${locale.countryCode ?? ''}"]!
                            .toText
                          ..style = Styles.ts_0C8CE9_16_medium),
                    onTap: () {
                      AppNavigator.startSettingLanguage();
                    },
                  ),
                  6.gapv,
                  SettingMenu(
                    label: "setting_chat_font".tr,
                  ),
                  6.gapv,
                  SettingMenu(
                    label: "setting_notify_voice".tr,
                  ),
                  6.gapv,
                  SettingMenu(
                    label: "setting_theme".tr,
                    onTap: () {
                      AppNavigator.startSettingTheme();
                    },
                  ),
                  6.gapv,
                  SettingMenu(
                    label: "setting_download".tr,
                  ),
                  divider(),
                  SettingMenu(
                    onTap: () {
                      AppNavigator.startSettingPassword();
                    },
                    label: "setting_edit_password".tr,
                  ),
                  6.gapv,
                  Obx(() => SettingMenu(
                      onTap: logic.openAppLock,
                      label: "setting_app_lock".tr,
                      hint: Padding(
                          padding: const EdgeInsets.only(bottom: 20).w,
                          child: "setting_app_lock_hint".tr.toText
                            ..style = Styles.ts_666666_12
                                .adapterDark(Styles.ts_555555_12)
                                .copyWith(letterSpacing: 2.w)),
                      extra: Padding(
                        padding: const EdgeInsets.only(right: 1).w,
                        child: Text(
                          DateUtil2.formattedTimes(
                              mineLogic.verifyPwdGapTime.value.dateTime),
                          style: Styles.ts_0C8CE9_16_medium,
                        ),
                      ))),
                  6.gapv,
                  SettingMenu(
                    label: "setting_privacy".tr,
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }

  Widget divider() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12).w,
      height: 0,
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(
        color: Styles.c_F6F6F6.adapterDark(Styles.c_161616),
      ))),
    );
  }
}
