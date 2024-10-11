part of 'image_bloc.dart';

abstract class ImageEvent extends Equatable {
  const ImageEvent();
}

class ImageEventPickImageCamera extends ImageEvent {
  @override
  List<Object?> get props => [];
}

class ImageEventPickImageFile extends ImageEvent {
  @override
  List<Object?> get props => [];
}
