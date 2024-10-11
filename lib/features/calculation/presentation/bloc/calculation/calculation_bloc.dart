import 'package:bloc/bloc.dart';
import 'package:calculation_ocr/core/error/failure.dart';
import 'package:calculation_ocr/features/calculation/domain/entities/calculation.dart';
import 'package:calculation_ocr/features/calculation/domain/usecases/get_all_calculation.dart';
import 'package:calculation_ocr/features/calculation/domain/usecases/save_calculation.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

part 'calculation_event.dart';
part 'calculation_state.dart';

class CalculationBloc extends Bloc<CalculationEvent, CalculationState> {
  final GetAllCalculation getAllCalculation;
  final SaveCalculation saveCalculation;

  CalculationBloc({
    required this.getAllCalculation,
    required this.saveCalculation,
  }) : super(CalculationStateEmpty()) {
    on<CalculationEventGetCalculation>((event, emit) async {
      emit(CalculationStateLoading());

      Either<Failure, List<Calculation>> resultGetAllCalculation =
          await getAllCalculation.execute();

      resultGetAllCalculation.fold(
        (leftResultGetAllCalculation) {
          emit(CalculationStateError("Cannot get all calculation"));
        },
        (rightResultGetAllCalculation) {
          if (rightResultGetAllCalculation.isEmpty) {
            emit(CalculationStateEmpty());
            return;
          }
          emit(CalculationStateLoaded(rightResultGetAllCalculation));
        },
      );
    });
    on<CalculationEventSaveCalculation>((event, emit) async {
      emit(CalculationStateLoading());

      final calculation =
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
  }
}
