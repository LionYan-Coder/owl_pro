import 'package:get/get.dart';

import 'discord_logic.dart';

class DiscordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DiscordLogic());
  }
}
