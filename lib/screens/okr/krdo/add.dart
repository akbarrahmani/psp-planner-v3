// ignore_for_file: file_names, unnecessary_null_comparison, unused_element

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:planner/components/Celander/calender.dart';
import 'package:planner/components/bottomSheet.dart';
import 'package:planner/components/button.dart';
import 'package:planner/components/numberPicker.dart';
import 'package:planner/components/textInput.dart';
import 'package:planner/components/toast.dart';
import 'package:planner/constant.dart';
import 'package:planner/dbModels/models.dart';
import 'package:planner/variables.dart';
import 'package:shamsi_date/shamsi_date.dart';

final _date = TextEditingController(),
    //  _rate = TextEditingController(),
    _desc = TextEditingController();
final _dateF = FocusNode(), _rF = FocusNode(), _dF = FocusNode();
RxBool _checkDo = false.obs;
RxDouble _rated = 0.0.obs;
DateTime? _d;
addKRDO(Goals goal, Objective obj, KR k, callback, {KRdo? item}) {
  _date.clear();
  //_rate.clear();
  _desc.clear();
  _rated = 0.0.obs;
  if (item != null) {
    _d = DateTime.parse(item.date);
    var jd = _d!.toJalali();
    _date.text = '${jd.day} ${jd.formatter.mN} ${jd.year}';
    //_rate.text = item.check ? item.rate.toString() : '';
    _desc.text = item.desc;
    _checkDo.value = item.check;
    _rated = item.rate.toDouble().obs;
  }
  MyBottomSheet.view(
      Column(children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            item == null
                ? 'افزودن بررسی نتیجه ${k.title}، هدف ${obj.title}، ${goal.title}-${goal.year}'
                : 'ویرایش بررسی نتیجه ${k.title}، هدف ${obj.title}، ${goal.title}-${goal.year}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        //
        Container(
            padding: const EdgeInsets.all(5),
            child: Obx(() => Row(children: [
                  MyButton(
                    title: 'بررسی شده',
                    bgColor: _checkDo.value ? Colors.blue : grey,
                    textColor: _checkDo.value ? Colors.white : grey,
                    onTap: () => _checkDo.toggle(),
                    borderOnly: !_checkDo.value,
                  ),
                  const SizedBox(width: 10),
                  MyButton(
                    title: 'بررسی نشده',
                    bgColor: !_checkDo.value ? Colors.blue : grey,
                    textColor: !_checkDo.value ? Colors.white : grey,
                    onTap: () => {_checkDo.toggle(), _rated.value = 0},
                    borderOnly: _checkDo.value,
                  )
                ]))),
        MyInput(
          title: 'توضیحات',
          controller: _desc,
          focusNode: _dF,
          nextFocusNode: _rF,
          type: InputType.text,
          line: 3,
          textInputAction: TextInputAction.next,
          icon: Iconsax.document,
        ),
        MyNumberPicker(
            min: 0,
            max: 100,
            icon: Iconsax.ruler,
            value: _rated,
            callback: (v) {
              _rated.value = v;
            }),

        MyInput(
          title: 'تاریخ',
          controller: _date,
          focusNode: _dateF,
          type: InputType.text,
          textInputAction: TextInputAction.done,
          readOnly: true,
          onTap: () => MyCalender.picker(
              time: false,
              callback: (v) {
                _d = DateTime.parse(v.toString());
                var jd = _d!.toJalali();
                _date.text = '${jd.day} ${jd.formatter.mN} ${jd.year}';
              }),
          line: 1,
          icon: Iconsax.clock,
        ),
        const SizedBox(height: 10),
        Row(children: [
          MyButton(
              title: 'تایید',
              bgColor: orange,
              textColor: Colors.white,
              onTap: () => _confirm(goal, obj, k, item, (v) {
                    callback(v);
                  })),
          const SizedBox(width: 10),
          MyButton(
              title: 'انصراف',
              bgColor: grey,
              textColor: grey,
              borderOnly: true,
              onTap: () => Get.back())
        ])
      ]),
      h: 430);
}

_confirm(Goals? goal, Objective? obj, KR? k, KRdo? item, callback) async {
  if (item == null && _desc.text.isEmpty) {
    MyToast.error('توضیحات بررسی را وارد کنید.');
  } else if (_date.text.isEmpty) {
    MyToast.error('تاریخ بررسی را وارد کنید.');
  } else if (item != null && _checkDo.isTrue && _rated.value == 0) {
    MyToast.error('امتیاز بررسی را وارد کنید.');
  } else {
    if (item == null) {
      KRdo kd = KRdo(
          id: krdo.length == 0 ? 1 : krdo.getAt(krdo.length - 1)!.id + 1,
          krID: k!.id,
          desc: _desc.text,
          check: _checkDo.value || _rated.value > 0,
          date: _d!.toIso8601String(),
          rate: _rated.value.toInt());
      await krdo.add(kd);
      Get.back();
      MyToast.success('بررسی نتیجه با موفقیت اضافه شد.');
      callback(kd);
    } else {
      item.desc = _desc.text;
      item.rate = _rated.value.toInt();
      // _rate.text != '' ? int.parse(_rate.text) : 0;
      item.check = _checkDo.value || _rated.value > 0;
      item.date = _d!.toIso8601String();
      for (var i = 0; i < krdo.length; i++) {
        if (krdo.getAt(i)!.id == item.id) {
          await krdo.putAt(i, item);
          break;
        }
      }
      Get.back();
      callback(item);
      MyToast.success('بررسی نتیجه با موفقیت ویرایش شد.');
      //
    }
  }
}
