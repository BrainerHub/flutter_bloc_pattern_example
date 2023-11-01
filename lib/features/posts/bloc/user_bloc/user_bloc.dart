import 'package:coreconceptsblocdemo/features/posts/models/user.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class UserBloc extends HydratedCubit<User?> {
  UserBloc() : super(null);

  @override
  User? fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      email: json['email'],
    );
  }

  @override
  Map<String, dynamic> toJson(User? state) {
    if (state != null) {
      return {
        'username': state.username,
        'email': state.email,
      };
    }
    return {};
  }

  void signUpUser(String username, String email) {
    final user = User(username: username, email: email);
    emit(user);
  }

  void updateUsername(String newUsername) {
    final currentUser = state;
    if (currentUser != null) {
      final updatedUser = currentUser.copyWith(username: newUsername);
      emit(updatedUser);
    }
  }

  void updateEmail(String newEmail) {
    final currentUser = state;
    if (currentUser != null) {
      final updatedUser = currentUser.copyWith(email: newEmail);
      emit(updatedUser);
    }
  }
}
