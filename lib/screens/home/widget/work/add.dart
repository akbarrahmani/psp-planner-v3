// ignore_for_file: unused_local_variable

import 'dart:async';

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
import 'package:planner/screens/home/widget/work/cat/select.dart';
import 'package:planner/service/notifications/notification.dart';
import 'package:planner/variables.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:timezone/timezone.dart' as tz;

addWork({Work? item, callback}) {
  DateTime startDate;
  DateTime endTime;
  DateTime notifTime;
  final title = TextEditingController(),
      desc = TextEditingController(),
      startDateCtl = TextEditingController(),
      endTimeCtl = TextEditingController(),
      notifTimeCtl = TextEditingController(),
      cat = TextEditingController(),
      repeat = TextEditingController(),
      repeatEnd = TextEditingController();
  final tf = FocusNode(),
      descf = FocusNode(),
      sdf = FocusNode(),
      etf = FocusNode(),
      ntf = FocusNode(),
      cf = FocusNode(),
      rf = FocusNode();
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
        endTime = DateTime.parse(item.endTime);
        jdd = startDate.toJalali();
        endTimeCtl.text =
            '${jdd.day} ${jdd.formatter.mN} ${jdd.year} ${jdd.hour}:${jdd.minute}';
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
        MyInput(
          title: 'عنوان',
          controller: title,
          focusNode: tf,
          nextFocusNode: descf,
          textInputAction: TextInputAction.next,
          required: true,
          type: InputType.text,
          icon: Iconsax.briefcase,
        ),
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
            onTap: () => MyCalender.picker(
                time: true,
                callback: (DateTime v) {
                  endTime = v;
                  var jd = v.toJalali();
                  endTimeCtl.text =
                      '${jd.day} ${jd.formatter.mN} ${jd.year} ${jd.hour}:${jd.minute}';
                }),
          ),
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
                    if (title.text == '') {
                      return MyToast.error('عنوان را وارد کنید!');
                    }
                    if (cat.text == '') {
                      return MyToast.error('دسته‌بندی را انتخاب کنید!');
                    }
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
                        endTime: '',
                        notifTime: notifTimeCtl.text != 'بدون اعلان'
                            ? notifTime.toIso8601String()
                            : '',
                        cat: catId!,
                        check: item == null ? false : item.check,
                        date: item == null
                            ? DateTime.now().toString()
                            : item.date,
                        project: false,
                        repeat: [],
                        parent: 0,
                        postponed: 0);
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
                    callback('v');
                    Get.back();
                    MyToast.success(item == null
                        ? 'کار با موفقیت ذخیره شد.'
                        : 'کار با موفقیت ویرایش شد.');
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
      h: item != null ? 500 : 450,
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
