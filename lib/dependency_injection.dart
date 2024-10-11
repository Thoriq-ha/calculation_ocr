import 'package:calculation_ocr/features/calculation/data/datasources/database_datasource.dart';
import 'package:calculation_ocr/features/calculation/data/datasources/encrypted_storage_datasource.dart';
import 'package:calculation_ocr/features/calculation/data/datasources/shared_pref_datasource.dart';
import 'package:calculation_ocr/features/calculation/data/repositories/calculation_repository_impl.dart';
import 'package:calculation_ocr/features/calculation/domain/repositories/calculation_repository.dart';
import 'package:calculation_ocr/features/calculation/domain/usecases/get_all_calculation.dart';
import 'package:calculation_ocr/features/calculation/domain/usecases/get_datasource_type.dart';
import 'package:calculation_ocr/features/calculation/domain/usecases/save_calculation.dart';
import 'package:calculation_ocr/features/calculation/domain/usecases/set_datasource_type.dart';
import 'package:calculation_ocr/features/calculation/presentation/bloc/calculation/calculation_bloc.dart';
import 'package:calculation_ocr/features/calculation/presentation/bloc/datasource_type/datasource_bloc.dart';
import 'package:calculation_ocr/features/calculation/presentation/bloc/image/image_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

var sl = GetIt.instance;

Future<void> init() async {
  /// GENERAL DEPENDENCIES
  // SHARED PREF
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // SQFLITE DATABASE
  final database = await _initDatabase();
  sl.registerLazySingleton<Database>(() => database);

  // SECURE STORAGE
  const secureStorage = FlutterSecureStorage();
  sl.registerLazySingleton(() => secureStorage);

  // IMAGE PICKER
  sl.registerLazySingleton(
    () => ImagePicker(),
  );

  // BLOC
  sl.registerLazySingleton(
    () => CalculationBloc(
      getAllCalculation: sl(),
      saveCalculation: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => DatasourceTypeBloc(
      setDatasourceTypeCalculation: sl(),
      getDatasourceTypeCalculation: sl(),
    ),
  );
  sl.registerLazySingleton(
    () => ImageBloc(imagePicker: sl()),
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
    () => SetDatasourceTypeCalculation(
      sl(),
    ),
  );
  sl.registerLazySingleton(
    () => GetDatasourceTypeCalculation(
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
    () => DatabaseDatasourceImpl(database: sl()),
  );
  sl.registerLazySingleton<EncryptedStorageDataSource>(
    () => EncryptedDatasourceImpl(secureStorage: sl()),
  );
  sl.registerLazySingleton<SharePrefDataSource>(
    () => SharedPrefDatasourceImpl(sharedPreferences: sl()),
  );
}

Future<Database> _initDatabase() async {
  final databasePath = await getDatabasesPath();
  final path = join(databasePath, 'calculation.db');

  return openDatabase(
    path,
    version: 1,
    onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE calculations (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          expression TEXT,
          result TEXT
        )
      ''');
    },
  );
}
