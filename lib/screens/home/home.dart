// ignore_for_file: must_be_immutable, dead_code

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:planner/components/Celander/calender.dart';
import 'package:planner/screens/home/widget/all.dart';
import 'package:planner/screens/home/widget/event/list.dart';
import 'package:planner/screens/home/widget/tab.dart';
import 'package:planner/variables.dart';
import '../../components/customAppBar.dart';

RxInt homeChildIndex = 0.obs;

RxBool scroll = true.obs;
RxDouble scrollOffsetP = 0.0.obs;
double scrollOffset = -1.0;

class Home extends GetView {
  Home({super.key});
  DateTime today = DateTime.now();
  Rx<DateTime> dateSelect = DateTime.now().obs;
  @override
  Widget build(BuildContext context) {
    return Obx(() => Stack(children: [
          MyScaffold(
              appBar: MyCalender.viewWeek(
                  init: selectedDate.value,
                  callback: (DateTime date) {
                    selectedDate.value = date;
                  }),
              expandedAppBar: MyCalender.viewMonth(
                  init: selectedDate.value,
                  callback: (DateTime date) {
                    selectedDate.value = date;
                  }),
              child: Obx(() => selectedDate.value == DateTime.now() ||
                      selectedDate.value != DateTime.now()
                  ? Column(children: [
                      ShowEventInHome(
                        callback: (v) {},
                      ),
                      TabHome()
                    ])
                  : Container())),
          Container(
              padding: const EdgeInsets.only(left: 10),
              alignment: Alignment.bottomLeft,
              child: InkWell(
                  onTap: () {
                    Get.to(homeChildIndex.value == 0
                        ? ShowAll(index: 0.obs)
                        : homeChildIndex.value == 1
                            ? ShowAll(index: 1.obs)
                            : ShowAll(index: 2.obs));
                  },
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(homeChildIndex.value == 0
                            ? 'مشاهده تمام کارها'
                            : homeChildIndex.value == 1
                                ? 'مشاهده تمام یادداشت‌ها'
                                : 'مشاهده تمام هزینه‌ها'),
                        const SizedBox(width: 5),
                        const Icon(
                          Iconsax.arrow_left,
                          size: 20,
                        )
                      ]))),
          if (false)
            Container(
                padding: const EdgeInsets.only(right: 10),
                alignment: Alignment.bottomRight,
                child: InkWell(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                      Text('مشاهده تمام کارها'),
                      SizedBox(width: 5),
                      Icon(
                        Iconsax.arrow_left,
                        size: 20,
                      )
                    ])))
        ]));
  }
}
