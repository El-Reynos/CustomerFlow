import 'package:customer_flow/pages/login/login_store.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
part 'sesion_store.g.dart';

class SessionStore = _SessionStore with _$SessionStore;

extension SessionStoreContextExtension on BuildContext {
  SessionStore get sessionStore => read<SessionStore>();
}

abstract class _SessionStore with Store {
  @observable
  User? userProfile;

  @action
  void setUserProfile(User value) {
    userProfile = value;
    _isLogged = true;
  }

  @action
  void logout(){
    _isLogged = false;
  }

  @readonly
  bool _isLogged = false;
}
