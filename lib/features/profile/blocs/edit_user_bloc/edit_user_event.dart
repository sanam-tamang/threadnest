

part of 'edit_user_bloc.dart';

class EditUserEvent extends Equatable {
  const EditUserEvent(
   { this.name,
    this.bio,
    this.imageFile,}
  );
  final String? name;
  final String? bio;
  final File? imageFile;

  @override
  List<Object?> get props => [name, bio, imageFile];
}
