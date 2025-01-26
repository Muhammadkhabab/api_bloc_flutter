import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:bloc_api_project/models/post_model.dart';
import 'package:equatable/equatable.dart';

import '../repository/post_repostiory.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostRepository fetchRepository = PostRepository();
  PostBloc() : super(PostState()) {
    on<PostFetched>(fetchApi);
  }

  Future<void> fetchApi(PostFetched event, Emitter<PostState> emit) async {
    await fetchRepository.fetchPost().then((posts) {
      emit(state.copyWith(
        postState: PostStatus.success,
        posts: posts,
        message: 'success',
      ));
    }).catchError((e) {
      emit(state.copyWith(
        postState: PostStatus.failure,
        message: e.toString(),
      ));
    });
  }
}
