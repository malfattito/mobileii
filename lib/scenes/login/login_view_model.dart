import 'package:flutter/foundation.dart';
import 'login_coordinator.dart';
import 'server_login.dart';

/// State and actions of the login scene.
class LoginViewModel extends ChangeNotifier {
  LoginViewModel({required this._serverLogin, required this._coordinator});

  // ignore: unused_field
  final ServerLogin _serverLogin;
  // ignore: unused_field
  final LoginCoordinator _coordinator;

  String _email = '';
  String _password = '';

  String get email => _email;
  String get password => _password;

  void onEmailChanged(String value) {
    _email = value;
    notifyListeners();
  }

  void onPasswordChanged(String value) {
    _password = value;
    notifyListeners();
  }

  /// Intentionally a no-op for now; will call [_serverLogin] and then
  /// [_coordinator] once both are implemented.
  void submit() {}
}
