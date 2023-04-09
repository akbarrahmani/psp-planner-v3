import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:planner/components/bottomSheet.dart';
import 'package:planner/components/button.dart';
import 'package:planner/components/textInput.dart';
import 'package:planner/components/toast.dart';
import 'package:planner/constant.dart';
import 'package:planner/dbModels/models.dart';
import 'package:planner/variables.dart';

workCatAdd({WorkCat? item, callback}) {
  final titleCtl = TextEditingController();
  final descCtl = TextEditingController();
  if (item != null) {
    titleCtl.text = item.name;
    descCtl.text = item.desc;
  }
  return MyBottomSheet.view(
      Column(children: [
        const Text('افزودن دسته‌بندی‌ کارها',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        MyInput(
          title: 'عنوان',
          icon: Iconsax.category,
          controller: titleCtl,
          type: InputType.text,
          required: true,
        ),
        MyInput(
          title: 'توضیحات',
          icon: Iconsax.document,
          controller: descCtl,
          type: InputType.text,
          line: 3,
        ),
        Row(
          children: [
            MyButton(
                title: 'افزودن',
                bgColor: orange,
                textColor: Colors.white,
                onTap: () {
                  if (titleCtl.text == '') {
                    return MyToast.error('عنوان را وارد کنید.');
                  }
                  if (item == null) {
                    WorkCat e = WorkCat(
                        id: workCat.length,
                        name: titleCtl.text,
                        desc: descCtl.text,
                        date: DateTime.now().toIso8601String());
                    workCat.add(e);
                    callback(e);
                    Get.back();
                  } else {
                    item.name = titleCtl.text;
                    item.desc = descCtl.text;
                    for (var i = 0; i < workCat.length; i++) {
                      if (item.id == workCat.getAt(i)!.id) {
                        workCat.putAt(i, item);
                      }
                    }
                    Get.back();
                  }
                }),
            const SizedBox(width: 10),
            MyButton(
                title: 'انصراف',
                bgColor: grey,
                textColor: grey,
                borderOnly: true,
                onTap: () {
                  Get.back();
                }),
          ],
        )
      ]),
      h: 300);
}
