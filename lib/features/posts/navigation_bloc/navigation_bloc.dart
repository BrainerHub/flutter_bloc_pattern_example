import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'navigation_event.dart';

class NavigationBloc extends Bloc<NavigationEvent, dynamic> {
  NavigationBloc() : super(null) {
    on<NavigateToPostDetails>(_navigateToPostDetails);
  }

  void _navigateToPostDetails(
      NavigateToPostDetails event, Emitter<dynamic> emit) {
    emit(event.destination);
  }

  Stream<dynamic> mapEventToState(NavigationEvent event) async* {
    if (event is NavigateToPostDetails) {
      yield event.destination;
    }
  }
}
