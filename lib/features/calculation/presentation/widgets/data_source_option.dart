import 'package:calculation_ocr/core/enum/data_source.dart';
import 'package:calculation_ocr/dependency_injection.dart';
import 'package:calculation_ocr/features/calculation/presentation/bloc/calculation/calculation_bloc.dart';
import 'package:calculation_ocr/features/calculation/presentation/bloc/datasource_type/datasource_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DataSourceOption extends StatelessWidget {
  const DataSourceOption({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DatasourceTypeBloc, DatasourceState>(
        listener: (context, state) {
          if (state is DatasourceStateUploaded) {
            sl<CalculationBloc>().add(const CalculationEventGetCalculation());
            sl<DatasourceTypeBloc>().add(const DatasourceEventGetDataSource());
          }
        },
        bloc: sl<DatasourceTypeBloc>()
          ..add(const DatasourceEventGetDataSource()),
        builder: (context, state) {
          if (state is DatasourceStateLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is DatasourceStateError) {
            return Center(
              child: Text(state.message),
            );
          } else if (state is DatasourceStateEmpty) {
            return const Center(
              child: Text('No Datasource'),
            );
          } else if (state is DatasourceStateLoaded) {
            return Row(
              children: [
                Flexible(
                  child: Material(
                    child: InkWell(
                      onTap: () {
                        sl<DatasourceTypeBloc>().add(
                            const DatasourceEventSetDataSource(
                                DataSourceType.encryptedStorage));
                      },
                      child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color:
                                state.source == DataSourceType.encryptedStorage
                                    ? Colors.amber
                                    : Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child:
                              const Center(child: Text('Encrypted Storage'))),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Material(
                    child: InkWell(
                      onTap: () {
                        sl<DatasourceTypeBloc>().add(
                            const DatasourceEventSetDataSource(
                                DataSourceType.databaseStorage));
                      },
                      child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color:
                                state.source == DataSourceType.databaseStorage
                                    ? Colors.amber
                                    : Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(child: Text('Database Storage'))),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: Text("EMPTY Datasource"),
            );
          }
        });
  }
}
