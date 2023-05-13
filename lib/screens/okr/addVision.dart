// ignore_for_file: file_names

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
import 'package:shamsi_date/shamsi_date.dart';

final _vs = TextEditingController(),
    _y = TextEditingController(text: Jalali.now().year.toString()),
    _desc = TextEditingController();
final _vsF = FocusNode(), _yF = FocusNode(), _dF = FocusNode();

addVision(callback, {Goals? item}) {
  _vs.clear();
  _y.text = Jalali.now().year.toString();
  _desc.clear();
  if (item != null) {
    _vs.text = item.title;
    _y.text = item.year.toString();
    _desc.text = item.desc;
  }
  MyBottomSheet.view(
      Column(children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            item != null ? 'ویرایش چشم‌انداز' : 'تعریف چشم‌انداز',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        MyInput(
          title: 'چشم انداز',
          controller: _vs,
          focusNode: _vsF,
          nextFocusNode: _yF,
          type: InputType.text,
          textInputAction: TextInputAction.next,
          icon: Iconsax.cup,
        ),
        MyInput(
          title: 'سال',
          controller: _y,
          focusNode: _yF,
          nextFocusNode: _dF,
          length: 4,
          type: InputType.number,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.number,
          icon: Iconsax.chart_3,
          onChanged: (v) {
            if (v.toString().length > 3 && int.parse(v) < Jalali.now().year) {
              MyToast.error('سال قبل را نمیتوانید انتخاب کنید.');
              _y.text = Jalali.now().year.toString();
              _y.selection = TextSelection.collapsed(offset: _y.text.length);
            }
          },
        ),
        MyInput(
          title: 'توضیحات',
          controller: _desc,
          focusNode: _dF,
          type: InputType.text,
          textInputAction: TextInputAction.newline,
          line: 3,
          icon: Iconsax.document,
        ),
        const SizedBox(height: 10),
        Row(children: [
          MyButton(
              title: item != null ? 'ویرایش' : 'افزودن',
              bgColor: orange,
              textColor: Colors.white,
              onTap: () => _confirm(item, (v) => callback(v))),
          const SizedBox(width: 10),
          MyButton(
              title: 'انصراف',
              bgColor: grey,
              textColor: grey,
              borderOnly: true,
              onTap: () => Get.back())
        ])
      ]),
      h: 360);
}

_confirm(Goals? item, callback) async {
  if (_vs.text.isEmpty) {
    return MyToast.error('عنوان چشم‌انداز نمی‌تواند خالی باشد.');
  } else if (_y.text.isEmpty) {
    return MyToast.error('سال چشم‌انداز نمی‌تواند خالی باشد.');
  } else {
    if (item == null) {
      Goals goal = Goals(
          id: goals.length == 0 ? 1 : goals.getAt(goals.length - 1)!.id + 1,
          title: _vs.text,
          desc: _desc.text,
          year: int.parse(_y.text),
          date: DateTime.now().toIso8601String());
      await goals.add(goal);
      Get.back(closeOverlays: true);
      MyToast.success('چشم‌انداز با موفقیت اضافه شد.');
      callback(goal);
    } else {
      item.title = _vs.text;
      item.desc = _desc.text;
      for (var i = 0; i < goals.length; i++) {
        if (goals.getAt(i)!.id == item.id) {
          await goals.putAt(i, item);
          Get.back(closeOverlays: true);
          MyToast.success('چشم‌انداز با موفقیت ویرایش شد.');
          callback(item);
          break;
        }
      }
    }
  }
}
