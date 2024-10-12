import 'package:calculation_ocr/dependency_injection.dart';
import 'package:calculation_ocr/features/calculation/domain/entities/calculation.dart';
import 'package:calculation_ocr/features/calculation/presentation/bloc/calculation/calculation_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CalculationListCard extends StatelessWidget {
  const CalculationListCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: double.infinity,
          child: Text(
            "History",
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.left,
          ),
        ),
        const SizedBox(height: 12),
        BlocBuilder<CalculationBloc, CalculationState>(
          bloc: sl<CalculationBloc>()
            ..add(const CalculationEventGetCalculation()),
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
              return ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: calculations.length,
                itemBuilder: (context, index) {
                  final calculation = calculations[index];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.calculate_outlined,
                          size: 36, color: Colors.green),
                      title: Text(
                        calculation.expression,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      subtitle: Text(
                        'Result: ${calculation.result}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: Text("EMPTY Calculations"),
              );
            }
          },
        ),
      ],
    );
  }
}
