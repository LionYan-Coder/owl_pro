import 'package:ellipsized_text/ellipsized_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/pages/mine/mine_logic.dart';
import 'package:owlpro_app/pages/transfer/trade_list/trade_list_logic.dart';
import 'package:owlpro_app/routes/app_navigator.dart';

final tabs = [
  "asset_token_tab_all",
  "asset_token_tab_send",
  "asset_token_tab_receipt"
];

class TradeListPage extends StatelessWidget {
  TradeListPage({super.key});

  final logic = Get.find<TradeListLogic>();
  final mineLogic = Get.find<MineLogic>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: TitleBar.back(
            title: "asset_token_title".tr,
          ),
          bottomNavigationBar: Container(
            width: double.infinity,
            padding: EdgeInsets.only(
                left: 24.w,
                right: 24.w,
                top: 16.w,
                bottom: context.mediaQueryPadding.bottom),
            decoration: BoxDecoration(
                border: Border(
                    top: BorderSide(
                        color: Styles.c_F6F6F6.adapterDark(Styles.c_161616))),
                color: Styles.c_FFFFFF.adapterDark(Styles.c_0D0D0D)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Flexible(
                    child: "wallet_asset_send".tr.toButton
                      ..onPressed = () {
                        AppNavigator.startTransfer();
                      }),
                6.gaph,
                Flexible(
                    child: "wallet_asset_receipt".tr.toButton
                      ..onPressed = () {
                        AppNavigator.startReceipt();
                      })
              ],
            ),
          ),
          body: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding:
                      const EdgeInsets.only(top: 24, right: 24, left: 24).w,
                  child: mineLogic.loadingBalance.value
                      ? const Center(
                          child: CircularProgressIndicator.adaptive())
                      : assetAllPanel()),
              32.gapv,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24).w,
                child: TextTab(
                    items: tabs
                        .map((tab) => TextTabItem(
                            label: tab.tr, value: tabs.indexOf(tab)))
                        .toList(),
                    activeItem: logic.currentTab.value,
                    onChanged: (index) => logic.onChangeTab(index)),
              ),
              Expanded(
                child: logic.loading.value
                    ? const Center(child: CircularProgressIndicator.adaptive())
                    : PageView.builder(
                        onPageChanged: (index) {
                          logic.currentTab.value = index;
                        },
                        controller: logic.pageController,
                        itemCount: tabs.length,
                        itemBuilder: (context, index) => Padding(
                          padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12)
                              .w,
                          child: ListView.builder(
                              itemCount: logic.filterList.length,
                              itemBuilder: (context, index) {
                                return _buildItemView(logic.filterList[index]);
                              }),
                        ),
                      ),
              )
            ],
          ),
        ));
  }

  Widget _buildItemView(TokenTransaction transaction) {
    final isSend = logic.isSend(transaction);
    final currentAddress =
        isSend ? transaction.to.delPad : transaction.from.delPad;
    final amount = transaction.value;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12).w,
      child: InkWell(
        onTap: () {
          AppNavigator.startTradeDetail(
              token: logic.tokenType.value, txHash: transaction.hash);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                (isSend ? "wallet_send".png : "wallet_receipt".png).toImage
                  ..width = 16.w
                  ..fit = BoxFit.cover,
                6.gaph,
                Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 3, horizontal: 4)
                            .w,
                    decoration: BoxDecoration(
                        color: isSend
                            ? Styles.c_DE473E.withOpacity(0.05)
                            : Styles.c_0C8CE9.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(4.r)),
                    child: (isSend
                            ? "asset_token_tab_send_tag"
                            : "asset_token_tab_receipt_tag")
                        .tr
                        .toText
                      ..style =
                          isSend ? Styles.ts_DE473E_12 : Styles.ts_0C8CE9_12),
                4.gaph,
                Container(
                  width: 120.w,
                  padding:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 4).w,
                  decoration: BoxDecoration(
                      color: Styles.c_333333
                          .adapterDark(Styles.c_CCCCCC)
                          .withOpacity(0.05),
                      borderRadius: BorderRadius.circular(4.r)),
                  child: EllipsizedText(
                    currentAddress.toOc,
                    type: EllipsisType.middle,
                    style: Styles.ts_333333_12.adapterDark(Styles.ts_CCCCCC_12),
                  ),
                ),
                Expanded(
                    child:
                        ((isSend ? '-' : '+') + amount.hextobigInt.toWei.fixed4)
                            .toText
                          ..style = Styles.ts_333333_16_bold
                              .adapterDark(Styles.ts_CCCCCC_16_bold)
                          ..textAlign = TextAlign.right)
              ],
            ),
            Padding(
                padding: const EdgeInsets.only(left: 24, top: 2).w,
                child: transaction.time.hexToDate().toText
                  ..style = Styles.ts_999999_12)
          ],
        ),
      ),
    );
  }

  Widget assetAllPanel() {
    return Container(
      decoration: BoxDecoration(
          color: Styles.c_0C8CE9.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12.r)),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12).w,
            margin: const EdgeInsets.symmetric(horizontal: 16).w,
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        color: "0xFFDBF0FF"
                            .toColor
                            .adapterDark("0xFF152129".toColor)))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0).w,
                      margin: const EdgeInsets.only(bottom: 4.0).w,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Styles.c_0C8CE9),
                          borderRadius: BorderRadius.circular(9999)),
                      child: logic.tokenType.value.name.png.toImage
                        ..width = 32.w
                        ..height = 32.w,
                    ),
                    logic.tokenType.value.name.toUpperCase().toText
                      ..style = Styles.ts_333333_16_bold
                          .adapterDark(Styles.ts_CCCCCC_16_bold)
                  ],
                ),
                "token_placeholder".png.toImage
                  ..width = 76.w
                  ..height = 76.w
              ],
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 12)
                    .w,
            child: Align(
              alignment: Alignment.centerRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  "asset_token_balance".tr.toText
                    ..style = Styles.ts_333333_14_medium
                        .adapterDark(Styles.ts_CCCCCC_14_medium),
                  8.gapv,
                  (logic.balance.toWei.fixed6).toText
                    ..style = Styles.ts_0481DC_28_bold,
                  3.gapv,
                  Text("≈\$${logic.balanceToUSD.fixed4}",
                      style: Styles.ts_999999_12)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
