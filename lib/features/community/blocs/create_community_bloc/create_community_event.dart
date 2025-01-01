// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'create_community_bloc.dart';

class CreateCommunityEvent extends Equatable {
  final String name;
  final String description;
  final File? imageFile;
  const CreateCommunityEvent({
    required this.name,
    required this.description,
    this.imageFile,
  });

  @override
  List<Object?> get props => [name, description, imageFile];
}
