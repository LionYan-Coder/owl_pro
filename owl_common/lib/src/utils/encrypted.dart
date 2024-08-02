import 'package:encrypt/encrypt.dart' as encrypt;

class EncryptionHelper {
  static const encryptionKey = "ilovecoding12345";

  static String encrypted64(String data) {
    final key = encrypt.Key.fromUtf8(encryptionKey);
    final iv = encrypt.IV.fromLength(16);
    final encrypter = encrypt.Encrypter(
        encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'));

    final encrypted = encrypter.encrypt(data, iv: iv);
    return "${iv.base64}:${encrypted.base64}";
  }

  static String decrypt64(String data) {
    final key = encrypt.Key.fromUtf8(encryptionKey);
    final parts = data.split(':');
    final iv = encrypt.IV.fromBase64(parts[0]);
    final encryptedData = parts[1];

    final encrypter = encrypt.Encrypter(
        encrypt.AES(key, mode: encrypt.AESMode.cbc, padding: 'PKCS7'));

    final decrypted = encrypter.decrypt64(encryptedData, iv: iv);

    return decrypted;
  }
}
