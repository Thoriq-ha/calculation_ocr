import 'package:calculation_ocr/core/enum/data_source.dart';
import 'package:calculation_ocr/dependency_injection.dart';
import 'package:calculation_ocr/features/calculation/domain/entities/calculation.dart';
import 'package:calculation_ocr/features/calculation/presentation/bloc/calculation/calculation_bloc.dart';
import 'package:calculation_ocr/flavors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<CalculationBloc, CalculationState>(
        listener: (context, state) {
          if (state is CalculationStateSavedDatasource) {
            sl<CalculationBloc>().add(const CalculationEventGetCalculation());
          }
        },
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
                  Container(
                    child: Row(
                      children: [
                        Flexible(
                          child: Material(
                            child: InkWell(
                              onTap: () {
                                sl<CalculationBloc>().add(
                                    const CalculationEventSetDataSource(
                                        DataSource.encryptedStorage));
                              },
                              child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: state.source ==
                                            DataSource.encryptedStorage
                                        ? Colors.amber
                                        : Colors.grey,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Center(
                                      child: Text('Encrypted Storage'))),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Flexible(
                          child: Material(
                            child: InkWell(
                              onTap: () {
                                sl<CalculationBloc>().add(
                                    const CalculationEventSetDataSource(
                                        DataSource.databaseStorage));
                              },
                              child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: state.source ==
                                            DataSource.databaseStorage
                                        ? Colors.amber
                                        : Colors.grey,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Center(
                                      child: Text('Database Storage'))),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (F.uIFunctionality == UIFunctionality.camera) {
                        context.pushNamed("camera");
                      } else {
                        context.pushNamed('file_storage');
                      }
                    },
                    child: Text(F.uIFunctionality == UIFunctionality.camera
                        ? 'Camera'
                        : 'File System'),
                  )
                ],
              ),
            );
          } else {
            return const Center(
              child: Text("EMPTY Calculations"),
            );
          }
        },
      ),
      // body: SingleChildScrollView(
      //   child: Column(
      //     children: [
      //       ElevatedButton(
      //         onPressed: () {
      //           context.pushNamed(
      //             "camera",
      //           );
      //         },
      //         child: const Text('Camera'),
      //       ),
      //       ElevatedButton(
      //         onPressed: () {
      //           context.pushNamed(
      //             "file_storage",
      //           );
      //         },
      //         child: const Text('File Storage'),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
