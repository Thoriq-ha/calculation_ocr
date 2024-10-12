import 'dart:developer';

import 'package:calculation_ocr/features/calculation/domain/enum/data_source.dart';
import 'package:calculation_ocr/core/error/failure.dart';
import 'package:calculation_ocr/core/utils/base64_padding.dart';
import 'package:calculation_ocr/features/calculation/data/datasources/database_datasource.dart';
import 'package:calculation_ocr/features/calculation/data/datasources/encrypted_storage_datasource.dart';
import 'package:calculation_ocr/features/calculation/data/datasources/shared_pref_datasource.dart';
import 'package:calculation_ocr/features/calculation/data/models/calculation_model.dart';
import 'package:calculation_ocr/features/calculation/domain/entities/calculation.dart';
import 'package:calculation_ocr/features/calculation/domain/repositories/calculation_repository.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:dartz/dartz.dart';

class CalculationRepositoryImpl extends CalculationRepository {
  final DatabaseDataSource databaseDataSource;
  final EncryptedStorageDataSource encryptedStorageDataSource;
  final SharePrefDataSource sharedPreferencesDataSource;

  CalculationRepositoryImpl(
      {required this.databaseDataSource,
      required this.encryptedStorageDataSource,
      required this.sharedPreferencesDataSource});

  @override
  Future<Either<Failure, List<Calculation>>> getAllCalculation() async {
    try {
      DataSourceType source = await sharedPreferencesDataSource.getDatasource();
      if (source == DataSourceType.encryptedStorage) {
        final contents = await encryptedStorageDataSource.readData();
        if (contents.isEmpty) {
          return const Right([]);
        }
        String? encryptionKey =
            await encryptedStorageDataSource.getEncryptionKey();
        String? ivBase64 = await encryptedStorageDataSource.getIV();

        if (encryptionKey == null || ivBase64 == null) {
          log('Tidak ada data terenkripsi yang valid.');
          return Left(Failure());
        }

        final key = encrypt.Key.fromBase64(encryptionKey);
        final iv = encrypt.IV.fromBase64(ivBase64);
        final encrypter = encrypt.Encrypter(encrypt.AES(key));

        final lines = contents.split('\n');
        List<CalculationModel> result = [];

        for (var line in lines) {
          if (line.isNotEmpty) {
            var parts = line.split('::');

            // Check if the line was split into exactly two parts
            if (parts.length == 2) {
              // Ensure both parts are correctly padded for Base64 decoding
              var encryptedExpression = addBase64Padding(parts[0]);
              var encryptedResult = addBase64Padding(parts[1]);

              try {
                var decryptedExpression =
                    encrypter.decrypt64(encryptedExpression, iv: iv);
                var decryptedResult =
                    encrypter.decrypt64(encryptedResult, iv: iv);

                result.add(CalculationModel(
                    expression: decryptedExpression, result: decryptedResult));
              } catch (e) {
                log('Error decrypting data: $e');
              }
            } else {
              log('Line does not contain a valid expression and result: $line');
            }
          }
        }
        return Right(result);
      } else {
        // Retrieve all CalculationModel objects from the data source
        final calculationModels = await databaseDataSource.getAllCalculation();
        // Convert CalculationModel objects to domain entities (Calculation)
        final result = calculationModels
            .map((model) => Calculation(
                  expression: model.expression,
                  result: model.result,
                ))
            .toList();
        return Right(result);
      }
    } catch (e) {
      log(e.toString());
      return Left(Failure());
    }
  }

  @override
  Future<Either<Failure, bool>> saveCalculation(Calculation calculation) async {
    try {
      DataSourceType source = await sharedPreferencesDataSource.getDatasource();
      if (source == DataSourceType.encryptedStorage) {
        String? encryptionKey =
            await encryptedStorageDataSource.getEncryptionKey();
        if (encryptionKey == null) {
          encryptionKey = encrypt.Key.fromLength(32).base64;
          await encryptedStorageDataSource.saveEncryptionKey(encryptionKey);
        }

        String? ivBase64 = await encryptedStorageDataSource.getIV();
        encrypt.IV iv;
        if (ivBase64 == null) {
          iv = encrypt.IV.fromLength(16);
          await encryptedStorageDataSource.saveIV(iv.base64);
        } else {
          iv = encrypt.IV.fromBase64(ivBase64);
        }

        final key = encrypt.Key.fromBase64(encryptionKey);
        final encrypter = encrypt.Encrypter(encrypt.AES(key));
        final encryptedExpression =
            encrypter.encrypt(calculation.expression, iv: iv).base64;
        final encryptedResult =
            encrypter.encrypt(calculation.result, iv: iv).base64;

        final result = await encryptedStorageDataSource.storeData(
            encryptedExpression, encryptedResult);

        return Right(result);
      } else {
        final result = await databaseDataSource.saveCalculation(calculation);
        return Right(result);
      }
    } catch (e) {
      return Left(Failure());
    }
  }

  @override
  Future<Either<Failure, bool>> setDatasource(DataSourceType source) async {
    try {
      final result = await sharedPreferencesDataSource.setDatasource(source);
      return Right(result);
    } catch (e) {
      return Left(Failure());
    }
  }

  @override
  Future<Either<Failure, DataSourceType>> getDatasource() async {
    try {
      final result = await sharedPreferencesDataSource.getDatasource();
      return Right(result);
    } catch (e) {
      return Left(Failure());
    }
  }
}
