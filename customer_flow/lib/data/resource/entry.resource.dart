import 'package:customer_flow/data/model/entry.model.dart';
import 'package:customer_flow/data/resource/process_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

extension EntryResourceExtension on BuildContext {
  EntryResource get entryResource => read<EntryResource>();
}

class EntryResource {
  final Dio apiClient;

  EntryResource({required this.apiClient});

  Future<List<EntryModel>> getEntries() async {
    try {
      final response = await apiClient.get('/entries');

      final entries = processResponse<List<EntryModel>>(response, (data) {
        if (data is! List<dynamic>) {
          throw Exception('Invalid data format: ${data.runtimeType}');
        }
        return data.map((e) => EntryModel.fromJson(e as Map<String, dynamic>)).toList();
      });
      return entries;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<EntryModel> createEntry(EntryModel data) async {
    final response = await apiClient.post('/entries', data: data.toJson());
    final entry = processResponse<EntryModel>(response, (data) {
      if (data is! Map<String, dynamic>) {
        throw Exception('Invalid data format: ${data.runtimeType}');
      }
      return EntryModel.fromJson(data);
    });
    return entry;
  }

  Future<EntryModel> updateEntry(String id, EntryModel data) async {
    final response = await apiClient.put('/entries/$id', data: data.toJson());
    final entry = processResponse<EntryModel>(response, (data) {
      if (data is! Map<String, dynamic>) {
        throw Exception('Invalid data format: ${data.runtimeType}');
      }
      return EntryModel.fromJson(data);
    });
    return entry;
  }

  Future<void> deleteEntry(String id) async {
    final response = await apiClient.delete('/entries/$id');
    processResponse<void>(response, (_) {});
  }
}
