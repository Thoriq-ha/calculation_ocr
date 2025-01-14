import 'package:encrypt/encrypt.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('encrypt', () async {
    final decrypted = Encrypter(
            AES(Key.fromBase64("kyJwx5nrrRqL23AkmRtQT4Uzf3so79kKWU6kiXOYUlY=")))
        .decrypt64(
            "x+rlAvjQ+6gsBknSqDdC9ZK44K2/ApNTO05q/PR3E3mJIwyFWOQ0Xy+2JHCgq7mKO4cS53AZtIli3Q+Xe6QxuA==",
            iv: IV.fromBase64("F6b+3KYxQASqxMQMTk5xbA=="));
    expect(
        decrypted, "Lorem ipsum dolor sit amet, consectetur adipiscing elit");
  });
}
