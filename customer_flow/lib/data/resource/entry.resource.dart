import 'package:customer_flow/data/model/entry.model.dart';
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
    final response = await apiClient.get<List<Map<String, dynamic>>>('/entries');
    return response.data?.map((e) => EntryModel.fromJson(e)).toList() ?? [];
  }
}
