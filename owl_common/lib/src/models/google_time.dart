import 'package:dart_date/dart_date.dart';

class GoogleTime {
  int? seconds;
  int? nanos;

  GoogleTime({this.seconds, this.nanos});

  GoogleTime.fromJson(Map<String, dynamic> json) {
    seconds = json['seconds'];
    nanos = json['nanos'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['seconds'] = seconds;
    data['nanos'] = nanos;

    return data;
  }

  String formatTimestamp({String? format}) {
    final dateTime = this.dateTime;
    return dateTime.format(format ?? 'yyyy-MM-dd HH:mm:ss');
  }

  DateTime get dateTime => DateTime.fromMillisecondsSinceEpoch(
        seconds! * 1000 + nanos! ~/ 1000000,
        isUtc: true,
      ).toLocal();
}
