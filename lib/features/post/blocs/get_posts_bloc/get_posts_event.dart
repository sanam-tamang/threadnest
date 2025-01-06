// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'get_posts_bloc.dart';

sealed class BasePostEvent extends Equatable {
  const BasePostEvent();

  @override
  List<Object> get props => [];
}

class GetPostsEvent extends BasePostEvent {
  const GetPostsEvent();

  @override
  List<Object> get props => [];
}

class GetPostsByCommunityEvent extends BasePostEvent {
  const GetPostsByCommunityEvent({
    required this.communityId,
  });
  final String communityId;

  @override
  List<Object> get props => [communityId];
}

class GetPostVoteUpdateEvent extends BasePostEvent {
  const GetPostVoteUpdateEvent({
    required this.postKey,
    required this.posts,
  });

  ///generally either "normal" or community id to distinguish key
  final String postKey;
  final List<GetPost> posts;
  @override
  List<Object> get props => [posts, postKey];
}
