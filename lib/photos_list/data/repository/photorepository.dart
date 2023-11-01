import 'package:coreconceptsblocdemo/photos_list/data/data_source/data_source.dart';
import 'package:coreconceptsblocdemo/photos_list/domain/entity/photo_enitity.dart';
import 'package:coreconceptsblocdemo/photos_list/domain/repostitory/photo_repository.dart';

class PhotoRepositoryImpl implements PhotoRepository {
  final PhotoDataSource dataSource;

  PhotoRepositoryImpl({required this.dataSource});

  @override
  Future<List<Photo>> getPhotos() {
    return dataSource.fetchPhotos();
  }
}
