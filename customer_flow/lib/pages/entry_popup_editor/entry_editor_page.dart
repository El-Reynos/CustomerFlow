import 'package:customer_flow/pages/entry_popup_editor/entry_editor_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class EntryEditorPage extends StatefulWidget {
  final String? description;
  const EntryEditorPage({this.description});

  @override
  State<EntryEditorPage> createState() => _EntryEditorPageState();
}

class _EntryEditorPageState extends State<EntryEditorPage> {
  @override
  Widget build(BuildContext context) => Provider<EntryEditorStore>(
    create: (context) => EntryEditorStore()..initialize(widget.description),
    builder: (context, _) {
      final store = context.entryEditorStore;
      final descriptionController = store.descriptionController;
      return Center(
        child: Material(
          elevation: 24,
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: 600,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Agregar/Editar Registro', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Observer(
                  builder: (context) => TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Descripción',
                      border: OutlineInputBorder(),
                      floatingLabelAlignment: FloatingLabelAlignment.start,
                      alignLabelWithHint: true,
                    ),
                    maxLines: 3,
                    onChanged: (value) => context.entryEditorStore.setDescription(value),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(child: const Text('Cancelar'), onPressed: () => Navigator.of(context).pop()),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      child: const Text('Guardar'),
                      onPressed: () {
                        if (context.mounted) {
                          Navigator.of(context).pop(descriptionController.text);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
