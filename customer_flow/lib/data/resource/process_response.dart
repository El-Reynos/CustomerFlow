import 'package:customer_flow/data/model/server.response.dart';
import 'package:dio/dio.dart';

T processResponse<T>(Response response, T Function(Object?) fromJsonT) {
  if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
    final serverResponse = ServerResponse.fromJson(response.data as Map<String, dynamic>, fromJsonT);
    if (serverResponse.success) {
      return serverResponse.data as T;
    } else {
      throw Exception(serverResponse.error ?? 'Unknown error');
    }
  } else {
    // INSERT_YOUR_CODE
    throw Exception('Error: ${response.statusCode} - ${response.statusMessage}\nResponse: ${response.data}');
  }
}
