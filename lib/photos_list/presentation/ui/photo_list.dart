import 'package:coreconceptsblocdemo/photos_list/bloc/photo_bloc.dart';
import 'package:coreconceptsblocdemo/photos_list/data/repository/photorepository.dart';
import 'package:coreconceptsblocdemo/photos_list/domain/entity/photo_enitity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coreconceptsblocdemo/photos_list/data/data_source/photo_data_source_impl.dart';

class PhotoListPage extends StatelessWidget {
  final photoRepository =
      PhotoRepositoryImpl(dataSource: PhotoDataSourceImpl());

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          PhotoBloc(repository: photoRepository)..add(FetchPhotosEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Photo List'),
        ),
        body: BlocBuilder<PhotoBloc, PhotoState>(
          builder: (context, state) {
            if (state is PhotoLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is PhotoLoaded) {
              return ListView.builder(
                itemCount: state.photos.length,
                itemBuilder: (context, index) {
                  final photo = state.photos[index];

                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ListTile(
                        minVerticalPadding: 20,
                        selectedTileColor: Colors.blue,
                        leading: ClipOval(
                          child: Image.network(
                            photo.thumbnailUrl,
                            color: Colors.blueGrey,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          photo.title,
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 14),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.blueGrey,
                              ),
                              onPressed: () {
                                final updatedTitle = 'New Updated Title';

                                final originalPhoto = Photo(
                                  id: photo.id,
                                  title: photo.title,
                                  thumbnailUrl: photo.thumbnailUrl,
                                );

                                final updatedPhoto = Photo(
                                  id: originalPhoto.id,
                                  title: updatedTitle,
                                  thumbnailUrl: originalPhoto.thumbnailUrl,
                                );

                                context
                                    .read<PhotoBloc>()
                                    .add(EditPhotoEvent(updatedPhoto));
                              },
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                context
                                    .read<PhotoBloc>()
                                    .add(DeletePhotoEvent(photo));
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (state is PhotoError) {
              return const Center(
                  child: Text(
                'Oops !! An Error No InternetConnection...',
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ));
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
