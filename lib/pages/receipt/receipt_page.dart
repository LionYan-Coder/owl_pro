import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/core/controller/im_controller.dart';
import 'package:owlpro_app/pages/receipt/receipt_logic.dart';

class ReceiptPage extends StatelessWidget {
  ReceiptPage({super.key});

  final imLogic = Get.find<IMController>();
  final logic = Get.find<ReceiptLogic>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(
        title: "asset_receipt_title".tr,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 48.w),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12).w,
                  border: Border.all(
                      color: Styles.c_EDEDED.adapterDark(Styles.c_262626))),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                            bottom: 24, left: 24, right: 24, top: 36)
                        .w,
                    child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 11),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.w),
                            color: Styles.c_0C8CE9.withOpacity(0.05)),
                        child: "asset_receipt_warning".tr.toText
                          ..style = Styles.ts_0C8CE9_12),
                  ),
                  Obx(() => QRcode(
                      onSave: (fn) {
                        logic.saveFunction = fn;
                      },
                      code: imLogic.userInfo.value.address?.toOc ?? '')),
                  24.gapv,
                  Container(
                    height: 1,
                    color: Styles.c_F6F6F6.adapterDark(Styles.c_161616),
                  ),
                  24.gapv,
                  "asset_receipt_address_label".tr.toText
                    ..style = Styles.ts_333333_14_medium
                        .adapterDark(Styles.ts_CCCCCC_14_bold),
                  12.gapv,
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 16, left: 16, right: 16)
                            .w,
                    child: Obx(() => Container(
                          padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 16)
                              .w,
                          decoration: BoxDecoration(
                              color:
                                  Styles.c_F9F9F9.adapterDark(Styles.c_121212),
                              borderRadius: BorderRadius.circular(8.w),
                              border: Border.all(
                                  color: Styles.c_EDEDED
                                      .adapterDark(Styles.c_262626))),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  imLogic.userInfo.value.address?.toOc ?? '',
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  // overflow: TextOverflow.ellipsis,
                                  style: Styles.ts_666666_14,
                                ),
                              ),
                              10.gaph,
                              ButtonCopy(
                                  data: imLogic.userInfo.value.address?.toOc ??
                                      '')
                            ],
                          ),
                        )),
                  )
                ],
              ),
            ),
            36.gapv,
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 64).w,
                child: "asset_receipt_address_save".tr.toButton
                  ..onPressed = logic.save)
          ],
        ),
      ),
    );
  }
}
