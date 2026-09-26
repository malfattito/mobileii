import 'package:flutter/widgets.dart';

import 'login_coordinator.dart';
import 'login_view.dart';
import 'login_view_model.dart';
import 'server_login.dart';

/// Assembles the login scene, injecting its dependencies into the ViewModel.
abstract final class LoginFactory {
  static Widget make() {
    final viewModel = LoginViewModel(
      serverLogin: const DefaultServerLogin(),
      coordinator: DefaultLoginCoordinator(),
    );
    return LoginView(viewModel: viewModel);
  }
}

/*
   server  = Server()
   coordinator = Coordinator()
   viewModel = ViewModel(server, coordinator) //Injecao de dependencia
   view = View(viewModel) //Injecao de dependencia
   factory.make() - > View (tela pronta para uso, visual e logica)
 */
