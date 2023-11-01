

import 'package:coreconceptsblocdemo/photos_list/domain/entity/photo_enitity.dart';

abstract class PhotoDataSource {
  Future<List<Photo>> fetchPhotos();
}
