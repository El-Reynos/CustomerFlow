import 'package:customer_flow/data/model/entry.model.dart';
import 'package:customer_flow/data/resource/entry.resource.dart';
import 'package:customer_flow/stores/sesion_store.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

part 'entry_editor_store.g.dart';

extension EntryEditorStoreContextExtension on BuildContext {
  EntryEditorStore get entryEditorStore => read<EntryEditorStore>();
}

class EntryEditorStore = _EntryEditorStoreBase with _$EntryEditorStore;

abstract class _EntryEditorStoreBase with Store {
  final SessionStore sessionStore;
  final EntryResource entryResource;

  _EntryEditorStoreBase({
    required this.sessionStore,
    required this.entryResource,
    EntryModel? entry,
  })  : _entry = entry ??
            EntryModel(
              description: '',
              expectedArrival: DateTime.now(),
              createdBy: sessionStore.userProfile?.name ?? '',
            ),
        _description = entry?.description ?? '';

  @readonly
  EntryModel _entry;

  @readonly
  String _description = '';

  @observable
  bool isSaving = false;

  @action
  void setDescription(String value) {
    _description = value;
    _entry = EntryModel(
      id: _entry.id,
      description: value,
      expectedArrival: _entry.expectedArrival,
      createdBy: _entry.createdBy,
    );
  }

  @action
  Future<EntryModel?> save() async {
    isSaving = true;
    try {
      EntryModel savedEntry;
      if (_entry.id != null) {
        savedEntry = await entryResource.updateEntry(_entry.id!, _entry);
      } else {
        savedEntry = await entryResource.createEntry(_entry);
      }
      isSaving = false;
      return savedEntry;
    } catch (e) {
      isSaving = false;
      rethrow;
    }
  }
}
