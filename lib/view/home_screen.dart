import 'package:bloc_api_project/bloc/post_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePostScreen extends StatefulWidget {
  const HomePostScreen({super.key});

  @override
  State<HomePostScreen> createState() => _HomePostScreenState();
}

class _HomePostScreenState extends State<HomePostScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PostBloc>().add(PostFetched());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post List using bloc'),
      ),
      body: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          if (state.postState == PostStatus.initial) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.postState == PostStatus.success) {
            return ListView.builder(
              itemCount: state.posts.length,
              itemBuilder: (context, index) {
                final post = state.posts[index];
                return ListTile(
                  leading: Text(post.id.toString()),
                  title: Text(post.title.toString()),
                  subtitle: Text(post.title.toString()),
                );
              },
            );
          } else {
            return Center(
              child: Text(state.message),
            );
          }
        },
      ),
    );
  }
}
