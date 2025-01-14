import 'package:encrypt/encrypt.dart';

void main() {
  final decrypted = Encrypter(
          AES(Key.fromBase64("kyJwx5nrrRqL23AkmRtQT4Uzf3so79kKWU6kiXOYUlY=")))
      .decrypt64(
          "x+rlAvjQ+6gsBknSqDdC9ZK44K2/ApNTO05q/PR3E3mJIwyFWOQ0Xy+2JHCgq7mKO4cS53AZtIli3Q+Xe6QxuA==",
          iv: IV.fromBase64("F6b+3KYxQASqxMQMTk5xbA=="));

  print(decrypted);
  print('decrypted');
}

// import 'package:encrypt/encrypt.dart';

// void main() {
//   const plainText = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit';
//   var encryptionKey = Key.fromLength(32).base64;
//   // var key = Key.fromBase64("NZZran9nODJp0WUNYxyJLbrVAgs/m/LEjogEb8eRiR8=");
//   // NZZran9nODJp0WUNYxyJLbrVAgs/m/LEjogEb8eRiR8=
//   final iv = IV.fromLength(16);

//   final encrypter = Encrypter(AES(key));

//   // final encrypted = encrypter.encrypt(plainText, iv: iv);
//   final decrypted = encrypter
//       .decrypt64("NZZran9nODJp0WUNYxyJLbrVAgs/m/LEjogEb8eRiR8=", iv: iv);

//   // print(encrypted
//   //     .base64); // Lorem ipsum dolor sit amet, consectetur adipiscing elit
//   print(decrypted); // Lorem ipsum dolor sit amet, consectetur adipiscing elit
// }
