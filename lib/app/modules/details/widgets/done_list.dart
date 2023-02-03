import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasksapp/app/core/utils/extention.dart';
import 'package:tasksapp/app/modules/home/controller.dart';

import '../../../core/values/colors.dart';

class DoneList extends StatelessWidget {
  final homeCtrl = Get.find<HomeController>();
  DoneList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => homeCtrl.doneTodos.isNotEmpty
          ? ListView(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 5.0.wp, vertical: 3.0.wp),
                  child: Text(
                    'Completed (${homeCtrl.doneTodos.length})',
                    style: TextStyle(
                      fontSize: 12.0.sp,
                      color: Colors.grey,
                    ),
                  ),
                ),
                ...homeCtrl.doneTodos
                    .map((element) => Dismissible(
                          direction: DismissDirection.endToStart,
                          onDismissed: (_) {
                            homeCtrl.deleteDoneTodo(element);
                          },
                          background: Container(
                            color: Colors.red.withOpacity(0.7),
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding:  EdgeInsets.only(right: 5.0),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          key: ObjectKey(element),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.0.wp),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.done,
                                  color: blue,
                                ),
                                SizedBox(
                                  width: 3.0.wp,
                                ),
                                Text(
                                  element['title'],
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    fontSize: 12.0.sp,
                                    color: Colors.grey,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ))
                    .toList(),
              ],
            )
          : Container(),
    );
  }
}
