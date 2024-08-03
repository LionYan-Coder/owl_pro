import 'package:ellipsized_text/ellipsized_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/pages/contacts/add_by_search/add_by_search_logic.dart';
import 'package:owlpro_app/routes/app_navigator.dart';
import 'package:owlpro_app/routes/app_routes.dart';

class AddBySearchPage extends StatelessWidget {
  AddBySearchPage({super.key});

  final logic = Get.find<AddBySearchLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(
        title: "user_search_title".tr,
        right: Row(
          children: [
            IconButton(
                onPressed: () {
                  //TODO 扫描二维码
                },
                icon: "ico_scan".svg.toSvg
                  ..width = 24.w
                  ..height = 24.w),
            16.gaph
          ],
        ),
      ),
      body: Column(
        children: [
          20.gapv,
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Input(
                controller: logic.searchTextController,
                name: "search_id",
                hintText: "user_search_field_hint".tr,
                prefixIcon: Icon(
                  Icons.search,
                  color: Styles.c_999999.adapterDark(Styles.c_666666),
                ),
                suffixIcon: Padding(
                  padding: EdgeInsets.all(12.w),
                  child: Button(
                    width: 44.w,
                    height: 24.w,
                    onPressed: logic.onSearch,
                    borderRadius: 4.r,
                    text: "user_search_button".tr,
                    textStyle: Styles.ts_FFFFFF_12_medium,
                  ),
                ),
              )),
          searchResult()
        ],
      ),
    );
  }

  Widget searchResult() {
    return Obx(() {
      if (logic.loading.value) {
        return const Expanded(
          child: Center(
            child: CircularProgressIndicator.adaptive(),
          ),
        );
      } else if (logic.currentUser.value != null) {
        final user = logic.currentUser.value;
        return Container(
          margin: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(
                      color: Styles.c_F6F6F6.adapterDark(Styles.c_161616)))),
          child: InkWell(
            onTap: () {
              if (user != null) {
                AppNavigator.startUserProfile(user);
              }
            },
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 24).w,
              child: Row(
                children: [
                  AvatarView(
                    radius: 20.w,
                    tag: user?.account ?? 'avatar',
                    url: user?.faceURL ?? '',
                    text: user?.nickname ?? '',
                  ),
                  8.gaph,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      (user?.nickname ?? '').toText
                        ..style = Styles.ts_333333_14_medium
                            .adapterDark(Styles.ts_CCCCCC_14_medium),
                      5.gapv,
                      SizedBox(
                        width: 138.w,
                        child: EllipsizedText(
                          user?.address?.toOc ?? '',
                          type: EllipsisType.middle,
                          style: Styles.ts_999999_12
                              .adapterDark(Styles.ts_666666_12),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      } else if (logic.searchTextController.text.isNotEmpty &&
          logic.currentUser.value == null) {
        return Padding(
          padding: EdgeInsets.only(top: 64.w),
          child: Center(
              child: "user_search_result_empty".tr.toText
                ..style = Styles.ts_999999_16.adapterDark(Styles.ts_666666_16)),
        );
      }

      return const SizedBox.shrink();
    });
  }
}
