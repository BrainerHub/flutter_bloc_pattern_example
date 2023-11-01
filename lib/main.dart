import 'package:connectivity/connectivity.dart';
import 'package:coreconceptsblocdemo/features/posts/bloc/auth_bloc/auth_cubit.dart';
import 'package:coreconceptsblocdemo/features/posts/bloc/posts_bloc.dart';
import 'package:coreconceptsblocdemo/features/posts/bloc/user_bloc/user_bloc.dart';

import 'package:coreconceptsblocdemo/features/posts/navigation_bloc/navigation_bloc.dart';
import 'package:coreconceptsblocdemo/features/posts/ui/login.dart';
import 'package:coreconceptsblocdemo/features/posts/ui/post_detail_page.dart';
import 'package:coreconceptsblocdemo/features/posts/ui/posts_page.dart';
import 'package:coreconceptsblocdemo/features/posts/ui/signup.dart';
import 'package:coreconceptsblocdemo/photos_list/bloc/photo_bloc.dart';
import 'package:coreconceptsblocdemo/photos_list/data/data_source/photo_data_source_impl.dart';
import 'package:coreconceptsblocdemo/photos_list/data/repository/photorepository.dart';
import 'package:coreconceptsblocdemo/photos_list/presentation/ui/photo_list.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

const hydratedBlocKey = 'postsData';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final photoRepository =
        PhotoRepositoryImpl(dataSource: PhotoDataSourceImpl());
    final photoBloc = PhotoBloc(repository: photoRepository);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'blocdemo',
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: Scaffold(
        body: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => AuthCubit(),
              child: LoginPage(),
            ),
            BlocProvider(
              create: (context) => PostsBloc(),
              child: const PostsPage(),
            ),
            BlocProvider(
              create: (context) => NavigationBloc(),
              child: PostDetailsPage(body: "", title: ""),
            ),
            BlocProvider(
              create: (context) => UserBloc(),
              child: SignupPage(),
            ),
            BlocProvider(
              create: (context) => photoBloc,
              child: PhotoListPage(),
            ),
          ],
          child: LoginPage(),
        ),
      ),
    );
  }
}
