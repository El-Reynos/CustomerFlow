import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

part 'entry_editor_store.g.dart';

extension EntryEditorStoreContextExtension on BuildContext {
  EntryEditorStore get entryEditorStore => read<EntryEditorStore>();
}

class EntryEditorStore = _EntryEditorStoreBase with _$EntryEditorStore;

abstract class _EntryEditorStoreBase with Store {
  _EntryEditorStoreBase();

  final descriptionController = TextEditingController();

  @observable
  bool isSaving = false;

  @action
  Future<void> initialize(String? description) async {
    descriptionController.text = description ?? '';
  }

  @action
  void setDescription(String value) {
    descriptionController.text = value;
  }

  void dispose() {
    descriptionController.dispose();
  }
}
