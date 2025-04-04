// import 'dart:convert';
// import 'dart:typed_data';
// import 'package:encrypt/encrypt.dart' as encrypt;
// import 'package:crypto/crypto.dart';
// import 'package:encrypt/encrypt.dart';
//
// class AESEncryption {
//   // static final key = encrypt.Key.fromUtf8('12345678901234567890123456789012'); // 32-byte key for AES-256
//   // static final iv = encrypt.IV.fromLength(16); // Generates a valid 16-byte IV
//   final key = Key.fromUtf8('12345678901234567890123456789012'); // 32 chars for AES-256
//   final iv = IV.fromUtf8('1234567890123456'); // Must be 16 characters
//
//   String encryptData(String plainText) {
//     // final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
//
//     // final encrypted = encrypter.encrypt(plainText, iv: iv);
//     final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
//     final encrypted = encrypter.encrypt('Hello', iv: iv);
//     return base64.encode(encrypted.bytes);
//   }
//
//   String decryptData(String encryptedText) {
//     final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
//
//     final decrypted = encrypter.decrypt64(encryptedText, iv: iv);
//     return decrypted;
//   }
// }


import 'package:encrypt/encrypt.dart';
import 'dart:convert';

class AESHelper {
  static final Key key = Key.fromUtf8('01234567890123456789012345678901'); // 32 bytes for AES-256
  static final IV iv = IV.fromUtf8('0123456789012345'); // 16 bytes

  static String encrypt(String text) {
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final encrypted = encrypter.encrypt(text, iv: iv);
    return encrypted.base64; // Convert to Base64 for safe transmission
  }

  static String decrypt(String encryptedText) {
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final decrypted = encrypter.decrypt64(encryptedText, iv: iv);
    return decrypted;
  }
}
