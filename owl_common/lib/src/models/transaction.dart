import 'package:json_annotation/json_annotation.dart';

part 'transaction.g.dart';

@JsonSerializable()
class TokenTransaction {
  final String hash;
  final String blockNumber;
  final String blockHash;
  final String from;
  final String to;
  final String value;
  final String time;
  final String? input;
  final String? gas;
  String? gasPrice;
  final String? token;

  TokenTransaction(
      {required this.hash,
      required this.blockNumber,
      required this.blockHash,
      required this.from,
      required this.to,
      required this.value,
      required this.gas,
      required this.gasPrice,
      required this.input,
      required this.time,
      required this.token});

  factory TokenTransaction.fromJson(Map<String, dynamic> json) =>
      _$TokenTransactionFromJson(json);

  Map<String, dynamic> toJson() => _$TokenTransactionToJson(this);
}
