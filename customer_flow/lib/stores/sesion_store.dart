import 'package:customer_flow/pages/login/login_store.dart';
import 'package:mobx/mobx.dart';
part 'sesion_store.g.dart';

class SessionStore = _SessionStore with _$SessionStore;

abstract class _SessionStore with Store {
  @observable
  User? userProfile ;

  @action
  void setUserProfile (User value) => userProfile  = value;
}