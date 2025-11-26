import 'package:customer_flow/data/model/entry.model.dart';
import 'package:customer_flow/data/resource/entry.resource.dart';
import 'package:customer_flow/pages/customer_flow_editor/customer_flow_editor_store.dart';
import 'package:customer_flow/stores/sesion_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomerFlowEditorPage extends StatefulWidget {
  const CustomerFlowEditorPage({super.key});

  @override
  State<CustomerFlowEditorPage> createState() => _CustomerFlowEditorPageState();
}

class _CustomerFlowEditorPageState extends State<CustomerFlowEditorPage> {
  @override
  Widget build(BuildContext context) => Provider(
    create: (context) =>
        CustomerFlowEditorStore(entryResource: context.entryResource, sessionStore: context.sessionStore),
    builder: (context, _) {
      final store = context.customerFlowEditorStore;
      return Scaffold(
        appBar: AppBar(title: Text(store.userName)),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // store.createEntry(
            //   EntryModel(description: 'Description 1', expectedArrival: DateTime.now(), createdBy: store.userName),
            // );
            store.getEntries();
          },
          child: const Icon(Icons.add),
        ),
        body: const Column(children: [Text('Customer Flow Editor')]),
      );
    },
  );
}
