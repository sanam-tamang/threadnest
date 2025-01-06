// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:threadnest/common/widgets/app_cached_network_image.dart';
import 'package:threadnest/common/widgets/app_loading_indicator.dart';
import 'package:threadnest/common/widgets/owner_access_widget.dart';
import 'package:threadnest/dependency_injection.dart';
import 'package:threadnest/features/community/blocs/join_community_bloc/join_community_bloc.dart';
import 'package:threadnest/features/community/models/community.dart';
import 'package:threadnest/features/profile/widgets/user_profile.dart';
import 'package:threadnest/features/post/blocs/get_posts_bloc/get_posts_bloc.dart';
import 'package:threadnest/features/post/widgets/post_card.dart';
import 'package:threadnest/router.dart';

class CommunityDetailPage extends StatefulWidget {
  const CommunityDetailPage({
    super.key,
    required this.community,
  });
  final Community community;
  @override
  State<CommunityDetailPage> createState() => _CommunityDetailPageState();
}

class _CommunityDetailPageState extends State<CommunityDetailPage> {
  late String postKey;
  late GetPostsBloc _bloc;
  late bool isMember;
  @override
  void initState() {
    postKey = widget.community.id;
    _bloc = sl<GetPostsBloc>();
    isMember = widget.community.isMember ?? false;

    if (_bloc.state is GetPostLoaded) {
      bool isKeyContains = _bloc.localPosts.containsKey(postKey);
      isKeyContains
          ? null
          : _bloc.add(GetPostsByCommunityEvent(communityId: postKey));
    }

    super.initState();
  }

  Future<void> _onRefresh() async {
    _bloc.add(GetPostsByCommunityEvent(communityId: postKey));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
      onRefresh: _onRefresh,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            pinned: true,
            actions: [
              OwnerAccessWidget(
                  ownerId: widget.community.ownerId,
                  child: IconButton(
                      onPressed: () {}, icon: const Icon(Icons.settings)))
            ],
          ),
        ],
        body: RefreshIndicator(
          onRefresh: _onRefresh,
          child: CustomScrollView(slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
                height: 250,
                width: double.maxFinite,
                child: Stack(
                  children: [
                    SizedBox(
                        height: 200,
                        width: double.maxFinite,
                        child: AppCachedNetworkImage(
                            imageUrl: widget.community.imageUrl)),
                    Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              boxShadow: const [
                                BoxShadow(
                                    offset: Offset(5, 5),
                                    blurRadius: 10,
                                    spreadRadius: -12)
                              ],
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildCommunityHeader(),
                              const Gap(8),
                              _buildAskWidget(),
                              const Gap(8),
                            ],
                          ),
                        ))
                  ],
                ),
              ),
            ),
            // SliverPadding(
            //     padding: const EdgeInsets.symmetric(vertical: 12),
            //     sliver: ()),

            SliverPadding(
                padding: const EdgeInsets.only(bottom: 12, top: 16),
                sliver: _buildQuestionWidget()),
          ]),
        ),
      ),
    ));
  }

  Widget _buildAskWidget() {
    return Row(
      children: [
        const Gap(16),
        const UserProfileWidget(),
        const Gap(8),
        Expanded(
          child: InkWell(
            onTap: () => widget.community.isMember == true
                ? context.pushNamed(AppRouteName.questionAskingPage,
                    extra: widget.community)
                : null,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onInverseSurface,
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Text(
                "Ask anything?...",
              ),
            ),
          ),
        ),
        const Gap(16),
      ],
    );
  }

  Widget _buildCommunityHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Gap(8),
        Text(
          widget.community.name,
          style: Theme.of(context)
              .textTheme
              .headlineLarge
              ?.copyWith(fontWeight: FontWeight.w500, letterSpacing: 0.8),
        ),
        const Spacer(),
        FilledButton(
            onPressed: () {
              isMember
                  ? null
                  : sl<JoinCommunityBloc>()
                      .add(JoinCommunityEvent(widget.community.id));
              setState(() {
                isMember = !isMember;
              });
            },
            child: Text(isMember ? "Joined" : "Join")),
      ],
    );
  }

  BlocBuilder<GetPostsBloc, GetPostState> _buildQuestionWidget() {
    return BlocBuilder<GetPostsBloc, GetPostState>(builder: (context, state) {
      if (state is GetPostLoading) {
        return const SliverToBoxAdapter(child: AppLoadingIndicator());
      } else if (state is GetPostLoaded && state.posts[postKey] != null) {
        return SliverList.builder(
            itemCount: state.posts[postKey]?.length,
            itemBuilder: (context, index) {
              final post = state.posts[postKey]![index];
              return Column(
                children: [
                  GestureDetector(
                      onTap: () => context.pushNamed(
                          AppRouteName.questionDetail,
                          queryParameters: {'postKey': postKey},
                          pathParameters: {"postId": post.id}),
                      child: PostCard(
                        post: post,
                        postKey: postKey,
                      )),
                ],
              );
            });
      } else {
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      }
    });
  }
}
