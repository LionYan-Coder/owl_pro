// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenTransaction _$TokenTransactionFromJson(Map<String, dynamic> json) =>
    TokenTransaction(
      hash: json['hash'] as String,
      blockNumber: json['blockNumber'] as String,
      blockHash: json['blockHash'] as String,
      from: json['from'] as String,
      to: json['to'] as String,
      value: json['value'] as String,
      gas: json['gas'] as String?,
      gasPrice: json['gasPrice'] as String?,
      input: json['input'] as String?,
      time: json['time'] as String,
      token: json['token'] as String?,
    );

Map<String, dynamic> _$TokenTransactionToJson(TokenTransaction instance) =>
    <String, dynamic>{
      'hash': instance.hash,
      'blockNumber': instance.blockNumber,
      'blockHash': instance.blockHash,
      'from': instance.from,
      'to': instance.to,
      'value': instance.value,
      'time': instance.time,
      'input': instance.input,
      'gas': instance.gas,
      'gasPrice': instance.gasPrice,
      'token': instance.token,
    };
