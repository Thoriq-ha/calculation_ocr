part of 'datasource_bloc.dart';

abstract class DatasourceState extends Equatable {}

class DatasourceStateEmpty extends DatasourceState {
  @override
  List<Object?> get props => [];
}

class DatasourceStateLoading extends DatasourceState {
  @override
  List<Object?> get props => [];
}

class DatasourceStateError extends DatasourceState {
  final String message;

  DatasourceStateError(this.message);

  @override
  List<Object?> get props => [message];
}

class DatasourceStateLoaded extends DatasourceState {
  final DataSourceType source;

  DatasourceStateLoaded(this.source);

  @override
  List<Object?> get props => [source];
}

class DatasourceStateUploaded extends DatasourceState {
  DatasourceStateUploaded();

  @override
  List<Object?> get props => [];
}
