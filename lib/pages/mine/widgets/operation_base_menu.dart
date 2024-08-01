import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/routes/app_navigator.dart';

const menus = ["posts", "favorite", "setting", "notification"];

class OperationBaseMenu extends StatelessWidget {
  const OperationBaseMenu({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: menus
          .map((menu) => InkWell(
                onTap: () {
                  _onTapMenu(context, menu);
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 12.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          'me_ico_$menu'.svg.toSvg
                            ..width = 20.w
                            ..fit = BoxFit.cover
                            ..color =
                                Styles.c_333333.adapterDark(Styles.c_CCCCCC),
                          8.gaph,
                          'me_menu_$menu'.tr.toText
                            ..style = Styles.ts_333333_16
                                .adapterDark(Styles.ts_CCCCCC_16)
                                .copyWith(letterSpacing: 1.5.w)
                        ],
                      ),
                      "arrow_right".svg.toSvg
                        ..width = 16.w
                        ..fit = BoxFit.cover
                        ..color = Styles.c_333333.adapterDark(Styles.c_CCCCCC),
                    ],
                  ),
                ),
              ))
          .toList(),
    );
  }

  void _onTapMenu(BuildContext context, String menu) {
    switch (menu) {
      case "setting":
        AppNavigator.startSetting();
        break;
      default:
    }
  }
}
