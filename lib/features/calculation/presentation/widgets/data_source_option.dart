import 'package:calculation_ocr/features/calculation/domain/enum/data_source.dart';
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

        if (state is DatasourceStateLoaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 1),
              content: Text(
                state.source == DataSourceType.encryptedStorage
                    ? 'Encrypted Storage Selected'
                    : 'Database Storage Selected',
              ),
            ),
          );
        }
      },
      bloc: sl<DatasourceTypeBloc>()..add(const DatasourceEventGetDataSource()),
      builder: (context, state) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeOut,
          child: _buildStateContent(context, state),
        );
      },
    );
  }

  Widget _buildStateContent(BuildContext context, DatasourceState state) {
    if (state is DatasourceStateError) {
      return Center(
        key: const ValueKey('error'),
        child: Text(state.message),
      );
    } else if (state is DatasourceStateEmpty) {
      return const Center(
        key: ValueKey('empty'),
        child: Text('No Datasource'),
      );
    } else if (state is DatasourceStateLoaded) {
      return SwitchListTile(
        key: const ValueKey('loaded'),
        title: const Text('Encrypted Storage'),
        subtitle:
            const Text('Switch between Encrypted Storage and Database Storage'),
        value: state.source == DataSourceType.encryptedStorage,
        onChanged: (bool value) {
          sl<DatasourceTypeBloc>().add(DatasourceEventSetDataSource(
              state.source == DataSourceType.encryptedStorage
                  ? DataSourceType.databaseStorage
                  : DataSourceType.encryptedStorage));
        },
      );
    } else {
      return const Center(
        key: ValueKey('loading'),
        child: Text("EMPTY Datasource"),
      );
    }
  }
}
