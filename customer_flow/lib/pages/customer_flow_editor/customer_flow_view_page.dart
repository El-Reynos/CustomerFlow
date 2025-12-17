import 'package:customer_flow/data/resource/entry.resource.dart';
import 'package:customer_flow/pages/customer_flow_editor/customer_flow_editor_store.dart';
import 'package:customer_flow/stores/sesion_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class CustomerFlowViewPage extends StatefulWidget {
  const CustomerFlowViewPage({super.key});

  @override
  State<CustomerFlowViewPage> createState() => _CustomerFlowViewPageState();
}

class _CustomerFlowViewPageState extends State<CustomerFlowViewPage> {
  @override
  Widget build(BuildContext context) => Provider(
    create: (context) => CustomerFlowEditorStore(
      entryResource: context.entryResource,
      sessionStore: context.sessionStore,
      isAnonymous: true,
    )..initialize(),
    builder: (context, _) {
      final store = context.customerFlowEditorStore;
      return Scaffold(
        appBar: AppBar(title: const Text('Bienvenido'), automaticallyImplyLeading: false),
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
                    child: ListTile(title: Text(e.description)),
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
