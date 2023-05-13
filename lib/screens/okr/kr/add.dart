// ignore_for_file: file_names, unnecessary_null_comparison, unused_element

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

final _kr = TextEditingController(),
    _day = TextEditingController(),
    _desc = TextEditingController();
final _krF = FocusNode(), _dayF = FocusNode(), _dF = FocusNode();
addKR(Goals goal, Objective obj, callback, {KR? item}) {
  _kr.clear();
  _day.clear();
  _desc.clear();
  if (item != null) {
    _kr.text = item.title;
    _day.text = item.rp.toString();
    _desc.text = item.desc;
  }
  MyBottomSheet.view(
      Column(children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            item == null
                ? 'افزودن نتیجه هدف ${obj.title}، ${goal.title}-${goal.year}'
                : 'ویرایش نتیجه هدف ${obj.title}، ${goal.title}-${goal.year}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        MyInput(
          title: 'نتیجه',
          controller: _kr,
          focusNode: _krF,
          nextFocusNode: _dayF,
          type: InputType.text,
          textInputAction: TextInputAction.next,
          icon: Iconsax.radar,
        ),
        MyInput(
          title: 'دوره بررسی(روز)',
          controller: _day,
          focusNode: _dayF,
          nextFocusNode: _dF,
          type: InputType.number,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          icon: Iconsax.magicpen,
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
              title: 'تایید',
              bgColor: orange,
              textColor: Colors.white,
              onTap: () => _confirm(goal, obj, item, (v) {
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

_confirm(Goals? goal, Objective? obj, KR? item, callback) async {
  if (_kr.text.isEmpty) {
    return MyToast.error('نتیجه نمی‌تواند خالی باشد.');
  } else if (_day.text.isEmpty) {
    return MyToast.error('دوره بررسی نمی‌تواند خالی باشد.');
  } else {
    if (item == null) {
      KR k = KR(
          id: kr.length == 0 ? 1 : kr.getAt(kr.length - 1)!.id + 1,
          objectiveID: obj!.id,
          title: _kr.text,
          desc: _desc.text,
          rp: int.parse(_day.text));

      await kr.add(k);
      List doDate = [];
      var date = DateTime.parse(obj.startDate)
          .add(const Duration(days: -1))
          .toIso8601String();
      do {
        date = (DateTime.parse(date).add(Duration(days: int.parse(_day.text))))
            .toIso8601String();
        if (DateTime.parse(obj.endDate).isAfter(DateTime.parse(date))) {
          doDate.add(date);
        } else {
          doDate.add(DateTime.parse(obj.endDate).toIso8601String());
        }
      } while (DateTime.parse(obj.endDate).isAfter(DateTime.parse(date)));
      for (var i = 0; i < doDate.length; i++) {
        KRdo doItem = KRdo(
            id: krdo.length == 0 ? 1 : krdo.getAt(krdo.length - 1)!.id + 1,
            krID: k.id,
            desc: '',
            check: false,
            date: doDate[i].toString(),
            rate: 0);
        await krdo.add(doItem);
      }
      Get.back();
      MyToast.success('نتیجه با موفقیت اضافه شد.');
      callback(k);
    } else {
      item.title = _kr.text;
      item.desc = _desc.text;
      item.rp = int.parse(_day.text);
      for (var i = 0; i < kr.length; i++) {
        if (kr.getAt(i)!.id == item.id) {
          await kr.putAt(i, item);
          break;
        }
      }

      for (var d = krdo.length - 1; d >= 0; d--) {
        var it = krdo.getAt(d)!;
        if (it.check == false &&
            it.desc.isEmpty &&
            it.krID == item.id &&
            DateTime.parse(it.date).compareTo(DateTime.now()) >= 0) {
          await krdo.deleteAt(d);
        }
      }
      List doDate = [];
      var date = DateTime.parse(obj!.startDate).compareTo(DateTime.now()) > 0
          ? DateTime.parse(obj.startDate)
              .add(const Duration(days: -1))
              .toIso8601String()
          : DateTime.now().toIso8601String();
      do {
        date = (DateTime.parse(date).add(Duration(days: int.parse(_day.text))))
            .toIso8601String();
        if (DateTime.parse(obj.endDate).isAfter(DateTime.parse(date))) {
          doDate.add(date);
        } else {
          doDate.add(DateTime.parse(obj.endDate).toIso8601String());
        }
      } while (DateTime.parse(obj.endDate).isAfter(DateTime.parse(date)));
      for (var i = 0; i < doDate.length; i++) {
        KRdo doItem = KRdo(
            id: krdo.length == 0 ? 1 : krdo.getAt(krdo.length - 1)!.id + 1,
            krID: obj.id,
            desc: '',
            check: false,
            date: doDate[i].toString(),
            rate: 0);
        await krdo.add(doItem);
      }
      Get.back();
      callback(item);
      MyToast.success('نتیجه با موفقیت ویرایش شد.');
      //
    }
  }
}
