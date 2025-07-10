class User {
  final int id;
  final String name;
  final String email;
  final String? photoUrl;
  final String? thumbnailUrl;
  final DateTime createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    this.thumbnailUrl,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  static User? fromJson(user) {
    if (user is Map<String, dynamic>) {
      return User(
        id: user['id'],
        name: user['name'] as String,
        email: user['email'] as String,
        thumbnailUrl: user['thumbnailUrl'] as String?,
      );
    }
    return null;
  }
}
