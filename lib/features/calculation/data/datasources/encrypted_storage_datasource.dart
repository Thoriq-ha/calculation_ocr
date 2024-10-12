import 'dart:developer';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';

abstract class EncryptedStorageDataSource {
  Future<bool> storeData(String encryptedExpression, String encryptedResult);
  Future<String> readData();
  Future<String?> getEncryptionKey();
  Future<void> saveEncryptionKey(String key);
  Future<String?> getIV();
  Future<void> saveIV(String iv);
}

class EncryptedDatasourceImpl implements EncryptedStorageDataSource {
  final FlutterSecureStorage secureStorage;

  EncryptedDatasourceImpl({required this.secureStorage});

  Future<String> _getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/secure_data';

    // Buat direktori jika belum ada
    final dir = Directory(path);
    if (!(await dir.exists())) {
      await dir.create(recursive: true);
    }

    return '$path/secure_data.txt'; // Path ke file
  }

  @override
  Future<bool> storeData(
      String encryptedExpression, String encryptedResult) async {
    try {
      final filePath = await _getFilePath();
      final file = File(filePath);
      await file.writeAsString('$encryptedExpression::$encryptedResult\n',
          mode: FileMode.append);
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  @override
  Future<String> readData() async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final filePath = await _getFilePath();
      final file = File(filePath);

      // Check if the file exists before reading
      if (!(await file.exists())) {
        log('File not found. Returning empty data.');
        return '';
      }

      // If the file exists, read its contents
      return await file.readAsString();
    } catch (e) {
      // Handle any errors that occur during file reading
      log('Error while reading data: $e');
      throw Exception('An error occurred while reading data.');
    }
  }

  @override
  Future<String?> getEncryptionKey() async {
    return await secureStorage.read(key: "encryptionKey");
  }

  @override
  Future<String?> getIV() async {
    return await secureStorage.read(key: "iv");
  }

  @override
  Future<void> saveEncryptionKey(String key) async {
    await secureStorage.write(key: "encryptionKey", value: key);
  }

  @override
  Future<void> saveIV(String iv) async {
    await secureStorage.write(key: "iv", value: iv);
  }
}
