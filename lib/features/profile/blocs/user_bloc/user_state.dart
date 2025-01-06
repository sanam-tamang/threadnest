part of 'user_bloc.dart';

sealed class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

final class UserInitial extends UserState {}

final class UserLoading extends UserState {}

final class UserLoaded extends UserState {
  final User user;
  const UserLoaded({required this.user});

  @override
  List<Object> get props => [user];
}

final class UserFailure extends UserState {
  final Failure failure;

  const UserFailure({required this.failure});
  @override
  List<Object> get props => [failure];
}
