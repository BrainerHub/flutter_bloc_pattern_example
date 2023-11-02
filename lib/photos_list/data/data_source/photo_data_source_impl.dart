import 'dart:convert';

import 'package:coreconceptsblocdemo/photos_list/core/Api/constants/const.dart';
import 'package:coreconceptsblocdemo/photos_list/data/data_source/data_source.dart';
import 'package:coreconceptsblocdemo/photos_list/domain/entity/photo_enitity.dart';
import 'package:http/http.dart' as http;

class PhotoDataSourceImpl implements PhotoDataSource {
  final String apiUrl = Constant.baseUrl + '/photos';

  @override
  Future<List<Photo>> fetchPhotos() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      // print('Response status: ${response.statusCode}');
      final List<dynamic> data = json.decode(response.body);
      final List photoEntities =
          data.map((json) => Photo.fromJson(json)).toList();
      final List<Photo> photos = photoEntities
          .map((entity) => Photo(
                id: entity.id,
                title: entity.title,
                thumbnailUrl: entity.thumbnailUrl,
              ))
          .toList();
      return photos;
    } else {
      print('Response status: ${response.statusCode}');

      throw Exception('Failed to load photos');
    }
  }
}
