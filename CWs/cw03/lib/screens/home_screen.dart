import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';
import '../widgets/task_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TaskService _taskService = TaskService();
  final TextEditingController _taskController = TextEditingController();
  String _searchText = '';

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  Future<void> _addTask() async {
    final text = _taskController.text.trim();

    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task name cannot be empty')),
      );
      return;
    }

    await _taskService.addTask(text);
    _taskController.clear();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Task Manager'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _taskController,
              decoration: const InputDecoration(
                labelText: 'Task name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _addTask,
                child: const Text('Add Task'),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Search tasks',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _searchText = value.trim().toLowerCase();
                });
              },
            ),
            const SizedBox(height: 12),
            Expanded(
              child: StreamBuilder<List<Task>>(
                stream: _taskService.streamTasks(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Something went wrong while loading tasks.'),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final tasks = snapshot.data ?? [];
                  final filteredTasks = tasks.where((task) {
                    return task.title.toLowerCase().contains(_searchText);
                  }).toList();

                  if (filteredTasks.isEmpty) {
                    return const Center(
                      child: Text(
                        'No tasks available. Add one to get started.',
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: filteredTasks.length,
                    itemBuilder: (context, index) {
                      return TaskTile(
                        task: filteredTasks[index],
                        taskService: _taskService,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
