import 'package:calculation_ocr/core/enum/data_source.dart';
import 'package:calculation_ocr/core/error/failure.dart';
import 'package:calculation_ocr/features/calculation/data/datasources/database_datasource.dart';
import 'package:calculation_ocr/features/calculation/data/datasources/encrypted_storage_datasource.dart';
import 'package:calculation_ocr/features/calculation/data/datasources/shared_pref_datasource.dart';
import 'package:calculation_ocr/features/calculation/data/models/calculation_model.dart';
import 'package:calculation_ocr/features/calculation/domain/entities/calculation.dart';
import 'package:calculation_ocr/features/calculation/domain/repositories/calculation_repository.dart';
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
      DataSource source = await sharedPreferencesDataSource.getDatasource();
      if (source == DataSource.encryptedStorage) {
        List<CalculationModel> result =
            await encryptedStorageDataSource.getAllCalculation();
        return Right(result);
      } else {
        List<CalculationModel> result =
            await databaseDataSource.getAllCalculation();
        return Right(result);
      }
    } catch (e) {
      return Left(Failure());
    }
  }

  @override
  Future<Either<Failure, bool>> saveCalculation(Calculation calculation) async {
    try {
      DataSource source = await sharedPreferencesDataSource.getDatasource();
      if (source == DataSource.encryptedStorage) {
        final result =
            await encryptedStorageDataSource.saveCalculation(calculation);
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
  Future<Either<Failure, bool>> setDatasource(DataSource source) async {
    try {
      final result = await sharedPreferencesDataSource.setDatasource(source);
      return Right(result);
    } catch (e) {
      return Left(Failure());
    }
  }

  @override
  Future<Either<Failure, DataSource>> getDatasource() async {
    try {
      final result = await sharedPreferencesDataSource.getDatasource();
      return Right(result);
    } catch (e) {
      return Left(Failure());
    }
  }
}
