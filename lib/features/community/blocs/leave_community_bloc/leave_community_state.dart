part of 'leave_community_bloc.dart';

sealed class LeaveCommunityState extends Equatable {
  const LeaveCommunityState();

  @override
  List<Object> get props => [];
}

final class LeaveCommunityInitial extends LeaveCommunityState {}

final class LeaveCommunityLoading extends LeaveCommunityState {}

final class LeaveCommunityLoaded extends LeaveCommunityState {}

final class LeaveCommunityFailure extends LeaveCommunityState {
  final Failure failure;

  LeaveCommunityFailure({required this.failure});

  @override
  List<Object> get props => [failure];
}
