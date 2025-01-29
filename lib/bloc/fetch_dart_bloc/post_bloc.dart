import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:bloc_api_project/models/post_model.dart';
import 'package:equatable/equatable.dart';

import '../../repository/post_repostiory.dart';
import 'post_event.dart';

part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostRepository fetchRepository = PostRepository();
  List<PostModel> tamperaryList = [];
  PostBloc() : super(PostState()) {
    on<PostFetched>(fetchApi);
    on<SearchItems>(_searchItems);
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

  void _searchItems(SearchItems event, Emitter<PostState> emit) {
    if (event.searchItem.isEmpty) {
      emit(state.copyWith(
        searchList: [],
        searchMessage: '',
      ));
    } else {
      tamperaryList = state.posts.where((element) => element.title.toString().toLowerCase().contains(event.searchItem.toLowerCase())).toList();
      if (tamperaryList.isEmpty) {
        emit(
          state.copyWith(
            searchList: [],
            searchMessage: 'Not Data Found',
          ),
        );
      } else {
        emit(
          state.copyWith(
            searchList: tamperaryList,
            searchMessage: 'Data Found',
          ),
        );
      }
    }
  }
}
