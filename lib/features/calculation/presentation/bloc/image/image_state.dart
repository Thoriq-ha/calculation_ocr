part of 'image_bloc.dart';

abstract class ImageState extends Equatable {}

class ImageStateEmpty extends ImageState {
  @override
  List<Object?> get props => [];
}

class ImageStateLoading extends ImageState {
  @override
  List<Object?> get props => [];
}

class ImageStateError extends ImageState {
  final XFile? image;
  final String message;

  ImageStateError(this.message, {this.image});

  @override
  List<Object?> get props => [message];
}

class ImageStateImagePicked extends ImageState {
  final XFile image;
  final String expression;
  final String result;

  ImageStateImagePicked(this.image, this.expression, this.result);

  @override
  List<Object?> get props => [];
}
