import 'package:get/get.dart';

class DateUtil2 {
  static String formattedTimes(DateTime time) {
    if (time.second > 0) {
      return '${time.second}${"seconds".tr}';
    } else if (time.minute > 0) {
      // 格式化为分钟
      return '${time.minute}${"minute".tr}';
    } else if (time.hour > 0) {
      // 格式化为小时
      return '${time.hour}${"hours".tr}';
    } else if (time.day > 0) {
      // 格式化为天数
      return '${time.day - 1}${"day".tr}';
    } else {
      return 'unkown';
    }
  }
}
