part of 'navigation_bloc.dart';

@immutable
abstract class NavigationEvent {}

class NavigateToPostDetails extends NavigationEvent {
  final Widget destination;

  NavigateToPostDetails(this.destination);
}
