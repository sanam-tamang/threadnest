part of 'remove_community_post_bloc.dart';

sealed class RemoveCommunityPostState extends Equatable {
  const RemoveCommunityPostState();

  @override
  List<Object> get props => [];
}

final class RemoveCommunityPostInitial extends RemoveCommunityPostState {}

final class RemoveCommunityPostLoading extends RemoveCommunityPostState {}

final class RemoveCommunityLoaded extends RemoveCommunityPostState {}

final class RemoveCommunityPostFailure extends RemoveCommunityPostState {
  final Failure failure;

  const RemoveCommunityPostFailure({required this.failure});

  @override
  List<Object> get props => [failure];
}
