import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_api_project/bloc/fetch_dart_bloc/post_bloc.dart';
import 'package:bloc_api_project/view/post_detail_screen.dart';

import '../bloc/fetch_dart_bloc/post_event.dart';

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

  Future<void> _onRefresh() async {
    // Trigger the PostFetched event to reload data
    context.read<PostBloc>().add(PostFetched());
    // Add a small delay to show the indicator
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Post List',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search TextField
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: const InputDecoration(
                hintText: 'Search by title',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                context.read<PostBloc>().add(SearchItems(searchItem: value));
              },
            ),
          ),
          // BlocBuilder to handle state changes
          Expanded(
            child: BlocBuilder<PostBloc, PostState>(
              builder: (context, state) {
                // Handle initial state
                if (state.postState == PostStatus.initial) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                // Handle success state
                else if (state.postState == PostStatus.success) {
                  // Check if there's a search query
                  if (state.searchList != null) {
                    // If search list is empty, show "No Data Found"
                    if (state.searchList!.isEmpty) {
                      return Center(
                        child: Text(
                          state.searchMessage ?? 'No Data Found',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    }
                    // If search list is not empty, show the search results
                    else {
                      return ListView.builder(
                        itemCount: state.searchList!.length,
                        itemBuilder: (context, index) {
                          final post = state.searchList![index];
                          return Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.blue.shade100,
                                child: Text(
                                  post.id.toString(),
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              title: Text(
                                post.title.toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                post.body.toString(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PostDetailScreen(
                                      id: post.id!,
                                      title: post.title!,
                                      body: post.body!,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      );
                    }
                  }
                  // If no search query, show the full list of posts
                  else {
                    return RefreshIndicator(
                      onRefresh: _onRefresh,
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: state.posts.length,
                        itemBuilder: (context, index) {
                          final post = state.posts[index];
                          return Card(
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.blue.shade100,
                                child: Text(
                                  post.id.toString(),
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              title: Text(
                                post.title.toString(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                post.body.toString(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PostDetailScreen(
                                      id: post.id!,
                                      title: post.title!,
                                      body: post.body!,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    );
                  }
                }
                // Handle failure state
                else {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.red.shade300,
                            size: 40,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              context.read<PostBloc>().add(PostFetched());
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
