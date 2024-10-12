import 'package:equatable/equatable.dart';

class Calculation extends Equatable {
  final String expression;
  final String result;

  const Calculation({required this.expression, required this.result});

  @override
  List<Object> get props => [expression, result];
}
