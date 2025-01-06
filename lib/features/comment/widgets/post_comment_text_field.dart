import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:threadnest/common/utils/app_toast.dart';
import 'package:threadnest/core/theme/box_shadow.dart';
import 'package:threadnest/dependency_injection.dart';
import 'package:threadnest/features/comment/blocs/post_comment_bloc/post_comment_bloc.dart';
import 'package:threadnest/features/post/blocs/get_post_by_id_bloc/get_post_by_id_bloc.dart';

class PostCommentTextField extends StatefulWidget {
  final String postId;

  const PostCommentTextField({
    super.key,
    required this.postId,
  });

  @override
  State<PostCommentTextField> createState() => _PostCommentTextFieldState();
}

class _PostCommentTextFieldState extends State<PostCommentTextField> {
  late TextEditingController _commentController;
  late FocusNode _commentFocus;
  bool _isKeywordOpen = false;
  bool _shouldAbleToPostComment = false;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController()
      ..addListener(() {
        setState(() {
          _shouldAbleToPostComment = _commentController.text.isNotEmpty;
        });
      });
    _commentFocus = FocusNode();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _isKeywordOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    !_isKeywordOpen ? _commentFocus.unfocus() : ();
  }

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        boxShadow: AppBoxShadow.postBoxShadow(context),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(
                  left: 12, top: 8, right: _isKeywordOpen ? 0 : 12, bottom: 4),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(4)),
              child: TextField(
                minLines: 1,
                maxLines: 4,
                onTapOutside: (event) => _commentFocus.unfocus(),
                controller: _commentController,
                focusNode: _commentFocus,
                decoration: const InputDecoration(
                  hintText: 'Add a comment',
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          BlocConsumer<PostCommentBloc, PostCommentState>(
            listener: (context, state) {
              if (state is PostCommentLoaded) {
                sl<GetPostByIdBloc>().add(GetPostByIdEvent(widget.postId));
                AppToast.show("Comment added");
              }
              if (state is PostCommentFailure) {
                AppToast.show(state.failure.message);
              }
            },
            builder: (context, state) {
              if (state is PostCommentLoading) {
                return const CircularProgressIndicator();
              } else {
                if (_isKeywordOpen) {
                  return IconButton(
                    onPressed: _shouldAbleToPostComment ? _onCommentSend : null,
                    icon: Icon(
                      Icons.send_outlined,
                      color: _shouldAbleToPostComment
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.surfaceDim,
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }
            },
          ),
        ],
      ),
    );
  }

  void _onCommentSend() {
    final content = _commentController.text;
    sl<PostCommentBloc>()
        .add(PostCommentEvent(postId: widget.postId, content: content.trim()));
    _commentController.clear();
  }
}
