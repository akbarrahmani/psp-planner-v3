// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:planner/components/lockScreen/lockScreen.dart';
import 'package:planner/constant.dart';
import 'package:planner/screens/home/widget/cost/cat/list.dart';
import 'package:planner/screens/home/widget/work/cat/list.dart';
import 'package:planner/variables.dart';
part './setLock.dart';

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
  RxBool notifPanel = true.obs;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Obx(() => change.isFalse || change.isTrue
            ? Column(children: [
                _headerItem(title: 'تنظیمات برنامه', start: true),
                _switchItem(
                  title: 'حالت شب',
                  value: darkMode,
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
                _navItem(
                  title: 'رمز ورود',
                  end: true,
                  page: SetLock(
                    callback: (v) {
                      change.toggle();
                    },
                  ),
                  cap: setting.getAt(0)!.password == '' ? 'خاموش' : 'روشن',
                ),
                _headerItem(title: 'تنظیمات تقویم'),
                _switchItem(
                  title: 'نمایش تعداد کارهای من',
                  value: setting.getAt(0)!.myTask!.obs,
                  onChanged: (v) {
                    var set = setting.getAt(0)!;
                    set.myTask = v;
                    setting.putAt(0, set);
                    change.toggle();
                  },
                ),
                _switchItem(
                  title: 'نمایش تعداد هزینه‌های من',
                  value: setting.getAt(0)!.myCost!.obs,
                  onChanged: (v) {
                    var set = setting.getAt(0)!;
                    set.myCost = v;
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
                  title:
                      'نمایش تعداد یا افزودن رویدادهای‌من به رویدادهای تقویمی',
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
                _numbericItem(
                    title: 'اختلاف تاریخ قمری (روز)',
                    value: hijriOffset,
                    min: -2,
                    max: 2,
                    callback: (v) {
                      var set = setting.getAt(0)!;
                      set.hijriOffset = v;
                      setting.putAt(0, set);
                      change.toggle();
                    }),
                _switchItem(
                  title: 'نمایش تاریخ میلادی',
                  end: true,
                  value: setting.getAt(0)!.gDate!.obs,
                  onChanged: (v) {
                    var set = setting.getAt(0)!;
                    set.gDate = v;
                    setting.putAt(0, set);
                    change.toggle();
                  },
                ),
                _headerItem(title: 'تنظیمات کارها'),
                _switchItem(
                  title: 'مدت زمان انجام کار پرسیده شود؟',
                  value: setting.getAt(0)!.timeAtWork!.obs,
                  onChanged: (v) {
                    var set = setting.getAt(0)!;
                    set.timeAtWork = v;
                    setting.putAt(0, set);
                    change.toggle();
                  },
                ),
                _switchItem(
                  title: 'اولویت بندی کارها',
                  value: setting.getAt(0)!.workPriority!.obs,
                  onChanged: (v) {
                    var set = setting.getAt(0)!;
                    set.workPriority = v;
                    setting.putAt(0, set);
                    change.toggle();
                  },
                ),
                // _switchItem(
                //   title: 'افزودن به تقویم گوگل',
                //   value: setting.getAt(0)!.addWorkToGCalender!.obs,
                //   onChanged: (v) {
                //     var set = setting.getAt(0)!;
                //     set.addWorkToGCalender = v;
                //     setting.putAt(0, set);
                //     change.toggle();
                //   },
                // ),

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
                // _switchItem(
                //   title: 'افزودن به تقویم گوگل',
                //   value: setting.getAt(0)!.addCostToGCalender!.obs,
                //   onChanged: (v) {
                //     var set = setting.getAt(0)!;
                //     set.addCostToGCalender = v;
                //     setting.putAt(0, set);
                //     change.toggle();
                //   },
                // ),

                _navItem(
                    title: 'دسته‌بندی هزینه‌ها',
                    end: true,
                    page: const CostCatPage()),
                _headerItem(title: 'تنظیمات یادآورها'),
                _switchItem(
                  title: 'اعلان رویدادها در روز قبل',
                  value: setting.getAt(0)!.eventDayBreforNotif!.obs,
                  onChanged: (v) {
                    var set = setting.getAt(0)!;
                    set.eventDayBreforNotif = v;
                    setting.putAt(0, set);
                    change.toggle();
                  },
                ),
                _numbericItem(
                    title: 'ساعت اعلان رویدادها',
                    value: setting.getAt(0)!.eventHourNotif!.obs,
                    callback: (v) {
                      var set = setting.getAt(0)!;
                      set.eventHourNotif = v;
                      setting.putAt(0, set);
                      change.toggle();
                    }),
                _switchItem(
                  title: 'اعلان بررسی اهداف در روز قبل',
                  value: setting.getAt(0)!.krdoDayBreforNotif!.obs,
                  onChanged: (v) {
                    var set = setting.getAt(0)!;
                    set.krdoDayBreforNotif = v;
                    setting.putAt(0, set);
                    change.toggle();
                  },
                ),
                _numbericItem(
                    title: 'ساعت اعلان بررسی اهداف',
                    value: setting.getAt(0)!.krdoHourNotif!.obs,
                    end: true,
                    callback: (v) {
                      var set = setting.getAt(0)!;
                      set.krdoHourNotif = v;
                      setting.putAt(0, set);
                      change.toggle();
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
    required onChanged,
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
    int min = 0,
    int max = 23,
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
                  if (value.value < max) {
                    value.value++;
                    callback(value.value);
                  }
                },
                child: Icon(
                  Iconsax.arrow_up_2,
                  color: darkMode.isTrue ? grey2 : grey,
                )),
            Container(
                width: 40,
                alignment: Alignment.center,
                child: Obx(() => Text(
                      value.value.toString(),
                      style: TextStyle(
                          fontSize: 20,
                          height: 1,
                          color: darkMode.isTrue ? grey2 : grey,
                          fontWeight: FontWeight.bold),
                    ))),
            InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: () {
                  if (value.value > min) {
                    value.value--;
                    callback(value.value);
                  }
                },
                child: Icon(
                  Iconsax.arrow_down_1,
                  color: darkMode.isTrue ? grey2 : grey,
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

_navItem({required String title, required page, String? cap, end = false}) {
  return Column(children: [
    InkWell(
      onTap: () => Get.to(page),
      child: Container(
          height: 50,
          padding:
              const EdgeInsets.only(right: 20, left: 10, top: 10, bottom: 10),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(title),
            Row(children: [
              if (cap != null)
                Text(
                  cap,
                  style: TextStyle(color: grey),
                ),
              const Icon(Iconsax.arrow_left_2)
            ])
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
