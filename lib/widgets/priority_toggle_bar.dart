import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

class PriorityToggleBar extends StatelessWidget {
  const PriorityToggleBar({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();
    final selected =
        Priority.values
            .map((p) => provider.activePriorities.contains(p))
            .toList();

    Color colorFor(Priority p) => switch (p) {
      Priority.low => Colors.green,
      Priority.medium => Colors.orange,
      Priority.high => Colors.red,
    };

    Widget dot(Color c) => Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: c, shape: BoxShape.circle),
    );

    final toggles = ToggleButtons(
      isSelected: selected,
      borderRadius: BorderRadius.circular(12),
      onPressed: (i) => provider.togglePriority(Priority.values[i]),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              dot(colorFor(Priority.low)),
              const SizedBox(width: 8),
              const Text('Low'),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              dot(colorFor(Priority.medium)),
              const SizedBox(width: 8),
              const Text('Medium'),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              dot(colorFor(Priority.high)),
              const SizedBox(width: 8),
              const Text('High'),
            ],
          ),
        ),
      ],
    );

    final completedSwitch = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Show Completed'),
        const SizedBox(width: 8),
        Switch.adaptive(
          value: provider.showCompleted,
          onChanged: provider.setShowCompleted,
        ),
      ],
    );

    // Responsive: on narrow screens stack; on wide keep in one row.
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 380;
        if (isNarrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Make the toggles horizontally scrollable if needed
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: toggles,
              ),
              const SizedBox(height: 8),
              // Keep the switch aligned to the end to save space
              Align(alignment: Alignment.centerRight, child: completedSwitch),
            ],
          );
        }

        // Wider: one row, left toggles can scroll a bit if tight
        return Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: toggles,
              ),
            ),
            const SizedBox(width: 8),
            // Let the right chunk shrink instead of overflowing
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: completedSwitch,
              ),
            ),
          ],
        );
      },
    );
  }
}
