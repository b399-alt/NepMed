import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:hive/hive.dart';
import '../models/user_model.dart';
import '../../../../core/constants/hive_constants.dart';

abstract class AuthLocalDataSource {
  Future<UserModel?> getCachedUser();
  Future<void> cacheUser(UserModel user);
  Future<void> clearCache();
  Future<UserModel?> login(String email, String password);
  Future<UserModel> register(String fullName, String email, String password);
  Future<bool> isLoggedIn();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final Box<UserModel> userBox;
  final Box<bool> authBox;

  AuthLocalDataSourceImpl({
    required this.userBox,
    required this.authBox,
  });

  String _hashPassword(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      return userBox.get(HiveConstants.currentUserKey);
    } catch (e) {
      throw Exception('Failed to get cached user: $e');
    }
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      await userBox.put(HiveConstants.currentUserKey, user);
      await authBox.put(HiveConstants.isLoggedInKey, true);
    } catch (e) {
      throw Exception('Failed to cache user: $e');
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await userBox.delete(HiveConstants.currentUserKey);
      await authBox.put(HiveConstants.isLoggedInKey, false);
    } catch (e) {
      throw Exception('Failed to clear cache: $e');
    }
  }

  @override
  Future<UserModel?> login(String email, String password) async {
    try {
      final passwordHash = _hashPassword(password);

      // Get all users and find matching email
      final users = userBox.values.toList();

      for (var user in users) {
        if (user.email.toLowerCase() == email.toLowerCase() &&
            user.passwordHash == passwordHash) {
          await authBox.put(HiveConstants.isLoggedInKey, true);
          await userBox.put(HiveConstants.currentUserKey, user);
          return user;
        }
      }

      return null;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  @override
  Future<UserModel> register(String fullName, String email, String password) async {
    try {
      // Check if user already exists
      final users = userBox.values.toList();

      for (var user in users) {
        if (user.email.toLowerCase() == email.toLowerCase()) {
          throw Exception('User with this email already exists');
        }
      }

      // Create new user
      final passwordHash = _hashPassword(password);
      final userId = DateTime.now().millisecondsSinceEpoch.toString();

      final newUser = UserModel(
        id: userId,
        fullName: fullName,
        email: email,
        passwordHash: passwordHash,
      );

      // Save user with email as key for easy lookup
      await userBox.put('user_$email', newUser);
      await cacheUser(newUser);

      return newUser;
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    try {
      return authBox.get(HiveConstants.isLoggedInKey, defaultValue: false) ?? false;
    } catch (e) {
      return false;
    }
  }
}
