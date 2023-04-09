import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:planner/components/bottomSheet.dart';
import 'package:planner/components/button.dart';
import 'package:planner/constant.dart';
import 'package:planner/screens/home/widget/cost/cat/add.dart';
import 'package:planner/variables.dart';

costCatSelect({String? selected, callback}) {
  if (costCat.isEmpty) {
    costCatAdd(callback: (e) => callback(e));
  } else {
    MyBottomSheet.view(Column(children: [
      const Text('دسته‌بندی‌ هزینه‌ها',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      const SizedBox(height: 10),
      Wrap(
          spacing: 10,
          runSpacing: 10,
          children: costCat.values
              .map((e) => InkWell(
                  onTap: () {
                    callback(e);
                    Get.back();
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color:
                              selected == e.name ? orange : Colors.transparent,
                          border: Border.all(
                              color: selected == e.name ? orange : grey,
                              width: 1),
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(e.name,
                          style: TextStyle(
                              color: selected == e.name ? Colors.white : grey,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)))))
              .toList()
              .reversed
              .toList()),
      Container(
          padding: const EdgeInsets.all(10),
          child: Row(children: [
            MyButton(
                title: 'دسته‌بندی جدید',
                bgColor: grey,
                textColor: grey,
                icon: Iconsax.add,
                borderOnly: true,
                onTap: () {
                  Get.back();
                  costCatAdd(callback: (e) => callback(e));
                })
          ]))
    ]));
  }
}
