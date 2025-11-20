import 'package:customer_flow/stores/sesion_store.dart';
import 'package:flutter/material.dart';
import 'package:customer_flow/pages/login/login_page.dart';
import 'package:provider/provider.dart';

final sessionStore = SessionStore();
void main() {
  runApp(
    Provider<SessionStore>(create: (_) => sessionStore, child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final sessionStore = Provider.of<SessionStore>(context, listen: false);
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(sessionStore: sessionStore),
        // '/clientes': (context) => ClientesPage(),
        // '/config': (context) => ConfigPage(),
      },
    );
  }
}
