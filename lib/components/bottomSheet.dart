// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../variables.dart';

class MyBottomSheet {
  static view(Widget child,
      {String header = '',
      double h = 400,
      isDismissible = true,
      showClose = true}) async {
    await Get.bottomSheet(
        Container(
            height: h > Get.height - 90 ? Get.height - 90 : h,
            width: Get.width,
            // constraints:
            //     BoxConstraints(maxHeight: Get.height - 100, minHeight: h),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: darkMode.value ? Colors.grey.shade800 : Colors.white,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10))),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Flexible(child: Container()),
                Flexible(
                    child: Container(
                  margin: const EdgeInsets.all(5),
                  height: 5,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey),
                )),
                Flexible(
                    child: showClose
                        ? InkWell(
                            onTap: () => Get.back(),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: const [
                                  Icon(
                                    Iconsax.close_circle,
                                    size: 20,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    'بستن',
                                    style: TextStyle(color: Colors.grey),
                                  )
                                ]))
                        : Container())
              ]),
              if (header != '')
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    header,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              Expanded(child: SingleChildScrollView(child: child))
            ])),
        isScrollControlled: true,
        enableDrag: false,
        isDismissible: isDismissible);
  }
}
