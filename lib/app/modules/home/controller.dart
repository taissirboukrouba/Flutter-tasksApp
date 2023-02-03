import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tasksapp/app/data/services/storage/repository.dart';
import 'package:flutter/material.dart';
import '../../data/models/task.dart';
import 'package:flutter/foundation.dart';

class HomeController extends GetxController {
  TaskRepository taskRepository;

  HomeController({required this.taskRepository});

  final formKey = GlobalKey<FormState>();
  final editController = TextEditingController();
  final chipIndex = 0.obs;
  final deleting = false.obs;
  final tasks =
      <Task>[].obs; // task type list [Personal ,Travel , Movies .....]
  final selectedTask = Rx<Task?>(null); // tasks to add in the task type
  final doingTodos = <dynamic>[].obs;
  final doneTodos = <dynamic>[].obs;
  final tabIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    tasks.assignAll(taskRepository.readTasks());
    ever(
        tasks,
        (callback) => taskRepository.writeTasks(
            tasks)); // whenever the task changes write it (update it)
  }

  void changeChipIndex(int value) {
    chipIndex.value = value;
  }

  void changeDeleting(bool value) {
    deleting.value = value;
  }

  bool addTask(Task task) {
    if (tasks.contains(task)) {
      return false;
    }
    tasks.add(task);
    return true;
  }

  void selectTask(Task? select) {
    selectedTask.value = select;
  }

  void deleteTask(Task task) {
    tasks.remove(task);
  }

  updateTask(Task task, String title) {
    var todos = task.todos ??
        []; // create the todos from the task else return empty list
    if (ContainTodo(todos, title)) {
      // if the new title we're giving to the todos list already exists
      return false;
    }
    var todo = {'title': title, 'done': false};
    todos.add(todo);
    var newTask = task.copyWith(todos: todos);
    int oldTaskIndex = tasks.indexOf(task);
    tasks[oldTaskIndex] = newTask;
    tasks.refresh();
    return true;
  }

  bool ContainTodo(List todos, String title) {
    return todos.any((element) => element['title'] == title);
  }

  void changeTodos(List<dynamic> select) {
    doingTodos.clear();
    doneTodos.clear();
    for (int i = 0; i < select.length; i++) {
      var todo = select[i];
      var status = todo['done'];
      if (status == true) {
        doneTodos.add(todo);
      } else {
        doingTodos.add(todo);
      }
    }
  }

  bool addTodo(String title) {
    var todo = {'title': title, 'done': false};
    // checks if our todos items have the same info(title,done) as the one we created
    if (doingTodos
        .any((element) => mapEquals<String, dynamic>(todo, element))) {
      return false;
    }
    var checkDoneTodo = {'title': title, 'done': true};

    if (doneTodos
        .any((element) => mapEquals<String, dynamic>(checkDoneTodo, element))) {
      return false;
    }
    doingTodos.add(todo);
    return true;
  }

  void updateTodos() {
    var newTodos = <Map<String, dynamic>>[]; // a list of maps (dictionaries)
    newTodos.addAll([
      ...doingTodos,
      ...doneTodos,
    ]);
    var newTask = selectedTask.value!.copyWith(todos: newTodos);
    int oldIndx = tasks.indexOf(selectedTask.value);
    tasks[oldIndx] = newTask;
    tasks.refresh();
  }

  void doneTodo(String title) {
    var doingtodo = {'title': title, 'done': false};
    int index = doingTodos.indexWhere(
        (element) => mapEquals<String, dynamic>(doingtodo, element));
    doingTodos.removeAt(index);
    var donetodo = {'title': title, 'done': true};
    doneTodos.add(donetodo);
    doingTodos.refresh();
    doneTodos.refresh();
  }

  void deleteDoneTodo(dynamic doneTodo) {
    // search the index we're trying to delete in the donetodos list
    int index = doneTodos
        .indexWhere((element) => mapEquals<String, dynamic>(doneTodo, element));
    doneTodos.removeAt(index);
    doneTodos.refresh();
  }

  bool isTodoEmpty(Task task) {
    return task.todos == null || task.todos!.isEmpty;
  }

// getting the done todos number
  int getDoneTodo(Task task) {
    var res = 0;
    for (int i = 0; i < task.todos!.length; i++) {
      if (task.todos![i]['done'] == true) {
        res++;
      }
    }
    return res;
  }

  void changeTabIndex(int value) {
    tabIndex.value = value;
  }

  int getTotalTasks() {
    var res = 0;
    for (int i = 0; i < tasks.length; i++) {
      if (tasks[i].todos != null) {
        res += tasks[i].todos!.length;
      }
    }
    return res;
  }

  int getTotalDoneTasks() {
    var res = 0;
    for (int i = 0; i < tasks.length; i++) {
      if (tasks[i].todos != null) {
        for (int j = 0; j < tasks[i].todos!.length; j++) {
          if (tasks[i].todos![j]['done']== true) {
            res += 1;
          }
        }
      }
    }
    return res;
  }
}
