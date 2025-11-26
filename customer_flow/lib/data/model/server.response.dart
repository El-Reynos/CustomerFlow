import 'package:json_annotation/json_annotation.dart';

part 'server.response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ServerResponse<T> {
  final bool success;
  final T? data;
  final String? error;

  ServerResponse({required this.success, this.data, this.error});

  factory ServerResponse.fromJson(Map<String, dynamic> json, T Function(Object?) fromJsonT) =>
      _$ServerResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T) toJsonT) => _$ServerResponseToJson(this, toJsonT);
}
