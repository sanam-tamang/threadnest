part of 'edit_user_bloc.dart';

sealed class EditUserState extends Equatable {
  const EditUserState();

  @override
  List<Object> get props => [];
}

final class EditUserInitial extends EditUserState {}

final class EditUserLoading extends EditUserState {}

final class EditUserLoaded extends EditUserState {}

final class EditUserFailure extends EditUserState {
  final Failure failure;

  EditUserFailure({required this.failure});
    @override
  List<Object> get props => [failure];
}

