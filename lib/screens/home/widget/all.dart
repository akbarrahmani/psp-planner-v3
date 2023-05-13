// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planner/constant.dart';
import 'package:planner/screens/home/widget/cost/all.dart';
import 'package:planner/screens/home/widget/event/all.dart';
import 'package:planner/screens/home/widget/note/all.dart';
import 'package:planner/screens/home/widget/work/all.dart';

class ShowAll extends GetView {
  RxInt index;
  ShowAll({super.key, required this.index});
  RxBool change = false.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: SizedBox(
                width: Get.width - 100,
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Obx(() => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              headItem(
                                  title: 'کارها',
                                  selected: index.value == 0,
                                  onTap: () {
                                    index.value = 0;
                                  }),
                              headItem(
                                  title: 'هزینه‌ها',
                                  selected: index.value == 2,
                                  onTap: () {
                                    index.value = 2;
                                  }),
                              headItem(
                                  title: 'یادداشت‌ها',
                                  selected: index.value == 1,
                                  onTap: () {
                                    index.value = 1;
                                  }),
                              headItem(
                                  title: 'رویدادها',
                                  selected: index.value == 3,
                                  onTap: () {
                                    index.value = 3;
                                  }),
                            ]))))),
        body: Obx(
          () => index.value == 0
              ? const AllWork()
              : index.value == 1
                  ? const AllNote()
                  : index.value == 2
                      ? const AllCost()
                      : const AllEvent(),
        ));
  }

  headItem({String? title, bool selected = false, onTap}) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: InkWell(
            onTap: () => onTap(),
            borderRadius: BorderRadius.circular(10),
            child: Container(
                //margin: margin,
                height: 34,
                width: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: selected ? orange : Colors.transparent,
                    border: selected ? null : Border.all(color: grey, width: 1),
                    borderRadius: BorderRadius.circular(10)),
                // padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  title!,
                  style: TextStyle(
                      color: selected ? Colors.white : grey,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ))));
  }
}
