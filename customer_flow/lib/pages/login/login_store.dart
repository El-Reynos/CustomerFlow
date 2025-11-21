import 'package:customer_flow/stores/sesion_store.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
part 'login_store.g.dart';

class LoginStore = _LoginStore with _$LoginStore;

extension LoginStoreContextExtension on BuildContext {
  LoginStore get loginStore => read<LoginStore>();
}

abstract class _LoginStore with Store {
  final SessionStore sessionStore;

  _LoginStore({required this.sessionStore});

  static const List<User> _users = [
    User(id: '6655bdf2b2cba31a51234567', name: 'Conrado', password: 'Conrado123'),
    User(id: '6655bdf2b2cba31a51234568', name: 'Tefy', password: 'Tefy123'),
  ];

  @readonly
  String _name = '';

  @readonly
  String _password = '';

  @readonly
  bool _isLoading = false;

  @readonly
  String? _errorMessage;

  @readonly
  bool _obscurePassword = true;

  @action
  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
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
    _isLoading = true;
    _errorMessage = null;

    User? user;

    for (final u in _users) {
      if (u.name == _name && u.password == _password) {
        user = u;
        break;
      }
    }

    _isLoading = false;

    if (user != null) {
      sessionStore.setUserProfile(user);
      return true;
    } else {
      _errorMessage = 'Nombre o contraseña incorrectos';
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
