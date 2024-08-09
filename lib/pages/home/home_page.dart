import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:owl_common/owl_common.dart';
import 'package:owlpro_app/pages/contacts/contact_page.dart';
import 'package:owlpro_app/pages/discord/discord_view.dart';
import 'package:owlpro_app/pages/home/home_logic.dart';
import 'package:owlpro_app/pages/mine/mine_logic.dart';
import 'package:owlpro_app/pages/mine/mine_page.dart';

import '../conversation/conversation_page.dart';

class HomePage extends StatelessWidget {
  final logic = Get.find<HomeLogic>();
  final mineLogic = Get.find<MineLogic>();

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(

      bottomNavigationBar: BottomBar(
        index: logic.tab.value,
        items: [
          BottomBarItem(
            selectedIcon: "tab_ico_chat_act",
            unselectedIcon: "tab_ico_chat_nor",
            onClick: logic.switchTab,
            onDoubleClick: logic.scrollToUnreadMessage,
            count: logic.unreadMsgCount.value,
          ),
          BottomBarItem(
            selectedIcon: "tab_ico_intimate_act",
            unselectedIcon: "tab_ico_intimate_nor",
            onClick: logic.switchTab,
            count: logic.unhandledCount.value,
          ),
          BottomBarItem(
            selectedIcon: "tab_ico_discover_act",
            unselectedIcon: "tab_ico_discover_nor",
            onClick: logic.switchTab,
          ),
          BottomBarItem(
            selectedIcon: "tab_ico_me_act",
            unselectedIcon: "tab_ico_me_nor",
            onClick: logic.switchTab,
          ),
        ],
      ) ,
      body: IndexedStack(
        index: logic.tab.value,
        children: [ConversationPage(), const ContactPage(), DiscordPage(), MinePage()],
      ),
    ));
  }
}
