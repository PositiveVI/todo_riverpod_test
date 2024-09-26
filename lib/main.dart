import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_riverpod_test/todolist.dart';

void main() => runApp(ProviderScope(
    child:
        MyApp())); //Alle Flutter-Anwendungen, die Riverpod verwenden, müssen einen ProviderScope an der Wurzel ihres Widget-Baums enthalten.

final tasksProvider = StateNotifierProvider<TaskNotifier, List<Task>>((ref) {
  //tasksProvider ist ein StateNotifierProvider, der eine Instanz von TaskNotifier erstellt und verwaltet.
  return TaskNotifier(tasks: [
    //tasksProvider wird mit einer Liste von Tasks initialisiert.
    Task(id: 1, label: 'Task 1'),
    Task(id: 2, label: 'Task 2'),
    Task(id: 3, label: 'Task 3'),
    Task(id: 4, label: 'Task 4'),
  ]);
});

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Riverpod Test',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}
