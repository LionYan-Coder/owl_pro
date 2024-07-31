import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/pages/home/home_logic.dart';
import 'package:owlpro_app/pages/mine/mine_page.dart';

class HomePage extends StatelessWidget {
  final logic = Get.find<HomeLogic>();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          bottomNavigationBar: Tabbar(logic: logic),
          body: IndexedStack(
            index: logic.currentPage.value,
            children: [Text("home"), Text("home"), Text("home"), MinePage()],
          ),
        ));
  }
}

class Tabbar extends StatelessWidget {
  const Tabbar({
    super.key,
    required this.logic,
  });

  final HomeLogic logic;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          bottom: context.mediaQueryPadding.bottom,
          left: 34.w,
          right: 34.w,
          top: 16.w),
      decoration: BoxDecoration(
          border: Border(
              top: BorderSide(
                  color: Styles.c_F6F6F6.adapterDark(Styles.c_161616))),
          color: Styles.c_FFFFFF.adapterDark(Styles.c_0D0D0D)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: logic.tabs
            .asMap()
            .map((index, icon) => MapEntry(
                index,
                IconButton(
                    onPressed: () {
                      logic.onChangePage(index);
                    },
                    icon:
                        "${logic.tabs[index]}${logic.currentPage.value == index ? '_act' : '_nor'}"
                            .svg
                            .toSvg
                          ..width = 24.w
                          ..fit = BoxFit.cover
                          ..color =
                              Styles.c_333333.adapterDark(Styles.c_CCCCCC))))
            .values
            .toList(),
      ),
    );
  }
}
