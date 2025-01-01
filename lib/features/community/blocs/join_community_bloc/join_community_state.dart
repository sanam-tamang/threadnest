part of 'join_community_bloc.dart';

sealed class JoinCommunityState extends Equatable {
  const JoinCommunityState();

  @override
  List<Object> get props => [];
}

final class JoinCommunityInitial extends JoinCommunityState {}

final class JoinCommunityLoading extends JoinCommunityState {}

final class JoinCommunityLoaded extends JoinCommunityState {
  const JoinCommunityLoaded();

  @override
  List<Object> get props => [];
}

final class JoinCommunityFailure extends JoinCommunityState {
  final Failure failure;

  const JoinCommunityFailure({required this.failure});

  @override
  List<Object> get props => [failure];
}
