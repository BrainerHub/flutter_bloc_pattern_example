import 'package:coreconceptsblocdemo/photos_list/domain/entity/photo_enitity.dart';

abstract class PhotoRepository {
  Future<List<Photo>> getPhotos();
}
