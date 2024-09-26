import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_riverpod_test/main.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('Your To Do List'),
      ),
      body: Column(
        children: [
          Progress(),
          TaskList(),
        ],
      ),
    );
  }
}

//-------------------------------------------------------------------------------
class Progress extends ConsumerWidget {
  //Fortschrittsanzeige
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var tasks = ref.watch(tasksProvider);

    var numCompletedTasks = tasks.where((task) {
      //Anzahl der beendeten Tasks
      return task.completed ==
          true; //Wenn die Task beendet ist, wird sie gezählt
    }).length;

    return Column(
      children: [
        Text(
            'Progress: $numCompletedTasks/${tasks.length} tasks completed'), //Anzeige der Anzahl der beendeten Tasks
        LinearProgressIndicator(
          value: numCompletedTasks / tasks.length,
          backgroundColor: Colors.white,
          color: Colors.green, // Set the color of the progress indicator
        ),
      ],
    );
  }
}

//-------------------------------------------------------------------------------
class TaskList extends ConsumerWidget {
  //Liste der Tasks
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var tasks = ref.watch(tasksProvider);

    return Column(
      children: tasks
          .map(
            (task) => TaskItem(task: task), //TaskItem für jeden Task erstellen
          )
          .toList(),
    );
  }
}

class TaskItem extends ConsumerWidget {
  final Task task;

  TaskItem({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Checkbox(
          onChanged: (newValue) =>
              ref.read(tasksProvider.notifier).toggle(task.id),
          value: task.completed,
          activeColor: Colors.green,
        ),
        Text(task.label),
      ],
    );
  }
}

@immutable //unveränderlich, Eigenschaften können nicht geändert werden
class Task {
  final int id; //identifiziert die Task
  final String label;
  final bool completed; //Sobald die Task beendet ist, wird sie auf true gesetzt

  Task(
      {required this.id,
      required this.label,
      this.completed = false}); //Constru

  Task copyWith({int? id, String? label, bool? completed}) {
    //Kopie der Task erstellen
    return Task(
        id: id ??
            this
                .id, //Wenn die Werte nicht geändert werden, wird der alte Wert übernommen
        label: label ??
            this
                .label, //Wenn die Werte nicht geändert werden, wird der alte Wert übernommen
        completed: completed ??
            this.completed); //Wenn die Werte nicht geändert werden, wird der alte Wert übernommen
  }
}

class TaskNotifier extends StateNotifier<List<Task>> {
  //Manager für die States in der classe Task
  //Notifier für die Tasks
  TaskNotifier({tasks}) : super(tasks);

  void add(Task task) {
    //Task hinzufügen
    state = [...state, task];
  }
//--By using StateNotifier, you can separate the business logic from the UI, making your code more modular and easier to test.--

  void toggle(int taskId) {
    //Task beenden
    state = [
      for (final item in state) //Alle Tasks durchgehen
        if (taskId == item.id) //Wenn die Task gefunden wurde
          item.copyWith(completed: !item.completed) //Task beenden
        else
          item
    ];
  }
}
