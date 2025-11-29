// lib/features/auth/data/repositories/user_repository.dart
import 'package:jordanhotel/features/auth/domain/entity/user.dart';

import '../dao/user_dao.dart';

class UserRepository {
  final UserDao _userDao;

  UserRepository(this._userDao);

  Future<User?> login(String username, String password) async {
    return await _userDao.login(username, password);
  }

  Future<User?> getUserByUsername(String username) async {
    return await _userDao.getUserByUsername(username);
  }

  Future<List<User>> getAllUsers() async {
    return await _userDao.getAllUsers();
  }

  Future<List<User>> getUsersByRole(String role) async {
    return await _userDao.getUsersByRole(role);
  }

  Future<void> addUser(User user) async {
    await _userDao.insertUser(user);
  }

  Future<void> updateUser(User user) async {
    await _userDao.updateUser(user);
  }

  Future<void> deleteUser(User user) async {
    await _userDao.deleteUser(user);
  }

  Future<void> deleteUserById(int id) async {
    await _userDao.deleteUserById(id);
  }
}
