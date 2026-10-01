import 'package:flutter/foundation.dart';

import 'login_coordinator.dart';
import 'login_result.dart';
import 'server_login.dart';

/// State and actions of the login scene.
///
/// The scene logs in with whatever [ServerLogin] the factory injected: the
/// mock ([DefaultServerLogin]) or the real API ([ServerLoginReal]).
class LoginViewModel extends ChangeNotifier {
  LoginViewModel({required this._serverLogin, required this._coordinator});

  final ServerLogin _serverLogin;
  // ignore: unused_field
  final LoginCoordinator _coordinator;

  String _email = '';
  String _password = '';
  bool _isLoading = false;
  String? _errorMessage;
  String? _userName;

  String get email => _email;
  String get password => _password;
  bool get isLoading => _isLoading;

  /// Message of the last failed attempt, or null.
  String? get errorMessage => _errorMessage;

  /// Name of the logged-in user, or null while not logged in.
  String? get userName => _userName;

  void onEmailChanged(String value) {
    _email = value;
    notifyListeners();
  }

  void onPasswordChanged(String value) {
    _password = value;
    notifyListeners();
  }

  Future<void> submit() async {
    if (_isLoading) return;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final result = await _serverLogin.fetchLogin(
      email: _email.trim(),
      password: _password,
    );

    _isLoading = false;
    switch (result) {
      case LoginSuccess(:final userName):
        _userName = userName;
      case LoginFailure(:final message):
        _errorMessage = message;
    }
    notifyListeners();
  }
}
