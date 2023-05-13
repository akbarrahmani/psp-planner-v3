// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:planner/components/button.dart';
import 'package:planner/constant.dart';
import 'package:planner/screens/health/health.dart';
import 'package:planner/variables.dart';
import 'package:planner/screens/health/components/component.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:time_machine/time_machine.dart';

class HStepTwo extends GetView {
  const HStepTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: Get.width,
      child: Column(children: [
        const SizedBox(height: 20),
        Text(
          'تنت سالم، دلت خوش🌹',
          style: TextStyle(
              color: orange, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        const Text(
          'با پلنرهمیار بیشتر حواست به سلامتیت هست!',
          style: TextStyle(fontSize: 17),
        ),
        const SizedBox(height: 10),
        Expanded(
            child: Column(children: [ageRowContainer(), bmiRowContainer()])),
        Container(
            padding: const EdgeInsets.only(right: 25, left: 25),
            child: const Text(
              'برای نمایش اطلاعات دقیق همه روزه داده‌های خواسته شده را وارد نمایید. تا بتوانیم محاسبات دقیق‌تری برای شما داشته باشیم.',
              style: TextStyle(fontSize: 17),
              textAlign: TextAlign.justify,
            )),
        const SizedBox(height: 10),
        Row(children: [
          MyButton(
              title: 'ویرایش',
              bgColor: grey,
              icon: Iconsax.edit,
              textColor: Colors.white,
              onTap: () async {
                hStep.value = 0;
              }),
          const SizedBox(width: 10),
          MyButton(
              title: 'ادامه',
              icon: Iconsax.previous,
              bgColor: orange,
              textColor: Colors.white,
              onTap: () {
                hStep.value = 2;
              })
        ]),
        const SizedBox(height: 10),
      ]),
    );
  }

  ageRowContainer() {
    Period age = const Period();
    var hd =
        healthInfo.length > 0 ? healthInfo.getAt(healthInfo.length - 1)! : null;
    if (hd != null) {
      age = LocalDate.dateTime(DateTime.now()).periodSince(LocalDate.dateTime(
          Jalali(
                  int.parse(hd.birthday.split('/')[0]),
                  int.parse(hd.birthday.split('/')[1]),
                  int.parse(hd.birthday.split('/')[2]))
              .toDateTime()));
    }
    return Container(
        decoration: BoxDecoration(
          color: grey.withAlpha(70),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.only(right: 10, left: 10, top: 5, bottom: 5),
        margin: const EdgeInsets.all(10),
        width: Get.width,
        height: 100,
        child: Stack(children: [
          const Align(
              alignment: Alignment.topRight,
              child: Text(
                'شما تا امروز',
                style: TextStyle(fontSize: 17),
              )),
          Align(
              alignment: Alignment.center,
              child: Text(
                '${age.years} سال و ${age.months} ماه و ${age.days} روز',
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              )),
          const Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'را پشت‌سر گذاشتید.',
                style: TextStyle(fontSize: 17),
              ))
        ]));
  }

  bmiRowContainer() {
    double bmi = 0.0;
    String bmiStatus = '';
    var hd =
        healthInfo.length > 0 ? healthInfo.getAt(healthInfo.length - 1)! : null;
    if (hd != null) {
      double height = hd.height / 100;
      bmi = double.parse((hd.weight / (height * height)).toStringAsFixed(1));
      bmiStatus = bmiStatusChecker(bmi);
    }
    return Container(
        decoration: BoxDecoration(
          color: bmiColor(bmi).withAlpha(60),
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(10),
        width: Get.width,
        child: Column(children: [
          Container(
              padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'شاخص توده بدنی (BMI)',
                      style: TextStyle(fontSize: 17),
                    ),
                    Text(
                      bmi.toString(),
                      style: const TextStyle(
                          fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '(${persianBMIStatus(bmi)})',
                      style: const TextStyle(fontSize: 17),
                    )
                  ])),
          Container(
              padding: const EdgeInsets.only(right: 5, left: 5, bottom: 1),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerRight,
                    end: Alignment.centerLeft,
                    colors: [
                      lowWeightColor,
                      okWeightColor,
                      greateWeightColor,
                      fatWeightColor,
                      veryFatWeightColor
                    ],
                    stops: const [
                      0.1,
                      0.3,
                      0.5,
                      0.73,
                      1
                    ]),
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'تا ۱۹ کمبود‌وزن',
                      style: TextStyle(fontSize: 10),
                    ),
                    Text(
                      'تا ۲۵ متناسب',
                      style: TextStyle(fontSize: 10),
                    ),
                    Text(
                      'تا ۳۰ اضافه‌وزن',
                      style: TextStyle(fontSize: 10),
                    ),
                    Text(
                      'تا ۴۰ چاق',
                      style: TextStyle(fontSize: 10),
                    ),
                    Text(
                      '> خیلی‌چاق',
                      style: TextStyle(fontSize: 10),
                    ),
                  ]))
        ]));
  }
}
