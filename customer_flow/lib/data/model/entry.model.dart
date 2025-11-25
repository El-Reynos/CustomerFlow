import 'package:json_annotation/json_annotation.dart';

part 'entry.model.g.dart';

@JsonSerializable()
class EntryModel {
  final String id;
  final String description;
  final DateTime expectedArrival;
  final String createdBy;

  EntryModel({required this.id, required this.description, required this.expectedArrival, required this.createdBy});

  factory EntryModel.fromJson(Map<String, dynamic> json) => _$EntryModelFromJson(json);
  Map<String, dynamic> toJson() => _$EntryModelToJson(this);
}
