import 'package:calculation_ocr/core/enum/data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SharePrefDataSource {
  Future<bool> setDatasource(DataSourceType calculation);
  Future<DataSourceType> getDatasource();
}

const keyDataSource = 'keyDataSource';

class SharedPrefDatasourceImpl implements SharePrefDataSource {
  final SharedPreferences sharedPreferences;

  SharedPrefDatasourceImpl({required this.sharedPreferences});

  @override
  Future<bool> setDatasource(DataSourceType calculation) {
    return sharedPreferences.setString(keyDataSource, calculation.name);
  }

  @override
  Future<DataSourceType> getDatasource() async {
    final value = sharedPreferences.getString(keyDataSource);
    if (value == null) {
      return DataSourceType.databaseStorage;
    }

    return Future.value(
        DataSourceType.values.firstWhere((element) => element.name == value));
  }
}
