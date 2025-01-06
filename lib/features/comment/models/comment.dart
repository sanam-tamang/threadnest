import 'package:equatable/equatable.dart';

import 'package:threadnest/features/profile/models/user.dart';

class GetComment extends Equatable {
  final String id;
  final String content;
  final User author;
  final int upvotes;
  final int downvotes;
  final String? voteStatus;

  String get overallVoteCount => (upvotes - downvotes).toString();
  const GetComment({
    required this.id,
    required this.content,
    required this.author,
    required this.upvotes,
    required this.downvotes,
    this.voteStatus,
  });

  @override
  List<Object?> get props {
    return [
      id,
      content,
      author,
      upvotes,
      downvotes,
      voteStatus,
    ];
  }

  GetComment copyWith({
    String? id,
    String? content,
    User? author,
    int? upvotes,
    int? downvotes,
    String? voteStatus,
  }) {
    return GetComment(
      id: id ?? this.id,
      content: content ?? this.content,
      author: author ?? this.author,
      upvotes: upvotes ?? this.upvotes,
      downvotes: downvotes ?? this.downvotes,
      voteStatus: voteStatus ?? this.voteStatus,
    );
  }

  factory GetComment.fromMap(Map<String, dynamic> map) {
    return GetComment(
      id: map['id'],
      content: map['content'],
      author: User.fromMap(map['comment_author']),
      upvotes: map['total_upvotes'],
      downvotes: map['total_downvotes'],
      voteStatus: map['user_vote_status'],
    );
  }
}
