part of 'posts_bloc.dart';

@immutable
abstract class PostsState {}

abstract class PostsActionState extends PostsState {}

class PostsInitial extends PostsState {}

class PostsFetchingLoadingState extends PostsState {}

class PostsFetchingErrorState extends PostsState {}

class PostFetchingSuccessfulState extends PostsState {
  final List<PostDataUiModel> posts;
  PostFetchingSuccessfulState({
    required this.posts,
  });

  copyWith({required List<PostDataUiModel> posts}) {}
}

class PostsAdditionSuccessState extends PostsActionState {}

class PostsAdditionErrorState extends PostsActionState {}

class PostsItemSelectedState extends PostsState {
  final int selectedItemId;

  PostsItemSelectedState({required this.selectedItemId});
}

class SnackbarShownState extends PostsActionState {
  final String message;

  SnackbarShownState(this.message);
}

class ItemSelectedState extends PostsActionState {
  final int? selectedItemId;
  ItemSelectedState({required this.selectedItemId});
}
