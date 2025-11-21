import 'package:customer_flow/stores/sesion_store.dart';
import 'package:flutter/material.dart';

class CustomerFlowEditorPage extends StatefulWidget {
  const CustomerFlowEditorPage({super.key});

  @override
  State<CustomerFlowEditorPage> createState() => _CustomerFlowEditorPageState();
}

class _CustomerFlowEditorPageState extends State<CustomerFlowEditorPage> {
  late final List<Client> _clients;
  final ScrollController _scrollController = ScrollController();

  String _nameFilter = '';
  String _descriptionFilter = '';
  ClientStatus? _statusFilter;
  DateTime? _dateFilter;
  bool _filtersExpanded = false;
  late SessionStore sessionStore;

  @override
  void initState() {
    super.initState();
    sessionStore = context.sessionStore;
    _clients = _generateClients();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<Client> _generateClients() {
    final now = DateTime.now();
    // Crea una lista en la que al menos 3 registros tengan el mismo createdAt
    final List<Client> list = [];
    final sameDate = now.subtract(const Duration(days: 5));

    for (int i = 0; i < 10; i++) {
      late DateTime createdAt;
      if (i >= 3 && i <= 5) {
        // Los registros 4, 5 y 6 tendrán la misma fecha de creación
        createdAt = sameDate;
      } else {
        createdAt = now.subtract(Duration(days: 10 - i));
      }
      list.add(
        Client(
          name: 'Cliente ${(i + 1).toString().padLeft(2, '0')}',
          detail: 'Detalle del cliente ${i + 1}',
          status: ClientStatus.pending,
          createdBy: sessionStore.userProfile?.name ?? 'Sistema',
          createdAt: createdAt,
        ),
      );
    }
    return list;
  }

  List<Client> get _filteredClients {
    final ordered = List<Client>.from(_clients)..sort((a, b) => a.createdAt.compareTo(b.createdAt));

    return ordered.where((client) {
      final matchesName = client.name.toLowerCase().contains(_nameFilter);
      final matchesDesc = client.detail.toLowerCase().contains(_descriptionFilter);
      final matchesStatus = _statusFilter == null || client.status == _statusFilter;
      final matchesDate = _dateFilter == null || _isSameDay(client.createdAt, _dateFilter!);
      return matchesName && matchesDesc && matchesStatus && matchesDate;
    }).toList();
  }

  void _toggleStatus(Client client) {
    setState(() {
      client.status = client.status == ClientStatus.completed ? ClientStatus.pending : ClientStatus.completed;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }

  bool _isSameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;

  String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

  @override
  Widget build(BuildContext context) {
    final clients = _filteredClients;
    final userName = sessionStore.userProfile?.name ?? 'Invitado';

    return Scaffold(
      appBar: AppBar(title: Text('Bienvenido $userName')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('Lista de Clientes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Spacer(),
                ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.add), label: const Text('Nuevo')),
              ],
            ),
            const SizedBox(height: 16),
            _FiltersSection(
              onNameChanged: (value) => setState(() {
                _nameFilter = value.toLowerCase();
              }),
              statusFilter: _statusFilter,
              onStatusChanged: (value) => setState(() {
                _statusFilter = value;
              }),
              onDescriptionChanged: (value) => setState(() {
                _descriptionFilter = value.toLowerCase();
              }),
              dateFilter: _dateFilter,
              onDateChanged: (value) => setState(() {
                _dateFilter = value;
              }),
              onClearDate: () => setState(() {
                _dateFilter = null;
              }),
              formatDate: _formatDate,
              initiallyExpanded: _filtersExpanded,
              onToggleExpanded: () => setState(() {
                _filtersExpanded = !_filtersExpanded;
              }),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(controller: _scrollController, children: _buildGroupedClientWidgets(clients)),
            ),
          ],
        ),
      ),
    );
  }
}

class _FiltersSection extends StatefulWidget {
  const _FiltersSection({
    required this.onNameChanged,
    required this.statusFilter,
    required this.onStatusChanged,
    required this.onDescriptionChanged,
    required this.dateFilter,
    required this.onDateChanged,
    required this.onClearDate,
    required this.formatDate,
    required this.initiallyExpanded,
    required this.onToggleExpanded,
  });

  final ValueChanged<String> onNameChanged;
  final ClientStatus? statusFilter;
  final ValueChanged<ClientStatus?> onStatusChanged;
  final ValueChanged<String> onDescriptionChanged;
  final DateTime? dateFilter;
  final ValueChanged<DateTime?> onDateChanged;
  final VoidCallback onClearDate;
  final String Function(DateTime) formatDate;
  final bool initiallyExpanded;
  final VoidCallback onToggleExpanded;

  @override
  State<_FiltersSection> createState() => _FiltersSectionState();
}

class _FiltersSectionState extends State<_FiltersSection> {
  late bool _isExpanded = widget.initiallyExpanded;

  @override
  void didUpdateWidget(covariant _FiltersSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initiallyExpanded != widget.initiallyExpanded) {
      _isExpanded = widget.initiallyExpanded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final headerColor = theme.colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Material(
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            onTap: () {
              setState(() => _isExpanded = !_isExpanded);
              widget.onToggleExpanded();
            },
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Icon(_isExpanded ? Icons.expand_less : Icons.expand_more, color: headerColor),
                  const SizedBox(width: 8),
                  Text(
                    'Filtros',
                    style: TextStyle(fontWeight: FontWeight.w600, color: headerColor),
                  ),
                  const Spacer(),
                  Text(_isExpanded ? 'Ocultar' : 'Mostrar', style: TextStyle(color: headerColor)),
                ],
              ),
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: _FiltersForm(
              onNameChanged: widget.onNameChanged,
              statusFilter: widget.statusFilter,
              onStatusChanged: widget.onStatusChanged,
              onDescriptionChanged: widget.onDescriptionChanged,
              dateFilter: widget.dateFilter,
              onDateChanged: widget.onDateChanged,
              onClearDate: widget.onClearDate,
              formatDate: widget.formatDate,
            ),
          ),
          crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),
      ],
    );
  }
}

class _FiltersForm extends StatelessWidget {
  const _FiltersForm({
    required this.onNameChanged,
    required this.statusFilter,
    required this.onStatusChanged,
    required this.onDescriptionChanged,
    required this.dateFilter,
    required this.onDateChanged,
    required this.onClearDate,
    required this.formatDate,
  });

  final ValueChanged<String> onNameChanged;
  final ClientStatus? statusFilter;
  final ValueChanged<ClientStatus?> onStatusChanged;
  final ValueChanged<String> onDescriptionChanged;
  final DateTime? dateFilter;
  final ValueChanged<DateTime?> onDateChanged;
  final VoidCallback onClearDate;
  final String Function(DateTime) formatDate;

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: dateFilter ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      onDateChanged(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: const InputDecoration(labelText: 'Filtrar por nombre', border: OutlineInputBorder()),
                onChanged: onNameChanged,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: DropdownButtonFormField<ClientStatus?>(
                initialValue: statusFilter,
                decoration: const InputDecoration(labelText: 'Estado', border: OutlineInputBorder()),
                items: const [
                  DropdownMenuItem(child: Text('Todos')),
                  DropdownMenuItem(value: ClientStatus.pending, child: Text('Pendiente')),
                  DropdownMenuItem(value: ClientStatus.completed, child: Text('Completado')),
                  DropdownMenuItem(value: ClientStatus.cancelled, child: Text('Cancelado')),
                ],
                onChanged: onStatusChanged,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          decoration: const InputDecoration(labelText: 'Filtrar por descripción', border: OutlineInputBorder()),
          onChanged: onDescriptionChanged,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => _pickDate(context),
                borderRadius: BorderRadius.circular(4),
                child: InputDecorator(
                  decoration: const InputDecoration(labelText: 'Filtrar por fecha', border: OutlineInputBorder()),
                  child: Text(
                    dateFilter != null ? formatDate(dateFilter!) : 'Seleccionar fecha',
                    style: TextStyle(color: dateFilter != null ? theme.colorScheme.onSurface : Colors.grey),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            IconButton(
              tooltip: 'Limpiar fecha',
              onPressed: dateFilter == null ? null : onClearDate,
              icon: const Icon(Icons.clear),
            ),
          ],
        ),
      ],
    );
  }
}

extension on _CustomerFlowEditorPageState {
  List<Widget> _buildGroupedClientWidgets(List<Client> clients) {
    if (clients.isEmpty) {
      return [const Center(child: Text('No hay registros con los filtros actuales'))];
    }

    final List<Widget> groups = [];
    DateTime? currentDay;
    final List<Widget> currentCards = [];

    void flushGroup() {
      final day = currentDay;
      if (day == null || currentCards.isEmpty) return;
      groups.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Registros del ${_formatDate(day)}',
                style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              ...currentCards,
            ],
          ),
        ),
      );
      currentCards.clear();
    }

    for (final client in clients) {
      final currentDayValue = currentDay;
      if (currentDayValue == null || !_isSameDay(currentDayValue, client.createdAt)) {
        flushGroup();
        currentDay = client.createdAt;
      }

      currentCards.add(
        Card(
          child: ListTile(
            title: Text(client.name),
            subtitle: Text(client.detail),
            trailing: IconButton(
              icon: Icon(
                Icons.check_circle,
                color: client.status == ClientStatus.completed ? Colors.green : Colors.grey,
              ),
              onPressed: () => _toggleStatus(client),
            ),
          ),
        ),
      );
    }

    flushGroup();
    return groups;
  }
}

class Client {
  Client({
    required this.name,
    required this.detail,
    required this.status,
    required this.createdBy,
    required this.createdAt,
  });

  final String name;
  final String detail;
  ClientStatus status;
  final String createdBy;
  final DateTime createdAt;
}

enum ClientStatus { pending, completed, cancelled }
