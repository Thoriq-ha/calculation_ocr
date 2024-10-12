import 'package:calculation_ocr/features/calculation/domain/enum/data_source.dart';
import 'package:calculation_ocr/core/error/failure.dart';
import 'package:calculation_ocr/features/calculation/domain/entities/calculation.dart';
import 'package:dartz/dartz.dart';

abstract class CalculationRepository {
  Future<Either<Failure, List<Calculation>>> getAllCalculation();

  Future<Either<Failure, bool>> saveCalculation(Calculation calculation);

  Future<Either<Failure, bool>> setDatasource(DataSourceType source);

  Future<Either<Failure, DataSourceType>> getDatasource();
}
