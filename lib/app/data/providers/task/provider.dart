import 'dart:convert';
import 'package:tasksapp/app/core/utils/keys.dart';
import 'package:tasksapp/app/data/services/storage/services.dart';
import 'package:get/get.dart';
import '../../models/task.dart';

class TaskProvider {
  final _storage = Get.find<StorageService>(); // read local db
  /* data format
      {"tasks" : [{
      'title':'Work',
      'color' : #ff123456,
      'icon' : oxe123,
      }]}
      */
  //------------------------------------
  //TODO:  readTasks() method
  List<Task> readTasks() {
    List<Task> mytasks = <Task>[];
    jsonDecode(_storage.read(taskKey).toString())
        .forEach((e) => mytasks.add(Task.fromJson(e)));
    return mytasks;
  }
//TODO:  writeTasks() method

  void writeTasks(List<Task> tasks) {
    _storage.write(taskKey, jsonEncode(tasks));
  }
}
