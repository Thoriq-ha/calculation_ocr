import 'package:bloc/bloc.dart';
import 'package:calculation_ocr/core/enum/data_source.dart';
import 'package:calculation_ocr/core/error/failure.dart';
import 'package:calculation_ocr/features/calculation/domain/entities/calculation.dart';
import 'package:calculation_ocr/features/calculation/domain/usecases/get_all_calculation.dart';
import 'package:calculation_ocr/features/calculation/domain/usecases/save_calculation.dart';
import 'package:calculation_ocr/features/calculation/domain/usecases/get_datasource_calculation.dart';
import 'package:calculation_ocr/features/calculation/domain/usecases/set_datasource_calculation.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

part 'calculation_event.dart';
part 'calculation_state.dart';

class CalculationBloc extends Bloc<CalculationEvent, CalculationState> {
  final GetAllCalculation getAllCalculation;
  final SaveCalculation saveCalculation;
  final SetDatasourceCalculation setDatasourceCalculation;
  final GetDatasourceCalculation getDatasourceCalculation;

  CalculationBloc({
    required this.getAllCalculation,
    required this.saveCalculation,
    required this.setDatasourceCalculation,
    required this.getDatasourceCalculation,
  }) : super(CalculationStateEmpty()) {
    on<CalculationEventGetCalculation>((event, emit) async {
      emit(CalculationStateLoading());

      Either<Failure, List<Calculation>> resultGetAllUser =
          await getAllCalculation.execute();

      final resultSetDataSource = await getDatasourceCalculation.execute();

      resultGetAllUser.fold(
        (leftResultGetAllUser) {
          emit(CalculationStateError("Cannot get all calculation"));
        },
        (rightResultGetAllUser) {
          resultSetDataSource.fold(
            ((leftResultDataSource) {
              emit(CalculationStateError("Cannot get DataSource"));
            }),
            ((rightResultDataSource) {
              emit(CalculationStateLoaded(
                  rightResultGetAllUser, rightResultDataSource));
            }),
          );
        },
      );
    });
    on<CalculationEventSaveCalculation>((event, emit) async {
      emit(CalculationStateLoading());

      Calculation calculation =
          Calculation(expression: event.expression, result: event.result);

      Either<Failure, bool> resultSaveCalculation =
          await saveCalculation.execute(calculation);
      resultSaveCalculation.fold(
        (leftResultSaveCalculation) {
          emit(CalculationStateError("Cannot save calculation"));
        },
        (rightResultSaveCalculation) {
          emit(CalculationStateSaved());
        },
      );
    });
    on<CalculationEventSetDataSource>((event, emit) async {
      emit(CalculationStateLoading());

      Either<Failure, bool> resultSetDataSource =
          await setDatasourceCalculation.execute(event.dataSource);
      resultSetDataSource.fold(
        (leftResultSaveCalculation) {
          emit(CalculationStateError("Cannot save Datasource"));
        },
        (rightResultSaveCalculation) {
          emit(CalculationStateSavedDatasource());
        },
      );
    });
  }
}
