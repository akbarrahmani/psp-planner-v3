import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shamsi_date/shamsi_date.dart';

import '../../../../components/bottomSheet.dart';
import '../../../../constant.dart';
import '../../../../variables.dart';

class ShowEventInHome extends GetView {
  const ShowEventInHome({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => MyBottomSheet.view(Container()),
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => Text(
                      'رویدادهای من در ${selectedDate.value.toJalali().day} ${selectedDate.value.toJalali().formatter.mN} ${selectedDate.value.toJalali().year}')),
                  Icon(
                    Iconsax.arrow_left,
                    color: grey,
                  )
                ])));
  }
}
