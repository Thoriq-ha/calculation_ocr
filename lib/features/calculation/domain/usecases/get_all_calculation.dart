import 'package:calculation_ocr/core/error/failure.dart';
import 'package:calculation_ocr/features/calculation/domain/entities/calculation.dart';
import 'package:calculation_ocr/features/calculation/domain/repositories/calculation_repository.dart';
import 'package:dartz/dartz.dart';

class GetAllCalculation {
  final CalculationRepository calculationRepository;

  const GetAllCalculation(this.calculationRepository);

  Future<Either<Failure, List<Calculation>>> execute() async {
    return await calculationRepository.getAllCalculation();
  }
}
