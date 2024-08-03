import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/pages/transfer/transfer_logic.dart';

class TokenListSheet extends StatefulWidget {
  const TokenListSheet({super.key});

  @override
  State<TokenListSheet> createState() => _TokenListSheetState();
}

class _TokenListSheetState extends State<TokenListSheet> {
  final transferLogic = Get.find<TransferLogic>();

  TokenType currentCoin = TokenType.owl;

  @override
  void initState() {
    setState(() {
      currentCoin = transferLogic.tokenType.value;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
          height: 260.w,
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12).w,
                  child: "send_coin_send_sheet_title".tr.toText
                    ..style = Styles.ts_333333_20_bold
                        .adapterDark(Styles.ts_0C8CE9_20_bold)),
              Expanded(
                child: CupertinoPicker(
                    onSelectedItemChanged: (int index) {
                      currentCoin = TokenType.values[index];
                    },
                    magnification: 1.22,
                    squeeze: 1.2,
                    useMagnifier: true,
                    scrollController: FixedExtentScrollController(
                        initialItem: TokenType.values
                            .indexOf(transferLogic.tokenType.value)),
                    itemExtent: 32.w,
                    children: TokenType.values
                        .map((token) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8).w,
                              child: token.name.toUpperCase().toText
                                ..style = Styles.ts_333333_16_medium
                                    .adapterDark(Styles.ts_CCCCCC_16_medium),
                            ))
                        .toList()),
              ),
              Center(
                child: "confirm".tr.toButton
                  ..width = 180.w
                  ..onPressed = () {
                    transferLogic.onChangeCoin(currentCoin);
                    Get.back();
                  },
              )
            ],
          )),
    );
  }
}


// 9cbf71fe74944adef83064f7dbf96926ca1dfb48bdc0413f35f27570efee8e73