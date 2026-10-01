import 'package:carteira_digital/main.dart';
import 'package:carteira_digital/scenes/login/login_factory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('a rebuild (hot reload) keeps what was typed in the scene', (
    tester,
  ) async {
    await tester.pumpWidget(CarteiraApp(home: LoginFactory.make()));
    await tester.enterText(
      find.byKey(const Key('login_email')),
      'ana@carteira.dev',
    );
    await tester.enterText(
      find.byKey(const Key('login_password')).last,
      '123456',
    );
    await tester.pump();

    // A hot reload rebuilds every widget and keeps the State objects.
    tester.binding.buildOwner!.reassemble(tester.binding.rootElement!);
    await tester.pump();

    await tester.tap(find.byKey(const Key('login_submit')));
    await tester.pump(const Duration(seconds: 1));

    expect(find.byKey(const Key('login_error')), findsNothing);
    expect(find.text('Bem-vindo, Ana Ribeiro!'), findsOneWidget);
  });
}
