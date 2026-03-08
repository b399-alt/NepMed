import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, UserEntity>> login(
    String email,
    String password,
  ) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        return const Left(ValidationFailure('Email and password are required'));
      }

      if (!_isValidEmail(email)) {
        return const Left(ValidationFailure('Invalid email format'));
      }

      final user = await localDataSource.login(email, password);

      if (user == null) {
        return const Left(AuthFailure('Invalid email or password'));
      }

      return Right(user.toEntity());
    } catch (e) {
      return Left(CacheFailure('Login failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register(
    String fullName,
    String email,
    String password,
  ) async {
    try {
      if (fullName.isEmpty || email.isEmpty || password.isEmpty) {
        return const Left(ValidationFailure('All fields are required'));
      }

      if (!_isValidEmail(email)) {
        return const Left(ValidationFailure('Invalid email format'));
      }

      if (password.length < 6) {
        return const Left(
          ValidationFailure('Password must be at least 6 characters'),
        );
      }

      final user = await localDataSource.register(fullName, email, password);

      return Right(user.toEntity());
    } on Exception catch (e) {
      if (e.toString().contains('already exists')) {
        return const Left(AuthFailure('User with this email already exists'));
      }
      return Left(CacheFailure('Registration failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearCache();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Logout failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final user = await localDataSource.getCachedUser();
      return Right(user?.toEntity());
    } catch (e) {
      return Left(CacheFailure('Failed to get current user: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    try {
      final loggedIn = await localDataSource.isLoggedIn();
      return Right(loggedIn);
    } catch (e) {
      return const Right(false);
    }
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }
}
