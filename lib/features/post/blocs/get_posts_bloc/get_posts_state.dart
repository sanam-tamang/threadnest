// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'get_posts_bloc.dart';

sealed class GetPostState extends Equatable {
  const GetPostState();

  @override
  List<Object?> get props => [];
}

final class GetPostInitial extends GetPostState {}

final class GetPostLoading extends GetPostState {}

final class GetPostLoaded extends GetPostState {
  const GetPostLoaded({required this.posts, this.currentState});

  ///it works like key as a normal when we get questions in our home /feed
  ///and when we fetch data from certain community need to put key as a community id and value and there posts
  ///
  final Map<String, List<GetPost>> posts;

  ///it will help to update state , because bloc not able to fully understand t
  final String? currentState;

  @override
  List<Object?> get props => [posts, currentState];
}

final class GetPostFailure extends GetPostState {
  final Failure failure;

  const GetPostFailure({required this.failure});
  @override
  List<Object> get props => [failure];
}
