import 'package:bloc/bloc.dart';
import 'package:coreconceptsblocdemo/photos_list/domain/entity/photo_enitity.dart';
import 'package:coreconceptsblocdemo/photos_list/domain/repostitory/photo_repository.dart';
import 'package:equatable/equatable.dart';

part 'photo_event.dart';
part 'photo_state.dart';

class PhotoBloc extends Bloc<PhotoEvent, PhotoState> {
  final PhotoRepository repository;
  final List<Photo> photos; 

  PhotoBloc({required this.repository})
      : photos = [], 
        super(PhotoInitial()) {
    on<FetchPhotosEvent>(_onFetchPhotos);
    on<AddPhotoEvent>(_onAddPhoto);
    on<EditPhotoEvent>(_onEditPhoto);
    on<DeletePhotoEvent>(_onDeletePhoto);
  }

  Future<void> _onFetchPhotos(FetchPhotosEvent event, Emitter<PhotoState> emit) async {
    emit(PhotoLoading());
    try {
      final fetchedPhotos = await repository.getPhotos();
      photos.clear();
      photos.addAll(fetchedPhotos);
      emit(PhotoLoaded(photos: List.from(photos)));
    } catch (e) {
      emit(PhotoError());
    }
  }

  Future<void> _onAddPhoto(AddPhotoEvent event, Emitter<PhotoState> emit) async {
    photos.add(event.photo);
    emit(PhotoLoaded(photos: List.from(photos)));
  }

  Future<void> _onEditPhoto(EditPhotoEvent event, Emitter<PhotoState> emit) async {
    final index = photos.indexWhere((photo) => photo.id == event.photo.id);
    if (index != -1) {
      photos[index] = event.photo;
      emit(PhotoLoaded(photos: List.from(photos)));
    }
  }

  Future<void> _onDeletePhoto(DeletePhotoEvent event, Emitter<PhotoState> emit) async {
    photos.removeWhere((photo) => photo.id == event.photo.id);
    emit(PhotoLoaded(photos: List.from(photos)));
  }
}
