part of 'calculation_bloc.dart';

abstract class CalculationEvent extends Equatable {
  const CalculationEvent();
}

class CalculationEventGetCalculation extends CalculationEvent {
  const CalculationEventGetCalculation();

  @override
  List<Object?> get props => [];
}

class CalculationEventSaveCalculation extends CalculationEvent {
  final String expression;
  final String result;
  const CalculationEventSaveCalculation(this.expression, this.result);

  @override
  List<Object?> get props => [expression, result];
}
