import 'package:customer_flow/data/model/entry.model.dart';
import 'package:customer_flow/data/resource/entry.resource.dart';
import 'package:customer_flow/stores/sesion_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

part 'customer_flow_editor_store.g.dart';

extension CustomerFlowEditorStoreContextExtension on BuildContext {
  CustomerFlowEditorStore get customerFlowEditorStore => read<CustomerFlowEditorStore>();
}

class CustomerFlowEditorStore = _CustomerFlowEditorStoreBase with _$CustomerFlowEditorStore;

abstract class _CustomerFlowEditorStoreBase with Store {
  final EntryResource entryResource;
  final SessionStore sessionStore;
  final String userName;

  final ScrollController scrollController = ScrollController();

  _CustomerFlowEditorStoreBase({required this.entryResource, required this.sessionStore})
    : userName = sessionStore.userProfile!.name;

  @readonly
  bool _isLoading = true;

  @observable
  List<EntryModel>? _allItems;

  @computed
  List<DayItems> get filteredItems {
    if (_allItems == null) return [];
    final Map<DateTime, List<EntryModel>> grouped = {};

    for (final entry in _allItems!) {
      final date = DateTime(entry.expectedArrival.year, entry.expectedArrival.month, entry.expectedArrival.day);
      grouped.putIfAbsent(date, () => []).add(entry);
    }

    final List<DayItems> result = grouped.entries
        .map((e) => DayItems(date: e.key, entries: e.value..sort((a, b) => a.description.compareTo(b.description))))
        .toList();
    result.sort((a, b) => a.date.compareTo(b.date));

    return result;
  }

  @action
  Future<void> initialize() async {
    _allItems = await entryResource.getEntries(sessionStore.userProfile);
    _isLoading = false;
    // Esperar a que el widget se renderice antes de hacer scroll
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients && scrollController.position.maxScrollExtent > 0) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }
    });
  }

  @action
  Future<void> createEntry(String description) async {
    _isLoading = true;
    await entryResource.createEntry(
      EntryModel(description: description, expectedArrival: DateTime.now(), createdBy: sessionStore.userProfile!.id),
    );
    _allItems = await entryResource.getEntries(sessionStore.userProfile);
    _isLoading = false;
    // Esperar a que el widget se renderice antes de hacer scroll
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients && scrollController.position.maxScrollExtent > 0) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }
    });
  }

  @action
  Future<void> updateEntry(EntryModel entry, String description) async {
    await entryResource.updateEntry(
      entry.id!,
      EntryModel(
        description: description,
        expectedArrival: entry.expectedArrival,
        createdBy: sessionStore.userProfile!.id,
      ),
    );
    _allItems = await entryResource.getEntries(sessionStore.userProfile);
  }

  @action
  Future<void> deleteEntry(String id) async {
    await entryResource.deleteEntry(id);
    _allItems = await entryResource.getEntries(sessionStore.userProfile);
  }

  void dispose() {
    scrollController.dispose();
  }
}

class DayItems {
  final DateTime date;
  final List<EntryModel> entries;

  DayItems({required this.date, required this.entries});
}
