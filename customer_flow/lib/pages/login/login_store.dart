import 'package:customer_flow/stores/sesion_store.dart';
import 'package:mobx/mobx.dart';
part 'login_store.g.dart';

class LoginStore = _LoginStore with _$LoginStore;

abstract class _LoginStore with Store {
  _LoginStore({required SessionStore sessionStore})
      : _sessionStore = sessionStore;

  final SessionStore _sessionStore;
  
  static const List<User> _users = [
    User(
      id: '6655bdf2b2cba31a51234567',
      name: 'Conrado',
      password: 'Conrado123',
    ),
    User(
      id: '6655bdf2b2cba31a51234568',
      name: 'Tefy',
      password: 'Tefy123',
    ),
  ];

  @readonly
  String _name = '';

  @readonly
  String _password = '';

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @observable
  bool obscurePassword = true;

  @action
  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
  }

  @action
  void setName(String value) {
    _name = value;
  }

  @action
  void setPassword(String value) {
    _password = value;
  }

  @action
  Future<bool> login() async {
    isLoading = true;
    errorMessage = null;

    User? user;

    for (final u in _users) {
      if (u.name == _name && u.password == _password) {
        user = u;
        break;
      }
    }

    isLoading = false;

    if (user != null) {
      _sessionStore.setUserProfile(user);
      return true;
    } else {
      errorMessage = 'Nombre o contraseña incorrectos';
      return false;
    }
  }
}

class User {
  final String id;
  final String name;
  final String password;

  const User({required this.id, required this.name, required this.password});
}
