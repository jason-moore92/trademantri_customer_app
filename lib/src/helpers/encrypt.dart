import 'dart:typed_data';

import 'package:encrypt/encrypt.dart';
import 'package:trapp/config/config.dart';

class Encrypt {
  static final Key key = Key.fromSecureRandom(16);
  static final IV iv = IV.fromLength(16);

  static String encryptString(String plainText) {
    try {
      Key key = Key(Uint8List.fromList(AppConfig.encryptKeyString.codeUnits));
      Encrypter encrypter = Encrypter(AES(key));
      final encrypted = encrypter.encrypt(plainText, iv: iv);
      return encrypted.base64;
    } catch (e) {
      return plainText;
    }
  }

  static String decryptString(String base64) {
    try {
      Key key = Key(Uint8List.fromList(AppConfig.encryptKeyString.codeUnits));
      Encrypter encrypter = Encrypter(AES(key));
      Encrypted encrypted = Encrypted.fromBase64(base64);
      final decrypted = encrypter.decrypt(encrypted, iv: iv);
      return decrypted;
    } catch (e) {
      return base64;
    }
  }
}
