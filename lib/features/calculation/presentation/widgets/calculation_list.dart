import 'package:calculation_ocr/dependency_injection.dart';
import 'package:calculation_ocr/features/calculation/domain/entities/calculation.dart';
import 'package:calculation_ocr/features/calculation/presentation/bloc/calculation/calculation_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CalculationListWidget extends StatelessWidget {
  const CalculationListWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalculationBloc, CalculationState>(
      bloc: sl<CalculationBloc>()..add(const CalculationEventGetCalculation()),
      builder: (context, state) {
        if (state is CalculationStateLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state is CalculationStateError) {
          return Center(
            child: Text(state.message),
          );
        } else if (state is CalculationStateEmpty) {
          return const Text('No Calculation');
        } else if (state is CalculationStateLoaded) {
          List<Calculation> calculations = state.allCalculation;
          return SingleChildScrollView(
            child: Column(
              children: [
                ...calculations.map((calculation) {
                  return ListTile(
                    title: Text(calculation.expression),
                    subtitle: Text(calculation.result),
                  );
                }),
              ],
            ),
          );
        } else {
          return const Center(
            child: Text("EMPTY Calculations"),
          );
        }
      },
    );
  }
}
