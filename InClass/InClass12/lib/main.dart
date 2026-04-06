import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'models/item_model.dart';
import 'services/firestore_service.dart';
import 'widgets/item_form_sheet.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const InventoryApp());
}

class InventoryApp extends StatelessWidget {
  const InventoryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inventory Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
        ),
      ),
      home: const InventoryHomePage(),
    );
  }
}

class InventoryHomePage extends StatefulWidget {
  const InventoryHomePage({super.key});

  @override
  State<InventoryHomePage> createState() => _InventoryHomePageState();
}

class _InventoryHomePageState extends State<InventoryHomePage> {
  final FirestoreService _service = FirestoreService();
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openAddSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => ItemFormSheet(
        onSubmit: ({
          required String name,
          required int quantity,
          required double price,
          required String category,
        }) {
          return _service.addItem(
            InventoryItem(
              id: '',
              name: name,
              quantity: quantity,
              price: price,
              category: category,
              createdAt: DateTime.now(),
            ),
          );
        },
      ),
    );
  }

  Future<void> _openEditSheet(InventoryItem item) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => ItemFormSheet(
        item: item,
        onSubmit: ({
          required String name,
          required int quantity,
          required double price,
          required String category,
        }) {
          return _service.updateItem(
            item.copyWith(
              name: name,
              quantity: quantity,
              price: price,
              category: category,
            ),
          );
        },
      ),
    );
  }

  Future<void> _deleteItem(InventoryItem item) async {
    await _service.deleteItem(item.id);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${item.name} deleted.')),
    );
  }

  List<InventoryItem> _applySearch(List<InventoryItem> items) {
    final query = _searchText.trim().toLowerCase();
    if (query.isEmpty) return items;

    return items.where((item) {
      return item.name.toLowerCase().contains(query) ||
          item.category.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Management'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openAddSheet,
        icon: const Icon(Icons.add),
        label: const Text('Add Item'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by item name or category',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchText.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchText = '');
                        },
                        icon: const Icon(Icons.clear),
                      ),
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => _searchText = value),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<InventoryItem>>(
              stream: _service.streamItems(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'Something went wrong while loading inventory items.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final items = _applySearch(snapshot.data ?? []);
                final lowStockCount = items.where((item) => item.isLowStock).length;
                final totalInventoryValue = items.fold<double>(
                  0,
                  (sum, item) => sum + item.totalValue,
                );

                if (items.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'No inventory items found. Add your first item to begin.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _SummaryChip(
                            icon: Icons.inventory_2_outlined,
                            label: 'Items: ${items.length}',
                          ),
                          _SummaryChip(
                            icon: Icons.warning_amber_rounded,
                            label: 'Low stock: $lowStockCount',
                          ),
                          _SummaryChip(
                            icon: Icons.attach_money,
                            label: 'Value: \$${totalInventoryValue.toStringAsFixed(2)}',
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];

                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              title: Text(
                                item.name,
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Category: ${item.category}'),
                                    Text('Quantity: ${item.quantity}'),
                                    Text('Price: \$${item.price.toStringAsFixed(2)}'),
                                    if (item.isLowStock)
                                      const Padding(
                                        padding: EdgeInsets.only(top: 6),
                                        child: Text(
                                          'Low stock alert',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    tooltip: 'Edit item',
                                    onPressed: () => _openEditSheet(item),
                                    icon: const Icon(Icons.edit),
                                  ),
                                  IconButton(
                                    tooltip: 'Delete item',
                                    onPressed: () => _deleteItem(item),
                                    icon: const Icon(Icons.delete),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
    );
  }
}