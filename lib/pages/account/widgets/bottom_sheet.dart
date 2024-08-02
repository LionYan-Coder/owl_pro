import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';

enum ModalType { privkey, mnemonic }

class WalletBottomSheet extends StatelessWidget {
  final ModalType type;
  final String content;
  const WalletBottomSheet(
      {super.key, required this.type, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 416.w + context.mediaQueryPadding.bottom,
      padding: EdgeInsets.only(
          top: 32.w, bottom: 16.w + context.mediaQueryPadding.bottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          "identity_modal_${type.name}_title".tr.toText
            ..style =
                Styles.ts_333333_20_bold.adapterDark(Styles.ts_CCCCCC_20_bold),
          16.gapv,
          Container(
              width: 280.w,
              padding:
                  const EdgeInsets.symmetric(horizontal: 6, vertical: 11).w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: Styles.c_0C8CE9.withOpacity(0.05)),
              child: "identity_modal_warning".tr.toText
                ..style = Styles.ts_0C8CE9_12),
          24.gapv,
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24).w,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 36).w,
            decoration: BoxDecoration(
                color: Styles.c_F9F9F9.adapterDark(Styles.c_121212),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                    color: Styles.c_EDEDED.adapterDark(Styles.c_262626))),
            child: content.toText
              ..style = Styles.ts_666666_14.adapterDark(Styles.ts_999999_14),
          ),
          32.gapv,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 64).w,
            child: Column(
              children: [
                "identity_modal_button_copy".tr.toButton
                  ..onPressed = () {
                    Clipboard.setData(ClipboardData(text: content));
                    ToastHelper.showToast(context, "copy_success".tr);
                  },
                20.gapv,
                "identity_modal_button_close".tr.toButton
                  ..variants = ButtonVariants.outline
                  ..onPressed = () {
                    Get.back();
                  },
              ],
            ),
          ),
        ],
      ),
    );
  }
}
