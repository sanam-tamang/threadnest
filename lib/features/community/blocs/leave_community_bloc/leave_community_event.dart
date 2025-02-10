// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'leave_community_bloc.dart';

class LeaveCommunityEvent extends Equatable {
  const LeaveCommunityEvent(
    this.communityId,
  );
  final String communityId;
  @override
  List<Object> get props => [communityId];
}
