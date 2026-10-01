import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'login_result.dart';

/// Authentication backend used by the login scene.
abstract interface class ServerLogin {
  Future<LoginResult> fetchLogin({
    required String email,
    required String password,
  });
}

/// Offline [ServerLogin] (mock) for development and previews: no network,
/// accepts only the test account after a short simulated delay.
class DefaultServerLogin implements ServerLogin {
  const DefaultServerLogin({this.delay = const Duration(milliseconds: 600)});

  static const email = 'ana@carteira.dev';
  static const password = '123456';

  final Duration delay;

  @override
  Future<LoginResult> fetchLogin({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(delay);
    if (email.isEmpty || password.isEmpty) {
      return const LoginFailure('Informe e-mail e senha.');
    }
    if (email != DefaultServerLogin.email ||
        password != DefaultServerLogin.password) {
      return const LoginFailure('E-mail ou senha incorretos.');
    }
    return const LoginSuccess(token: 'mock-token', userName: 'Ana Ribeiro');
  }
}

/// Real [ServerLogin], talking to the Carteira API (`POST /auth/login`).
class ServerLoginReal implements ServerLogin {
  ServerLoginReal({
    String? baseUrl,
    http.Client? client,
    this.timeout = const Duration(seconds: 10),
  }) : baseUrl = baseUrl ?? defaultBaseUrl(),
       _client = client ?? http.Client();

  /// The Android emulator reaches the host machine at 10.0.2.2.
  static String defaultBaseUrl() {
    final android = !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
    return android ? 'http://10.0.2.2:8080' : 'http://localhost:8080';
  }

  final String baseUrl;
  final Duration timeout;
  final http.Client _client;

  @override
  Future<LoginResult> fetchLogin({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client
          .post(
            Uri.parse('$baseUrl/auth/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(timeout);
      return _toResult(response);
    } on TimeoutException {
      return const LoginFailure('O servidor demorou demais para responder.');
    } on http.ClientException {
      return const LoginFailure(
        'Sem conexão. Verifique sua internet e tente de novo.',
      );
    } on FormatException {
      return const LoginFailure('Resposta inesperada do servidor.');
    }
  }

  LoginResult _toResult(http.Response response) {
    switch (response.statusCode) {
      case 200:
        final json = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
        final user = json['user'] as Map;
        return LoginSuccess(
          token: json['token'] as String,
          userName: user['name'] as String,
        );
      case 401:
        return const LoginFailure('E-mail ou senha incorretos.');
      case 422:
        return const LoginFailure('Informe e-mail e senha.');
      default:
        return LoginFailure('Erro no servidor (${response.statusCode}).');
    }
  }
}
