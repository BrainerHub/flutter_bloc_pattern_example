part of 'posts_bloc.dart';

@immutable
abstract class PostsEvent {}


class PostsInitialFetchEvent extends PostsEvent{}


class PostAddEvent extends PostsEvent{}

class ShowSnackbarEvent extends PostsEvent {
  final String message;

  ShowSnackbarEvent(this.message);
}

class ItemSelectedEvent extends PostsEvent {
  final int? selectedItemId;

  ItemSelectedEvent(this.selectedItemId);
}
