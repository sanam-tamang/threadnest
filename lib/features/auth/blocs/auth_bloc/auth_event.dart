part of 'auth_bloc.dart';
sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

final class SignUpWithEmailAndPasswordEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;

  const SignUpWithEmailAndPasswordEvent({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  @override
  List<Object> get props => [name, email, password, confirmPassword];
}

final class SignInWithEmailAndPasswordEvent extends AuthEvent {
  final String email;
  final String password;

  const SignInWithEmailAndPasswordEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

final class SignInWithGoogleEvent extends AuthEvent {}

final class ResetPasswordEvent extends AuthEvent {
  final String email;

  const ResetPasswordEvent({required this.email});

  @override
  List<Object> get props => [email];
}