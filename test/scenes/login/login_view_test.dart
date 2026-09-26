import 'package:carteira_design_system/carteira_design_system.dart';
import 'package:carteira_digital/scenes/login/login_coordinator.dart';
import 'package:carteira_digital/scenes/login/login_factory.dart';
import 'package:carteira_digital/scenes/login/login_view.dart';
import 'package:carteira_digital/scenes/login/login_view_model.dart';
import 'package:carteira_digital/scenes/login/server_login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeServerLogin implements ServerLogin {
  int calls = 0;

  @override
  Future<void> fetchLogin({
    required String email,
    required String password,
  }) async {
    calls++;
  }
}

class _FakeLoginCoordinator implements LoginCoordinator {}

Widget _app(Widget home) => MaterialApp(theme: AppTheme.light(), home: home);

void main() {
  testWidgets('LoginFactory.make builds the login scene', (tester) async {
    await tester.pumpWidget(_app(LoginFactory.make()));

    expect(find.byType(LoginView), findsOneWidget);
  });

  testWidgets('renders e-mail, password and primary button', (tester) async {
    final server = _FakeServerLogin();
    final viewModel = LoginViewModel(
      serverLogin: server,
      coordinator: _FakeLoginCoordinator(),
    );
    await tester.pumpWidget(_app(LoginView(viewModel: viewModel)));

    expect(find.byType(AppTextField), findsNWidgets(2));
    expect(find.byType(PasswordField), findsOneWidget);

    final button = tester.widget<AppButton>(
      find.byKey(const Key('login_submit')),
    );
    expect(button.variant, AppButtonVariant.primary);

    await tester.enterText(find.byKey(const Key('login_email')), 'a@b.com');
    await tester.tap(find.byKey(const Key('login_submit')));
    await tester.pump();

    expect(viewModel.email, 'a@b.com');
    expect(server.calls, 0);
  });
}
