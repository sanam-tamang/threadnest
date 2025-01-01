// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'join_community_bloc.dart';

class JoinCommunityEvent extends Equatable {
  const JoinCommunityEvent(
    this.communityId,
  );
  final String communityId;
  @override
  List<Object> get props => [communityId];
}
