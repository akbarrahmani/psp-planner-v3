// ignore_for_file: file_names, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:persian_tools/persian_tools.dart';
import 'package:planner/components/MySearchFilter.dart';
import 'package:planner/components/button.dart';
import 'package:planner/components/utility.dart';
import 'package:planner/components/titledList.dart';
import 'package:planner/constant.dart';
import 'package:planner/dbModels/models.dart';
import 'package:planner/variables.dart';

foodList({callback}) {
  List allFood = foodDetails.values.toList();
  allFood.sort((a, b) => a.name.compareTo(b.name));
  List pfood = foodDetails.values
      .where((element) =>
          (element.peronal != null && element.peronal!) ||
          element.categories!.contains(20))
      .toList();
  List ffood = [];
  List ffoodId = [];
  for (var element in favoriteFood.values) {
    ffoodId.add(element.id);
  }
  for (var i = 0; i < allFood.length; i++) {
    if (ffoodId.contains(allFood[i].id)) ffood.add(allFood[i]);
  }
  ffood.sort((a, b) => a.name.compareTo(b.name));
  RxList f = List.from(allFood).obs;
  RxString mode = 'all'.obs;
  Get.dialog(Scaffold(
    appBar: AppBar(
      title: const Text('انتخاب خوراکی'),
    ),
    body: Column(children: [
      Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: MySearchFilter(
            listData: f.value,
            condition: const ['name'],
            callback: (v) {
              f.value = v;
            },
          )),
      Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Obx(() => Row(children: [
                MyButton(
                    title: 'همه',
                    icon: Iconsax.menu_1,
                    bgColor: grey,
                    textColor: mode.value == 'all' ? Colors.white : grey,
                    borderOnly: mode.value != 'all',
                    onTap: () => {
                          f = List.from(allFood).obs,
                          mode.value = 'all',
                        }),
                const SizedBox(width: 10),
                MyButton(
                    title: 'علاقمندی',
                    icon: Icons.favorite_border,
                    bgColor: grey,
                    textColor: mode.value == 'fav' ? Colors.white : grey,
                    borderOnly: mode.value != 'fav',
                    onTap: () => {
                          f = List.from(ffood).obs,
                          mode.value = 'fav',
                        }),
                const SizedBox(width: 10),
                MyButton(
                    title: 'شخصی',
                    icon: Iconsax.user,
                    bgColor: grey,
                    textColor: mode.value == 'per' ? Colors.white : grey,
                    borderOnly: mode.value != 'per',
                    onTap: () => {
                          f = List.from(pfood).obs,
                          mode.value = 'per',
                        })
              ]))),
      Expanded(
          child: Obx(() =>
              mode.value == 'all' || mode.value == 'fav' || mode.value == 'per'
                  ? TitledList(
                      data: f.value,
                      type: TitledListType.food,
                      callback: (v) {
                        callback(v);
                      })
                  : Container()))
    ]),
  ));
}

foodItem({FoodDetails? food, callback}) {
  return Column(children: [
    InkWell(
      onTap: () => callback(food),
      child: Container(
        height: 50,
        padding: const EdgeInsets.only(right: 30, left: 5),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Flexible(
              child: Text(
            food!.name!,
            style: const TextStyle(fontWeight: FontWeight.bold),
          )),
          Row(children: [
            Column(children: [
              const Text('کالری'),
              Container(
                alignment: Alignment.center,
                width: 50,
                padding: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), color: orange),
                child: Text(
                  food.calorie == null
                      ? '-'
                      : addCommas(doubleToString(food.calorie!, 4)),
                  style: const TextStyle(color: Colors.white),
                ),
              )
            ]),
            const SizedBox(width: 5),
            Column(children: [
              const Text('ک'),
              Container(
                alignment: Alignment.center,
                width: 50,
                padding: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 146, 208, 119)),
                child: Text(
                  food.carbo == null ? '-' : doubleToString(food.carbo!, 4),
                  style: const TextStyle(color: Colors.white),
                ),
              )
            ]),
            const SizedBox(width: 5),
            Column(children: [
              const Text('پ'),
              Container(
                alignment: Alignment.center,
                width: 50,
                padding: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 241, 162, 125)),
                child: Text(
                  food.protein == null ? '-' : doubleToString(food.protein!, 4),
                  style: const TextStyle(color: Colors.white),
                ),
              )
            ]),
            const SizedBox(width: 5),
            Column(children: [
              const Text('چ'),
              Container(
                alignment: Alignment.center,
                width: 50,
                padding: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 255, 196, 59)),
                child: Text(
                  food.fat == null ? '-' : doubleToString(food.fat!, 4),
                  style: const TextStyle(color: Colors.white),
                ),
              )
            ])
          ])
        ]),
      ),
    ),
    Container(
      height: 1,
      width: Get.width,
      margin: const EdgeInsets.only(right: 30),
      color: darkMode.isTrue ? Colors.grey.shade800 : Colors.grey.shade300,
    )
  ]);
}
