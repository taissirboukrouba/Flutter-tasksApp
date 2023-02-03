import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:tasksapp/app/core/utils/extention.dart';
import 'package:tasksapp/app/modules/home/controller.dart';

class AddDialogue extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();
  AddDialogue({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // will pop scope disactivates the return button of the android device
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () {
                          Get.back();
                          homeCtrl.editController.clear();
                          homeCtrl.selectTask(null);
                        },
                        icon: const Icon(Icons.close)),
                    TextButton(
                        style: ButtonStyle(
                            overlayColor:
                                MaterialStateProperty.all(Colors.transparent)),
                        onPressed: () {
                          if (homeCtrl.formKey.currentState!.validate()) {
                            if (homeCtrl.selectedTask.value == null) {
                              EasyLoading.showError('Please Select task type');
                            } else {
                              var success = homeCtrl.updateTask(
                                homeCtrl.selectedTask.value!,
                                homeCtrl.editController.text,
                              );
                              if (success) {
                                EasyLoading.showSuccess(
                                    'Todo item Added Successfully');
                                Get.back();
                                homeCtrl.selectedTask(null);
                              } else {
                                EasyLoading.showError(
                                    'Todo item Already Exists');
                              }
                              homeCtrl.editController.clear();
                            }
                          }
                        },
                        child: Text(
                          'Done',
                          style: TextStyle(fontSize: 14.0.sp),
                        )),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0.wp),
                child: Text(
                  'New  Task',
                  style:
                      TextStyle(fontSize: 20.0.sp, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0.wp),
                child: TextFormField(
                  controller: homeCtrl.editController,
                  decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[300]!))),
                  autofocus: true,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your todo item !';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: 5.0.wp, left: 5.0.wp, right: 5.0.wp, bottom: 2.0.wp),
                child: Text(
                  'Add to',
                  style: TextStyle(fontSize: 14.0.sp, color: Colors.grey),
                ),
              ),
              ...homeCtrl.tasks
                  .map((element) => Obx(
                        () => InkWell(
                          onTap: () => homeCtrl.selectTask(element),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 3.0.wp, horizontal: 5.0.wp),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      IconData(element.icon,
                                          fontFamily: 'MaterialIcons'),
                                      color: HexColor.fromHex(element.color),
                                    ),
                                    SizedBox(
                                      width: 3.0.wp,
                                    ),
                                    Text(
                                      element.title,
                                      style: TextStyle(
                                          fontSize: 12.0.sp,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                if (homeCtrl.selectedTask.value == element)
                                  const Icon(
                                    Icons.check,
                                    color: Colors.blue,
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }
}
