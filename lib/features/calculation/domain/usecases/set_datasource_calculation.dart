import 'package:calculation_ocr/core/enum/data_source.dart';
import 'package:calculation_ocr/core/error/failure.dart';
import 'package:calculation_ocr/features/calculation/domain/repositories/calculation_repository.dart';
import 'package:dartz/dartz.dart';

class SetDatasourceCalculation {
  final CalculationRepository calculationRepository;

  const SetDatasourceCalculation(this.calculationRepository);

  Future<Either<Failure, bool>> execute(DataSource source) async {
    return await calculationRepository.setDatasource(source);
  }
}
