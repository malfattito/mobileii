/// Authentication backend used by the login scene.
abstract interface class ServerLogin {
  Future<void> fetchLogin({required String email, required String password});
}

/// Offline [ServerLogin] for development and previews.
class DefaultServerLogin implements ServerLogin {
  const DefaultServerLogin();
  @override
  Future<void> fetchLogin({ required String email,  required String password,
  }) async {}
}

/// Real [ServerLogin], talking to the Carteira API.
class ServerLoginImpl implements ServerLogin {
  const ServerLoginImpl();
  @override
  Future<void> fetchLogin({ required String email, required String password,
  }) async {}
}
