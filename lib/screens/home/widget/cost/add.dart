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
import 'package:planner/screens/home/widget/cost/cat/select.dart';
import 'package:planner/service/notifications/notification.dart';
import 'package:planner/variables.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:timezone/timezone.dart' as tz;

addCost({Cost? item, callback}) {
  DateTime effDate;
  DateTime? paidDate;
  DateTime notifTime;
  final title = TextEditingController(),
      desc = TextEditingController(),
      effDateCtl = TextEditingController(),
      price = TextEditingController(),
      paidDateCtl = TextEditingController(),
      notifTimeCtl = TextEditingController(),
      cat = TextEditingController(),
      repeat = TextEditingController(),
      repeatEnd = TextEditingController();
  final tf = FocusNode(),
      descf = FocusNode(),
      edf = FocusNode(),
      prc = FocusNode(),
      pdf = FocusNode(),
      ntf = FocusNode(),
      cf = FocusNode(),
      rf = FocusNode();

  RxBool paid = false.obs, noTime = false.obs;
  int? catId;
  var repeatDate = [];
  int cc = 0;

  effDate = DateTime(selectedDate.value.year, selectedDate.value.month,
      selectedDate.value.day, DateTime.now().hour, DateTime.now().minute);

  var jd = effDate.toJalali();
  effDateCtl.text =
      '${jd.day} ${jd.formatter.mN} ${jd.year} ${jd.hour}:${jd.minute}';
  notifTimeCtl.text = 'یک روز قبل';
  notifTime = effDate.add(const Duration(days: -1));
  if (item != null) {
    Timer(const Duration(milliseconds: 50), () {
      title.text = item.title;
      desc.text = item.desc;
      price.text = intToPrice(item.price);
      effDate = DateTime.parse(item.effDate);
      var jdd = effDate.toJalali();
      effDateCtl.text =
          '${jdd.day} ${jdd.formatter.mN} ${jdd.year} ${jdd.hour}:${jdd.minute}';

      if (item.notifTime != '') {
        notifTime = DateTime.parse(item.notifTime);
        jdd = notifTime.toJalali();
        notifTimeCtl.text =
            '${jdd.day} ${jdd.formatter.mN} ${jdd.year} ${jdd.hour}:${jdd.minute}';
      }
      catId = item.cat;
      cat.text = costCat.values
          .where((element) => element.id == item.cat)
          .toList()[0]
          .name;
    });
  }

  MyBottomSheet.view(
      Column(children: [
        const SizedBox(height: 10),
        Text(
          item == null ? 'ثبت هزینه جدید' : 'ویرایش هزینه',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        const SizedBox(height: 10),
        MyInput(
          title: 'عنوان',
          controller: title,
          focusNode: tf,
          nextFocusNode: pdf,
          textInputAction: TextInputAction.next,
          required: true,
          type: InputType.text,
          icon: Iconsax.receipt,
        ),
        MyInput(
          title: 'مبلغ قابل پرداخت',
          controller: price,
          focusNode: pdf,
          nextFocusNode: descf,
          textInputAction: TextInputAction.next,
          type: InputType.price,
          keyboardType: TextInputType.number,
          icon: Iconsax.dollar_square,
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
          title: 'سررسید پرداخت',
          controller: effDateCtl,
          focusNode: edf,
          type: InputType.text,
          icon: Iconsax.clock,
          readOnly: true,
          onTap: () => MyCalender.picker(
              time: true,
              noTime: true,
              callback: (v) {
                if (v != null && v != 'cancel') {
                  effDate = DateTime.parse(v.toString());
                  var jd = effDate.toJalali();
                  effDateCtl.text =
                      '${jd.day} ${jd.formatter.mN} ${jd.year} ${jd.hour}:${jd.minute}';
                  noTime.value = false;
                  if (effDate
                      .add(const Duration(days: -1))
                      .isAfter(DateTime.now())) {
                    notifTimeCtl.text = 'یک روز قبل';
                    notifTime = effDate.add(const Duration(days: -1));
                  } else if (effDate
                      .add(const Duration(hours: -1))
                      .isAfter(DateTime.now())) {
                    notifTimeCtl.text = 'یک ساعت قبل';
                    notifTime = effDate.add(const Duration(hours: -1));
                  } else {
                    notifTimeCtl.text = 'بدون اعلان';
                  }
                } else if (v == null) {
                  effDateCtl.text = 'بدون زمان‌بندی';
                  notifTimeCtl.text = 'بدون اعلان';
                  noTime.value = true;
                }
              }),
        ),
        if (item != null) const SizedBox(width: 10),
        if (item != null)
          MyInput(
            title: 'سررسید پرداخت',
            controller: effDateCtl,
            focusNode: edf,
            type: InputType.text,
            icon: Iconsax.clock_1,
            readOnly: true,
            onTap: () => MyCalender.picker(
                time: true,
                callback: (v) {
                  if (v != null && v != 'cancel') {
                    effDate = DateTime.parse(v.toString());
                    var jd = effDate.toJalali();
                    paidDateCtl.text =
                        '${jd.day} ${jd.formatter.mN} ${jd.year} ${jd.hour}:${jd.minute}';
                  }
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
                        end: effDate,
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
                    notifTime = effDate;
                  } else if (p0 == 'یک ساعت قبل') {
                    notifTime = effDate.add(const Duration(hours: -1));
                  } else if (p0 == 'یک روز قبل') {
                    notifTime = effDate.add(const Duration(days: -1));
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
            costCatSelect(
                selected: cat.text,
                callback: (CostCat e) {
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
                  title: item != null ? 'ویرایش هزینه' : 'ثبت هزینه',
                  bgColor: orange,
                  textColor: Colors.white,
                  onTap: () async {
                    if (title.text == '') {
                      return MyToast.error('عنوان را وارد کنید!');
                    }
                    if (cat.text == '') {
                      return MyToast.error('دسته‌بندی را انتخاب کنید!');
                    }
                    Cost w = Cost(
                        id: item == null
                            ? cost.isEmpty
                                ? 1
                                : cost.getAt(cost.length - 1)!.id + 1
                            : item.id,
                        title: title.text,
                        desc: desc.text,
                        price: int.parse(price.text),
                        paidDate: '',
                        effDate: effDateCtl.text != 'بدون زمان‌بندی'
                            ? effDate.toIso8601String()
                            : '',
                        notifTime: notifTimeCtl.text != 'بدون اعلان'
                            ? notifTime.toIso8601String()
                            : '',
                        cat: catId!,
                        paid: false,
                        date: item == null
                            ? DateTime.now().toString()
                            : item.date,
                        repeat: [],
                        parent: 0);
                    if (item == null) {
                      await cost.add(w);
                    } else {
                      for (var i = 0; i < cost.length; i++) {
                        if (cost.getAt(i)!.id == item.id) {
                          await cost.putAt(i, w);
                        }
                      }
                    }
                    _setNotif(
                        notifCtl: notifTimeCtl.text,
                        notifTime: notifTime,
                        effDate: effDate,
                        c: w);
                    callback('v');
                    Get.back();
                    MyToast.success(item == null
                        ? 'هزینه با موفقیت ذخیره شد.'
                        : 'هزینه با موفقیت ویرایش شد.');
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
      h: item != null ? 550 : 500,
      showClose: false,
      isDismissible: false);
}

_setNotif(
    {required DateTime notifTime,
    required notifCtl,
    required DateTime effDate,
    required Cost c,
    bool reset = false}) {
  if (reset) {
    MyNotification.cancelNotification(int.parse('2${c.id}'));
  }
  if (notifCtl != 'بدون اعلان') {
    String title = '';
    String body = c.desc.isNotEmpty ? c.desc : 'کار';
    if (notifCtl == 'درلحظه') {
      title = 'حالا: ${c.title}';
    } else if (notifCtl == 'یک ساعت قبل') {
      title = 'یک ساعت آینده: ${c.title}';
    } else if (notifCtl == 'یک روز قبل') {
      title = 'فردا: ${c.title}';
    } else {
      Duration diff = effDate.difference(notifTime);
      title = diff.inDays > 0
          ? '${diff.inDays} روز تا: ${c.title}'
          : diff.inHours > 0
              ? '${diff.inHours} ساعت تا: ${c.title}'
              : '${diff.inMinutes} دقیقه تا: ${c.title}';
    }
    tz.TZDateTime date = tz.TZDateTime(tz.local, notifTime.year,
        notifTime.month, notifTime.day, notifTime.hour, notifTime.minute);
    MyNotification.scheduleNotification(
        id: int.parse('3${c.id}'),
        title: title,
        body: body,
        date: date,
        payload: 'localcost-${int.parse('3${c.id}')}');
  }
}
