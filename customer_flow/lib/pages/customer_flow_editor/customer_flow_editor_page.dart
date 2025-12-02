import 'package:customer_flow/data/resource/entry.resource.dart';
import 'package:customer_flow/pages/customer_flow_editor/customer_flow_editor_store.dart';
import 'package:customer_flow/pages/entry_popup_editor/entry_editor_page.dart';
import 'package:customer_flow/stores/sesion_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class CustomerFlowEditorPage extends StatefulWidget {
  const CustomerFlowEditorPage({super.key});

  @override
  State<CustomerFlowEditorPage> createState() => _CustomerFlowEditorPageState();
}

class _CustomerFlowEditorPageState extends State<CustomerFlowEditorPage> {
  @override
  Widget build(BuildContext context) => Provider(
    create: (context) =>
        CustomerFlowEditorStore(entryResource: context.entryResource, sessionStore: context.sessionStore)..initialize(),
    builder: (context, _) {
      final store = context.customerFlowEditorStore;
      return Scaffold(
        appBar: AppBar(
          title: Text('Bienvenido, ${store.userName}'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.sessionStore.logout();
              Navigator.of(context).pop();
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final description = await showDialog<String>(
              context: context,
              builder: (context) => const EntryEditorPage(),
            );
            if (description != null) {
              store.createEntry(description);
            }
          },
          child: const Icon(Icons.add),
        ),
        body: Observer(builder: (_) => store.isLoading == true ? const _LoadingSkeleton() : const _List()),
      );
    },
  );
}

class _LoadingSkeleton extends StatelessWidget {
  const _LoadingSkeleton();

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: const Column(
      children: [
        Text(''),
        Card(margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: ListTile()),
      ],
    ),
  );
}

class _List extends StatelessWidget {
  const _List();

  @override
  Widget build(BuildContext context) => Builder(
    builder: (context) => Observer(
      builder: (context) {
        final store = context.customerFlowEditorStore;
        final filteredItems = store.filteredItems;
        return ListView.builder(
          controller: store.scrollController,
          itemCount: filteredItems.length,
          itemBuilder: (context, index) {
            final item = filteredItems[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Text(
                    '${item.date.day.toString().padLeft(2, '0')}/${item.date.month.toString().padLeft(2, '0')}/${item.date.year}',
                    style: const TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                ...item.entries.map(
                  (e) => Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      title: Text(e.description),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () async {
                              final description = await showDialog<String>(
                                context: context,
                                builder: (context) => EntryEditorPage(description: e.description),
                              );
                              if (description != null) {
                                store.updateEntry(e, description);
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Confirmación'),
                                  content: const Text('Seguro que desea eliminar este registro'),
                                  actions: [
                                    TextButton(
                                      child: const Text('Cancelar'),
                                      onPressed: () => Navigator.of(context).pop(false),
                                    ),
                                    TextButton(
                                      child: const Text('Eliminar'),
                                      onPressed: () => Navigator.of(context).pop(true),
                                    ),
                                  ],
                                ),
                              );
                              if (confirm == true) {
                                await store.deleteEntry(e.id!);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    ),
  );
}
