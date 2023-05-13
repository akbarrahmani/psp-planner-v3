// ignore_for_file: must_be_immutable, unrelated_type_equality_checks, unused_element

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
import 'package:planner/screens/health/health.dart';
import 'package:planner/variables.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class HStepOne extends GetView {
  HStepOne({super.key});
  RxString gender = ''.obs;
  RxInt h = 90.obs;
  final RxBool _hs = false.obs;
  final _bdc = TextEditingController();
  RxString bd = ''.obs;
  RxInt w = 60.obs;
  RxBool _ws = false.obs;
  final _actc = TextEditingController();
  int? _act;
  @override
  Widget build(BuildContext context) {
    initPage();
    return Obx(() => Container(
        padding: const EdgeInsets.all(10),
        width: Get.width,
        // color: gender.value == ''
        //     ? Colors.transparent
        //     : gender.value == 'man'
        //         ? const Color.fromARGB(50, 183, 245, 255)
        //         : const Color.fromARGB(50, 255, 189, 189),
        child: Column(children: [
          const Text(
              'در این بخش از پلنر همیار میتوانید سلامتی خود را بطور مختصر زیر نظر بگیرید.\nبرای این امر مشخصات خود را ثبت، و بعد از آن بصورت روزانه اطلاعات خواسته شده را وارد نمایید.',
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 16)),
          Container(
              margin: const EdgeInsets.only(top: 5),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: darkMode.isTrue ? grey2 : grey)),
              padding: const EdgeInsets.all(5),
              child: Row(children: const [
                Icon(
                  Iconsax.danger,
                  color: Colors.red,
                ),
                SizedBox(width: 5),
                Flexible(
                    child: Text(
                        'لازم بذکر است اطلاعات ارائه شده در این بخش نمی‌تواند به عنوان مرجع پزشکی استفاده شود.',
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontSize: 16, color: Colors.red)))
              ])),
          const SizedBox(height: 10),
          Row(children: [
            MyButton(
                title: 'زن',
                icon: Iconsax.woman,
                bgColor: gender.value != 'woman' ? grey : womanColor,
                textColor: gender.value != 'woman' ? grey : Colors.white,
                borderOnly: gender.value != 'woman',
                onTap: () {
                  gender.value = 'woman';
                }),
            const SizedBox(width: 10),
            MyButton(
                title: 'مرد',
                icon: Iconsax.man,
                bgColor: gender.value != 'man' ? grey : manColor,
                textColor: gender.value != 'man' ? grey : Colors.white,
                borderOnly: gender.value != 'man',
                onTap: () {
                  gender.value = 'man';
                })
          ]),
          const SizedBox(height: 10),
          Expanded(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                Flexible(
                    child: Stack(children: [
                  Obx(() => _hs.isFalse
                      ? Container(
                          padding: const EdgeInsets.only(left: 30),
                          alignment: Alignment.centerLeft,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                // Text('پس از انتخاب جنسیت'),
                                Text(
                                  'قد خود را تنظیم کنید',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text('به بالا بکشید...'),
                                Icon(Iconsax.arrow_up_2)
                              ]),
                        )
                      : Container()),
                  SfLinearGauge(
                      minimum: 100,
                      maximum: 200,
                      showAxisTrack: false,
                      orientation: LinearGaugeOrientation.vertical,
                      axisLabelStyle: TextStyle(
                          fontFamily: 'iran',
                          color: grey,
                          height: 1,
                          fontSize: 12),
                      barPointers: [
                        LinearBarPointer(
                            value: h.value.toDouble(),
                            thickness: 100,
                            enableAnimation: false,
                            position: LinearElementPosition.outside,
                            color: Colors.transparent,
                            child: gender.value == ''
                                ? Container()
                                : Image.asset(gender.value == 'man'
                                    ? 'asset/img/health/mh.png'
                                    : 'asset/img/health/wh.png')),
                      ],
                      markerPointers: [
                        LinearWidgetPointer(
                            value: h.value.toDouble(),
                            position: LinearElementPosition.outside,
                            onChanged: (v) {
                              if (gender.value == '') {
                                MyToast.info('ابتدا جنسیت خود را مشخص کنید.');
                              } else {
                                _hs.value = true;
                                h.value = v.toInt();
                              }
                            },
                            onChangeEnd: (double v) {
                              if (gender.value != '') {
                                _hs.value = true;
                              }
                            },
                            child: SizedBox(
                                width: Get.width / 3,
                                child: Row(children: [
                                  SizedBox(
                                      width: (Get.width / 4),
                                      child: Divider(
                                        color: darkMode.isTrue ? grey2 : grey,
                                      )),
                                  Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color:
                                                darkMode.isTrue ? grey2 : grey,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      height: 20,
                                      width: 30,
                                      alignment: Alignment.center,
                                      child: Obx(() => Text(
                                            _hs.value
                                                ? h.value.toStringAsFixed(0)
                                                : 'قد',
                                            style: TextStyle(
                                              fontWeight: _hs.value
                                                  ? null
                                                  : FontWeight.bold,
                                              fontSize: _hs.value ? null : 20,
                                              height: _hs.value ? null : 1,
                                              color: darkMode.isTrue
                                                  ? grey2
                                                  : grey,
                                            ),
                                          ))),
                                ]))),
                      ]),
                ])), //  if (false)
                Flexible(
                    child: Column(children: [
                  MyInput(
                      controller: _bdc,
                      title: 'تاریخ تولد',
                      type: InputType.text,
                      readOnly: true,
                      icon: Iconsax.cake,
                      onTap: () => MyCalender.picker(callback: (DateTime v) {
                            Jalali jv = v.toJalali();
                            bd.value = '${jv.year}/${jv.month}/${jv.day}';
                            _bdc.text =
                                DateConvertor.toJalaliLong(v, time: false);
                          })),
                  // MyNumberPicker(
                  //     min: 40,
                  //     max: 140,
                  //     value: _w,
                  //     icon: Iconsax.weight,
                  //     callback: (v) {
                  //       _w.value = v;
                  //     }),

                  Expanded(
                      child: Container(
                    width: Get.width,
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: (Get.isDarkMode ? grey : Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(10)),
                    child: SfRadialGauge(
                      axes: <RadialAxis>[
                        RadialAxis(
                            canScaleToFit: true,
                            labelOffset: 8,
                            axisLabelStyle: GaugeTextStyle(
                                fontFamily: 'iran',
                                color: darkMode.isTrue ? grey2 : grey,
                                //height: 1,
                                fontSize: 12),
                            minimum: 40,
                            maximum: 150,
                            pointers: [
                              MarkerPointer(
                                  enableDragging: true,
                                  value: w.value.toDouble(),
                                  onValueChangeStart: (double startValue) {},
                                  onValueChanging: (ValueChangingArgs v) {
                                    if (gender.value == '') {
                                      MyToast.info(
                                          'ابتدا جنسیت خود را مشخص کنید.');
                                    } else {
                                      _ws.value = true;
                                      w.value = v.value.toInt();
                                    }
                                  },
                                  onValueChanged: (v) {
                                    if (gender.value == '') {
                                      MyToast.info(
                                          'ابتدا جنسیت خود را مشخص کنید.');
                                    } else {
                                      _ws.value = true;
                                      w.value = v.toInt();
                                    }
                                  },
                                  onValueChangeEnd: (double v) {
                                    if (gender.value != '') {
                                      _ws.value = true;
                                    }
                                  })
                            ],
                            annotations: <GaugeAnnotation>[
                              GaugeAnnotation(
                                  widget: Container(
                                      padding:
                                          const EdgeInsets.only(bottom: 12),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  IconButton(
                                                    icon: const Icon(
                                                        Iconsax.add_circle),
                                                    onPressed: () {
                                                      if (gender.value == '') {
                                                        MyToast.info(
                                                            'ابتدا جنسیت خود را مشخص کنید.');
                                                      } else {
                                                        _ws.value = true;
                                                        w.value++;
                                                      }
                                                    },
                                                  ),
                                                  Obx(() => Text(
                                                      _ws.value
                                                          ? w.value.toString()
                                                          : 'وزن',
                                                      style: const TextStyle(
                                                          fontSize: 40,
                                                          height: 1,
                                                          fontWeight: FontWeight
                                                              .bold))),
                                                  IconButton(
                                                    icon: const Icon(
                                                        Iconsax.minus_cirlce),
                                                    onPressed: () {
                                                      if (gender.value == '') {
                                                        MyToast.info(
                                                            'ابتدا جنسیت خود را مشخص کنید.');
                                                      } else {
                                                        _ws.value = true;
                                                        w.value--;
                                                      }
                                                    },
                                                  ),
                                                ]),
                                            const SizedBox(height: 8),
                                            const Icon(
                                              Iconsax.weight,
                                              size: 30,
                                            ),
                                          ])),
                                  angle: 90,
                                  positionFactor: 0.0)
                            ])
                      ],
                    ),
                  )),
                  MyInput(
                    controller: _actc,
                    title: 'سطح فعالیت هفتگی',
                    type: InputType.text,
                    readOnly: true,
                    icon: Iconsax.activity,
                    onTap: () => MyBottomSheet.view(
                        Column(children: [
                          const SizedBox(height: 10),
                          const Text(
                            'سطح فعالیت هفتگی خود را انتخاب کنید.',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: List.generate(
                                5,
                                (index) => InkWell(
                                    onTap: () {
                                      _act = index + 1;
                                      _actc.text = _act == 1
                                          ? 'بسیار کم (غالبا نشسته)'
                                          : _act == 2
                                              ? 'کم (۱ تا ۳ روز ورزش)'
                                              : _act == 3
                                                  ? 'متوسط (۳ تا ۵ روز ورزش)'
                                                  : _act == 4
                                                      ? 'زیاد (۶ تا ۷ روز ورزش)'
                                                      : 'خیلی زیاد (ورزش حرفه‌ای)';
                                      Get.back();
                                    },
                                    child: Image.asset(
                                      'asset/img/health/act/${index + 1}.png',
                                      height: Get.width / 2,
                                    ))),
                          )
                        ]),
                        h: 280),
                  )
                ]))
              ])),
          const SizedBox(height: 10),
          Row(children: [
            MyButton(
                title: 'تایید و ادامه',
                icon: Iconsax.tick_circle,
                bgColor: orange,
                textColor: Colors.white,
                onTap: () async {
                  if (gender.value != '' &&
                      _hs.value &&
                      _ws.value &&
                      bd.value != '' &&
                      _act != null) {
                    await healthInfo.clear();
                    await healthDaily.clear();
                    HealthInfo hi = HealthInfo(
                        gender: gender.value,
                        birthday: bd.value,
                        height: h.value,
                        weight: w.value,
                        dailyAct: _act!,
                        date: DateTime.now().toIso8601String());
                    HealthDaily hd = HealthDaily(
                        date: DateTime.now().toIso8601String(),
                        weight: w.value,
                        height: h.value);
                    await healthInfo.add(hi);
                    await healthDaily.add(hd);
                    MyToast.success('اطلاعات با موفقیت ثبت شد.');
                    hStep.value = 1;
                  } else {
                    MyToast.error('تمام اطلاعات را وارد کنید.');
                  }
                }),
          ]),
          const SizedBox(height: 15),
        ])));
  }

  initPage() {
    if (healthInfo.isNotEmpty) {
      HealthInfo hi = healthInfo.getAt(healthInfo.length - 1)!;
      gender.value = hi.gender;
      h = hi.height.obs;
      _hs.value = true;
      var td = hi.birthday.split('/');
      var jd = Jalali(int.parse(td[0]), int.parse(td[1]), int.parse(td[2]))
          .toDateTime();
      _bdc.text = DateConvertor.toJalaliLong(jd, time: false);

      bd = hi.birthday.obs;
      w = hi.weight.obs;
      _ws = true.obs;
      _act = hi.dailyAct;
      _actc.text = _act == 1
          ? 'بسیار کم (غالبا نشسته)'
          : _act == 2
              ? 'کم (۱ تا ۳ روز ورزش)'
              : _act == 3
                  ? 'متوسط (۳ تا ۵ روز ورزش)'
                  : _act == 4
                      ? 'زیاد (۶ تا ۷ روز ورزش)'
                      : 'خیلی زیاد (ورزش حرفه‌ای)';
    }
  }
}
