// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:planner/screens/home/widget/all.dart';
import 'package:planner/screens/home/widget/event/add.dart';
import 'package:shamsi_date/shamsi_date.dart';

import '../../../../components/bottomSheet.dart';
import '../../../../constant.dart';
import '../../../../dbModels/models.dart';
import '../../../../variables.dart';

class ShowEventInHome extends GetView {
  var callback;
  ShowEventInHome({super.key, required this.callback});
  RxBool change = false.obs;
  List<Event> dayEvent = [];

  @override
  Widget build(BuildContext context) {
    initpage();
    return Obx(() => change.isFalse || change.isTrue
        ? InkWell(
            onTap: () => dayEvent.isNotEmpty ? showDayEvent() : null,
            child: Container(
                height: 35,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Obx(() => Row(children: [
                            if (dayEvent.isNotEmpty)
                              CircleAvatar(
                                maxRadius: 10,
                                backgroundColor: orange.withOpacity(0.8),
                                child: Text(
                                  '${dayEvent.length}',
                                  style: const TextStyle(
                                      height: 1, color: Colors.white),
                                ),
                              ),
                            const SizedBox(width: 5),
                            Text(dayEvent.isNotEmpty
                                ? 'رویداد در ${selectedDate.value.toJalali().day} ${selectedDate.value.toJalali().formatter.mN} ${selectedDate.value.toJalali().year} دارید'
                                : 'در ${selectedDate.value.toJalali().day} ${selectedDate.value.toJalali().formatter.mN} ${selectedDate.value.toJalali().year} رویدادی ندارید'),
                          ])), //  'رویدادهای من در ${selectedDate.value.toJalali().day} ${selectedDate.value.toJalali().formatter.mN} ${selectedDate.value.toJalali().year}')),
                      if (dayEvent.isNotEmpty)
                        Icon(
                          Iconsax.arrow_left,
                          color: grey,
                          size: 20,
                        ),
                      if (dayEvent.isEmpty)
                        InkWell(
                            onTap: () {
                              Get.back();
                              Get.to(ShowAll(index: 3.obs));
                            },
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'مشاهده تمام رویدادها',
                                    style: TextStyle(
                                      color: grey,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Icon(Iconsax.arrow_left,
                                      size: 20, color: grey)
                                ])),
                    ])))
        : Container());
  }

  initpage() async {
    if (event.isNotEmpty) dayEvent = [];
    Jalali jd = selectedDate.value.toJalali();
    dayEvent = event.values
        .where((element) =>
            element.date != '' &&
            '${jd.day}${jd.month}' ==
                '${element.effDate.split('/')[1]}${element.effDate.split('/')[0]}')
        .toList();
  }

  showDayEvent() {
    MyBottomSheet.view(
        Obx(() => change.isFalse || change.isTrue
            ? Column(children: [
                Text(
                  'رویدادهای من در ${selectedDate.value.toJalali().formatter.wN} ${selectedDate.value.toJalali().day} ${selectedDate.value.toJalali().formatter.mN} ${selectedDate.value.toJalali().year}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Column(
                    children: dayEvent
                        .map((e) => EventItem(
                              item: e,
                              callback: (v) {
                                initpage();
                                change.toggle();
                                callback(v);
                              },
                            ))
                        .toList()),
                Container(
                  padding: const EdgeInsets.only(top: 20),
                  alignment: Alignment.bottomLeft,
                  child: InkWell(
                      onTap: () {
                        Get.back();
                        Get.to(ShowAll(index: 3.obs));
                      },
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: const [
                            Text('مشاهده تمام رویدادها'),
                            SizedBox(width: 5),
                            Icon(
                              Iconsax.arrow_left,
                              size: 20,
                            )
                          ])),
                )
              ])
            : Container()),
        h: (dayEvent.length >= 10) ? 600 : 100 + (dayEvent.length * 50));
  }
}

class EventItem extends GetView {
  Event item;
  var callback;
  EventItem({super.key, required this.item, required this.callback});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 10),
      height: 50,
      child: Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [
            const Icon(Iconsax.notification, size: 18),
            const SizedBox(width: 5),
            Text(
              item.title,
              style: const TextStyle(fontSize: 16),
            )
          ]),
          IconButton(
              onPressed: () => {
                    Get.back(),
                    addEvent(item: item, callback: (v) => callback(v))
                  },
              icon: Icon(
                Iconsax.edit_2,
                size: 18,
                color: grey,
              ))
        ]),
        Container(
          height: 1,
          width: Get.width,
          margin: const EdgeInsets.only(right: 20),
          color: darkMode.isTrue ? Colors.grey.shade800 : Colors.grey.shade300,
        )
      ]),
    );
  }
}
