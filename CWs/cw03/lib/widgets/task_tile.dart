import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';

class TaskTile extends StatefulWidget {
  final Task task;
  final TaskService taskService;

  const TaskTile({super.key, required this.task, required this.taskService});

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  bool _isExpanded = false;
  final TextEditingController _subtaskController = TextEditingController();

  @override
  void dispose() {
    _subtaskController.dispose();
    super.dispose();
  }

  Future<void> _addSubtask() async {
    final text = _subtaskController.text.trim();
    if (text.isEmpty) return;

    await widget.taskService.addSubtask(widget.task, text);
    _subtaskController.clear();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                Checkbox(
                  value: task.isCompleted,
                  onChanged: (_) async {
                    await widget.taskService.toggleTaskCompletion(task);
                  },
                ),
                Expanded(
                  child: Text(
                    task.title,
                    style: TextStyle(
                      fontSize: 16,
                      decoration: task.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  icon: Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    await widget.taskService.deleteTask(task.id);
                  },
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
            if (_isExpanded) ...[
              const Divider(),
              if (task.subtasks.isEmpty)
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('No subtasks yet'),
                ),
              ...List.generate(task.subtasks.length, (index) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.subdirectory_arrow_right),
                  title: Text(task.subtasks[index]),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () async {
                      await widget.taskService.deleteSubtask(task, index);
                    },
                  ),
                );
              }),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _subtaskController,
                      decoration: const InputDecoration(
                        hintText: 'Add subtask',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _addSubtask,
                    child: const Text('Add'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
