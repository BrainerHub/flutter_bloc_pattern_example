import 'dart:async';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:connectivity/connectivity.dart';
import 'package:coreconceptsblocdemo/features/posts/bloc/posts_bloc.dart';

import 'package:coreconceptsblocdemo/features/posts/navigation_bloc/navigation_bloc.dart';
import 'package:coreconceptsblocdemo/features/posts/ui/post_detail_page.dart';
import 'package:coreconceptsblocdemo/photos_list/data/data_source/photo_data_source_impl.dart';
import 'package:coreconceptsblocdemo/photos_list/data/repository/photorepository.dart';
import 'package:coreconceptsblocdemo/photos_list/presentation/ui/photo_list.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  final PostsBloc postsBloc = PostsBloc();
  int? selectedItemId;
  final NavigationBloc navigationBloc = NavigationBloc();

  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;
  final photoRepository =
      PhotoRepositoryImpl(dataSource: PhotoDataSourceImpl());
  Connectivity connectivity = Connectivity();

  @override
  void initState() {
    getConnectivity();

    postsBloc.add(PostsInitialFetchEvent());
    super.initState();
  }

  getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen(
        (ConnectivityResult result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
          if (!isDeviceConnected && isAlertSet == false) {
            showDialogBox();
            setState(() => isAlertSet = true);
          } 
        },
      );

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  showDialogBox() => showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: const Text('No Connection'),
          content: const Text('Please check your internet connectivity'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.pop(context, 'Cancel');
                setState(() => isAlertSet = false);
                isDeviceConnected =
                    await InternetConnectionChecker().hasConnection;
                if (!isDeviceConnected && isAlertSet == false) {
                  showDialogBox();
                  const snackBar = SnackBar(
                    backgroundColor: Colors.red,
                    content: Text('No Internet Connection!'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);

                  setState(() => isAlertSet = true);
                }
                // else {
                //   const snackBar = SnackBar(
                //     backgroundColor: Colors.green,
                //     content: Text('Internet connected!'),
                //   );
                //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
                //   setState(() => isAlertSet = false);
                // }
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News'),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          postsBloc.add(PostAddEvent());
          postsBloc.add(ShowSnackbarEvent('Your message here'));

          Navigator.push(context,
              MaterialPageRoute(builder: (context) => PhotoListPage()));
        },
      ),
      body: BlocConsumer<PostsBloc, PostsState>(
        bloc: postsBloc,
        listenWhen: (previous, current) => current is PostsActionState,
        buildWhen: (previous, current) => current is! PostsActionState,
        listener: (context, state) {
          if (state is SnackbarShownState) {
            final snackBar = SnackBar(
              elevation: 0,
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              content: AwesomeSnackbarContent(
                title: 'On Bloc Listner!',
                message: 'This is an example It is Bloc Listener',
                contentType: ContentType.failure,
              ),
            );

            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(snackBar);
          }

          if (state is PostsAdditionSuccessState) {}
        },
        builder: (context, state) {
          switch (state.runtimeType) {
            case PostsFetchingLoadingState:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case PostFetchingSuccessfulState:
              final successState = state as PostFetchingSuccessfulState;
              return Container(
                child: ListView.builder(
                  itemCount: successState.posts.length,
                  itemBuilder: (context, index) {
                    final post = successState.posts[index];
                    bool isSelected = selectedItemId == post.id;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedItemId = post.id;
                        });

                        final snackBar = SnackBar(
                          elevation: 0,
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.transparent,
                          content: AwesomeSnackbarContent(
                            title: 'On Bloc Selected!',
                            message:
                                'This is an example of bloc selector , bloc consumer',
                            contentType: ContentType.help,
                          ),
                        );

                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(snackBar);
                      },
                      child: Container(
                        color:
                            isSelected ? Colors.black87 : Colors.grey.shade200,
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BlocSelector<PostsBloc, PostsState, bool>(
                              selector: (state) =>
                                  state is ItemSelectedState ? true : false,
                              builder: (context, state) {
                                return Text(
                                  post.title,
                                  style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                );
                              },
                            ),
                            SizedBox(height: 10),
                            Text(
                              post.body,
                              style: TextStyle(
                                  color: isSelected
                                      ? Colors.white54
                                      : Colors.black,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      isSelected ? Colors.red : Colors.blueGrey,
                                ),
                                onPressed: () {
                                  final snackBar = SnackBar(
                                    elevation: 0,
                                    behavior: SnackBarBehavior.fixed,
                                    backgroundColor: Colors.transparent,
                                    content: AwesomeSnackbarContent(
                                      title: 'On Bloc Navigated!',
                                      message:
                                          'This is an example of  bloc routing!!',
                                      contentType: ContentType.success,
                                    ),
                                  );

                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(snackBar);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PostDetailsPage(
                                              title: post.title,
                                              body: post.body)));
                                },
                                child: const Text("View Details"))
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            default:
              return const SizedBox();
          }
        },
      ),
    );
  }
}
