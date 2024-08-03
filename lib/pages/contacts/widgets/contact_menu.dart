import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/pages/contacts/contact_logic.dart';

class ContactMenus extends StatelessWidget {
  ContactMenus({super.key});

  final contactLogic = Get.find<ContactLogic>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 24, right: 24, top: 12, bottom: 18).w,
      child: Column(
        children: [
          _panelButton(
              context: context,
              icon: "chat_ico_newfriend".svg.toSvg
                ..width = 16.w
                ..fit = BoxFit.cover
                ..color = Styles.c_0C8CE9,
              text: "contact_panel_new_friend".tr,
              onTap: () {
                contactLogic.newFriend();
                // context.push(AppRouter.contactNewFriend);
              }),
          _panelButton(
              context: context,
              icon: "chat_ico_inform".svg.toSvg
                ..width = 16.w
                ..fit = BoxFit.cover
                ..color = Styles.c_0C8CE9,
              text: "contact_panel_inform".tr,
              extra: redDot(context, count: 6),
              onTap: () {
                contactLogic.myGroup();
              }),
          _panelButton(
              context: context,
              icon: "chat_ico_block".svg.toSvg
                ..width = 16.w
                ..fit = BoxFit.cover
                ..color = Styles.c_DE473E,
              text: "contact_panel_block".tr,
              onTap: () {
                contactLogic.myBlack();
              }),
          _panelButton(
              context: context,
              icon: "chat_ico_group".svg.toSvg
                ..width = 16.w
                ..fit = BoxFit.cover
                ..color = Styles.c_1ED386,
              text: "contact_panel_group".tr,
              onTap: () {
                contactLogic.myGroup();
              })
        ],
      ),
    );
  }

  Widget _panelButton(
      {required BuildContext context,
      required Widget icon,
      required String text,
      VoidCallback? onTap,
      Widget? extra}) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) onTap();
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 8.w),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12).w,
        decoration: BoxDecoration(
            border:
                Border.all(color: Styles.c_EDEDED.adapterDark(Styles.c_333333)),
            color: Styles.c_F9F9F9.adapterDark(Styles.c_262626),
            borderRadius: BorderRadius.circular(8.r)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color:
                                Styles.c_EDEDED.adapterDark(Styles.c_262626)),
                        color: Styles.c_FFFFFF.adapterDark(Styles.c_0D0D0D),
                        borderRadius: BorderRadius.circular(9999)),
                    child: Center(child: icon),
                  ),
                  12.gaph,
                  text.toText
                    ..style = Styles.ts_333333_16_medium
                        .adapterDark(Styles.ts_CCCCCC_16_medium)
                ],
              ),
            ),
            extra ?? const SizedBox.shrink(),
            4.gaph
          ],
        ),
      ),
    );
  }

  Widget redDot(BuildContext context, {required int count}) {
    return ClipOval(
      child: Container(
        color: Styles.c_DE473E,
        width: 16.w,
        height: 16.w,
        child: Center(
            child: "$count".toText
              ..style = Styles.ts_FFFFFF_10.adapterDark(Styles.ts_333333_10)),
      ),
    );
  }
}
