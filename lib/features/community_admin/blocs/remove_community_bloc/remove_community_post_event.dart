part of 'remove_community_post_bloc.dart';

class RemoveCommunityPostEvent extends Equatable {
  const RemoveCommunityPostEvent({
    required this.postId,
    required this.communityId,
  });
  final String postId;
  final String communityId;

  @override
  List<Object> get props => [postId, communityId];
}
