part of 'get_post_by_id_bloc.dart';

sealed class GetPostByIdState extends Equatable {
  const GetPostByIdState();

  @override
  List<Object> get props => [];
}

final class GetPostByIdInitial extends GetPostByIdState {}

final class GetPostByIdLoading extends GetPostByIdState {}

final class GetPostByIdLoaded extends GetPostByIdState {
  final GetPost post;

  const GetPostByIdLoaded({required this.post});

  @override
  List<Object> get props => [post];
}

final class GetPostByIdFailure extends GetPostByIdState {
  final Failure failure;

  const GetPostByIdFailure({required this.failure});

  @override
  List<Object> get props => [failure];
}
