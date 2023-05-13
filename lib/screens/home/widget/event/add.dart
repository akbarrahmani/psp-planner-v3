// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:planner/components/Celander/calender.dart';
import 'package:planner/components/bottomSheet.dart';
import 'package:planner/components/button.dart';
import 'package:planner/components/textInput.dart';
import 'package:planner/components/toast.dart';
import 'package:planner/constant.dart';
import 'package:planner/dbModels/models.dart';
import 'package:planner/variables.dart';
import 'package:shamsi_date/shamsi_date.dart';

addEvent({Event? item, callback}) {
  Jalali date = item != null
      ? Jalali(
          selectedDate.value.toJalali().year,
          int.parse(item.effDate.split('/')[0]),
          int.parse(item.effDate.split('/')[1]))
      : selectedDate.value.toJalali();
  final title = TextEditingController(), dateCtl = TextEditingController();
  final tf = FocusNode(), df = FocusNode();
  //var jd = date.toJalali();
  dateCtl.text = '${date.day} ${date.formatter.mN}';
  if (item != null) {
    title.text = item.title;
  }
  MyBottomSheet.view(
      Column(children: [
        const SizedBox(height: 10),
        Text(
          item == null ? 'ثبت رویداد جدید' : 'ویرایش رویداد',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        const SizedBox(height: 10),
        MyInput(
          title: 'عنوان',
          controller: title,
          focusNode: tf,
          nextFocusNode: df,
          textInputAction: TextInputAction.next,
          required: true,
          type: InputType.text,
          icon: Iconsax.notification,
        ),
        MyInput(
          title: 'تاریخ',
          controller: dateCtl,
          focusNode: df,
          textInputAction: TextInputAction.next,
          readOnly: true,
          onTap: () => MyCalender.picker(
              init: date.toDateTime(),
              callback: (v) {
                if (v != null && v != 'cancel') {
                  date = DateTime.parse(v.toString()).toJalali();
                  dateCtl.text = '${date.day} ${date.formatter.mN}';
                }
              }),
          required: true,
          type: InputType.text,
          icon: Iconsax.clock,
        ),
        Container(
            margin: const EdgeInsets.only(top: 10, right: 5, left: 5),
            child: Row(children: [
              MyButton(
                  title: item != null ? 'ویرایش رویداد' : 'ثبت رویداد جدید',
                  bgColor: orange,
                  textColor: Colors.white,
                  onTap: () async {
                    if (title.text.isEmpty) {
                      return MyToast.error('عنوان را وارد کنید.');
                    }
                    Event e = Event(
                        id: item == null
                            ? event.isEmpty
                                ? 1
                                : event.getAt(event.length - 1)!.id + 1
                            : item.id,
                        title: title.text,
                        effDate: '${date.month}/${date.day}',
                        date: DateTime.now().toIso8601String());
                    if (item == null) {
                      await event.add(e);
                    } else {
                      for (var i = 0; i < event.length; i++) {
                        if (event.getAt(i)!.id == item.id) {
                          await event.putAt(i, e);
                        }
                      }
                    }
                    callback('v');
                    Get.back();
                    MyToast.success(item == null
                        ? 'رویداد با موفقیت ذخیره شد.'
                        : 'رویداد با موفقیت ویرایش شد.');
                  }),
              const SizedBox(width: 10),
              MyButton(
                  title: 'انصراف',
                  bgColor: grey,
                  textColor: grey,
                  borderOnly: true,
                  onTap: () => Get.back()),
              if (item != null) const SizedBox(width: 10),
              if (item != null)
                MyButton(
                  title: 'حذف',
                  bgColor: Colors.red,
                  textColor: Colors.red,
                  icon: Iconsax.trash,
                  onTap: () {
                    Get.back();
                    MyBottomSheet.view(
                        Column(children: [
                          const Text(
                            'عملیات حذف قابل بازگشت نیست!',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const Text('از حذف اطمینان دارید؟'),
                          const SizedBox(height: 10),
                          Row(children: [
                            MyButton(
                              title: 'تایید و حذف',
                              bgColor: Colors.red,
                              textColor: Colors.white,
                              icon: Iconsax.trash,
                              onTap: () async {
                                Get.back();
                                for (var i = 0; i < event.length; i++) {
                                  if (event.getAt(i)!.id == item.id) {
                                    await event.deleteAt(i);
                                    callback('v');
                                    break;
                                  }
                                }
                              },
                            ),
                            const SizedBox(width: 10),
                            MyButton(
                                title: 'انصراف',
                                bgColor: grey,
                                textColor: grey,
                                icon: Iconsax.close_circle,
                                borderOnly: true,
                                onTap: () {
                                  Get.back();
                                })
                          ])
                        ]),
                        h: 130);
                  },
                  borderOnly: true,
                )
            ]))
      ]),
      h: 230);
}
