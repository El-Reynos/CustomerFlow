import 'package:customer_flow/data/model/entry.model.dart';
import 'package:customer_flow/data/resource/entry.resource.dart';
import 'package:customer_flow/pages/entry_popup_editor/entry_editor_store.dart';
import 'package:customer_flow/stores/sesion_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EntryEditorPage extends StatefulWidget {
  final EntryModel? entry;
  const EntryEditorPage({this.entry});

  @override
  State<EntryEditorPage> createState() => _EntryEditorPageState();
}

class _EntryEditorPageState extends State<EntryEditorPage> {
  late final TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(
      text: widget.entry?.description ?? '',
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Provider<EntryEditorStore>(
    create: (context) => EntryEditorStore(
      sessionStore: context.sessionStore,
      entryResource: context.entryResource,
      entry: widget.entry,
    ),
    child: Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              color: Colors.black54,
            ),
          ),
        ),
        Center(
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
                  Text(
                    widget.entry == null ? 'Nuevo Registro' : 'Editando',
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Descripción',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    onChanged: (value) => context.entryEditorStore.setDescription(value),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        child: const Text('Cancelar'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        child: const Text('Guardar'),
                        onPressed: () async {
                          final store = context.entryEditorStore;
                          final entry = await store.save();
                          if (entry != null && context.mounted) {
                            Navigator.of(context).pop(entry);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
