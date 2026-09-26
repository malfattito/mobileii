import 'package:carteira_design_system/carteira_design_system.dart';
import 'package:flutter/material.dart';

import 'login_view_model.dart';

class LoginView extends StatefulWidget {
  const LoginView({required this.viewModel, super.key});

  final LoginViewModel viewModel;

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  void dispose() {
    widget.viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    final textTheme = Theme.of(context).textTheme;

    return AppScaffold(
      showAppBar: false,
      body: Center(
        child: SingleChildScrollView(
          child: AutofillGroup(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Entrar', style: textTheme.headlineMedium),
                const Gap.xs(),
                Text(
                  'Acesse sua carteira digital',
                  style: textTheme.bodyMedium,
                ),
                const Gap.xl(),
                AppTextField(
                  key: const Key('login_email'),
                  label: 'E-mail',
                  hint: 'voce@exemplo.com',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  prefixIcon: Icons.mail_outline,
                  autofillHints: const [AutofillHints.email],
                  onChanged: viewModel.onEmailChanged,
                ),
                const Gap.md(),
                PasswordField(
                  key: const Key('login_password'),
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.password],
                  onChanged: viewModel.onPasswordChanged,
                ),
                const Gap.xl(),
                AppButton(
                  key: const Key('login_submit'),
                  label: 'Entrar',
                  onPressed: viewModel.submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
