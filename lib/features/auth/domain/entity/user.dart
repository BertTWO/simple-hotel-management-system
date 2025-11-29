// lib/features/auth/data/models/user.dart
import 'package:floor/floor.dart';

@Entity(tableName: 'users')
class User {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String username;
  final String password;
  final String? fullName;
  final String? email;

  @ColumnInfo(name: 'created_at')
  final String createdAt;

  User({
    this.id,
    required this.username,
    required this.password,
    this.fullName,
    this.email,
    required this.createdAt,
  });

  User copyWith({
    int? id,
    String? username,
    String? password,
    String? role,
    String? fullName,
    String? email,
    String? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
