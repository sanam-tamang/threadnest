// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'post_comment_bloc.dart';

class PostCommentEvent extends Equatable {
  const PostCommentEvent({
    required this.postId,
    required this.content,
  });
  final String postId;
  final String content;
  @override
  List<Object> get props => [postId, content];
}
