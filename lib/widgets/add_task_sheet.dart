import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

class AddTaskSheet extends StatefulWidget {
  const AddTaskSheet({super.key});

  @override
  State<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends State<AddTaskSheet> {
  final _controller = TextEditingController();
  Priority _priority = Priority.medium;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final title = _controller.text.trim();
    if (title.isEmpty) return;
    await context.read<TaskProvider>().addTask(title, _priority);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    Color colorFor(Priority p) {
      switch (p) {
        case Priority.low:
          return Colors.green;
        case Priority.medium:
          return Colors.orange;
        case Priority.high:
          return Colors.red;
      }
    }

    Widget chip(Priority p, String label) {
      final selected = _priority == p;
      return ChoiceChip(
        selected: selected,
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: colorFor(p),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(label),
          ],
        ),
        onSelected: (_) => setState(() => _priority = p),
      );
    }

    return Padding(
      padding: MediaQuery.of(
        context,
      ).viewInsets.add(const EdgeInsets.fromLTRB(16, 16, 16, 24)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Add Task', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            children: [
              chip(Priority.low, 'Low'),
              chip(Priority.medium, 'Medium'),
              chip(Priority.high, 'High'),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              icon: const Icon(Icons.check),
              label: const Text('Add Task'),
              onPressed: _submit,
            ),
          ),
        ],
      ),
    );
  }
}
