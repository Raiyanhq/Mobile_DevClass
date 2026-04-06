import 'package:cloud_firestore/cloud_firestore.dart';

class InventoryItem {
  final String id;
  final String name;
  final int quantity;
  final double price;
  final String category;
  final DateTime createdAt;

  const InventoryItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    required this.category,
    required this.createdAt,
  });

  bool get isLowStock => quantity <= 5;
  double get totalValue => quantity * price;

  InventoryItem copyWith({
    String? id,
    String? name,
    int? quantity,
    double? price,
    String? category,
    DateTime? createdAt,
  }) {
    return InventoryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantity': quantity,
      'price': price,
      'category': category,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory InventoryItem.fromMap(Map<String, dynamic> map, String documentId) {
    final createdAt = map['createdAt'];
    return InventoryItem(
      id: documentId,
      name: (map['name'] ?? '').toString(),
      quantity: (map['quantity'] ?? 0) is int
          ? map['quantity'] as int
          : int.tryParse(map['quantity'].toString()) ?? 0,
      price: (map['price'] ?? 0).toDouble(),
      category: (map['category'] ?? 'General').toString(),
      createdAt: createdAt is Timestamp ? createdAt.toDate() : DateTime.now(),
    );
  }
}