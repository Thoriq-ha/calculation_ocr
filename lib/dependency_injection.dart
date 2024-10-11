import 'package:calculation_ocr/features/calculation/data/datasources/database_datasource.dart';
import 'package:calculation_ocr/features/calculation/data/datasources/encrypted_storage_datasource.dart';
import 'package:calculation_ocr/features/calculation/data/datasources/shared_pref_datasource.dart';
import 'package:calculation_ocr/features/calculation/data/repositories/calculation_repository_impl.dart';
import 'package:calculation_ocr/features/calculation/domain/repositories/calculation_repository.dart';
import 'package:calculation_ocr/features/calculation/domain/usecases/get_all_calculation.dart';
import 'package:calculation_ocr/features/calculation/domain/usecases/get_datasource_calculation.dart';
import 'package:calculation_ocr/features/calculation/domain/usecases/save_calculation.dart';
import 'package:calculation_ocr/features/calculation/domain/usecases/set_datasource_calculation.dart';
import 'package:calculation_ocr/features/calculation/presentation/bloc/calculation/calculation_bloc.dart';
import 'package:calculation_ocr/features/calculation/presentation/bloc/image/image_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

var sl = GetIt.instance;

Future<void> init() async {
  /// GENERAL DEPENDENCIES
  // SHARED PREF
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // BLOC
  sl.registerLazySingleton(
    () => CalculationBloc(
      getAllCalculation: sl(),
      saveCalculation: sl(),
      setDatasourceCalculation: sl(),
      getDatasourceCalculation: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => ImageBloc(imagePicker: sl()),
  );

  // IMAGE PICKER
  sl.registerLazySingleton(
    () => ImagePicker(),
  );

  // USECASE
  sl.registerLazySingleton(
    () => GetAllCalculation(
      sl(),
    ),
  );
  sl.registerLazySingleton(
    () => SaveCalculation(
      sl(),
    ),
  );
  sl.registerLazySingleton(
    () => SetDatasourceCalculation(
      sl(),
    ),
  );
  sl.registerLazySingleton(
    () => GetDatasourceCalculation(
      sl(),
    ),
  );

  // REPOSITORY
  sl.registerLazySingleton<CalculationRepository>(
    () => CalculationRepositoryImpl(
      databaseDataSource: sl(),
      encryptedStorageDataSource: sl(),
      sharedPreferencesDataSource: sl(),
    ),
  );

  // DATA SOURCE
  sl.registerLazySingleton<DatabaseDataSource>(
    () => DatabaseDatasourceImpl(),
  );
  sl.registerLazySingleton<EncryptedStorageDataSource>(
    () => EncryptedDatasourceImpl(),
  );
  sl.registerLazySingleton<SharePrefDataSource>(
    () => SharedPrefDatasourceImpl(sharedPreferences: sl()),
  );
}
