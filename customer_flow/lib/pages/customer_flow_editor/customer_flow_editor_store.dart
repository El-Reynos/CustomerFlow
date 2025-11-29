import 'package:customer_flow/data/model/entry.model.dart';
import 'package:customer_flow/data/resource/entry.resource.dart';
import 'package:customer_flow/stores/sesion_store.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

part 'customer_flow_editor_store.g.dart';

extension CustomerFlowEditorStoreContextExtension on BuildContext {
  CustomerFlowEditorStore get customerFlowEditorStore =>
      read<CustomerFlowEditorStore>();
}

class CustomerFlowEditorStore = _CustomerFlowEditorStoreBase
    with _$CustomerFlowEditorStore;

abstract class _CustomerFlowEditorStoreBase with Store {
  final EntryResource entryResource;
  final SessionStore sessionStore;
  final String userName;

  _CustomerFlowEditorStoreBase({
    required this.entryResource,
    required this.sessionStore,
  }) : userName = sessionStore.userProfile!.name;

  @readonly
  bool _isLoading = true;

  @readonly
  List<EntryModel> _list = [];

  @action
  Future<void> initialize() async {
    final entries = await entryResource.getEntries();
    _list.addAll(entries);
    _isLoading = false;
  }

  @action
  Future<void> createEntry(EntryModel data) async {
    final entry = await entryResource.createEntry(data);
  }

  @action
  Future<void> getEntries() async {
    final entries = await entryResource.getEntries();
    print(entries);
  }
}
