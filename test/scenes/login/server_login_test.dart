import 'dart:convert';

import 'package:carteira_digital/scenes/login/login_result.dart';
import 'package:carteira_digital/scenes/login/server_login.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  group('DefaultServerLogin (mock)', () {
    const server = DefaultServerLogin(delay: Duration.zero);

    test('accepts the test account', () async {
      final result = await server.fetchLogin(
        email: 'ana@carteira.dev',
        password: '123456',
      );
      expect(result, isA<LoginSuccess>());
      expect((result as LoginSuccess).userName, 'Ana Ribeiro');
    });

    test('rejects a wrong password', () async {
      final result = await server.fetchLogin(
        email: 'ana@carteira.dev',
        password: 'errada',
      );
      expect((result as LoginFailure).message, 'E-mail ou senha incorretos.');
    });

    test('asks for both fields when one is empty', () async {
      final result = await server.fetchLogin(email: '', password: '123456');
      expect((result as LoginFailure).message, 'Informe e-mail e senha.');
    });
  });

  group('ServerLoginReal', () {
    late http.Request sent;

    ServerLoginReal serverAnswering(int status, Object body) => ServerLoginReal(
      baseUrl: 'http://localhost:8080',
      client: MockClient((request) async {
        sent = request;
        return http.Response(jsonEncode(body), status);
      }),
    );

    test('posts the credentials and reads token and name', () async {
      final server = serverAnswering(200, {
        'token': 'tok_1',
        'user': {'name': 'Ana Ribeiro'},
      });

      final result = await server.fetchLogin(
        email: 'ana@carteira.dev',
        password: '123456',
      );

      expect(sent.method, 'POST');
      expect(sent.url.toString(), 'http://localhost:8080/auth/login');
      expect(jsonDecode(sent.body), {
        'email': 'ana@carteira.dev',
        'password': '123456',
      });
      expect((result as LoginSuccess).token, 'tok_1');
      expect(result.userName, 'Ana Ribeiro');
    });

    test('maps 401 to wrong credentials', () async {
      final result = await serverAnswering(
        401,
        {},
      ).fetchLogin(email: 'a', password: 'b');
      expect((result as LoginFailure).message, 'E-mail ou senha incorretos.');
    });

    test('maps 500 to a server error', () async {
      final result = await serverAnswering(
        500,
        {},
      ).fetchLogin(email: 'a', password: 'b');
      expect((result as LoginFailure).message, 'Erro no servidor (500).');
    });

    test('maps a connection failure to no connection', () async {
      final server = ServerLoginReal(
        baseUrl: 'http://localhost:8080',
        client: MockClient((_) async => throw http.ClientException('refused')),
      );
      final result = await server.fetchLogin(email: 'a', password: 'b');
      expect(
        (result as LoginFailure).message,
        'Sem conexão. Verifique sua internet e tente de novo.',
      );
    });
  });
}
