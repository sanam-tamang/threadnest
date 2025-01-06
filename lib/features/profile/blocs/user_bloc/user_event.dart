// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class GetUserEvent extends UserEvent {
  const GetUserEvent({
    this.currentlyVisitedProfileId,
    this.refresh,
  });
  final String? currentlyVisitedProfileId;
  ///when refresh true it will fetch new user  from database even if it cached locally 
  final bool? refresh;
  @override
  List<Object?> get props => [currentlyVisitedProfileId, refresh];
}
