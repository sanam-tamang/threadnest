// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'post_feed_bloc.dart';

sealed class PostFeedState extends Equatable {
  const PostFeedState();

  @override
  List<Object> get props => [];
}

final class PostFeedInitial extends PostFeedState {}

final class PostFeedLoading extends PostFeedState {}

final class PostFeedLoaded extends PostFeedState {
  const PostFeedLoaded();

  @override
  List<Object> get props => [];
}

final class PostFeedFailure extends PostFeedState {
  final Failure failure;

  const PostFeedFailure({required this.failure});
  @override
  List<Object> get props => [failure];
}
