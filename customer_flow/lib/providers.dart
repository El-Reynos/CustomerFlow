import 'package:customer_flow/data/resource/entry.resource.dart';
import 'package:customer_flow/stores/sesion_store.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';

List<Provider> getProviders() {
  final dio = Dio();
  dio.options.baseUrl = 'http://localhost:8000';
  dio.options.validateStatus = (_) => true; // hace que los status code no hagan throw
  return [
    Provider<EntryResource>(create: (_) => EntryResource(apiClient: dio)),
    Provider<SessionStore>(create: (_) => SessionStore()),
  ];
}
