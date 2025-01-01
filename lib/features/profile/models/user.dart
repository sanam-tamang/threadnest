// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User extends Equatable {
  final String id;
  final String name;
  final String? email;
  final String? imageUrl;
  final String? bio;

  const User(
      {required this.id,
      required this.name,
      this.email,
      this.imageUrl,
      this.bio});

  factory User.fromMap(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);

  @override
  List<Object?> get props {
    return [
      id,
      name,
      email,
      imageUrl,
      bio,
    ];
  }
}
