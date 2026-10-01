/// Outcome of a login attempt. A [ServerLogin] never throws: every failure
/// comes back as a [LoginFailure] with a message ready for the user.
sealed class LoginResult {
  const LoginResult();
}

final class LoginSuccess extends LoginResult {
  const LoginSuccess({required this.token, required this.userName});

  final String token;
  final String userName;
}

final class LoginFailure extends LoginResult {
  const LoginFailure(this.message);

  final String message;
}
