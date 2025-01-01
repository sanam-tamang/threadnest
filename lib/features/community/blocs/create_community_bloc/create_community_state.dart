part of 'create_community_bloc.dart';

sealed class CreateCommunityState extends Equatable {
  const CreateCommunityState();
  
  @override
  List<Object> get props => [];
}

final class CreateCommunityInitial extends CreateCommunityState {}
final class CreateCommunityLoading extends CreateCommunityState {}
final class CreateCommunityLoaded extends CreateCommunityState {}
final class CreateCommunityFailure extends CreateCommunityState {
  final Failure failure;

 const  CreateCommunityFailure({required this.failure});

  @override
  List<Object> get props => [failure];
}


