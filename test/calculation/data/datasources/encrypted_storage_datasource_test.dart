import 'dart:io';
import 'package:calculation_ocr/features/calculation/data/datasources/encrypted_storage_datasource.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:path_provider/path_provider.dart';

import 'encrypted_storage_datasource_test.mocks.dart';

@GenerateMocks([FlutterSecureStorage])
void main() {
  TestWidgetsFlutterBinding
      .ensureInitialized(); // Pastikan binding terinisialisasi
  late MockFlutterSecureStorage mockSecureStorage;
  late EncryptedDatasourceImpl dataSource;

  const MethodChannel channel =
      MethodChannel('plugins.flutter.io/path_provider');

  setUp(() {
    // Mock method call handler untuk getTemporaryDirectory dan getApplicationDocumentsDirectory
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      if (methodCall.method == 'getTemporaryDirectory') {
        // Kembalikan path mock untuk direktori sementara
        return 'test/helper/data';
      } else if (methodCall.method == 'getApplicationDocumentsDirectory') {
        // Kembalikan path mock untuk direktori dokumen aplikasi
        return 'test/helper/data';
      }
      return null;
    });

    mockSecureStorage = MockFlutterSecureStorage();
    dataSource = EncryptedDatasourceImpl(secureStorage: mockSecureStorage);
  });

  tearDown(() {
    // Bersihkan setelah setiap pengujian
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  group('EncryptedDatasourceImpl', () {
    test('saveEncryptionKey should save key to secure storage', () async {
      // Arrange
      const key = 'testEncryptionKey';
      when(mockSecureStorage.write(key: "encryptionKey", value: key))
          .thenAnswer((_) async => null);

      // Act
      await dataSource.saveEncryptionKey(key);

      // Assert
      verify(mockSecureStorage.write(key: "encryptionKey", value: key))
          .called(1);
    });

    test('getEncryptionKey should retrieve key from secure storage', () async {
      // Arrange
      const key = 'testEncryptionKey';
      when(mockSecureStorage.read(key: "encryptionKey"))
          .thenAnswer((_) async => key);

      // Act
      final result = await dataSource.getEncryptionKey();

      // Assert
      expect(result, key);
      verify(mockSecureStorage.read(key: "encryptionKey")).called(1);
    });

    test('saveIV should save IV to secure storage', () async {
      // Arrange
      const iv = 'testIV';
      when(mockSecureStorage.write(key: "iv", value: iv))
          .thenAnswer((_) async {});

      // Act
      await dataSource.saveIV(iv);

      // Assert
      verify(mockSecureStorage.write(key: "iv", value: iv)).called(1);
    });

    test('getIV should retrieve IV from secure storage', () async {
      // Arrange
      const iv = 'testIV';
      when(mockSecureStorage.read(key: "iv")).thenAnswer((_) async => iv);

      // Act
      final result = await dataSource.getIV();

      // Assert
      expect(result, iv);
      verify(mockSecureStorage.read(key: "iv")).called(1);
    });

    test('storeData should store encrypted data in file', () async {
      // Arrange
      const encryptedExpression = 'encryptedExpression';
      const encryptedResult = 'encryptedResult';
      final tempDir = await getTemporaryDirectory();
      final testFile = File('${tempDir.path}/secure_data/secure_data.txt');
      await testFile.create(recursive: true);

      // Act
      final result =
          await dataSource.storeData(encryptedExpression, encryptedResult);

      // Assert
      expect(result, true);
      expect(await testFile.readAsString(),
          contains('$encryptedExpression::$encryptedResult'));
    });

    test('readData should return content of stored file', () async {
      // Arrange
      final tempDir = await getTemporaryDirectory();
      final testFile = File('${tempDir.path}/secure_data/secure_data.txt');
      await testFile.create(recursive: true);
      await testFile.writeAsString('encryptedExpression::encryptedResult\n');

      // Act
      final result = await dataSource.readData();

      // Assert
      expect(result, contains('encryptedExpression::encryptedResult'));
    });
  });
}
