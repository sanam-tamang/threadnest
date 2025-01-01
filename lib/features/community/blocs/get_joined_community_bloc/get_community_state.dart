part of 'get_community_bloc.dart';

sealed class GetJoinedCommunityState extends Equatable {
  const GetJoinedCommunityState();

  @override
  List<Object> get props => [];
}

final class GetJoinedCommunityInitial extends GetJoinedCommunityState {}

final class GetJoinedCommunityLoading extends GetJoinedCommunityState {}

final class GetJoinedCommunityLoaded extends GetJoinedCommunityState {
  final List<Community> communities;

  const GetJoinedCommunityLoaded({required this.communities});

  @override
  List<Object> get props => [communities];
}

final class GetJoinedCommunityFailure extends GetJoinedCommunityState {
  final Failure failure;

  const GetJoinedCommunityFailure({required this.failure});

  @override
  List<Object> get props => [failure];
}
