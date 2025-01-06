// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:threadnest/common/widgets/make_ink_widget.dart';
import 'package:threadnest/core/theme/colors.dart';

class VoteButton extends StatelessWidget {
  const VoteButton({
    super.key,
    required this.onTap,
    required this.isUpVote,
    required this.voteStatus,
  });
  final VoidCallback onTap;
  final bool isUpVote;
  final String? voteStatus;

  @override
  Widget build(BuildContext context) {
    Color? upvoteBtnColor;
    Color? downvoteBtnColor;

    upvoteBtnColor = voteStatus == "up"
        ? ColorsManager.postCardVotedButtonColor
        : ColorsManager.postCardActionButtonColor;
    downvoteBtnColor = voteStatus == "down"
        ? ColorsManager.postCardVotedButtonColor
        : ColorsManager.postCardActionButtonColor;

    return MakeInkButton(
        onTap: onTap,
        child: isUpVote
            ? Icon(
                Icons.arrow_upward,
                color: upvoteBtnColor,
              )
            : Icon(
                Icons.arrow_downward,
                color: downvoteBtnColor,
              ));
  }
}
