enum LoginMethod { email, google }

class AuthModel {
  String id;
  String email;
  String password;
  AuthModel(
      {this.id = '',
      this.email = '',
      this.password = '',
      this.loginMethod = LoginMethod.email});
  LoginMethod loginMethod;
}
