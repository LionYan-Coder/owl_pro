import 'dart:convert';
import 'dart:typed_data';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bitcoin/flutter_bitcoin.dart';
import 'package:hive/hive.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:json_annotation/json_annotation.dart';
import 'package:owl_common/owl_common.dart';
import 'package:pointycastle/digests/ripemd160.dart';
import 'package:web3dart/crypto.dart';

part 'wallet.g.dart';

@HiveType(typeId: 2)
@JsonSerializable()
class Wallet {
  @HiveField(1)
  String address;
  @HiveField(2)
  String privKey;
  @HiveField(3)
  String? mnemonic;

  Wallet({required this.address, required this.privKey, this.mnemonic});

  static String generateMnemonic() {
    return bip39.generateMnemonic();
  }

  static String? getPrivateKeyByMnemonic(String mnemonic,
      {String derivePath = "m/44/65535/0/0/0"}) {
    Uint8List seed = bip39.mnemonicToSeed(mnemonic);
    final hdWallet = HDWallet.fromSeed(seed).derivePath(derivePath);
    return hdWallet.privKey;
  }

  static String getAddress(String privKey) {
    final keyPair =
        ECPair.fromPrivateKey(Uint8List.fromList(hex.decode(privKey)));

    Digest sha256Hash = sha256.convert(keyPair.publicKey);
    RIPEMD160Digest ripemd160 = RIPEMD160Digest();
    Uint8List ripemd160Hash =
        ripemd160.process(Uint8List.fromList(sha256Hash.bytes));
    String ripemd160Hex = hex.encode(ripemd160Hash);
    return '0x$ripemd160Hex';
  }

  String sign(Uint8List hash) {
    final keyPair = ECPair.fromPrivateKey(
        Uint8List.fromList(hex.decode(privKey)),
        compressed: false);

    return bytesToHex(keyPair.sign(hash), include0x: true);
  }

  static Future<Wallet> createWallet() async {
    final mnemonic = bip39.generateMnemonic();
    final privKey = Wallet.getPrivateKeyByMnemonic(mnemonic);
    if (privKey == null) {
      Logger.print("Error getting private key", isError: true);
      throw ErrorDescription("Error getting private key");
    }
    final address = Wallet.getAddress(privKey);
    final wallet =
        Wallet(address: address, privKey: privKey, mnemonic: mnemonic);

    return wallet;
  }

  static Wallet? restoreFromPrivateKey(String privKey) {
    final address = Wallet.getAddress(privKey);
    final wallet = Wallet(address: address, privKey: privKey);
    return wallet;
  }

  static Wallet? restoreFromMnemonic(String mnemonic) {
    final privKey = Wallet.getPrivateKeyByMnemonic(mnemonic);
    if (privKey != null) {
      final address = Wallet.getAddress(privKey);
      final wallet =
          Wallet(address: address, privKey: privKey, mnemonic: mnemonic);
      return wallet;
    }
    return null;
  }

  Future<void> saveWalletToHive(Box box) async {
    String encstr = EncryptionHelper.encrypted64(jsonEncode(toJson()));
    box.put(address, encstr);
  }

  static Wallet loadWalletFromHive(
    Box box,
    String address,
  ) {
    String decstr = EncryptionHelper.decrypt64(box.get(address));
    return Wallet.fromJson(jsonDecode(decstr));
  }

  static Future<void> deleteWallet(
    Box box,
    String address,
  ) async {
    await box.delete(address);
  }

  String get publicKey => bytesToHex(
      ECPair.fromPrivateKey(Uint8List.fromList(hex.decode(privKey)),
              compressed: false)
          .publicKey,
      include0x: true);

  bool get isFromMnemonic => mnemonic != null && mnemonic!.isNotEmpty;

  factory Wallet.fromJson(Map<String, dynamic> json) => _$WalletFromJson(json);

  Map<String, dynamic> toJson() => _$WalletToJson(this);
}


@JsonSerializable()
class Balance {
  BigInt owlBalance;
  BigInt olinkBalance;

  Balance({required this.owlBalance, required this.olinkBalance});

  factory Balance.fromJson(Map<String, dynamic> json) =>
      _$BalanceFromJson(json);

  Map<String, dynamic> toJson() => _$BalanceToJson(this);
}
