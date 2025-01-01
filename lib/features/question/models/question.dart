// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:equatable/equatable.dart';

import 'package:threadnest/features/profile/models/user.dart';

class GetQuestion extends Equatable {
  final String id;
  final String title;
  final String? content;
  final String? imageUrl;
  final String? documentUrl;
  final User author;
  final int upvotes;
  final int downvotes;
  final String? voteStatus;
  final QuestionCommunity community;

  const GetQuestion({
    required this.id,
    required this.title,
    required this.content,
    this.imageUrl,
    this.documentUrl,
    required this.author,
    required this.upvotes,
    required this.downvotes,
    this.voteStatus,
    required this.community,
  });

  int get overalPostVote => upvotes - downvotes;

  factory GetQuestion.fromMap(Map<String, dynamic> map) {
    return GetQuestion(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      imageUrl: map['image_url'],
      documentUrl: map['document_url'],
      author: User.fromMap(map['author']),
      upvotes: map['total_upvotes'],
      downvotes: map['total_downvotes'],
      voteStatus: map['user_vote_status'],
      community: QuestionCommunity.fromMap(map['community']),
    );
  }

  GetQuestion copyWith({
    String? id,
    String? title,
    String? content,
    String? imageUrl,
    String? documentUrl,
    User? author,
    int? upvotes,
    int? downvotes,

    ///"up" or "down" pr NULL
    String? voteStatus,
    QuestionCommunity? community,
  }) {
    return GetQuestion(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      imageUrl: imageUrl ?? this.imageUrl,
      documentUrl: documentUrl ?? this.documentUrl,
      author: author ?? this.author,
      upvotes: upvotes ?? this.upvotes,
      downvotes: downvotes ?? this.downvotes,
      voteStatus: voteStatus ?? this.voteStatus,
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
      voteStatus,
      community,
    ];
  }
}

class PostQuestion {
  final String title;
  final String? content;
  final File? imageFile;
  final File? documentFile;
  final String communityId;

  PostQuestion(
      {required this.title,
      this.content,
      this.imageFile,
      this.documentFile,
      required this.communityId});
}

class QuestionCommunity extends Equatable {
  final String id;
  final String name;

  const QuestionCommunity({
    required this.id,
    required this.name,
  });

  factory QuestionCommunity.fromMap(Map<String, dynamic> map) {
    return QuestionCommunity(
      id: map['id'],
      name: map['name'],
    );
  }

  @override
  List<Object> get props => [id, name];
}
