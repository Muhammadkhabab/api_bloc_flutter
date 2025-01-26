part of 'post_bloc.dart';

//this is the enum which we will use to manage the state of the post
enum PostStatus { initial, success, failure }

class PostState extends Equatable {
  const PostState({
    this.postState = PostStatus.initial,
    this.posts = const <PostModel>[],
    this.message = '',
  });
  final PostStatus postState;
  final List<PostModel> posts;
  final String message;

  PostState copyWith({
    PostStatus? postState,
    List<PostModel>? posts,
    String? message,
  }) {
    return PostState(
      postState: postState ?? this.postState,
      posts: posts ?? this.posts,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [postState, posts, message];
}
