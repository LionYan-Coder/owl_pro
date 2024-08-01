import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/pages/contacts/widgets/contact_menu.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16)
                          .w,
                  child: Row(
                    children: [
                      "contact_title".tr.toText
                        ..style = Styles.ts_333333_18_bold
                            .adapterDark(Styles.ts_CCCCCC_18_bold)
                    ],
                  ),
                ),
                Positioned(
                    top: 6.w,
                    right: 16.w,
                    child: IconButton(
                        onPressed: () {
                          //TODO 搜索页
                        },
                        icon: "nvbar_ico_search".svg.toSvg
                          ..width = 24.w
                          ..height = 24.w
                          ..color =
                              Styles.c_333333.adapterDark(Styles.c_CCCCCC)))
              ],
            ),
            Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 18).w,
                child: ContactMenus())
          ],
        ),
      ),
    );
  }
}
