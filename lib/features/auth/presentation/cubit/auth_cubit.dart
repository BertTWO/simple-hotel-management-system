// lib/features/auth/presentation/cubit/auth_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:jordanhotel/core/util/hasher.dart';
import 'package:jordanhotel/features/auth/data/repository/user_repo.dart';
import 'package:jordanhotel/features/auth/domain/entity/user.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final UserRepository _userRepository;
  User? _currentUser;

  AuthCubit(this._userRepository) : super(AuthInitial()) {
    _createDefaultAdmin();
  }

  User? get currentUser => _currentUser;

  Future<void> login(String username, String password) async {
    emit(AuthLoading());

    try {
      final hashed = hashPassword(password);

      final user = await _userRepository.login(username, hashed);

      if (user != null) {
        _currentUser = user;
        emit(AuthSuccess(user));
      } else {
        emit(const AuthError('Invalid username or password'));
      }
    } catch (e) {
      emit(AuthError('Login failed: $e'));
    }
  }

  Future<void> register({
    required String username,
    required String password,
    String? fullName,
    String? email,
  }) async {
    emit(AuthLoading());

    try {
      // Check if username already exists
      final existingUser = await _userRepository.getUserByUsername(username);
      if (existingUser != null) {
        emit(const AuthError('Username already exists'));
        return;
      }

      final hashedPassword = hashPassword(password);

      final newUser = User(
        username: username,
        password: hashedPassword, // store hash
        fullName: fullName,
        email: email,
        createdAt: DateTime.now().toIso8601String(),
      );

      await _userRepository.addUser(newUser);
      emit(const AuthRegistrationSuccess('User registered successfully'));
    } catch (e) {
      emit(AuthError('Registration failed: $e'));
    }
  }

  void logout() {
    _currentUser = null;
    emit(AuthInitial());
  }

  Future<void> _createDefaultAdmin() async {
    final existingAdmin = await _userRepository.getUserByUsername("jordan123");

    if (existingAdmin == null) {
      await register(
        username: "jordan123",
        password: "jordanpangit123",
        fullName: "Administrator",
        email: "jordanpangit123@gmail.com",
      );
    }
  }
}
