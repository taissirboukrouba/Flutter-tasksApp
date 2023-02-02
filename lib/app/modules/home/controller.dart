import 'package:get/get.dart';
import 'package:tasksapp/app/data/services/storage/repository.dart';
import 'package:flutter/material.dart';
import '../../data/models/task.dart';

class HomeController extends GetxController {
  TaskRepository taskRepository;

  HomeController({required this.taskRepository});

  final formKey = GlobalKey<FormState>();
  final editController = TextEditingController();
  final chipIndex = 0.obs;
  final deleting = false.obs;
  final tasks = <Task>[].obs;
  final selectedTask = Rx<Task?>(null);
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
}
