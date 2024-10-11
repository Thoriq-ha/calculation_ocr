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
  final XFile image;
  final DataSource dataSource;
  final String expression;
  final String result;
  const CalculationEventSaveCalculation(
      this.image, this.dataSource, this.expression, this.result);

  @override
  List<Object?> get props => [dataSource, expression, result];
}

class CalculationEventSetDataSource extends CalculationEvent {
  final DataSource dataSource;
  const CalculationEventSetDataSource(this.dataSource);

  @override
  List<Object?> get props => [dataSource];
}
