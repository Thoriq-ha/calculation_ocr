import 'package:calculation_ocr/core/enum/data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SharePrefDataSource {
  Future<bool> setDatasource(DataSource calculation);
  Future<DataSource> getDatasource();
}

const keyDataSource = 'keyDataSource';

class SharedPrefDatasourceImpl implements SharePrefDataSource {
  final SharedPreferences sharedPreferences;

  SharedPrefDatasourceImpl({required this.sharedPreferences});

  @override
  Future<bool> setDatasource(DataSource calculation) {
    return sharedPreferences.setString(keyDataSource, calculation.name);
  }

  @override
  Future<DataSource> getDatasource() async {
    final value = sharedPreferences.getString(keyDataSource);
    if (value == null) {
      return DataSource.databaseStorage;
    }

    return Future.value(
        DataSource.values.firstWhere((element) => element.name == value));
  }
}
