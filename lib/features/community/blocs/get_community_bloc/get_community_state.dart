part of 'get_community_bloc.dart';

sealed class GetCommunityState extends Equatable {
  const GetCommunityState();

  @override
  List<Object> get props => [];
}

final class GetCommunityInitial extends GetCommunityState {}

final class GetCommunityLoading extends GetCommunityState {}

final class GetCommunityLoaded extends GetCommunityState {
  final List<Community> communities;

  const GetCommunityLoaded({required this.communities});

  @override
  List<Object> get props => [communities];
}

final class GetCommunityFailure extends GetCommunityState {
  final Failure failure;

  const GetCommunityFailure({required this.failure});

  @override
  List<Object> get props => [failure];
}
