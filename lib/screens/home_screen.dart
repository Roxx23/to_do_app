import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/add_task_sheet.dart';
import '../widgets/priority_toggle_bar.dart';
import '../widgets/task_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _openAddSheet(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const AddTaskSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();
    final tasks = provider.tasks;

    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do'),
        actions: [
          if (provider.completedCount > 0)
            TextButton.icon(
              onPressed: () => provider.clearCompleted(),
              icon: const Icon(Icons.delete_sweep),
              label: const Text('Clear Completed'),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddSheet(context),
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
        child: Column(
          children: [
            const PriorityToggleBar(),
            const SizedBox(height: 8),
            Expanded(
              // Cross-fade the whole list when bulk changes happen (e.g., clear completed)
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                child: ListView.builder(
                  key: ValueKey('v${provider.version}'),
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: tasks.length,
                  itemBuilder: (_, i) => TaskTile(task: tasks[i]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
