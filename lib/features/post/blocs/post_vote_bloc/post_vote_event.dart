// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'post_vote_bloc.dart';

sealed class PostVoteEvent extends Equatable {
  const PostVoteEvent();

  @override
  List<Object> get props => [];
}

class PostVoteUpEvent extends PostVoteEvent {
  const PostVoteUpEvent({
    required this.postKey,
    required this.post,
  });
  final String postKey;
  final GetPost post;

  @override
  List<Object> get props => [post, postKey];
}

class PostVoteDownEvent extends PostVoteEvent {
  const PostVoteDownEvent({
    required this.postKey,
    required this.post,
  });
  final String postKey;
  final GetPost post;

  @override
  List<Object> get props => [post, postKey];
}
