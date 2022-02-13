import 'package:encrypt/encrypt.dart';

class Crypt {
  Crypt._();
  static final Crypt instance = Crypt._();
  factory Crypt() => instance;

  final _key = Key.fromUtf8('vbRsfw8QutiaFpmLdCbpFZR323s62v9M');
  final _iv = IV.fromLength(16);

  String encrypt64(String plainText) {
    final encrypter = Encrypter(AES(_key));
    final encrypted = encrypter.encrypt(plainText, iv: _iv);
    return encrypted.base64;
  }

  String decrypt64(String encoded) {
    final encrypter = Encrypter(AES(_key));
    return encrypter.decrypt64(encoded, iv: _iv);
  }
}
