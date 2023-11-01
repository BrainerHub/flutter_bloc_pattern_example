import 'package:coreconceptsblocdemo/features/posts/bloc/auth_bloc/auth.state.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';


class AuthCubit extends HydratedCubit<AuthState> {
  AuthCubit() : super(AuthState(email: '', password: ''));

  void login(String email, String password) {
    emit(AuthState(email: email, password: password));
  }

  @override
  AuthState? fromJson(Map<String, dynamic> json) {
    return AuthState(
      email: json['email'],
      password: json['password'],
    );
  }

  @override
  Map<String, dynamic>? toJson(AuthState state) {
    return {
      'email': state.email,
      'password': state.password,
    };
  }
}
