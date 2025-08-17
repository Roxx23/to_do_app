import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  const TaskTile({super.key, required this.task});

  Color _priorityColor(Priority p) {
    switch (p) {
      case Priority.low:
        return Colors.green;
      case Priority.medium:
        return Colors.orange;
      case Priority.high:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();
    final isVisible = provider.isTaskVisible(task);

    // When the tile first appears (new task), slide & fade in.
    final entryAnimation = task.isNew;

    final content = _TaskCard(
      task: task,
      priorityColor: _priorityColor(task.priority),
    );

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) {
        // Compose fade + slight vertical slide
        final offsetTween = Tween<Offset>(
          begin: Offset(0, entryAnimation ? 0.15 : 0.0),
          end: Offset.zero,
        );
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: offsetTween.animate(animation),
            child: child,
          ),
        );
      },
      child:
          isVisible ? content : const SizedBox.shrink(key: ValueKey('hidden')),
    );
  }
}

class _TaskCard extends StatelessWidget {
  final Task task;
  final Color priorityColor;

  const _TaskCard({required this.task, required this.priorityColor});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<TaskProvider>();

    return Container(
      key: ValueKey(task.id),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        elevation: 1,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => provider.toggleCompleted(task.id, !task.completed),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                // Priority dot
                Container(
                  width: 10,
                  height: 10,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: priorityColor,
                    shape: BoxShape.circle,
                  ),
                ),
                // Title with animated style when completed
                Expanded(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOut,
                    style: TextStyle(
                      fontSize: 16,
                      decoration:
                          task.completed
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                      color:
                          task.completed
                              ? Theme.of(
                                context,
                              ).textTheme.bodyMedium!.color!.withOpacity(0.6)
                              : Theme.of(context).textTheme.bodyMedium!.color,
                    ),
                    child: Text(
                      task.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Checkbox(
                  value: task.completed,
                  onChanged:
                      (v) => provider.toggleCompleted(task.id, v ?? false),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
