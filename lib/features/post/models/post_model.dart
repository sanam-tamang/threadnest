import 'dart:io';

import 'package:equatable/equatable.dart';

import 'package:threadnest/features/comment/models/comment.dart';
import 'package:threadnest/features/community/models/community.dart';
import 'package:threadnest/features/profile/models/user.dart';

///GetPosts
class GetPost extends Equatable {
  final String id;
  final String title;
  final String? content;
  final String? imageUrl;
  final String? documentUrl;
  final User author;
  final int upvotes;
  final int downvotes;
  final int totalComments;
  final int totalShares;
  final String? voteStatus;
  final List<GetComment>? comments;
  final Community community;

  const GetPost({
    required this.id,
    required this.title,
    required this.content,
    this.imageUrl,
    this.documentUrl,
    required this.author,
    required this.upvotes,
    required this.downvotes,
    required this.totalComments,
    required this.totalShares,
    this.voteStatus,
    required this.comments,
    required this.community,
  });

  String get overalPostVote =>
      upvotes - downvotes == 0 ? "vote" : (upvotes - downvotes).toString();

  factory GetPost.fromMap(Map<String, dynamic> map) {
    return GetPost(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      imageUrl: map['image_url'],
      documentUrl: map['document_url'],
      author: User.fromMap(map['author']),
      upvotes: map['total_upvotes'],
      downvotes: map['total_downvotes'],
      voteStatus: map['user_vote_status'],
      community: Community.fromMap(map['community']),
      totalComments: map['total_comments'] ?? 0,
      totalShares: map['total_share_count'] ?? 0,
      comments: map['comments'] == null
          ? null
          : List.from(map['comments'])
              .map((e) => GetComment.fromMap(e))
              .toList(),
    );
  }

  GetPost copyWith({
    String? id,
    String? title,
    String? content,
    String? imageUrl,
    String? documentUrl,
    User? author,
    int? upvotes,
    int? downvotes,
    int? totalComments,
    int? totalShares,
    String? voteStatus,
    List<GetComment>? comments,
    Community? community,
  }) {
    return GetPost(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      documentUrl: documentUrl ?? this.documentUrl,
      author: author ?? this.author,
      upvotes: upvotes ?? this.upvotes,
      downvotes: downvotes ?? this.downvotes,
      totalComments: totalComments ?? this.totalComments,
      totalShares: totalShares ?? this.totalShares,
      voteStatus: voteStatus ?? this.voteStatus,
      comments: comments ?? this.comments,
      community: community ?? this.community,
    );
  }

  @override
  List<Object?> get props {
    return [
      id,
      title,
      content,
      imageUrl,
      documentUrl,
      author,
      upvotes,
      downvotes,
      totalComments,
      totalShares,
      voteStatus,
      comments,
      community,
    ];
  }
}

class PostFeed {
  final String title;
  final String? content;
  final File? imageFile;
  final File? documentFile;
  final String communityId;

  PostFeed(
      {required this.title,
      this.content,
      this.imageFile,
      this.documentFile,
      required this.communityId});
}
