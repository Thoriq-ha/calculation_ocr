import 'package:calculation_ocr/features/calculation/domain/entities/calculation.dart';
import 'package:calculation_ocr/features/calculation/domain/repositories/calculation_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';

class SaveCalculation {
  final CalculationRepository calculationRepository;

  const SaveCalculation(this.calculationRepository);

  Future<Either<Failure, bool>> execute(Calculation calculation) async {
    return await calculationRepository.saveCalculation(calculation);
  }
}
