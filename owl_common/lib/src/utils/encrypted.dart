import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionHelper {
  static final _key = encrypt.Key.fromUtf8('12jenfsakjfsf030rj1idmksanf8911g');
  // 改为一个固定的 IV
  static final _iv = encrypt.IV.fromUtf8('16byteslongivkey');

  static String encrypted64(String data) {
    final encrypter =
        encrypt.Encrypter(encrypt.AES(_key, mode: encrypt.AESMode.cbc));
    final encrypted = encrypter.encrypt(data, iv: _iv);
    return encrypted.base64;
  }

  static String decrypt64(String data) {
    final encrypter =
        encrypt.Encrypter(encrypt.AES(_key, mode: encrypt.AESMode.cbc));
    final decrypted = encrypter.decrypt64(data, iv: _iv);
    return decrypted;
  }
}
