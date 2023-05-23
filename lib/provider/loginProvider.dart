import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/account_model.dart';

class Login {
  String email;
  String password;
  String token;
  AccountModel? accountModel;

  Login(
      {required this.email,
      required this.password,
      this.token = '',
      this.accountModel});

  Login copyWith(
      {String? email, String? password, String? token, AccountModel? account}) {
    return Login(
        email: email ?? this.email,
        password: password ?? this.password,
        token: token ?? this.token,
        accountModel: account ?? this.accountModel);
  }
}

class LoginNotifier extends StateNotifier<Login> {
  LoginNotifier(Login state) : super(state);

  void setEmail(String email) {
    state.email = email;
  }

  void setPassword(String password) {
    state.password = password;
  }

  void setToken(String token) {
    state.token = token;
  }

  void setAccount(AccountModel accountModel) {
    state.accountModel = accountModel;
  }
}

final loginProvider = StateNotifierProvider<LoginNotifier, Login>((ref) {
  return LoginNotifier(
      Login(email: '', password: '', token: '', accountModel: null));
});
