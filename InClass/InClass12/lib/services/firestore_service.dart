import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/item_model.dart';

class FirestoreService {
  FirestoreService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _itemsRef =>
      _firestore.collection('inventory_items');

  Future<void> addItem(InventoryItem item) async {
    await _itemsRef.add(item.toMap());
  }

  Stream<List<InventoryItem>> streamItems() {
    return _itemsRef
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => InventoryItem.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> updateItem(InventoryItem item) async {
    await _itemsRef.doc(item.id).update(item.toMap());
  }

  Future<void> deleteItem(String id) async {
    await _itemsRef.doc(id).delete();
  }
}