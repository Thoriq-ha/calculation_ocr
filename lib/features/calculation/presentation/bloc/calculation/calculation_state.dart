part of 'calculation_bloc.dart';

abstract class CalculationState extends Equatable {}

class CalculationStateEmpty extends CalculationState {
  @override
  List<Object?> get props => [];
}

class CalculationStateLoading extends CalculationState {
  @override
  List<Object?> get props => [];
}

class CalculationStateError extends CalculationState {
  final String message;

  CalculationStateError(this.message);

  @override
  List<Object?> get props => [message];
}

class CalculationStateLoaded extends CalculationState {
  final DataSource source;
  final List<Calculation> allCalculation;

  CalculationStateLoaded(this.allCalculation, this.source);

  @override
  List<Object?> get props => [];
}

class CalculationStateSaved extends CalculationState {
  CalculationStateSaved();

  @override
  List<Object?> get props => [];
}

class CalculationStateSavedDatasource extends CalculationState {
  CalculationStateSavedDatasource();

  @override
  List<Object?> get props => [];
}
