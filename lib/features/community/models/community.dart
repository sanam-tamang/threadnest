// ignore_for_file: public_member_api_docs, sort_constructors_first
class Community {
  final String name;
  final String? description;
  final String? imageUrl;
  final String id;
  final bool? isMember;
  final String ownerId;

  Community({
    required this.name,
    this.description,
    this.imageUrl,
    required this.id,
    required this.isMember,
    required this.ownerId,
  });

  factory Community.fromMap(Map<String, dynamic> map) {
    return Community(
        name: map['name'],
        description: map['description'],
        imageUrl: map['image_url'],
        id: map['id'],
        ownerId: map['owner_id'],
        isMember: map['is_member']);
  }

  Community copyWith({
    String? name,
    String? description,
    String? imageUrl,
    String? id,
    bool? isMember,
    String? ownerId,
  }) {
    return Community(
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      id: id ?? this.id,
      isMember: isMember ?? this.isMember,
      ownerId: ownerId ?? this.ownerId,
    );
  }
}
