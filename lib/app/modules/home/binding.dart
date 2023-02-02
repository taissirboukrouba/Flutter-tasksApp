import 'package:get/get.dart';
import 'package:tasksapp/app/data/providers/task/provider.dart';
import 'package:tasksapp/app/modules/home/controller.dart';

import '../../data/services/storage/repository.dart';

class HomeBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => HomeController(
        taskRepository: TaskRepository(taskProvider: TaskProvider()),
      ),
    );
  }
}
