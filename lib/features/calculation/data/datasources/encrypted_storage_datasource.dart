import 'package:calculation_ocr/features/calculation/data/models/calculation_model.dart';
import 'package:calculation_ocr/features/calculation/domain/entities/calculation.dart';

abstract class EncryptedStorageDataSource {
  Future<List<CalculationModel>> getAllCalculation();
  Future<bool> saveCalculation(Calculation calculation);
}

class EncryptedDatasourceImpl implements EncryptedStorageDataSource {
  List<CalculationModel> calculations = [
    const CalculationModel(
      expression: '4 + 5',
      result: '9',
    ),
  ];

  @override
  Future<List<CalculationModel>> getAllCalculation() async {
    // throw UnimplementedError();
    await Future.delayed(const Duration(seconds: 1));
    return Future.value(calculations);
  }

  @override
  Future<bool> saveCalculation(Calculation calculation) {
    calculations.add(CalculationModel(
        expression: calculation.expression, result: calculation.result));
    return Future.value(true);
  }
}
