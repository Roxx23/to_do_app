import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/task_provider.dart';
import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final taskProvider = TaskProvider();
  await taskProvider.loadTasks();

  runApp(
    ChangeNotifierProvider.value(
      value: taskProvider,
      child: const AnimatedTodoApp(),
    ),
  );
}

class AnimatedTodoApp extends StatelessWidget {
  const AnimatedTodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animated To-Do',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(),
    );
  }
}
