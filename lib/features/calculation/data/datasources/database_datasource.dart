import 'package:sqflite/sqflite.dart';
import 'package:calculation_ocr/features/calculation/data/models/calculation_model.dart';
import 'package:calculation_ocr/features/calculation/domain/entities/calculation.dart';

abstract class DatabaseDataSource {
  Future<List<CalculationModel>> getAllCalculation();
  Future<bool> saveCalculation(Calculation calculation);
}

class DatabaseDatasourceImpl implements DatabaseDataSource {
  final Database database;

  DatabaseDatasourceImpl({required this.database});

  @override
  Future<List<CalculationModel>> getAllCalculation() async {
    final List<Map<String, dynamic>> maps =
        await database.query('calculations');

    return List.generate(maps.length, (i) {
      return CalculationModel(
        expression: maps[i]['expression'],
        result: maps[i]['result'],
      );
    });
  }

  @override
  Future<bool> saveCalculation(Calculation calculation) async {
    await database.insert(
      'calculations',
      {
        'expression': calculation.expression,
        'result': calculation.result,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return true;
  }
}
