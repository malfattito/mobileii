import 'package:carteira_design_system/carteira_design_system.dart';
import 'package:carteira_digital/scenes/login/login_coordinator.dart';
import 'package:carteira_digital/scenes/login/login_factory.dart';
import 'package:carteira_digital/scenes/login/login_result.dart';
import 'package:carteira_digital/scenes/login/login_view.dart';
import 'package:carteira_digital/scenes/login/login_view_model.dart';
import 'package:carteira_digital/scenes/login/server_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeServerLogin implements ServerLogin {
  _FakeServerLogin(this.result);

  final LoginResult result;
  int calls = 0;

  @override
  Future<LoginResult> fetchLogin({
    required String email,
    required String password,
  }) async {
    calls++;
    return result;
  }
}

class _FakeLoginCoordinator implements LoginCoordinator {}

Widget _app(Widget home) => MaterialApp(theme: AppTheme.light(), home: home);

LoginView _view(ServerLogin server) => LoginView(
  viewModel: LoginViewModel(
    serverLogin: server,
    coordinator: _FakeLoginCoordinator(),
  ),
);

void main() {
  testWidgets('LoginFactory.make builds the login scene', (tester) async {
    await tester.pumpWidget(_app(LoginFactory.make()));

    expect(find.byType(LoginView), findsOneWidget);
  });

  testWidgets('renders e-mail, password and primary button', (tester) async {
    await tester.pumpWidget(
      _app(_view(_FakeServerLogin(const LoginFailure('x')))),
    );

    expect(find.byType(AppTextField), findsNWidgets(2));
    expect(find.byType(PasswordField), findsOneWidget);

    final button = tester.widget<AppButton>(
      find.byKey(const Key('login_submit')),
    );
    expect(button.variant, AppButtonVariant.primary);
  });

  testWidgets('submits with the injected server and shows the welcome', (
    tester,
  ) async {
    final server = _FakeServerLogin(
      const LoginSuccess(token: 't', userName: 'Ana Ribeiro'),
    );
    await tester.pumpWidget(_app(_view(server)));

    await tester.enterText(find.byKey(const Key('login_email')), 'a@b.com');
    await tester.tap(find.byKey(const Key('login_submit')));
    await tester.pump();

    expect(server.calls, 1);
    expect(find.text('Bem-vindo, Ana Ribeiro!'), findsOneWidget);
  });

  testWidgets('shows the failure message', (tester) async {
    final server = _FakeServerLogin(
      const LoginFailure('E-mail ou senha incorretos.'),
    );
    await tester.pumpWidget(_app(_view(server)));

    await tester.tap(find.byKey(const Key('login_submit')));
    await tester.pump();

    expect(find.text('E-mail ou senha incorretos.'), findsOneWidget);
    expect(find.byKey(const Key('login_welcome')), findsNothing);
  });
}
