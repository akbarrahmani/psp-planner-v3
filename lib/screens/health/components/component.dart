import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planner/components/food/foodCategoris.dart';
import 'package:planner/variables.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:time_machine/time_machine.dart';

Color lowWeightColor = const Color.fromARGB(255, 100, 181, 246);
Color okWeightColor = const Color.fromARGB(255, 79, 203, 83);
Color greateWeightColor = Colors.yellow;
Color fatWeightColor = const Color.fromARGB(255, 245, 124, 0);
Color veryFatWeightColor = const Color.fromARGB(255, 211, 47, 47);

Color bmiColor(double bmi) {
  return bmi.isLowerThan(19.01)
      ? lowWeightColor
      : bmi.isLowerThan(25.01)
          ? okWeightColor
          : bmi.isLowerThan(30.01)
              ? greateWeightColor
              : bmi.isLowerThan(40.01)
                  ? fatWeightColor
                  : veryFatWeightColor;
}

String bmiStatusChecker(double bmi) {
  return bmi.isLowerThan(19.01)
      ? 'low'
      : bmi.isLowerThan(25.01)
          ? 'ok'
          : bmi.isLowerThan(30.01)
              ? 'great'
              : bmi.isLowerThan(40.01)
                  ? 'fat'
                  : 'veryFat';
}

String persianBMIStatus(double bmi) {
  return bmi.isLowerThan(19.01)
      ? 'کمبود وزن'
      : bmi.isLowerThan(25.01)
          ? 'متناسب'
          : bmi.isLowerThan(30.01)
              ? 'اضافه وزن'
              : bmi.isLowerThan(40.01)
                  ? 'چاق'
                  : 'چاقی مفرط';
}

double dailyActFactor(int act) {
  switch (act) {
    case 1:
      return 1.2; //فعالیت خیلی کم
    case 2:
      return 1.375; // کم
    case 3:
      return 1.55; //متوسط
    case 4:
      return 1.725; //زیاد
    case 5:
      return 1.9; //خیلی زیاد
    default:
      return 1.375;
  }
}

int calCalories(Rx<DateTime> sdate) {
  RxInt bmr = 0.obs;
  var info = healthInfo.getAt(healthInfo.length - 1)!;
  int age = LocalDate.dateTime(sdate.value)
      .periodSince(LocalDate.dateTime(Jalali(
              int.parse(info.birthday.split('/')[0]),
              int.parse(info.birthday.split('/')[1]),
              int.parse(info.birthday.split('/')[2]))
          .toDateTime()))
      .years;
  if (info.gender == 'men' || info.gender == 'man') {
    bmr.value =
        (66 + (13.7 * info.weight) + (5 * info.height) - (6.8 * age)).toInt();
  } else {
    bmr.value =
        (655 + (9.6 * info.weight) + (1.7 * info.height) - (4.7 * age)).toInt();
  }
  switch (info.dailyAct) {
    case 1:
      bmr.value = (bmr.value * 1.2).toInt();
      break;
    case 2:
      bmr.value = (bmr.value * 1.375).toInt();
      break;
    case 3:
      bmr.value = (bmr.value * 1.55).toInt();
      break;
    case 4:
      bmr.value = (bmr.value * 1.725).toInt();
      break;
    case 5:
      bmr.value = (bmr.value * 1.9).toInt();
      break;
  }
  return bmr.value;
}

String findFoodCatName(id) {
  for (var i = 0; i < foodCatgoriesDB.length; i++) {
    if (foodCatgoriesDB[i]['id'] == id) {
      return foodCatgoriesDB[i]['name'];
    }
  }
  return ' ';
}

int findWeight(DateTime date) {
  int d = 0;
  do {
    for (var i = healthDaily.length - 1; i > -1; i--) {
      var h = healthDaily.getAt(i)!;
      if (date.add(Duration(days: d)).toIso8601String().split('T')[0] ==
          h.date!.split('T')[0]) {
        return h.weight!;
      }
    }
    d--;
  } while (date
      .add(Duration(days: d))
      .isAfter(DateTime.parse(healthDaily.getAt(0)!.date!)));
  return healthDaily.getAt(0)!.weight!;
}

int findWather(DateTime date) {
  var wd = wDrink.values
      .where((element) =>
          date.toIso8601String().split('T')[0] == element.date!.split('T')[0])
      .toList();
  if (wd.isNotEmpty) {
    return wd[0].count!;
  } else {
    return 0;
  }
}

double findCaleries(DateTime date) {
  var c = 0.0;
  var cd = foodEat.values
      .where((element) =>
          date.toIso8601String().split('T')[0] == element.date!.split('T')[0])
      .toList();
  if (cd.isNotEmpty) {
    for (var i = 0; i < cd.length; i++) {
      c += (cd[i].food!.calorie! * cd[i].amount!);
    }
  }
  return c;
}
