// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:planner/constant.dart';
import 'package:planner/screens/home/widget/cost/cat/list.dart';
import 'package:planner/screens/home/widget/work/cat/list.dart';
import 'package:planner/variables.dart';

RxInt _hourEvent = 9.obs;
RxInt _hourKrdo = 9.obs;

class SettingController extends GetxController {
  int hourEventInit = 0;
  int hourKrdoInit = 0;
  @override
  void onReady() {
    var setti = setting.getAt(0)!;
    hourEventInit = setti.eventHourNotif!;
    hourKrdoInit = setti.krdoHourNotif!;

    super.onReady();
  }

  @override
  Future<void> onClose() async {
    if (_hourEvent.value != hourEventInit || _hourKrdo.value != hourKrdoInit) {
      var setti = setting.getAt(0)!;
      setti.eventHourNotif = _hourEvent.value;
      setti.krdoHourNotif = _hourKrdo.value;
      await setting.putAt(0, setti);
      // if (_hourEvent.value != hourEventInit) ScheduleNotif.setEventNotif();
      // if (_hourKrdo.value != hourKrdoInit) ScheduleNotif.setKrDONotif();
    }
    super.onClose();
  }
}

class Setting extends GetView {
  Setting({super.key});
  RxBool change = true.obs;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Obx(() => change.isFalse || change.isTrue
            ? Column(children: [
                _headerItem(title: 'تنظیمات حالت نمایش', start: true),
                _switchItem(
                  title: 'حالت شب',
                  value: darkMode,
                  end: true,
                  onChanged: (v) {
                    darkMode.value = v;
                    Get.changeThemeMode(
                        darkMode.value ? ThemeMode.dark : ThemeMode.light);
                    var set = setting.getAt(0)!;
                    set.darkMode = v;
                    setting.putAt(0, set);
                    change.toggle();
                  },
                ),
                _headerItem(title: 'تنظیمات نمایش تقویم'),
                _switchItem(
                  title: 'نمایش تعداد تسک‌های من',
                  value: setting.getAt(0)!.myTask!.obs,
                  onChanged: (v) {
                    var set = setting.getAt(0)!;
                    set.myTask = v;
                    setting.putAt(0, set);
                    change.toggle();
                  },
                ),
                _switchItem(
                  title: 'نمایش تعداد رویدادهای تقویمی',
                  value: setting.getAt(0)!.calenderEvent!.obs,
                  onChanged: (v) {
                    var set = setting.getAt(0)!;
                    set.calenderEvent = v;
                    setting.putAt(0, set);
                    change.toggle();
                  },
                ),
                _switchItem(
                  title: 'نمایش تعداد/افزورن رویدادهای‌من به رویدادهای تقویمی',
                  value: setting.getAt(0)!.myEvent!.obs,
                  onChanged: (v) {
                    var set = setting.getAt(0)!;
                    set.myEvent = v;
                    setting.putAt(0, set);
                    change.toggle();
                  },
                ),
                _switchItem(
                  title: 'نمایش تاریخ قمری',
                  value: setting.getAt(0)!.hDate!.obs,
                  onChanged: (v) {
                    var set = setting.getAt(0)!;
                    set.hDate = v;
                    setting.putAt(0, set);
                    change.toggle();
                  },
                ),
                _switchItem(
                  title: 'نمایش تاریخ میلادی',
                  value: setting.getAt(0)!.gDate!.obs,
                  end: true,
                  onChanged: (v) {
                    var set = setting.getAt(0)!;
                    set.gDate = v;
                    setting.putAt(0, set);
                    change.toggle();
                  },
                ),
                _headerItem(title: 'تنظیمات کارها'),
                _switchItem(
                  title: 'زمان انجام کار پرسیده شود؟',
                  value: setting.getAt(0)!.timeAtWork!.obs,
                  onChanged: (v) {
                    var set = setting.getAt(0)!;
                    set.timeAtWork = v;
                    setting.putAt(0, set);
                    change.toggle();
                  },
                ),
                _navItem(
                    title: 'دسته‌بندی کارها',
                    end: true,
                    page: const WorkCatPage()),
                _headerItem(title: 'تنظیمات هزینه‌ها'),
                _switchItem(
                  title: 'زمان پرداخت پرسیده شود؟',
                  value: setting.getAt(0)!.payDate!.obs,
                  onChanged: (v) {
                    var set = setting.getAt(0)!;
                    set.payDate = v;
                    setting.putAt(0, set);
                    change.toggle();
                  },
                ),
                _navItem(
                    title: 'دسته‌بندی هزینه‌ها',
                    end: true,
                    page: const CostCatPage()),
                _headerItem(title: 'تنظیمات یادآورها'),
                _numbericItem(
                    title: 'ساعت اعلان رویدادهای روزانه',
                    value: _hourEvent,
                    callback: (v) {
                      _hourEvent = v;
                    }),
                _numbericItem(
                    title: 'ساعت اعلان بررسی اهداف',
                    value: _hourKrdo,
                    end: true,
                    callback: (v) {
                      _hourKrdo = v;
                    }),
                _headerItem(title: ''),
              ])
            : Container()));
  }
}

_headerItem({required String title, start = false}) {
  return Container(
    padding: const EdgeInsets.only(top: 20, right: 20),
    decoration: !start
        ? BoxDecoration(border: Border(top: BorderSide(color: grey2, width: 1)))
        : null,
    alignment: Alignment.topRight,
    child: Text(
      title,
      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
    ),
  );
}

_switchItem(
    {required String title,
    required RxBool value,
    onChanged,
    bool end = false}) {
  return Column(children: [
    InkWell(
      onTap: () => onChanged(!value.value),
      child: Container(
          height: 50,
          padding:
              const EdgeInsets.only(right: 20, left: 10, top: 10, bottom: 10),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(title),
            Obx(() => Switch(
                thumbColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  return grey;
                }),
                value: value.value,
                onChanged: onChanged))
          ])),
    ),
    if (!end)
      Container(
        height: 1,
        width: Get.width,
        color: grey2,
        margin: const EdgeInsets.only(right: 20),
      )
  ]);
}

_numbericItem(
    {required String title,
    required RxInt value,
    required callback,
    bool end = false}) {
  return Column(children: [
    Container(
        height: 50,
        padding:
            const EdgeInsets.only(right: 20, left: 10, top: 10, bottom: 10),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(title),
          Row(children: [
            InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: () {
                  if (value.value < 23) {
                    value.value++;
                    callback(value);
                  }
                },
                child: Icon(
                  Iconsax.arrow_up_2,
                  color: grey,
                )),
            Container(
                width: 40,
                alignment: Alignment.center,
                child: Obx(() => Text(
                      value.value.toString(),
                      style: TextStyle(
                          fontSize: 20,
                          height: 1,
                          color: grey,
                          fontWeight: FontWeight.bold),
                    ))),
            InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: () {
                  if (value.value > 0) {
                    value.value--;
                    callback(value);
                  }
                },
                child: Icon(
                  Iconsax.arrow_down_1,
                  color: grey,
                )),
          ])
        ])),
    if (!end)
      Container(
        height: 1,
        width: Get.width,
        color: grey2,
        margin: const EdgeInsets.only(right: 20),
      )
  ]);
}

_navItem({required String title, required page, end = false}) {
  return Column(children: [
    InkWell(
      onTap: () => Get.to(page),
      child: Container(
          height: 50,
          padding:
              const EdgeInsets.only(right: 20, left: 10, top: 10, bottom: 10),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text(title), const Icon(Iconsax.arrow_left_2)])),
    ),
    if (!end)
      Container(
        height: 1,
        width: Get.width,
        color: grey2,
        margin: const EdgeInsets.only(right: 20),
      )
  ]);
}
