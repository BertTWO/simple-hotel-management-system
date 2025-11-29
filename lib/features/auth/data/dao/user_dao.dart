// lib/features/auth/data/dao/user_dao.dart
import 'package:floor/floor.dart';
import 'package:jordanhotel/features/auth/domain/entity/user.dart';

@dao
abstract class UserDao {
  @Query(
    'SELECT * FROM users WHERE username = :username AND password = :password',
  )
  Future<User?> login(String username, String password);

  @Query('SELECT * FROM users WHERE username = :username')
  Future<User?> getUserByUsername(String username);

  @Query('SELECT * FROM users')
  Future<List<User>> getAllUsers();

  @Query('SELECT * FROM users WHERE role = :role')
  Future<List<User>> getUsersByRole(String role);

  @insert
  Future<void> insertUser(User user);

  @update
  Future<void> updateUser(User user);

  @delete
  Future<void> deleteUser(User user);

  @Query('DELETE FROM users WHERE id = :id')
  Future<void> deleteUserById(int id);
}
