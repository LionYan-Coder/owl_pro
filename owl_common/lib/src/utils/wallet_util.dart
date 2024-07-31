import 'dart:math';

import 'package:bip39/bip39.dart' as bip39;
import 'package:convert/convert.dart';

class WalletUtil {
  static bool validMnemonic(String mnemonic) {
    return bip39.validateMnemonic(mnemonic);
  }

  static bool validPrivateKey(String privKey) {
    try {
      return hex.decode(privKey).length == 32;
    } catch (e) {
      return false;
    }
  }

  static bool validAdress(String address) {
    try {
      return address.contains('0x') && address.length == 42;
    } catch (e) {
      return false;
    }
  }

   static String generateRandomHex(int length) {
    final random = Random.secure();
    final bytes = List<int>.generate(length, (_) => random.nextInt(256));
    return hex.encode(bytes);
  }
}
