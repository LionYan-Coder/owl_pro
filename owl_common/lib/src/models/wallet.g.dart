// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WalletAdapter extends TypeAdapter<Wallet> {
  @override
  final int typeId = 2;

  @override
  Wallet read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Wallet(
      address: fields[1] as String,
      privKey: fields[2] as String,
      mnemonic: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Wallet obj) {
    writer
      ..writeByte(3)
      ..writeByte(1)
      ..write(obj.address)
      ..writeByte(2)
      ..write(obj.privKey)
      ..writeByte(3)
      ..write(obj.mnemonic);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WalletAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WallteAccountAdapter extends TypeAdapter<WallteAccount> {
  @override
  final int typeId = 3;

  @override
  WallteAccount read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WallteAccount(
      address: fields[1] as String,
      nickname: fields[2] as String,
      account: fields[3] as String,
      about: fields[4] as String?,
      coverURL: fields[6] as String?,
      faceURL: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, WallteAccount obj) {
    writer
      ..writeByte(6)
      ..writeByte(1)
      ..write(obj.address)
      ..writeByte(2)
      ..write(obj.nickname)
      ..writeByte(3)
      ..write(obj.account)
      ..writeByte(4)
      ..write(obj.about)
      ..writeByte(5)
      ..write(obj.faceURL)
      ..writeByte(6)
      ..write(obj.coverURL);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WallteAccountAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Wallet _$WalletFromJson(Map<String, dynamic> json) => Wallet(
      address: json['address'] as String,
      privKey: json['privKey'] as String,
      mnemonic: json['mnemonic'] as String?,
    );

Map<String, dynamic> _$WalletToJson(Wallet instance) => <String, dynamic>{
      'address': instance.address,
      'privKey': instance.privKey,
      'mnemonic': instance.mnemonic,
    };

WallteAccount _$WallteAccountFromJson(Map<String, dynamic> json) =>
    WallteAccount(
      address: json['address'] as String,
      nickname: json['nickname'] as String,
      account: json['account'] as String,
      about: json['about'] as String?,
      coverURL: json['coverURL'] as String?,
      faceURL: json['faceURL'] as String?,
    );

Map<String, dynamic> _$WallteAccountToJson(WallteAccount instance) =>
    <String, dynamic>{
      'address': instance.address,
      'nickname': instance.nickname,
      'account': instance.account,
      'about': instance.about,
      'faceURL': instance.faceURL,
      'coverURL': instance.coverURL,
    };
