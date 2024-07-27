import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionHelper {
  static final key = encrypt.Key.fromUtf8('12jenfsakjfsf030rj1idmksanf8911g');
  static final iv = encrypt.IV.fromLength(16);

  static String encrypted64(String data) {
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final encrypted = encrypter.encrypt(data, iv: iv);
    return encrypted.base64;
  }

  static String decrypt64(String data) {
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    final decrypted = encrypter.decrypt64(data, iv: iv);
    return decrypted;
  }
}
