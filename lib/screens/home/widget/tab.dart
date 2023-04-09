// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planner/components/button.dart';
import 'package:planner/constant.dart';
import 'package:planner/screens/home/home.dart';
import 'package:planner/screens/home/widget/work/list.dart';
import 'package:planner/screens/home/widget/note/list.dart';
import 'package:planner/screens/home/widget/cost/list.dart';

class TabHome extends GetView {
  TabHome({super.key});
  RxBool change = false.obs;
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Obx(() => change.isTrue || change.isFalse
            ? Column(children: [
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(children: [
                      MyButton(
                          title: 'کارها',
                          bgColor: grey.withOpacity(0.8),
                          textColor: homeChildIndex.value != 0
                              ? grey.withOpacity(0.8)
                              : Colors.white,
                          borderOnly: homeChildIndex.value != 0,
                          onTap: () => {
                                homeChildIndex.value = 0,
                                // scrollControllerHome.animateTo(0.0,
                                //     duration: const Duration(milliseconds: 100),
                                //     curve: Curves.linear)
                              }),
                      const SizedBox(width: 10),
                      MyButton(
                          title: 'یادداشت‌ها',
                          bgColor: grey.withOpacity(0.8),
                          textColor: homeChildIndex.value != 1
                              ? grey.withOpacity(0.8)
                              : Colors.white,
                          borderOnly: homeChildIndex.value != 1,
                          onTap: () => {
                                homeChildIndex.value = 1,
                                // scrollControllerHome.animateTo(0.0,
                                //     duration: const Duration(milliseconds: 100),
                                //     curve: Curves.linear)
                              }),
                      const SizedBox(width: 10),
                      MyButton(
                          title: 'هزینه‌ها',
                          bgColor: grey.withOpacity(0.8),
                          textColor: homeChildIndex.value != 2
                              ? grey.withOpacity(0.8)
                              : Colors.white,
                          borderOnly: homeChildIndex.value != 2,
                          onTap: () => {
                                homeChildIndex.value = 2,
                                // scrollControllerHome.animateTo(0.0,
                                //     duration: const Duration(milliseconds: 100),
                                //     curve: Curves.linear)
                              })
                    ])),
                const SizedBox(height: 5),
                Expanded(
                    child: SingleChildScrollView(
                        child: Obx(() => homeChildIndex.value == 0
                            ? ShowWorkInHome(
                                callback: (v) {
                                  change.toggle();
                                },
                              )
                            : homeChildIndex.value == 1
                                ? ShowNoteInHome(
                                    callback: (v) {
                                      change.toggle();
                                    },
                                  )
                                : ShowCostInHome(
                                    callback: (v) {
                                      change.toggle();
                                    },
                                  ))))
              ])
            : Container()));
  }
}
