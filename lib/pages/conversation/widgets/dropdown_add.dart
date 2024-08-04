import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/routes/app_navigator.dart';

class DropdownAdd extends StatelessWidget {
  const DropdownAdd({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 2.w + context.mediaQueryPadding.top,
      right: 12.w,
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
          dropdownStyleData: DropdownStyleData(
            width: 110.w,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 16).w,
            decoration: BoxDecoration(
              border: Border.all(
                  color: Styles.c_EDEDED.adapterDark(Styles.c_555555)),
              borderRadius: BorderRadius.circular(8.r),
              color: Styles.c_FFFFFF.adapterDark(Styles.c_262626),
            ),
            offset: Offset(-72.w, 0),
          ),
          menuItemStyleData: MenuItemStyleData(
            height: 20.w,
            padding: const EdgeInsets.only(left: 16, right: 16).w,
          ),
          customButton: IgnorePointer(
            child: IconButton(
              onPressed: () {},
              icon: "nvbar_ico_add".svg.toSvg
                ..width = 24.w
                ..height = 24.w
                ..color = Styles.c_333333.adapterDark(Styles.c_CCCCCC),
            ),
          ),
          onChanged: (val) {
            if (val == 'newfriend') {
              AppNavigator.startAddBySearch();
              // context.push(AppRouter.userSearchPath);
            }
          },
          items: [
            DropdownMenuItem(
              value: 'newfriend',
              child: InkWell(
                  child: Row(children: [
                "chat_ico_newfriend".svg.toSvg
                  ..width = 16.w
                  ..height = 16.w
                  ..color = Styles.c_333333.adapterDark(Styles.c_CCCCCC),
                4.gaph,
                "chat_list_newfriend".tr.toText
                  ..style = Styles.ts_333333_14.adapterDark(Styles.ts_CCCCCC_14)
              ])),
            ),
            const DropdownMenuItem(enabled: false, child: SizedBox.shrink()),
            DropdownMenuItem(
              value: 'group',
              child: InkWell(
                  child: Row(children: [
                "chat_ico_group".svg.toSvg
                  ..width = 16.w
                  ..height = 16.w
                  ..color = Styles.c_333333.adapterDark(Styles.c_CCCCCC),
                4.gaph,
                "chat_list_group".tr.toText
                  ..style = Styles.ts_333333_14.adapterDark(Styles.ts_CCCCCC_14)
              ])),
            )
          ],
        ),
      ),
    );
  }
}
