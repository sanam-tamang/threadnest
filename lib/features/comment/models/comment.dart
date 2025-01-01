
import 'package:json_annotation/json_annotation.dart';
import 'package:threadnest/features/profile/models/user.dart';

 
part 'comment.g.dart';

@JsonSerializable()
class Comment {
    final  String id;
    final  String content;
    final  User author;
    final  int likes;



  factory Comment.fromJson(Map<String,dynamic> json) => _$CommentFromJson(json);


  Comment({
    required this.id,
    required this.content,
    required this.author,
    required this.likes,
  });
  

}
