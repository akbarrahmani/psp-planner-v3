// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:planner/components/Celander/calender.dart';
import 'package:planner/components/bottomSheet.dart';
import 'package:planner/components/button.dart';
import 'package:planner/components/textInput.dart';
import 'package:planner/components/toast.dart';
import 'package:planner/constant.dart';
import 'package:planner/dbModels/models.dart';
import 'package:planner/screens/home/widget/work/add.dart';
import 'package:planner/service/notifications/notification.dart';
import 'package:planner/variables.dart';
import 'package:shamsi_date/shamsi_date.dart';

class ShowWorkInHome extends GetView {
  var callback;
  ShowWorkInHome({super.key, required this.callback});
  RxBool change = false.obs;
  List<Work> dayWork = [];
  @override
  Widget build(BuildContext context) {
    initpage();
    return Obx(() => change.isFalse || change.isTrue
        ? Column(
            children: dayWork
                .map((e) => WorkItem(
                      item: e,
                      callback: (v) {
                        change.toggle();
                        callback('v');
                      },
                    ))
                .toList())
        : Container());
  }

  initpage() {
    dayWork = [];
    dayWork = work.values
        .where((element) =>
            element.startDate != '' &&
            '${selectedDate.value.day}${selectedDate.value.month}${selectedDate.value.year}' ==
                '${DateTime.parse(element.startDate).day}${DateTime.parse(element.startDate).month}${DateTime.parse(element.startDate).year}')
        .toList();
    dayWork.sort((a, b) =>
        DateTime.parse(a.startDate).compareTo(DateTime.parse(b.startDate)));
  }
}

class WorkItem extends GetView {
  Work? item;
  var callback;
  WorkItem({required this.item, required this.callback, super.key});

  @override
  Widget build(BuildContext context) {
    RxBool change = false.obs;
    return Column(children: [
      Obx(() => change.isFalse || change.isTrue
          ? SwipeActionCell(
              index: item!.id,
              key: ValueKey(item!.id),
              firstActionWillCoverAllSpaceOnDeleting: false,
              closeWhenScrolling: false,
              trailingActions: [
                if (item!.postponed == 0)
                  SwipeAction(
                      title: !item!.check ? "انجام شده" : "انجام نشده",
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                      icon: Icon(
                        !item!.check
                            ? Iconsax.tick_circle
                            : Iconsax.close_circle,
                        color: Colors.white,
                      ),
                      color: !item!.check ? orange : Colors.red,
                      widthSpace: 100,
                      forceAlignmentToBoundary: true,
                      performsFirstActionWithFullSwipe: true,
                      nestedAction: item!.check
                          ? SwipeNestedAction(title: "تغییر به انجام نشده")
                          : null,
                      onTap: (handler) async {
                        handler(false);
                        _toDo(item!, (v) => callback('v'));
                      }),
                if (item!.postponed == 0 && !item!.check)
                  SwipeAction(
                      title: "موکول به آینده",
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                      icon: const Icon(
                        Iconsax.arrow_up_1,
                        color: Colors.white,
                      ),
                      color: Colors.blue,
                      widthSpace: 100,
                      forceAlignmentToBoundary: true,
                      performsFirstActionWithFullSwipe: true,
                      onTap: (handler) async {
                        handler(false);
                        _postponed(item!, (v) => callback('v'));
                      }),
              ],
              leadingActions: const [],
              child: Container(
                  padding: const EdgeInsets.only(
                      right: 10, bottom: 5, top: 5, left: 10),
                  height: 50,
                  child: InkWell(
                      onTap: () =>
                          _workItemDetails(item!, (v) => callback('v')),
                      child: Row(children: [
                        CircleAvatar(
                          backgroundColor: _checkStatus(item!) == 0
                              ? grey
                              : _checkStatus(item!) == 1
                                  ? Colors.red
                                  : _checkStatus(item!) == 2
                                      ? orange
                                      : Colors.blue,
                          child: Icon(
                            _checkStatus(item!) == 0
                                ? Iconsax.timer
                                : _checkStatus(item!) == 1
                                    ? Iconsax.close_circle
                                    : _checkStatus(item!) == 2
                                        ? Iconsax.tick_circle
                                        : Iconsax.arrow_up_1,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                            child: Row(children: [
                          Flexible(
                              fit: FlexFit.tight,
                              child: Text(
                                item!.title,
                                style: TextStyle(
                                    fontSize: 16,
                                    decoration: item!.check
                                        ? TextDecoration.lineThrough
                                        : null,
                                    fontWeight: item!.check
                                        ? FontWeight.normal
                                        : FontWeight.bold),
                              )),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _checkStatus(item!) == 0
                                      ? 'درانتظار'
                                      : _checkStatus(item!) == 1
                                          ? 'انجام نشده'
                                          : _checkStatus(item!) == 2
                                              ? _workTime(item!)
                                              : 'موکول شده',
                                  style: TextStyle(color: grey, fontSize: 12),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'ایجاد شده در: ${DateConvertor.toJalaliShort(DateTime.parse(item!.date))}',
                                  style: TextStyle(fontSize: 10, color: grey2),
                                )
                              ])
                        ]))
                      ]))))
          : Container()),
      Container(
        height: 1,
        width: Get.width,
        margin: const EdgeInsets.only(right: 60),
        color: darkMode.isTrue ? Colors.grey.shade800 : Colors.grey.shade300,
      )
    ]);
  }
}

String _workTime(Work item) {
  if (item.endTime != '') {
    try {
      int jdn = DateTime.parse(item.endTime)
          .difference(DateTime.parse(item.startDate))
          .inMinutes;
      return 'انجام شده(${(jdn / 60).toString().split('.')[0]}:${(jdn % 60).toStringAsFixed(0)})';
    } catch (e) {
      return 'انجام شده(${item.endTime})';
    }
  }
  return 'انجام شده (بدون زمان)';
}

_workItemDetails(Work item, callback) {
  String jsd = 'بدون زمان‌بندی';
  String jnd = 'بدون اعلان';
  String jed = _workTime(item);
  var jdd = DateTime.parse(item.startDate).toJalali();
  jsd = '${jdd.day} ${jdd.formatter.mN} ${jdd.year} ${jdd.hour}:${jdd.minute}';
  if (item.notifTime != '') {
    var jdn = DateTime.parse(item.notifTime).toJalali();
    jnd =
        '${jdn.day} ${jdn.formatter.mN} ${jdn.year} ${jdn.hour}:${jdn.minute}';
  }

  MyBottomSheet.view(
      Column(children: [
        MyInput(
          controller: TextEditingController(text: item.title),
          title: 'عنوان',
          icon: Iconsax.briefcase,
          type: InputType.text,
          readOnly: true,
        ),
        MyInput(
          controller: TextEditingController(text: item.desc),
          title: 'توضیحات',
          icon: Iconsax.document,
          line: 3,
          type: InputType.text,
          readOnly: true,
        ),
        MyInput(
          controller: TextEditingController(text: jsd),
          title: 'تاریخ و ساعت',
          icon: Iconsax.clock,
          type: InputType.text,
          readOnly: true,
        ),
        if (setting.getAt(0)!.timeAtWork!)
          MyInput(
            title: 'مدت زمان انجام کار',
            controller: TextEditingController(text: jed),
            type: InputType.text,
            icon: Iconsax.clock_1,
            readOnly: true,
          ),
        MyInput(
          title: 'اعلان',
          controller: TextEditingController(text: jnd),
          readOnly: true,
          type: InputType.text,
          line: 1,
          icon: Iconsax.notification,
        ),
        MyInput(
          title: 'دسته‌بندی',
          type: InputType.text,
          icon: Iconsax.category,
          controller: TextEditingController(
              text: workCat.values
                  .where((element) => element.id == item.cat)
                  .toList()[0]
                  .name),
          required: true,
          readOnly: true,
        ),
        const SizedBox(height: 10),
        if (item.postponed != 0)
          Container(
              height: 35,
              width: Get.width,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: orange.withOpacity(0.5)),
              child: Text(
                'به ${DateConvertor.toJalaliShort(DateTime.parse(work.values.where((element) => element.id == item.postponed).toList()[0].startDate))} موکول شد.',
                style: const TextStyle(fontSize: 16),
              )),
        if (item.postponed == 0)
          Row(children: [
            MyButton(
              title: !item.check ? "انجام شده" : "تغییر به انجام نشده",
              // style: const TextStyle(fontSize: 14, color: Colors.white),
              icon: !item.check ? Iconsax.tick_circle : Iconsax.close_circle,
              bgColor: !item.check ? orange : Colors.red,
              textColor: Colors.white,
              onTap: () {
                Get.back();
                _toDo(item, (v) => callback('v'));
              },
            ),
            if (!item.check) const SizedBox(width: 10),
            if (!item.check)
              MyButton(
                title: 'موکول به آینده',
                bgColor: Colors.blue,
                textColor: Colors.white,
                onTap: () {
                  Get.back();
                  _postponed(item, (v) => callback('v'));
                },
              )
          ]),
        if (item.postponed == 0) const SizedBox(height: 10),
        if (item.postponed == 0)
          Row(children: [
            MyButton(
              title: 'ویرایش',
              bgColor: grey,
              textColor: grey,
              icon: Iconsax.edit,
              onTap: () {
                Get.back();
                addWork(
                    item: item,
                    callback: (v) {
                      callback(v);
                    });
              },
              borderOnly: true,
            )
          ])
      ]),
      h: setting.getAt(0)!.timeAtWork!
          ? item.postponed == 0
              ? 520
              : 475
          : item.postponed == 0
              ? 460
              : 415);
}

_postponed(Work item, callback) {
  MyCalender.picker(
      start: DateTime.parse(item.startDate),
      init: DateTime.parse(item.startDate),
      callback: (DateTime v) async {
        if (v.isAfter(DateTime.parse(item.startDate))) {
          String nt = '';
          if (item.notifTime != '') {
            int dr = DateTime.parse(item.notifTime)
                .difference(DateTime.parse(item.startDate))
                .inMinutes;
            nt = v.add(Duration(minutes: dr)).toIso8601String();
          }
          Work newItem = Work(
              id: work.getAt(work.length - 1)!.id + 1,
              title: item.title,
              desc: item.desc,
              startDate: v.toIso8601String(),
              endTime: '',
              notifTime: nt,
              cat: item.cat,
              check: false,
              date: item.date,
              project: item.project,
              repeat: item.repeat,
              parent: item.id,
              postponed: 0);

          await work.add(newItem);
          for (var i = 0; i < work.length; i++) {
            if (work.getAt(i)!.id == item.id) {
              item.postponed = newItem.id;
              await work.putAt(i, item);
              MyNotification.cancelNotification(int.parse('2${item.id}'));
              break;
            }
          }
          callback('v');
        } else {
          MyToast.error(
              'امکان موکول کردن کار به روز و یا ساعات قبل وجود ندارد!');
        }
      },
      time: true);
}

_toDo(Work item, callback) async {
  if (setting.getAt(0)!.timeAtWork! && !item.check) {
    String min = '00';
    String hour = '00';
    bool check = false;
    await MyBottomSheet.view(
        Column(children: [
          const Text(
            'زمان انجام کار را بر اساس ساعت و دقیقه مشخص کنید.',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          SizedBox(
              // width: 300,
              height: 100,
              child: Row(children: [
                Flexible(
                    child: Stack(children: [
                  CupertinoPicker(
                    backgroundColor: Colors.white,
                    itemExtent: 30,
                    scrollController:
                        FixedExtentScrollController(initialItem: 0),
                    // This is called when selected item is changed.
                    onSelectedItemChanged: (v) {
                      min = v.toString().length == 1 ? '0$v' : '$v';
                      check = false;
                    },
                    children: List<Widget>.generate(60, (int index) {
                      return Center(
                        child: Text(
                          index.toString().length == 1 ? '0$index' : '$index',
                          style: const TextStyle(fontFamily: 'iran'),
                        ),
                      );
                    }),
                  ),
                  Container(
                      alignment: Alignment.topCenter,
                      child: const Text(
                        'دقیقه',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )),
                ])),
                Flexible(
                    child: Stack(children: [
                  CupertinoPicker(
                    backgroundColor: Colors.white,
                    itemExtent: 30,
                    scrollController:
                        FixedExtentScrollController(initialItem: 0),
                    // This is called when selected item is changed.
                    onSelectedItemChanged: (v) {
                      hour = v.toString().length == 1 ? '0$v' : '$v';
                      check = false;
                    },
                    children: List<Widget>.generate(1001, (int index) {
                      return Center(
                        child: Text(
                          index.toString().length == 1 ? '0$index' : '$index',
                          style: const TextStyle(fontFamily: 'iran'),
                        ),
                      );
                    }),
                  ),
                  Container(
                      alignment: Alignment.topCenter,
                      child: const Text(
                        'ساعت',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )),
                ])),
              ])),
          const SizedBox(height: 10),
          Row(children: [
            MyButton(
                title: "تایید",
                icon: Iconsax.tick_circle,
                bgColor: !item.check ? orange : Colors.red,
                textColor: Colors.white,
                onTap: () async {
                  if (min == '00' && hour == '00' && !check) {
                    check = true;
                    return MyToast.info(
                        'زمان انتخابی صفر است!\nدرصورت اطمینان مجددا تایید کنید.');
                  }
                  for (var i = 0; i < work.length; i++) {
                    if (work.getAt(i)!.id == item.id) {
                      item.check = !item.check;
                      item.endTime = '$hour:$min';
                      await work.putAt(i, item);
                      callback('v');
                      Get.back();
                      break;
                    }
                  }
                }),
            const SizedBox(width: 10),
            MyButton(
              title: 'انصراف',
              bgColor: grey,
              textColor: grey,
              borderOnly: true,
              onTap: () => Get.back(),
            )
          ])
        ]),
        h: 220);
  } else {
    for (var i = 0; i < work.length; i++) {
      if (work.getAt(i)!.id == item.id) {
        item.check = !item.check;
        item.endTime = '';
        await work.putAt(i, item);
        callback('v');
        Get.back();
        break;
      }
    }
  }
}

int _checkStatus(Work item) {
  if (item.postponed > 0) {
    return 3;
  }
  if (item.check) {
    return 2;
  }
  if (item.startDate != '' &&
      DateTime.parse(item.startDate).isBefore(DateTime.now())) {
    return 1;
  }
  return 0;
}
