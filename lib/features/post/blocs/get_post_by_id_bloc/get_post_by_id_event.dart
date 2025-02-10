// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'get_post_by_id_bloc.dart';

sealed class BaseGetPostByIdEvent extends Equatable {
  const BaseGetPostByIdEvent();

  @override
  List<Object> get props => [];
}

final class GetPostByIdEvent extends BaseGetPostByIdEvent {
  const GetPostByIdEvent(
    this.postId,
  );
  final String postId;
  @override
  List<Object> get props => [postId];
}

///helps to update post locally
final class UpdatePostByIdEvent extends BaseGetPostByIdEvent {
  const UpdatePostByIdEvent(
    this.post,
  );
 final  GetPost post;
  @override
  List<Object> get props => [post];
}
