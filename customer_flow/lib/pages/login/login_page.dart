import 'package:customer_flow/pages/customer_flow_editor/customer_flow_editor_page.dart';
import 'package:customer_flow/stores/sesion_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'login_store.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key, required SessionStore sessionStore})
      : _sessionStore = sessionStore,
        loginStore = LoginStore(sessionStore: sessionStore);

  final SessionStore _sessionStore;
  final LoginStore loginStore;

  @override
  Widget build(BuildContext context) => Scaffold(
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
                  icon: Icon(
                    loginStore.obscurePassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
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
              onPressed: loginStore.isLoading
                  ? null
                  : () async {
                      final ok = await loginStore.login();
                      if (ok && context.mounted) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => CustomerFlowEditorPage(
                              sessionStore: _sessionStore,
                            ),
                          ),
                        );
                      }
                    },
              child: loginStore.isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Ingresar'),
            ),
          ),
        ],
      ),
    ),
  );
}
