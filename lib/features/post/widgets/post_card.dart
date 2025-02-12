// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import 'package:threadnest/common/utils/app_toast.dart';
import 'package:threadnest/common/utils/progress_indicaror.dart';

import 'package:threadnest/common/widgets/app_cached_network_image.dart';
import 'package:threadnest/common/widgets/file_downloader.dart';
import 'package:threadnest/common/widgets/make_ink_widget.dart';
import 'package:threadnest/common/widgets/owner_access_widget.dart';
import 'package:threadnest/common/widgets/vote_button.dart';
import 'package:threadnest/core/theme/colors.dart';
import 'package:threadnest/dependency_injection.dart';
import 'package:threadnest/features/community/blocs/join_community_bloc/join_community_bloc.dart';
import 'package:threadnest/features/community/widgets/join_community_listener.dart';
import 'package:threadnest/features/community_admin/blocs/remove_community_bloc/remove_community_post_bloc.dart';
import 'package:threadnest/features/post/blocs/post_vote_bloc/post_vote_bloc.dart';
import 'package:threadnest/features/post/models/post_model.dart';

import 'package:threadnest/features/post/widgets/card_footer_button_style.dart';
import 'package:threadnest/router.dart';

class PostCard extends StatefulWidget {
  final GetPost post;

  ///post key tend to tell from where post is accessed whether from feed or communtinity
  ///generall post key is ["community_id"] if it accessed from community otherwise its ["normal"]
  final String postKey;

  const PostCard({
    super.key,
    required this.post,
    required this.postKey,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          // borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: ColorScheme.of(context).surfaceContainerHigh,
                offset: const Offset(5, 5),
                blurRadius: 10,
                spreadRadius: -5)
          ]),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.only(bottom: 2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMainContent(),
          const Gap(8),
          _buildPostFooterActionButtons(),
        ],
      ),
    );
  }

  Widget _buildPostFooterActionButtons() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          __upAndDownVoteButtons(),
          __commentButton(),
          __buildPostShare()
        ],
      ),
    );
  }

  PostCardFooterActionStyleButtonWidget __buildPostShare() {
    return PostCardFooterActionStyleButtonWidget(
        child: Row(
      children: [
        MakeInkButton(
            onTap: () {},
            child: const Icon(
              Icons.share,
              color: ColorsManager.postCardActionButtonColor,
            )),
        const Gap(5),
        Text(widget.post.totalShares == 0
            ? ""
            : widget.post.totalShares.toString()),
      ],
    ));
  }

  PostCardFooterActionStyleButtonWidget __commentButton() {
    return PostCardFooterActionStyleButtonWidget(
        child: Row(
      children: [
        MakeInkButton(
          onTap: () {},
          child: const Icon(
            CupertinoIcons.chat_bubble,
            color: ColorsManager.postCardActionButtonColor,
          ),
        ),
        const Gap(6),
        Text(widget.post.totalComments.toString()),
      ],
    ));
  }

  Widget __upAndDownVoteButtons() {
    return PostCardFooterActionStyleButtonWidget(
      child: Row(
        children: [
          VoteButton(
            voteStatus: widget.post.voteStatus,
            onTap: () => sl<PostVoteBloc>().add(
                PostVoteUpEvent(post: widget.post, postKey: widget.postKey)),
            isUpVote: true,
          ),
          const Gap(6),
          Text(
            widget.post.overalPostVote,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const Gap(6),
          VoteButton(
            isUpVote: false,
            voteStatus: widget.post.voteStatus,
            onTap: () => sl<PostVoteBloc>().add(
                PostVoteDownEvent(post: widget.post, postKey: widget.postKey)),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _postCardEitherAuthorOrCommunity(),
        _buildTitle(),
        if (widget.post.content != null && widget.post.content!.isNotEmpty) ...[
          const Gap(4),
          Text(widget.post.content!),
        ],
        if (widget.post.imageUrl != null) ...[
          Gap(4),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color:
                        ColorScheme.of(context).inverseSurface.withAlpha(40))),
            child: AppCachedNetworkImage(
              imageUrl: widget.post.imageUrl,
              borderRadius: 12,
            ),
          )
        ],
        if (widget.post.documentUrl != null) ...[
          const Gap(4),
          _buildDocumentWidget(),
        ],
        const Gap(8),
      ],
    );
  }

  Container _buildDocumentWidget() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Text(
            widget.post.documentUrl!.split("/").last.split("+").last,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          FileDownloaderWidget(
              fileUrl: widget.post.documentUrl!,
              child: const Icon(Icons.download_for_offline_outlined))
        ],
      ),
    );
  }

  Text _buildTitle() {
    return Text(
      widget.post.title,
      style: Theme.of(context)
          .textTheme
          .titleMedium
          ?.copyWith(fontWeight: FontWeight.w700, color: Colors.black87),
    );
  }

  Widget _postCardEitherAuthorOrCommunity() {
    bool isSameCommunity = widget.postKey == widget.post.community.id;
    return isSameCommunity ? _buildAuthorInfo() : _buildCommunityInfo();
  }

  Widget _buildCommunityInfo() {
    return Row(
      children: [
        SizedBox(
          height: 30,
          child: AppCachedNetworkImage(
            imageUrl: widget.post.community.imageUrl,
            isCircular: true,
          ),
        ),
        const Gap(5),
        Text(
          widget.post.community.name,
          style: Theme.of(context)
              .textTheme
              .labelMedium
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        const Spacer(),
        _JoinButton(widget: widget),
        const Gap(2),
        _PostPopupMenu(post: widget.post, children: const [])
      ],
    );
  }

  Widget _buildAuthorInfo() {
    return GestureDetector(
      onTap: () => context.pushNamed(AppRouteName.userProfilePage,
          pathParameters: {"id": widget.post.author.id}),
      child: Row(
        children: [
          SizedBox(
            height: 30,
            child: AppCachedNetworkImage(
              imageUrl: widget.post.author.imageUrl,
              isCircular: true,
            ),
          ),
          const Gap(5),
          Text(
            widget.post.author.name,
            style: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          const Gap(2),
          _PostPopupMenu(
            post: widget.post,
            children: OwnerAccessWidget.isOwner(widget.post.community.ownerId)
                ? [
                    PopupMenuItem(
                      value: "remove-post-from-community",
                      child: BlocListener<RemoveCommunityPostBloc,
                          RemoveCommunityPostState>(
                        listener: (context, state) async {
                          if (state is RemoveCommunityPostLoading) {
                            await AppProgressIndicator.show2(context);
                          } else if (state is RemoveCommunityLoaded) {
                            Navigator.pop(context); // Close the menu
                            AppToast.show("Post removed");
                          } else if (state is RemoveCommunityPostFailure) {
                            Navigator.pop(context); // Close the menu
                            AppToast.show(state.failure.message);
                          }
                        },
                        child: InkWell(
                          onTap: _removePostFromCommunity,
                          child: const Row(
                            children: [
                              Icon(Icons.delete_outline),
                              SizedBox(width: 8),
                              Text("Remove from community"),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]
                : [],
          )
        ],
      ),
    );
  }

  void _removePostFromCommunity() {
    sl<RemoveCommunityPostBloc>().add(
      RemoveCommunityPostEvent(
        postId: widget.post.id,
        communityId: widget.post.community.id,
      ),
    );
  }
}

class _JoinButton extends StatefulWidget {
  const _JoinButton({
    required this.widget,
  });

  final PostCard widget;

  @override
  State<_JoinButton> createState() => _JoinButtonState();
}

class _JoinButtonState extends State<_JoinButton> {
  late bool isMemeber;
  late JoinCommunityBloc bloc;
  @override
  void initState() {
    super.initState();
    isMemeber = widget.widget.post.community.isMember ?? false;
    bloc = sl<JoinCommunityBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return JoinCommunityListener(
      bloc: bloc,
      child: !isMemeber
          ? Transform.scale(
              scale: 0.75,
              child: FilledButton(
                  onPressed: () {
                    bloc.add(
                        JoinCommunityEvent(widget.widget.post.community.id));
                    setState(() {
                      isMemeber = !isMemeber;
                    });
                  },
                  child: const Text("Join")),
            )
          : const SizedBox(),
    );
  }
}

class _PostPopupMenu extends StatelessWidget {
  const _PostPopupMenu({required this.post, required this.children});

  final GetPost post;
  final List<PopupMenuItem> children;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) {
        return [
          const PopupMenuItem(
            value: 'save',
            child: Text("Save"),
          ),
          ...children
        ];
      },
    );
  }
}
