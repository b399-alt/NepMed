import 'package:flutter/foundation.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/check_auth_status_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthProvider extends ChangeNotifier {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final LogoutUseCase logoutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final CheckAuthStatusUseCase checkAuthStatusUseCase;

  AuthProvider({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.logoutUseCase,
    required this.getCurrentUserUseCase,
    required this.checkAuthStatusUseCase,
  });

  AuthStatus _status = AuthStatus.initial;
  UserEntity? _currentUser;
  String? _errorMessage;

  AuthStatus get status => _status;
  UserEntity? get currentUser => _currentUser;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isLoading => _status == AuthStatus.loading;

  void _setStatus(AuthStatus status) {
    _status = status;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    _status = AuthStatus.error;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> checkAuthStatus() async {
    _setStatus(AuthStatus.loading);

    final result = await checkAuthStatusUseCase(NoParams());

    result.fold(
      (failure) {
        _setStatus(AuthStatus.unauthenticated);
      },
      (isLoggedIn) async {
        if (isLoggedIn) {
          await loadCurrentUser();
        } else {
          _setStatus(AuthStatus.unauthenticated);
        }
      },
    );
  }

  Future<void> loadCurrentUser() async {
    final result = await getCurrentUserUseCase(NoParams());

    result.fold(
      (failure) {
        _setStatus(AuthStatus.unauthenticated);
      },
      (user) {
        _currentUser = user;
        _setStatus(
          user != null ? AuthStatus.authenticated : AuthStatus.unauthenticated,
        );
      },
    );
  }

  Future<bool> login(String email, String password) async {
    _setStatus(AuthStatus.loading);
    clearError();

    final result = await loginUseCase(
      LoginParams(email: email, password: password),
    );

    return result.fold(
      (failure) {
        _setError(failure.message);
        return false;
      },
      (user) {
        _currentUser = user;
        _setStatus(AuthStatus.authenticated);
        return true;
      },
    );
  }

  Future<bool> register(String fullName, String email, String password) async {
    _setStatus(AuthStatus.loading);
    clearError();

    final result = await registerUseCase(
      RegisterParams(fullName: fullName, email: email, password: password),
    );

    return result.fold(
      (failure) {
        _setError(failure.message);
        return false;
      },
      (user) {
        _currentUser = user;
        _setStatus(AuthStatus.authenticated);
        return true;
      },
    );
  }

  Future<void> logout() async {
    _setStatus(AuthStatus.loading);

    final result = await logoutUseCase(NoParams());

    result.fold(
      (failure) {
        _setError(failure.message);
      },
      (_) {
        _currentUser = null;
        _setStatus(AuthStatus.unauthenticated);
      },
    );
  }
}
