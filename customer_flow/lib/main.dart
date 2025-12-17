import 'package:customer_flow/pages/customer_flow_editor/customer_flow_editor_page.dart';
import 'package:customer_flow/pages/customer_flow_editor/customer_flow_view_page.dart';
import 'package:customer_flow/pages/login/login_page.dart';
import 'package:customer_flow/providers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() {
  final providers = getProviders();
  runApp(MultiProvider(providers: providers, child: const MyApp()));
}

final _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/anonymous', builder: (context, state) => const CustomerFlowViewPage()),
    GoRoute(path: '/editor', builder: (context, state) => const CustomerFlowEditorPage()),
  ],
  errorBuilder: (context, state) => Scaffold(body: Center(child: Text('Error: ${state.error}'))),
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(routerConfig: _router);
}
