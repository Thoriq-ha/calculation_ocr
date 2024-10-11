import 'package:calculation_ocr/core/enum/data_source.dart';
import 'package:calculation_ocr/core/error/failure.dart';
import 'package:calculation_ocr/features/calculation/domain/repositories/calculation_repository.dart';
import 'package:dartz/dartz.dart';

class GetDatasourceTypeCalculation {
  final CalculationRepository calculationRepository;

  const GetDatasourceTypeCalculation(this.calculationRepository);

  Future<Either<Failure, DataSourceType>> execute() async {
    return await calculationRepository.getDatasource();
  }
}
