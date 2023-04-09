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

addNote({Note? item, callback}) {
  DateTime date = item != null ? DateTime.parse(item.date) : DateTime.now();
  int cat = 1;
  final title = TextEditingController(),
      desc = TextEditingController(),
      dateCtl = TextEditingController();
  final tf = FocusNode(), descf = FocusNode(), df = FocusNode();
  var jd = date.toJalali();
  dateCtl.text = '${jd.day} ${jd.formatter.mN} ${jd.year}';
  RxBool showCat = false.obs;
  if (item != null) {
    title.text = item.title;
    desc.text = item.text;
    cat = item.cat;
  }
  MyBottomSheet.view(
      Obx(() => Stack(children: [
            Column(children: [
              const SizedBox(height: 10),
              Text(
                item == null ? 'ثبت یادداشت جدید' : 'ویرایش یادداشت',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
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
                icon: Iconsax.note_2,
              ),
              Row(children: [
                Flexible(
                    child: MyInput(
                  title: 'تاریخ',
                  controller: dateCtl,
                  focusNode: df,
                  nextFocusNode: descf,
                  textInputAction: TextInputAction.next,
                  readOnly: true,
                  onTap: () => MyCalender.picker(callback: (v) {
                    if (v != null && v != 'cancel') {
                      date = DateTime.parse(v.toString());
                      var jd = date.toJalali();
                      dateCtl.text = '${jd.day} ${jd.formatter.mN} ${jd.year}';
                    }
                  }),
                  required: true,
                  type: InputType.text,
                  icon: Iconsax.clock,
                )),
                IconButton(
                    onPressed: () {
                      showCat.toggle();
                    },
                    icon: Icon(
                      noteCat[cat],
                      color: orange,
                    ))
              ]),
              MyInput(
                title: 'توضیحات',
                controller: desc,
                focusNode: descf,
                textInputAction: TextInputAction.newline,
                required: true,
                line: 3,
                type: InputType.text,
                icon: Iconsax.document,
              ),
              Container(
                  margin: const EdgeInsets.only(top: 10, right: 5, left: 5),
                  child: Row(children: [
                    MyButton(
                        title: item != null
                            ? 'ویرایش یادداشت'
                            : 'ثبت یادداشت جدید',
                        bgColor: orange,
                        textColor: Colors.white,
                        onTap: () async {
                          if (title.text.isEmpty) {
                            return MyToast.error('عنوان را وارد کنید.');
                          } else if (desc.text.isEmpty) {
                            return MyToast.error('توضیحات را وارد کنید.');
                          }
                          Note n = Note(
                              id: item == null
                                  ? note.isEmpty
                                      ? 1
                                      : note.getAt(note.length - 1)!.id + 1
                                  : item.id,
                              title: title.text,
                              text: desc.text,
                              date: date.toIso8601String(),
                              cat: cat);
                          if (item == null) {
                            await note.add(n);
                          } else {
                            for (var i = 0; i < note.length; i++) {
                              if (note.getAt(i)!.id == item.id) {
                                await note.putAt(i, n);
                              }
                            }
                          }
                          callback('v');
                          Get.back();
                          MyToast.success(item == null
                              ? 'یادداشت با موفقیت ذخیره شد.'
                              : 'یادداشت با موفقیت ویرایش شد.');
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
            AnimatedPositioned(
              duration: const Duration(milliseconds: 400),
              top: 96,
              left: showCat.isTrue ? 5 : -(Get.width),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                width: showCat.isTrue ? Get.width * 0.93 : 50,
                height: 40,
                decoration: BoxDecoration(
                    color: Get.isDarkMode ? grey : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [BoxShadow(blurRadius: 1)]),
                child: Row(children: [
                  const Icon(Iconsax.arrow_right_3),
                  Flexible(
                      child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(children: [
                            for (int i = 0; i < noteCat.length; i++)
                              IconButton(
                                  onPressed: () {
                                    cat = i;
                                    showCat.toggle();
                                  },
                                  icon: Icon(
                                    noteCat[i],
                                    color: cat == i ? orange : grey,
                                  ))
                          ]))),
                  const Icon(Iconsax.arrow_left_2),
                ]),
              ),
            ),
          ])),
      h: 360);
}
