// ignore_for_file: unused_local_variable

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:planner/components/Celander/calender.dart';
import 'package:planner/components/MyDropDown/screen.dart';
import 'package:planner/components/bottomSheet.dart';
import 'package:planner/components/button.dart';
import 'package:planner/components/textInput.dart';
import 'package:planner/components/toast.dart';
import 'package:planner/constant.dart';
import 'package:planner/dbModels/models.dart';
import 'package:planner/function/google.dart';
import 'package:planner/screens/home/widget/work/cat/select.dart';
import 'package:planner/service/notifications/notification.dart';
import 'package:planner/variables.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:googleapis/calendar/v3.dart' as gc;

addWork({Work? item, callback}) {
  DateTime startDate;
  DateTime endTime;
  DateTime notifTime;
  RxInt priority = 1.obs;
  RxInt repeatPeriod = 0.obs;
  RxInt repeatCount = 0.obs;
  final title = TextEditingController(),
      desc = TextEditingController(),
      startDateCtl = TextEditingController(),
      endTimeCtl = TextEditingController(),
      notifTimeCtl = TextEditingController(),
      cat = TextEditingController(),
      repeat = TextEditingController(),
      repeatEnd = TextEditingController(),
      repeatPeriodCtl = TextEditingController(text: 'بدون تکرار');
  final tf = FocusNode(),
      descf = FocusNode(),
      sdf = FocusNode(),
      etf = FocusNode(),
      ntf = FocusNode(),
      cf = FocusNode(),
      rf = FocusNode(),
      rpf = FocusNode();

  int c = 0;
  RxBool wdo = false.obs, noTime = false.obs;
  int? catId;
  var repeatDate = [];

  startDate = DateTime(selectedDate.value.year, selectedDate.value.month,
      selectedDate.value.day, DateTime.now().hour, DateTime.now().minute);

  var jd = startDate.toJalali();
  startDateCtl.text =
      '${jd.day} ${jd.formatter.mN} ${jd.year} ${jd.hour}:${jd.minute}';
  notifTimeCtl.text = 'یک روز قبل';
  notifTime = startDate.add(const Duration(days: -1));
  if (item != null) {
    Timer(const Duration(milliseconds: 50), () {
      title.text = item.title;
      desc.text = item.desc;
      startDate = DateTime.parse(item.startDate);
      var jdd = startDate.toJalali();
      startDateCtl.text =
          '${jdd.day} ${jdd.formatter.mN} ${jdd.year} ${jdd.hour}:${jdd.minute}';
      if (item.endTime != '') {
        if (item.endTime.length > 5) {
          endTime = DateTime.parse(item.endTime);
          var en = DateTime.parse(item.startDate).difference(endTime);
          int h = int.parse((en.inMinutes / 60).toString().split('.')[0]);
          int m = en.inMinutes - (h * 60);
          endTimeCtl.text = '$h:$m';
        } else {
          endTimeCtl.text = item.endTime;
        }
      }
      if (item.notifTime != '') {
        notifTime = DateTime.parse(item.notifTime);
        jdd = notifTime.toJalali();
        notifTimeCtl.text =
            '${jdd.day} ${jdd.formatter.mN} ${jdd.year} ${jdd.hour}:${jdd.minute}';
      }
      catId = item.cat;
      cat.text = workCat.values
          .where((element) => element.id == item.cat)
          .toList()[0]
          .name;
      priority.value = item.priority;
    });
  }

  MyBottomSheet.view(
      Column(children: [
        const SizedBox(height: 10),
        Text(
          item == null ? 'ثبت کار جدید' : 'ویرایش کار',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        const SizedBox(height: 10),
        Row(children: [
          Flexible(
            child: MyInput(
              title: 'عنوان',
              controller: title,
              focusNode: tf,
              nextFocusNode: descf,
              textInputAction: TextInputAction.next,
              required: true,
              type: InputType.text,
              icon: Iconsax.briefcase,
            ),
          ),
          if (setting.getAt(0)!.workPriority!)
            Row(children: [
              Container(
                  margin: const EdgeInsets.all(3),
                  child: InkWell(
                      onTap: () {
                        priority.value = 2;
                      },
                      child: Obx(() => Icon(
                            Iconsax.arrow_square_up,
                            size: 40,
                            color: priority.value == 2 ? Colors.green : grey,
                          )))),
              Container(
                margin: const EdgeInsets.all(3),
                child: InkWell(
                    onTap: () {
                      priority.value = 1;
                    },
                    child: Obx(() => Icon(
                          Iconsax.minus_square,
                          size: 40,
                          color: priority.value == 1 ? Colors.amber : grey,
                        ))),
              ),
              Container(
                  margin: const EdgeInsets.all(3),
                  child: InkWell(
                      onTap: () {
                        priority.value = 0;
                      },
                      child: Obx(() => Icon(
                            Iconsax.arrow_square_down,
                            size: 40,
                            color: priority.value == 0 ? Colors.red : grey,
                          )))),
            ])
        ]),
        MyInput(
          title: 'توضیحات',
          controller: desc,
          focusNode: descf,
          type: InputType.text,
          line: 3,
          icon: Iconsax.document,
        ),
        MyInput(
          title: 'تاریخ و ساعت',
          controller: startDateCtl,
          focusNode: sdf,
          type: InputType.text,
          icon: Iconsax.clock,
          readOnly: true,
          onTap: () => MyCalender.picker(
              time: true,
              noTime: true,
              callback: (v) {
                if (v != null && v != 'cancel') {
                  startDate = DateTime.parse(v.toString());
                  var jd = startDate.toJalali();
                  startDateCtl.text =
                      '${jd.day} ${jd.formatter.mN} ${jd.year} ${jd.hour}:${jd.minute}';
                  noTime.value = false;
                  if (startDate
                      .add(const Duration(days: -1))
                      .isAfter(DateTime.now())) {
                    notifTimeCtl.text = 'یک روز قبل';
                    notifTime = startDate.add(const Duration(days: -1));
                  } else if (startDate
                      .add(const Duration(hours: -1))
                      .isAfter(DateTime.now())) {
                    notifTimeCtl.text = 'یک ساعت قبل';
                    notifTime = startDate.add(const Duration(hours: -1));
                  } else {
                    notifTimeCtl.text = 'بدون اعلان';
                  }
                } else if (v == null) {
                  startDateCtl.text = 'بدون زمان‌بندی';
                  notifTimeCtl.text = 'بدون اعلان';
                  repeatPeriodCtl.text = 'بدون تکرار';
                  repeatPeriod.value = 0;
                  noTime.value = true;
                }
              }),
        ),
        if (item != null)
          MyInput(
              title: 'مدت زمان انجام کار',
              controller: endTimeCtl,
              focusNode: etf,
              type: InputType.text,
              icon: Iconsax.clock_1,
              readOnly: true,
              onTap: () async {
                String min = '00';
                String hour = '00';
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
                                },
                                children:
                                    List<Widget>.generate(60, (int index) {
                                  return Center(
                                    child: Text(
                                      index.toString().length == 1
                                          ? '0$index'
                                          : '$index',
                                      style:
                                          const TextStyle(fontFamily: 'iran'),
                                    ),
                                  );
                                }),
                              ),
                              Container(
                                  alignment: Alignment.topCenter,
                                  child: const Text(
                                    'دقیقه',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
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
                                  hour =
                                      v.toString().length == 1 ? '0$v' : '$v';
                                },
                                children:
                                    List<Widget>.generate(1001, (int index) {
                                  return Center(
                                    child: Text(
                                      index.toString().length == 1
                                          ? '0$index'
                                          : '$index',
                                      style:
                                          const TextStyle(fontFamily: 'iran'),
                                    ),
                                  );
                                }),
                              ),
                              Container(
                                  alignment: Alignment.topCenter,
                                  child: const Text(
                                    'ساعت',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
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
                              endTimeCtl.text = '$hour:$min';
                              Get.back();
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
              }),
        if (item == null)
          Obx(() => noTime.isTrue
              ? MyInput(
                  title: 'بدون تکرار',
                  controller: repeatPeriodCtl,
                  focusNode: rpf,
                  readOnly: true,
                  type: InputType.text,
                  line: 1,
                  icon: Iconsax.repeat,
                )
              : Container(
                  margin: const EdgeInsets.all(5),
                  // padding: const EdgeInsets.only(right: 10),
                  height: 40.0,
                  decoration: BoxDecoration(
                      color: (Get.isDarkMode ? grey : Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(children: [
                    Flexible(
                        child: MyDropdown(
                            margin: EdgeInsets.zero,
                            items: const [
                              'بدون تکرار',
                              'روزانه',
                              'هفتگی',
                              'ماهیانه'
                            ],
                            onChanged: (p0) {
                              // repeatCountCtl.initialItem = 0;
                              if (p0 == 'بدون تکرار') {
                                repeatPeriod.value = 0;
                              } else if (p0 == 'روزانه') {
                                repeatPeriod.value = 1;
                              } else if (p0 == 'هفتگی') {
                                repeatPeriod.value = 2;
                              } else if (p0 == 'ماهیانه') {
                                repeatPeriod.value = 3;
                              }
                            },
                            icon: Iconsax.repeat,
                            hintText: 'روتین',
                            focusNode: rpf,
                            controller: repeatPeriodCtl)),
                  ]))),
        Obx(() => noTime.isTrue
            ? MyInput(
                title: 'اعلان',
                controller: notifTimeCtl,
                focusNode: ntf,
                readOnly: true,
                type: InputType.text,
                line: 1,
                icon: Iconsax.notification,
              )
            : MyDropdown(
                items: const [
                    'بدون اعلان',
                    'درلحظه',
                    'یک ساعت قبل',
                    'یک روز قبل',
                    'سفارشی'
                  ],
                onChanged: (p0) {
                  if (p0 == 'سفارشی') {
                    MyCalender.picker(
                        time: true,
                        end: startDate,
                        callback: (v) {
                          if (v != 'cancel') {
                            notifTime = DateTime.parse(v.toString());
                            var jd = notifTime.toJalali();
                            notifTimeCtl.text =
                                '${jd.day} ${jd.formatter.mN} ${jd.year} ${jd.hour}:${jd.minute}';
                          } else {
                            notifTimeCtl.text = 'بدون اعلان';
                          }
                        });
                  } else if (p0 == 'درلحظه') {
                    notifTime = startDate;
                  } else if (p0 == 'یک ساعت قبل') {
                    notifTime = startDate.add(const Duration(hours: -1));
                  } else if (p0 == 'یک روز قبل') {
                    notifTime = startDate.add(const Duration(days: -1));
                  }
                },
                icon: Iconsax.notification,
                hintText: 'اعلان',
                focusNode: ntf,
                controller: notifTimeCtl)),
        MyInput(
          title: 'دسته‌بندی',
          controller: cat,
          focusNode: cf,
          required: true,
          readOnly: true,
          onTap: () {
            workCatSelect(
                selected: cat.text,
                callback: (WorkCat e) {
                  cat.text = e.name;
                  catId = e.id;
                });
          },
          type: InputType.text,
          icon: Iconsax.category,
        ),
        Container(
            margin: const EdgeInsets.only(top: 10, right: 5, left: 5),
            child: Row(children: [
              MyButton(
                  title: item != null ? 'ویرایش کار' : 'ثبت کار',
                  bgColor: orange,
                  textColor: Colors.white,
                  onTap: () async {
                    bool cancel = false;
                    if (title.text == '') {
                      return MyToast.error('عنوان را وارد کنید!');
                    }
                    if (cat.text == '') {
                      return MyToast.error('دسته‌بندی را انتخاب کنید!');
                    }
                    if (repeatPeriod.value != 0) {
                      Get.back();
                      String pr = repeatPeriod.value == 1
                          ? 'روز'
                          : repeatPeriod.value == 2
                              ? 'هفته'
                              : 'ماه';
                      await MyBottomSheet.view(
                          Column(children: [
                            Text(
                              'میخواهید چند $pr این کار تکرار شود؟',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            if (repeatPeriod.value == 1)
                              Row(children: [
                                MyButton(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    title: '30 روز',
                                    bgColor: orange,
                                    textColor: Colors.white,
                                    onTap: () {
                                      repeatCount.value = 30;
                                      Get.back();
                                    }),
                                MyButton(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    title: '45 روز',
                                    bgColor: orange,
                                    textColor: Colors.white,
                                    onTap: () {
                                      repeatCount.value = 45;
                                      Get.back();
                                    }),
                                MyButton(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    title: '90 روز',
                                    bgColor: orange,
                                    textColor: Colors.white,
                                    onTap: () {
                                      repeatCount.value = 90;
                                      Get.back();
                                    }),
                                MyButton(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    title: '180 روز',
                                    bgColor: orange,
                                    textColor: Colors.white,
                                    onTap: () {
                                      repeatCount.value = 180;
                                      Get.back();
                                    }),
                              ]),
                            if (repeatPeriod.value == 2)
                              Row(children: [
                                MyButton(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    title: '4 هفته',
                                    bgColor: orange,
                                    textColor: Colors.white,
                                    onTap: () {
                                      repeatCount.value = 4;
                                      Get.back();
                                    }),
                                MyButton(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    title: '12 هفته',
                                    bgColor: orange,
                                    textColor: Colors.white,
                                    onTap: () {
                                      repeatCount.value = 12;
                                      Get.back();
                                    }),
                                MyButton(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    title: '24 هفته',
                                    bgColor: orange,
                                    textColor: Colors.white,
                                    onTap: () {
                                      repeatCount.value = 24;
                                      Get.back();
                                    }),
                                MyButton(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    title: '48 هفته',
                                    bgColor: orange,
                                    textColor: Colors.white,
                                    onTap: () {
                                      repeatCount.value = 48;
                                      Get.back();
                                    }),
                              ]),
                            if (repeatPeriod.value == 3)
                              Row(children: [
                                MyButton(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    title: '3 ماه',
                                    bgColor: orange,
                                    textColor: Colors.white,
                                    onTap: () {
                                      repeatCount.value = 3;
                                      Get.back();
                                    }),
                                MyButton(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    title: '6 ماه',
                                    bgColor: orange,
                                    textColor: Colors.white,
                                    onTap: () {
                                      repeatCount.value = 6;
                                      Get.back();
                                    }),
                                MyButton(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    title: '12 ماه',
                                    bgColor: orange,
                                    textColor: Colors.white,
                                    onTap: () {
                                      repeatCount.value = 12;
                                      Get.back();
                                    }),
                                MyButton(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    title: '24 ماه',
                                    bgColor: orange,
                                    textColor: Colors.white,
                                    onTap: () {
                                      repeatCount.value = 24;
                                      Get.back();
                                    }),
                              ]),
                            const SizedBox(height: 10),
                            Row(children: [
                              const Text('و یا: ',
                                  style: TextStyle(fontSize: 16)),
                              Flexible(
                                  child: MyInput(
                                title: 'روز',
                                type: InputType.number,
                                keyboardType: TextInputType.number,
                                icon: Iconsax.repeat_circle,
                                onChanged: (v) {
                                  repeatCount.value = int.parse(v);
                                },
                              ))
                            ]),
                            const SizedBox(height: 10),
                            Row(children: [
                              MyButton(
                                  title: 'ثبت کار',
                                  bgColor: orange,
                                  textColor: Colors.white,
                                  onTap: () {
                                    Get.back();
                                  }),
                              const SizedBox(width: 10),
                              MyButton(
                                  title: 'انصراف',
                                  bgColor: grey,
                                  textColor: grey,
                                  borderOnly: true,
                                  onTap: () {
                                    cancel = true;
                                    Get.back();
                                  }),
                            ])
                          ]),
                          h: 220);
                    }
                    if (!cancel) {
                      Work w = Work(
                          id: item == null
                              ? work.isEmpty
                                  ? 1
                                  : work.getAt(work.length - 1)!.id + 1
                              : item.id,
                          title: title.text,
                          desc: desc.text,
                          startDate: startDateCtl.text != 'بدون زمان‌بندی'
                              ? startDate.toIso8601String()
                              : '',
                          endTime: endTimeCtl.text,
                          notifTime: notifTimeCtl.text != 'بدون اعلان'
                              ? notifTime.toIso8601String()
                              : '',
                          cat: catId!,
                          check: item == null
                              ? false
                              : item.check
                                  ? item.check
                                  : endTimeCtl.text != ''
                                      ? true
                                      : false,
                          date: item == null
                              ? DateTime.now().toString()
                              : item.date,
                          project: false,
                          repeat: [
                            '${repeatPeriod.value}-${repeatCount.value}'
                          ],
                          parent: 0,
                          postponed: 0,
                          priority: priority.value);
                      if (item == null) {
                        await work.add(w);
                      } else {
                        for (var i = 0; i < work.length; i++) {
                          if (work.getAt(i)!.id == item.id) {
                            await work.putAt(i, w);
                          }
                        }
                      }
                      _setNotif(
                          notifCtl: notifTimeCtl.text,
                          notifTime: notifTime,
                          startDate: startDate,
                          w: w);
                      if (setting.getAt(0)!.addWorkToGCalender!) {
                        gc.Event ev = gc.Event();
                        ev.description = desc.text;
                        ev.summary = title.text;
                        gc.EventDateTime start =
                            gc.EventDateTime(); //Setting start time
                        start.dateTime = startDate;
                        start.timeZone = "GMT+03:30";
                        ev.start = start;
                        ev.created = DateTime.now();
                        ev.reminders = gc.EventReminders();
                        GoogleCalender.insertEvent(ev);
                      }
                      if (item == null && repeatPeriod.value != 0) {
                        int m =
                            DateTime.parse(w.startDate).toJalali().monthLength;
                        DateTime ssd = DateTime.parse(w.startDate);
                        DateTime nnd = w.notifTime != ''
                            ? DateTime.parse(w.notifTime)
                            : DateTime.now();
                        for (var i = 0; i < repeatCount.value - 1; i++) {
                          String sd = ssd
                              .add(Duration(
                                days: repeatPeriod.value == 1
                                    ? 1
                                    : repeatPeriod.value == 2
                                        ? 7
                                        : m,
                              ))
                              .toIso8601String();
                          String nd = '';
                          if (w.notifTime != '') {
                            nd = nnd
                                .add(Duration(
                                  days: repeatPeriod.value == 1
                                      ? 1
                                      : repeatPeriod.value == 2
                                          ? 7
                                          : m,
                                ))
                                .toIso8601String();
                            nnd = DateTime.parse(nd);
                          }
                          ssd = DateTime.parse(sd);
                          m = DateTime.parse(sd).toJalali().monthLength;
                          Work rw = Work(
                              id: work.getAt(work.length - 1)!.id + 1,
                              title: w.title,
                              desc: w.desc,
                              startDate: sd,
                              endTime: '',
                              notifTime: nd,
                              cat: w.cat,
                              check: false,
                              date: w.date,
                              project: w.project,
                              repeat: [],
                              parent: w.id,
                              postponed: 0,
                              priority: w.priority);
                          await work.add(rw);
                          _setNotif(
                              notifCtl: notifTimeCtl.text,
                              notifTime: DateTime.parse(nd),
                              startDate: DateTime.parse(sd),
                              w: w);
                          if (setting.getAt(0)!.addWorkToGCalender!) {
                            gc.Event ev1 = gc.Event();
                            ev1.description = w.title;
                            ev1.summary = w.desc;
                            gc.EventDateTime start =
                                gc.EventDateTime(); //Setting start time
                            start.dateTime = DateTime.parse(sd);
                            start.timeZone = "GMT+03:30";
                            ev1.start = start;
                            ev1.created = DateTime.now();
                            ev1.reminders = gc.EventReminders();
                            GoogleCalender.insertEvent(ev1);
                          }
                          Future.delayed(const Duration(milliseconds: 50));
                        }
                      }
                      callback('v');
                      Get.back();
                      MyToast.success(item == null
                          ? 'کار با موفقیت ذخیره شد.'
                          : 'کار با موفقیت ویرایش شد.');
                    }
                  }),
              const SizedBox(width: 10),
              MyButton(
                  title: 'انصراف',
                  bgColor: grey,
                  textColor: grey,
                  borderOnly: true,
                  onTap: () => Get.back()),
            ]))
      ]),
      h: 500,
      showClose: false,
      isDismissible: false);
}

_setNotif(
    {required DateTime notifTime,
    required notifCtl,
    required DateTime startDate,
    required Work w,
    bool reset = false}) {
  if (reset) {
    MyNotification.cancelNotification(int.parse('2${w.id}'));
  }
  if (notifCtl != 'بدون اعلان') {
    String title = '';
    String body = w.desc.isNotEmpty ? w.desc : 'کار';
    if (notifCtl == 'درلحظه') {
      title = 'حالا: ${w.title}';
    } else if (notifCtl == 'یک ساعت قبل') {
      title = 'یک ساعت آینده: ${w.title}';
    } else if (notifCtl == 'یک روز قبل') {
      title = 'فردا: ${w.title}';
    } else {
      Duration diff = startDate.difference(notifTime);
      title = diff.inDays > 0
          ? '${diff.inDays} روز تا: ${w.title}'
          : diff.inHours > 0
              ? '${diff.inHours} ساعت تا: ${w.title}'
              : '${diff.inMinutes} دقیقه تا: ${w.title}';
    }
    tz.TZDateTime date = tz.TZDateTime(tz.local, notifTime.year,
        notifTime.month, notifTime.day, notifTime.hour, notifTime.minute);
    MyNotification.scheduleNotification(
        id: int.parse('2${w.id}'),
        title: title,
        body: body,
        date: date,
        payload: 'localwork-${int.parse('2${w.id}')}');
  }
}
