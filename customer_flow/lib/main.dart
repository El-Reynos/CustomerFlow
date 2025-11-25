import 'package:customer_flow/pages/login/login_page.dart';
import 'package:customer_flow/providers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  final providers = getProviders();
  runApp(MultiProvider(providers: providers, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    initialRoute: '/',
    routes: {
      // '/clientes': (context) => ClientesPage(),
      '/': (context) => const LoginPage(),
      // '/config': (context) => ConfigPage(),
    },
  );
}
