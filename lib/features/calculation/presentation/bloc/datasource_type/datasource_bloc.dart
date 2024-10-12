import 'package:bloc/bloc.dart';
import 'package:calculation_ocr/features/calculation/domain/enum/data_source.dart';
import 'package:calculation_ocr/features/calculation/domain/usecases/get_datasource_type.dart';
import 'package:calculation_ocr/features/calculation/domain/usecases/set_datasource_type.dart';
import 'package:equatable/equatable.dart';

part 'datasource_event.dart';
part 'datasource_state.dart';

class DatasourceTypeBloc extends Bloc<DatasourceEvent, DatasourceState> {
  final SetDatasourceTypeCalculation setDatasourceTypeCalculation;
  final GetDatasourceTypeCalculation getDatasourceTypeCalculation;

  DatasourceTypeBloc({
    required this.setDatasourceTypeCalculation,
    required this.getDatasourceTypeCalculation,
  }) : super(DatasourceStateEmpty()) {
    on<DatasourceEventGetDataSource>((event, emit) async {
      emit(DatasourceStateLoading());

      final resultDataSourceType = await getDatasourceTypeCalculation.execute();
      resultDataSourceType.fold(
        (leftResultGetAllCalculation) {
          emit(DatasourceStateError("Cannot get all calculation"));
        },
        (rightResultGetAllCalculation) {
          emit(DatasourceStateLoaded(rightResultGetAllCalculation));
        },
      );
    });
    on<DatasourceEventSetDataSource>((event, emit) async {
      emit(DatasourceStateLoading());

      final resultDataSourceType =
          await setDatasourceTypeCalculation.execute(event.dataSource);
      resultDataSourceType.fold(
        (leftResultGetAllCalculation) {
          emit(DatasourceStateError("Cannot get all calculation"));
        },
        (rightResultGetAllCalculation) {
          emit(DatasourceStateUploaded());
        },
      );
    });
  }
}
