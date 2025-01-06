// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:threadnest/common/widgets/app_cached_network_image.dart';
import 'package:threadnest/common/widgets/app_error_widget.dart';
import 'package:threadnest/common/widgets/app_loading_indicator.dart';
import 'package:threadnest/core/theme/colors.dart';
import 'package:threadnest/dependency_injection.dart';
import 'package:threadnest/features/comment/models/comment.dart';
import 'package:threadnest/features/comment/widgets/post_comment_text_field.dart';
import 'package:threadnest/features/post/blocs/get_post_by_id_bloc/get_post_by_id_bloc.dart';
import 'package:threadnest/features/post/widgets/comment_vote_buttons.dart';
import 'package:threadnest/features/post/widgets/post_card.dart';

class PostDetailPage extends StatefulWidget {
  final String postId;
  final String postKey;
  const PostDetailPage(
      {super.key, required this.postId, required this.postKey});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  late GetPostByIdBloc _bloc;
  late TextEditingController _commentController;
  late FocusNode _commentFocus;
  @override
  void initState() {
    _bloc = sl<GetPostByIdBloc>()..add(GetPostByIdEvent(widget.postId));
    _commentController = TextEditingController();
    _commentFocus = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) => _commentFocus.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
        ),
        body: BlocBuilder<GetPostByIdBloc, GetPostByIdState>(
          bloc: _bloc,
          builder: (context, state) {
            if (state is GetPostByIdLoading) {
              return const AppLoadingIndicator();
            } else if (state is GetPostByIdLoaded) {
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: PostCard(post: state.post, postKey: widget.postKey),
                  ),
                  state.post.comments != null && state.post.comments!.isNotEmpty
                      ? _buildComments(state)
                      : _buildNoCommentWidget(context)
                ],
              );
            } else if (state is GetPostByIdFailure) {
              return AppErrorWidget(failure: state.failure);
            }
            return const SizedBox.shrink();
          },
        ),
        bottomSheet: PostCommentTextField(
          postId: widget.postId,
        ),
      ),
    );
  }

  SliverToBoxAdapter _buildNoCommentWidget(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: 24, bottom: 120),
        child: Column(
          children: [
            const Icon(
              Icons.text_snippet_sharp,
              size: 100,
              color: ColorsManager.gray,
            ),
            const Gap(8),
            Text(
              "Be the first to share your thoughts! 🚀",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: ColorsManager.gray),
            )
          ],
        ),
      ),
    );
  }

  SliverPadding _buildComments(GetPostByIdLoaded state) {
    return SliverPadding(
      padding: const EdgeInsets.only(bottom: 150),
      sliver: SliverList.builder(
          itemCount: state.post.comments!.length,
          itemBuilder: (context, index) {
            final comment = state.post.comments![index];

            return __buildComment(context, comment);
          }),
    );
  }

  Widget __buildComment(BuildContext context, GetComment comment) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLowest,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _authorImage(comment),
          const Gap(4),
          _buildCommentContent(comment),
          const Gap(8),
          CommentVoteButtons(comment: comment),
        ],
      ),
    );
  }

  Text _buildCommentContent(GetComment comment) {
    return Text(comment.content,
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(fontWeight: FontWeight.w500));
  }

  Row _authorImage(GetComment comment) {
    return Row(
      children: [
        SizedBox(
            height: 25,
            child: AppCachedNetworkImage(
              imageUrl: comment.author.imageUrl,
              isCircular: true,
            )),
        const Gap(2),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(comment.author.name,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.w600)),
            comment.author.bio == null
                ? const SizedBox.shrink()
                : Text(comment.author.bio!,
                    style: Theme.of(context).textTheme.labelSmall),
          ],
        )
      ],
    );
  }
}
