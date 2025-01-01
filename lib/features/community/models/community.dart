class Community {
  final String name;
  final String? description;
  final String? imageUrl;
  final String id;
  final bool? isUserJoined;

  Community({
    required this.name,
    this.description,
    this.imageUrl,
    required this.id,
    required this.isUserJoined,
  });

  factory Community.fromMap(Map<String, dynamic> map) {
    return Community(
      name: map['name'],
      description: map['description'],
      imageUrl: map['imageUrl'],
      id: map['id'],
      isUserJoined: map['user_communities'] == null
          ? null
          : map['user_communities'].isNotEmpty
              ? true
              : false,
    );
  }
}
