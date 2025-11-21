import 'package:customer_flow/pages/customer_flow_editor/customer_flow_editor_page.dart';
import 'package:customer_flow/pages/login/login_store.dart';
import 'package:customer_flow/stores/sesion_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late ReactionDisposer _disposer;

  @override
  void initState() {
    super.initState();
    final sessionStore = context.sessionStore;
    _disposer = reaction<bool>(
      (_) => sessionStore.isLogged,
      (isLogged) => isLogged
          ? Navigator.of(context).push(MaterialPageRoute(builder: (_) => const CustomerFlowEditorPage()))
          : null,
    );
  }

  @override
  void dispose() {
    _disposer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Provider<LoginStore>(
    create: (_) => LoginStore(sessionStore: context.sessionStore),
    builder: (context, child) {
      final loginStore = context.loginStore;
      return Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Observer(
                builder: (_) => TextField(
                  decoration: InputDecoration(
                    labelText: 'Nombre',
                    border: const OutlineInputBorder(),
                    errorText: loginStore.errorMessage,
                  ),
                  onChanged: loginStore.setName,
                ),
              ),
              const SizedBox(height: 16),
              Observer(
                builder: (_) => TextField(
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(loginStore.obscurePassword ? Icons.visibility_off : Icons.visibility),
                      onPressed: loginStore.togglePasswordVisibility,
                    ),
                  ),
                  obscureText: loginStore.obscurePassword,
                  onChanged: loginStore.setPassword,
                ),
              ),
              const SizedBox(height: 24),
              Observer(
                builder: (_) => ElevatedButton(
                  onPressed: loginStore.isLoading ? null : loginStore.login,
                  child: loginStore.isLoading
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Ingresar'),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
