// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:threadnest/common/widgets/app_cached_network_image.dart';
import 'package:threadnest/core/theme/colors.dart';
import 'package:threadnest/dependency_injection.dart';
import 'package:threadnest/features/question/blocs/question_vote_bloc/question_vote_bloc.dart';
import 'package:threadnest/features/question/models/question.dart';

class QuestionCard extends StatelessWidget {
  final GetQuestion question;

  ///question key tend to tell from where question is accessed whether from feed or communtinity
  final String questionKey;

  const QuestionCard({
    super.key,
    required this.question,
    required this.questionKey,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildVotingColumn(),
            const SizedBox(width: 16),
            Expanded(child: _buildMainContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildVotingColumn() {
    Color? upvoteBtnColor;
    Color? downvoteBtnColor;
    if (question.voteStatus != null) {
      upvoteBtnColor =
          question.voteStatus == "up" ? ColorsManager.mainBlue : Colors.grey;
      downvoteBtnColor =
          question.voteStatus == "down" ? ColorsManager.mainBlue : Colors.grey;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_upward),
            onPressed: () => sl<QuestionVoteBloc>().add(QuestionVoteUpEvent(
                question: question, questionKey: questionKey)),
            color: upvoteBtnColor,
          ),
          Text(
            '${question.overalPostVote}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_downward),
            onPressed: () => sl<QuestionVoteBloc>().add(QuestionVoteDownEvent(
                question: question, questionKey: questionKey)),
            color: downvoteBtnColor,
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
        Text(
          question.title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        if (question.content != null) ...[
          const SizedBox(height: 8),
          Text(question.content!),
        ],
        if (question.imageUrl != null) ...[
          AppCachedNetworkImage(imageUrl: question.imageUrl)
        ],
        if (question.documentUrl != null) ...[
          TextButton(
            onPressed: () {},
            child: const Text('Attached Document'),
          ),
        ],
        _buildFooter(),
      ],
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildAuthorInfo(),
        _buildCommentInfo(),
        // Text(question.communityId),
      ],
    );
  }

  Widget _buildAuthorInfo() {
    return Row(
      children: [
        const Icon(Icons.person, size: 16),
        const SizedBox(width: 4),
        Text(question.author.name),
      ],
    );
  }

  Widget _buildCommentInfo() {
    return const Row(
      children: [
        Icon(Icons.comment, size: 16),
        SizedBox(width: 4),
      ],
    );
  }
}
