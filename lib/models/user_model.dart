class UserModel {
  final String id;

  final String name;

  final String email;

  final String photoUrl;

  final String role;

  final List<String>
  dietaryPreferences;

  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.role,
    required this.dietaryPreferences,
    required this.createdAt,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? photoUrl,
    String? role,
    List<String>?
    dietaryPreferences,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl:
      photoUrl ?? this.photoUrl,
      role: role ?? this.role,
      dietaryPreferences:
      dietaryPreferences ??
          this
              .dietaryPreferences,
      createdAt:
      createdAt ??
          this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'role': role,
      'dietaryPreferences':
      dietaryPreferences,
      'createdAt':
      createdAt
          .toIso8601String(),
    };
  }

  factory UserModel.fromMap(
      Map<String, dynamic> map,
      ) {
    DateTime parseDate(
        dynamic value,
        ) {
      if (value == null) {
        return DateTime.now();
      }

      if (value is DateTime) {
        return value;
      }

      try {
        return DateTime.parse(
          value.toString(),
        );
      } catch (_) {
        return DateTime.now();
      }
    }

    return UserModel(
      id:
      map['id']?.toString() ??
          '',

      name:
      map['name']
          ?.toString() ??
          '',

      email:
      map['email']
          ?.toString() ??
          '',

      photoUrl:
      map['photoUrl']
          ?.toString() ??
          '',

      role:
      map['role']
          ?.toString() ??
          'user',

      dietaryPreferences:
      map['dietaryPreferences']
      is List
          ? List<String>.from(
        map['dietaryPreferences'],
      )
          : [],

      createdAt: parseDate(
        map['createdAt'],
      ),
    );
  }
}