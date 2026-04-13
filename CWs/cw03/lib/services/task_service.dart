import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';

class TaskService {
  final CollectionReference<Map<String, dynamic>> _tasksRef = FirebaseFirestore
      .instance
      .collection('tasks');

  Future<void> addTask(String title) async {
    final task = Task(
      id: '',
      title: title.trim(),
      isCompleted: false,
      subtasks: [],
      createdAt: DateTime.now(),
    );

    await _tasksRef.add(task.toMap());
  }

  Stream<List<Task>> streamTasks() {
    return _tasksRef.orderBy('createdAt', descending: false).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs.map((doc) {
        return Task.fromMap(doc.id, doc.data());
      }).toList();
    });
  }

  Future<void> updateTask(Task task) async {
    await _tasksRef.doc(task.id).update(task.toMap());
  }

  Future<void> toggleTaskCompletion(Task task) async {
    await _tasksRef.doc(task.id).update({'isCompleted': !task.isCompleted});
  }

  Future<void> deleteTask(String taskId) async {
    await _tasksRef.doc(taskId).delete();
  }

  Future<void> addSubtask(Task task, String subtask) async {
    final updatedSubtasks = List<String>.from(task.subtasks)
      ..add(subtask.trim());

    await _tasksRef.doc(task.id).update({'subtasks': updatedSubtasks});
  }

  Future<void> deleteSubtask(Task task, int index) async {
    final updatedSubtasks = List<String>.from(task.subtasks);

    if (index >= 0 && index < updatedSubtasks.length) {
      updatedSubtasks.removeAt(index);

      await _tasksRef.doc(task.id).update({'subtasks': updatedSubtasks});
    }
  }
}
