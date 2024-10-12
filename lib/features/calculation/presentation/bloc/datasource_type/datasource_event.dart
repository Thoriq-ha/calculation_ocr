part of 'datasource_bloc.dart';

abstract class DatasourceEvent extends Equatable {
  const DatasourceEvent();
}

class DatasourceEventGetDataSource extends DatasourceEvent {
  const DatasourceEventGetDataSource();

  @override
  List<Object?> get props => [];
}

class DatasourceEventSetDataSource extends DatasourceEvent {
  final DataSourceType dataSource;

  const DatasourceEventSetDataSource(this.dataSource);

  @override
  List<Object?> get props => [dataSource];
}
