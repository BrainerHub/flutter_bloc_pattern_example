import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coreconceptsblocdemo/features/posts/bloc/auth_bloc/auth_cubit.dart';
import 'package:coreconceptsblocdemo/features/posts/bloc/posts_bloc.dart';
import 'package:coreconceptsblocdemo/features/posts/bloc/user_bloc/user_bloc.dart';
import 'package:coreconceptsblocdemo/features/posts/ui/posts_page.dart';
import 'package:coreconceptsblocdemo/features/posts/ui/signup.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final authState = context.select((AuthCubit authCubit) => authCubit.state);
    final user = BlocProvider.of<UserBloc>(context).state;

    emailController.text = authState.email ?? '';
    passwordController.text = authState.password ?? '';

    final _formKey = GlobalKey<FormState>();

    if (authState.email != null &&
        authState.email!.isNotEmpty &&
        user != null &&
        user.email == emailController.text) {
      return BlocProvider.value(
        value: BlocProvider.of<PostsBloc>(context),
        child: const PostsPage(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome Back !!'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final email = emailController.text;
                        final password = passwordController.text;

                        context.read<AuthCubit>().login(email, password);

                        final user = BlocProvider.of<UserBloc>(context).state;

                        if (user != null && user.email == email) {
                          const snackBar = SnackBar(
                            backgroundColor: Colors.green,
                            content: Text('Logged In Successfully!'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                value: BlocProvider.of<PostsBloc>(context),
                                child: const PostsPage(),
                              ),
                            ),
                          );
                        } else {
                          const snackBar = SnackBar(
                            backgroundColor: Colors.red,
                            content: Text('User Not available!'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      }
                    },
                    child: const Text('Login'),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      emailController.clear();
                      passwordController.clear();

                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: BlocProvider.of<UserBloc>(context),
                            child: SignupPage(),
                          ),
                        ),
                      );
                    },
                    child: const Text('SignUp'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
