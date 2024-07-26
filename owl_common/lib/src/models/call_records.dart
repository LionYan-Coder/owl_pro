import 'package:hive/hive.dart';

part 'call_records.g.dart';

@HiveType(typeId: 4)
class CallRecords {
  @HiveField(1)
  String userID;
  @HiveField(2)
  String nickname;
  @HiveField(3)
  String? faceURL;
  @HiveField(4)
  String type;
  @HiveField(5)
  bool success;
  @HiveField(6)
  bool incomingCall;
  @HiveField(7)
  int date;
  @HiveField(8)
  int duration;

  CallRecords({
    required this.userID,
    required this.nickname,
    this.faceURL,
    required this.type,
    required this.success,
    required this.incomingCall,
    required this.date,
    required this.duration,
  });

  CallRecords.fromJson(Map<String, dynamic> json)
      : userID = json['userID'],
        nickname = json['nickname'],
        faceURL = json['faceURL'],
        type = json['type'],
        success = json['success'],
        incomingCall = json['incomingCall'],
        date = json['date'],
        duration = json['duration'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userID'] = userID;
    data['nickname'] = nickname;
    data['faceURL'] = faceURL;
    data['type'] = type;
    data['success'] = success;
    data['incomingCall'] = incomingCall;
    data['date'] = date;
    data['duration'] = duration;
    return data;
  }
}
