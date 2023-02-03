import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:tasksapp/app/core/utils/extention.dart';
import 'package:tasksapp/app/modules/details/widgets/doing_list.dart';
import 'package:tasksapp/app/modules/details/widgets/done_list.dart';
import 'package:tasksapp/app/modules/home/controller.dart';

class DetailPage extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();

  DetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var task = homeCtrl.selectedTask.value!;
    var color = HexColor.fromHex(task.color);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Form(
          key: homeCtrl.formKey,
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.all(3.0.wp),
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Get.back();
                          homeCtrl.updateTodos();
                          homeCtrl.selectTask(null);
                          homeCtrl.editController.clear();
                        },
                        icon: const Icon(Icons.arrow_back)),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0.wp),
                child: Row(
                  children: [
                    Icon(
                      IconData(
                        task.icon,
                        fontFamily: 'MaterialIcons',
                      ),
                      color: color,
                    ),
                    SizedBox(width: 3.0.wp),
                    Text(
                      task.title,
                      style: TextStyle(
                          fontSize: 12.0.sp, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Obx(() {
                var totalTodos =
                    homeCtrl.doingTodos.length + homeCtrl.doneTodos.length;
                return Padding(
                  padding: EdgeInsets.only(
                    top: 3.0.wp,
                    left: 16.0.wp,
                    right: 16.0.wp,
                  ),
                  child: Row(
                    children: [
                      Text(
                        '$totalTodos Tasks',
                        style: TextStyle(fontSize: 12.0.sp, color: Colors.grey),
                      ),
                      SizedBox(width: 3.0.wp),
                      Expanded(
                          child: StepProgressIndicator(
                        totalSteps: totalTodos == 0 ? 1 : totalTodos,
                        currentStep: homeCtrl.doneTodos.length,
                        size: 5,
                        padding: 0,
                        selectedGradientColor: LinearGradient(
                          colors: [color.withOpacity(0.7), color],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        unselectedGradientColor: LinearGradient(
                          colors: [Colors.grey[300]!, Colors.grey[300]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      )),
                    ],
                  ),
                );
              }),
              Padding(
                padding:
                    EdgeInsets.symmetric(vertical: 2.0.wp, horizontal: 5.0.wp),
                child: TextFormField(
                  controller: homeCtrl.editController,
                  autofocus: true,
                  decoration: InputDecoration(
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      prefixIcon: const Icon(
                        Icons.check_box_outline_blank,
                        color: Colors.grey,
                      ),
                      suffixIcon: IconButton(
                          onPressed: () {
                            if (homeCtrl.formKey.currentState!.validate()) {
                              var success = homeCtrl
                                  .addTodo(homeCtrl.editController.text);
                              if (success) {
                                EasyLoading.showSuccess(
                                    'Todo item added successfully');
                              } else {
                                EasyLoading.showError(
                                    'Todo item already exists');
                              }
                              homeCtrl.editController.clear();
                            }
                          },
                          icon: const Icon(
                            Icons.done,
                            color: Colors.green,
                          ))),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your todo item';
                    }
                  },
                ),
              ),
              DoingList(),
              DoneList(),
            ],
          ),
        ),
      ),
    );
  }
}
