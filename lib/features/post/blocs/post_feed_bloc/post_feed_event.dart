part of 'post_feed_bloc.dart';

class PostFeedEvent extends Equatable {
  final PostFeed postFeed;
  const PostFeedEvent({required this.postFeed});

  @override
  List<Object> get props => [postFeed];
}
