import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:tasksapp/app/core/utils/extention.dart';
import 'package:tasksapp/app/core/values/colors.dart';
import 'package:tasksapp/app/modules/home/controller.dart';
import 'package:tasksapp/app/widgets/icons.dart';

import '../../../data/models/task.dart';

class AddCard extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();
  AddCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final icons = getIcons();
    var squareWidth = Get.width - 12.0.wp;

    return Container(
      width: squareWidth / 2,
      height: squareWidth / 2,
      margin: EdgeInsets.all(3.0.wp),
      child: InkWell(
        onTap: () async {
          await Get.defaultDialog(
            titlePadding: EdgeInsets.symmetric(vertical: 5.0.wp),
            radius: 5,
            title: 'Task Type',
            content: Form(
              key: homeCtrl.formKey,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 3.0.wp),
                    child: TextFormField(
                      controller: homeCtrl.editController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Title',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your task title';
                        }
                        return null; // else don't do anything
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.0.wp),
                    child: Wrap(
                      spacing: 2.0.wp,
                      children: icons
                          .map((e) => Obx(() {
                                final index = icons.indexOf(e);
                                return ChoiceChip(
                                  selectedColor: Colors.grey[200],
                                  elevation: 0,
                                  backgroundColor: Colors.white,
                                  label: e,
                                  selected: homeCtrl.chipIndex.value == index,
                                  onSelected: (bool selected) {
                                    homeCtrl.chipIndex.value =
                                        selected ? index : 0;
                                  },
                                );
                              }))
                          .toList(),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (homeCtrl.formKey.currentState!.validate()) {
                        // means if the form is validated we're copying it's elements
                        int icon =
                            icons[homeCtrl.chipIndex.value].icon!.codePoint;
                        String color =
                            icons[homeCtrl.chipIndex.value].color!.toHex();
                        var task = Task(
                            title: homeCtrl.editController.text,
                            icon: icon,
                            color: color);
                        Get.back();
                        homeCtrl.addTask(task)
                            ? EasyLoading.showSuccess('Creation Succeeded')
                            : EasyLoading.showError(
                                'Duplicate Detected'); // closing the dialogue
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      minimumSize: const Size(150, 40),
                    ),
                    child: const Text('Confirm'),
                  ),
                ],
              ),
            ),
          );
          homeCtrl.editController.clear();
          homeCtrl.changeChipIndex(0);
        },
        child: DottedBorder(
          color: Colors.grey[400]!,
          dashPattern: const [8, 4],
          child: Center(
            child: Icon(
              Icons.add,
              color: Colors.grey[400],
              size: 10.0.wp,
            ),
          ),
        ),
      ),
    );
  }
}
