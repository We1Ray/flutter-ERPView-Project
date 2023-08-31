import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/account_model.dart';

class Login {
  AccountModel? account;

  Login({this.account});

  Login copyWith({AccountModel? account}) {
    return Login(account: account ?? this.account);
  }
}

class LoginNotifier extends StateNotifier<Login> {
  LoginNotifier(Login state) : super(state);

  void setAccount(AccountModel account) {
    state.account = account;
  }
}

final loginProvider = StateNotifierProvider<LoginNotifier, Login>((ref) {
  return LoginNotifier(Login(account: null));
});
