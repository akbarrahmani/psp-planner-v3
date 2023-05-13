// ignore_for_file: file_names, unnecessary_null_comparison

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

final _obj = TextEditingController(),
    _s = TextEditingController(),
    _e = TextEditingController(),
    _desc = TextEditingController();
final _objF = FocusNode(),
    _sF = FocusNode(),
    _eF = FocusNode(),
    _dF = FocusNode();
DateTime? _sd, _ed;
addObj(Goals goal, callback, {Objective? item}) {
  _obj.clear();
  _s.clear();
  _e.clear();
  _desc.clear();
  if (item != null) {
    _obj.text = item.title;
    _sd = DateTime.parse(item.startDate);
    var jds = _sd!.toJalali();
    _s.text = '${jds.day} ${jds.formatter.mN} ${jds.year}';
    _ed = DateTime.parse(item.endDate);
    var jde = _ed!.toJalali();
    _e.text = '${jde.day} ${jde.formatter.mN} ${jde.year}';
    _desc.text = item.desc;
  }
  MyBottomSheet.view(
      Column(children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            item == null
                ? 'تعریف هدف چشم‌انداز ${goal.title}-${goal.year}'
                : 'ویرایش هدف چشم‌انداز ${goal.title}-${goal.year}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        MyInput(
          title: 'هدف(Objective)',
          controller: _obj,
          focusNode: _objF,
          nextFocusNode: _sF,
          type: InputType.text,
          textInputAction: TextInputAction.next,
          icon: Iconsax.radar_2,
        ),
        Row(children: [
          Flexible(
              child: MyInput(
            title: 'شروع',
            controller: _s,
            focusNode: _sF,
            nextFocusNode: _eF,
            readOnly: true,
            type: InputType.text,
            textInputAction: TextInputAction.next,
            icon: Iconsax.clock,
            onTap: () => MyCalender.picker(
                time: false,
                callback: (v) {
                  _sd = DateTime.parse(v.toString());
                  var jd = _sd!.toJalali();
                  _s.text = '${jd.day} ${jd.formatter.mN} ${jd.year}';
                }),
          )),
          const SizedBox(width: 10),
          Flexible(
              child: MyInput(
            title: 'پایان',
            controller: _e,
            focusNode: _eF,
            nextFocusNode: _dF,
            readOnly: true,
            type: InputType.text,
            textInputAction: TextInputAction.next,
            icon: Iconsax.clock,
            onTap: () => MyCalender.picker(
                time: false,
                callback: (v) {
                  _ed = DateTime.parse(v.toString());
                  var jd = _ed!.toJalali();
                  _e.text = '${jd.day} ${jd.formatter.mN} ${jd.year}';
                }),
          ))
        ]),
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
              title: 'تایید',
              bgColor: orange,
              textColor: Colors.white,
              onTap: () => _confirm(goal, item, (v) {
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
      h: 360);
}

_confirm(Goals? goal, Objective? item, callback) async {
  if (_obj.text.isEmpty) {
    return MyToast.error('هدف چشم‌انداز نمی‌تواند خالی باشد.');
  } else if (_s.text.isEmpty) {
    return MyToast.error('زمان شروع هدف چشم‌انداز نمی‌تواند خالی باشد.');
  } else if (_e.text.isEmpty) {
    return MyToast.error('زمان پایان هدف چشم‌انداز نمی‌تواند خالی باشد.');
  } else {
    if (item == null) {
      Objective o = Objective(
          id: objective.length == 0
              ? 1
              : objective.getAt(objective.length - 1)!.id + 1,
          goalID: goal!.id,
          title: _obj.text,
          desc: _desc.text,
          startDate: _sd!.toIso8601String(),
          endDate: _ed!.toIso8601String(),
          date: DateTime.now().toIso8601String());
      await objective.add(o);
      Get.back();
      MyToast.success('هدف چشم‌انداز با موفقیت اضافه شد.');
      callback(o);
    } else {
      item.title = _obj.text;
      item.desc = _desc.text;
      item.startDate = _sd!.toIso8601String();
      item.endDate = _ed!.toIso8601String();
      for (var i = 0; i < objective.length; i++) {
        if (objective.getAt(i)!.id == item.id) {
          await objective.putAt(i, item);
          Get.back();
          callback(item);
          MyToast.success('هدف چشم‌انداز با موفقیت ویرایش شد.');
          break;
        }
      }
    }
  }
}
