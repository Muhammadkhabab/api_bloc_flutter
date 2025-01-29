import 'package:equatable/equatable.dart';

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
