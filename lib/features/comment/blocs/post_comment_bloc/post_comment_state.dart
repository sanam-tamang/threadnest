part of 'post_comment_bloc.dart';

sealed class PostCommentState extends Equatable {
  const PostCommentState();

  @override
  List<Object> get props => [];
}

final class PostCommentInitial extends PostCommentState {}

final class PostCommentLoading extends PostCommentState {}

final class PostCommentLoaded extends PostCommentState {}

final class PostCommentFailure extends PostCommentState {
  final Failure failure;

  const PostCommentFailure({required this.failure});
  @override
  List<Object> get props => [failure];
}
