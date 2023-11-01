import 'dart:async';

import 'package:coreconceptsblocdemo/features/posts/models/post_data_ui_model.dart';
import 'package:coreconceptsblocdemo/features/posts/repos/posts_repo.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';

part 'posts_event.dart';
part 'posts_state.dart';

const hydratedBlocKey = 'posts_bloc';

class PostsBloc extends HydratedBloc<PostsEvent, PostsState> {
  PostsBloc() : super(PostsInitial()) {
    on<PostsInitialFetchEvent>(postsInitialFetchEvent);
    on<PostAddEvent>(postAddEvent);
    on<ShowSnackbarEvent>(showSnackbarEvent);
    on<ItemSelectedEvent>(initialSelectedEvent);
  }
  int? selectedItemId; 

  FutureOr<void> postsInitialFetchEvent(
      PostsInitialFetchEvent event, Emitter<PostsState> emit) async {
    emit(PostsFetchingLoadingState());

    final savedData = HydratedBloc.storage.read(hydratedBlocKey);
    print(savedData);

    if (savedData != null && savedData is List<dynamic>) {
      final List<PostDataUiModel> posts = savedData.map((postJson) {
        return PostDataUiModel.fromJson(postJson);
      }).toList();
      print('storage');

      emit(PostFetchingSuccessfulState(posts: posts));
    } else {
      List<PostDataUiModel> posts = await PostsRepo.fetchPosts();
      print('api');

      HydratedBloc.storage
          .write(hydratedBlocKey, posts.map((post) => post.toJson()).toList());

      emit(PostFetchingSuccessfulState(posts: posts));
    }
  }

  FutureOr<void> postAddEvent(
      PostAddEvent event, Emitter<PostsState> emit) async {
    bool success = await PostsRepo.addPost();

    if (success) {
      emit(PostsAdditionSuccessState());
    } else {
      emit(PostsAdditionErrorState());
    }
  }

  FutureOr<void> initialSelectedEvent(
      ItemSelectedEvent event, Emitter<PostsState> emit) {
    selectedItemId = event.selectedItemId;
    emit(ItemSelectedState(selectedItemId: selectedItemId));
  }

  @override
  PostsState? fromJson(Map<String, dynamic> json) {
    try {
      final List<PostDataUiModel> posts =
          (json[hydratedBlocKey] as List<dynamic>).map((postJson) {
        return PostDataUiModel.fromJson(postJson);
      }).toList();
      selectedItemId = json['selectedItemId'];
      return PostFetchingSuccessfulState(posts: posts);
    } catch (_) {
      return PostsInitial();
    }
  }

  @override
  Map<String, dynamic>? toJson(PostsState state) {
    if (state is PostFetchingSuccessfulState) {
      return {
        hydratedBlocKey: state.posts.map((post) => post.toJson()).toList(),
        'selectedItemId': selectedItemId,
      };
    }
    return {};
  }
}

FutureOr<void> showSnackbarEvent(
    ShowSnackbarEvent event, Emitter<PostsState> emit) async {
  emit(SnackbarShownState(event.message));
}
