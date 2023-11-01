part of 'photo_bloc.dart';

abstract class PhotoEvent extends Equatable {
  const PhotoEvent();

  @override
  List<Object> get props => [];
}

class FetchPhotosEvent extends PhotoEvent {}

class AddPhotoEvent extends PhotoEvent {
  final Photo photo;

  AddPhotoEvent(this.photo);

  @override
  List<Object> get props => [photo];
}

class EditPhotoEvent extends PhotoEvent {
  final Photo photo;

  EditPhotoEvent(this.photo);

  @override
  List<Object> get props => [photo];
}

class DeletePhotoEvent extends PhotoEvent {
  final Photo photo;

  DeletePhotoEvent(this.photo);

  @override
  List<Object> get props => [photo];
}
