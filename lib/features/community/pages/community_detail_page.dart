// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:threadnest/common/widgets/app_cached_network_image.dart';
import 'package:threadnest/common/widgets/app_loading_indicator.dart';
import 'package:threadnest/dependency_injection.dart';
import 'package:threadnest/features/community/blocs/join_community_bloc/join_community_bloc.dart';
import 'package:threadnest/features/community/models/community.dart';
import 'package:threadnest/features/profile/widgets/user_profile.dart';
import 'package:threadnest/features/question/blocs/get_question_bloc/get_question_bloc.dart';
import 'package:threadnest/features/question/widgets/question_card.dart';
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
  late String questionKey;
  late GetQuestionBloc _bloc;
  late ScrollController _scrollController;
  bool _isScrolledTomoreThen200h = false;
  @override
  void initState() {
    questionKey = widget.community.id;
    _bloc = sl<GetQuestionBloc>();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.offset > 200 && !_isScrolledTomoreThen200h) {
          setState(() {
            _isScrolledTomoreThen200h = true;
          });
        } else if (_scrollController.offset <= 200 &&
            _isScrolledTomoreThen200h) {
          setState(() {
            _isScrolledTomoreThen200h = false;
          });
        }
      });

    if (_bloc.state is GetQuestionLoaded) {
      bool isKeyContains = _bloc.localQuestions.containsKey(questionKey);
      isKeyContains
          ? null
          : _bloc.add(GetQuestionsByCommunityEvent(communityId: questionKey));
    }

    super.initState();
  }

  Future<void> _onRefresh() async {
    _bloc.add(GetQuestionsByCommunityEvent(communityId: questionKey));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator.adaptive(
      onRefresh: _onRefresh,
      child: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          _buildAppBar(),
        ],
        body: CustomScrollView(slivers: [
          SliverToBoxAdapter(child: _buildAskWidget(context)),
          _buildQuestionWidget(),
        ]),
      ),
    ));
  }

  Row _buildAskWidget(BuildContext context) {
    return Row(
      children: [
        const Gap(16),
        const UserProfileWidget(),
        const Gap(8),
        Expanded(
          child: InkWell(
            onTap: () => context.pushNamed(AppRouteName.questionAskingPage,
                extra: widget.community),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceDim,
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

  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 250,
      snap: true,
      floating: true,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: _isScrolledTomoreThen200h,
        titlePadding: _isScrolledTomoreThen200h
            ? const EdgeInsets.symmetric(horizontal: 16).copyWith(left: 24)
            : EdgeInsets.zero,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                  height: 40,
                  child: AppCachedNetworkImage(
                    imageUrl: widget.community.imageUrl,
                    isCircular: true,
                  )),
              const Gap(8),
              Text(
                widget.community.name,
              ),
              const Spacer(),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                reverseDuration: const Duration(milliseconds: 200),
                child: _isScrolledTomoreThen200h
                    ? const SizedBox.shrink()
                    : Transform.scale(
                        scale: 0.7,
                        child: FilledButton(
                            onPressed: () => widget.community.isUserJoined!
                                ? null
                                : sl<JoinCommunityBloc>().add(
                                    JoinCommunityEvent(widget.community.id)),
                            child: Text(widget.community.isUserJoined == null
                                ? 'Join'
                                : widget.community.isUserJoined!
                                    ? "joined"
                                    : "join")),
                      ),
              ),
            ],
          ),
        ),
        background: const AppCachedNetworkImage(
          imageUrl:
              "https://imgs.search.brave.com/umDbO7Ww3JAEHTRKsH6dTnS9rBWXXiSp91xzB6q1iYs/rs:fit:500:0:0:0/g:ce/aHR0cHM6Ly93d3cu/Y29yZWxkcmF3LmNv/bS9zdGF0aWMvY2Rn/cy9pbWFnZXMvbGVh/cm4vZ3VpZGUtdG8t/dmVjdG9yLWRlc2ln/bi9ob3ctZG8tdmVj/dG9yLWdyYXBoaWNz/LXdvcmsvaW1nLTAz/LnBuZw",
          prefix: "",
        ),
      ),
    );
  }

  BlocBuilder<GetQuestionBloc, GetQuestionState> _buildQuestionWidget() {
    return BlocBuilder<GetQuestionBloc, GetQuestionState>(
        builder: (context, state) {
      if (state is GetQuestionLoading) {
        return const SliverToBoxAdapter(child: AppLoadingIndicator());
      } else if (state is GetQuestionLoaded &&
          state.questions[questionKey] != null) {
        return SliverList.builder(
            itemCount: state.questions[questionKey]?.length,
            itemBuilder: (context, index) {
              final question = state.questions[questionKey]![index];
              return Column(
                children: [
                  GestureDetector(
                      onTap: () => context.pushNamed(
                          AppRouteName.questionDetail,
                          pathParameters: {"questionId": question.id}),
                      child: QuestionCard(
                        question: question,
                        questionKey: questionKey,
                      )),
                  GestureDetector(
                      onTap: () => context.pushNamed(
                          AppRouteName.questionDetail,
                          pathParameters: {"questionId": question.id}),
                      child: QuestionCard(
                        question: question,
                        questionKey: questionKey,
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
