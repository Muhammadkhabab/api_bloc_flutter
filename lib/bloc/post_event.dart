part of 'post_bloc.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();
  @override
  List<Object> get props => [];
}

class PostFetched extends PostEvent {}

class SearchItems extends PostEvent {
  final String searchItem;
  const SearchItems({required this.searchItem});
}
