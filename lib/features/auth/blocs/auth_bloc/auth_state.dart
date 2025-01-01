part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSignedIn extends AuthState {}

final class AuthSignedInNotVerified extends AuthState {}

final class AuthPasswordResetSuccess extends AuthState {}

final class AuthError extends AuthState {
  final Failure failure;

  const AuthError(this.failure);

  @override
  List<Object> get props => [failure];
}
