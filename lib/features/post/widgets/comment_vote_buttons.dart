import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:threadnest/common/widgets/vote_button.dart';
import 'package:threadnest/core/theme/colors.dart';
import 'package:threadnest/dependency_injection.dart';
import 'package:threadnest/features/comment/blocs/vote_comment_bloc/vote_comment_bloc.dart';
import 'package:threadnest/features/comment/models/comment.dart';

class CommentVoteButtons extends StatefulWidget {
  const CommentVoteButtons({
    super.key,
    required this.comment,
  });

  final GetComment comment;

  @override
  State<CommentVoteButtons> createState() => _CommentVoteButtonsState();
}

class _CommentVoteButtonsState extends State<CommentVoteButtons> {
  late String? currentVoteStatus;
  late int overallVotes;
  @override
  void initState() {
    currentVoteStatus = widget.comment.voteStatus;
    overallVotes = widget.comment.upvotes - widget.comment.downvotes;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          VoteButton(
              onTap: _onUpvote, isUpVote: true, voteStatus: currentVoteStatus),
          const Gap(6),
          Text(
            overallVotes.toString(),
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: ColorsManager.gray),
          ),
          const Gap(6),
          VoteButton(
              onTap: _onDownVote,
              isUpVote: false,
              voteStatus: currentVoteStatus),
        ],
      ),
    );
  }

  void _onDownVote() {
    if (currentVoteStatus == null) {
      sl<VoteCommentBloc>()
          .add(VoteDownCommentEvent(commentId: widget.comment.id));
      setState(() {
        currentVoteStatus = "down";
        overallVotes--;
      });
    }
  }

  void _onUpvote() {
    if (currentVoteStatus == null) {
      sl<VoteCommentBloc>()
          .add(VoteUpCommentEvent(commentId: widget.comment.id));
      setState(() {
        currentVoteStatus = "up";
        overallVotes++;
      });
    }
  }
}
