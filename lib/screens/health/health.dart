import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planner/screens/health/daily/daily.dart';
import 'package:planner/screens/health/firstStep/one.dart';
import 'package:planner/screens/health/firstStep/two.dart';
import 'package:planner/variables.dart';

RxInt hStep = 0.obs;

// ignore: must_be_immutable
class Health extends GetView {
  Health({super.key});
  RxBool load = false.obs;
  @override
  Widget build(BuildContext context) {
    initPage();
    return Obx(() => hStep.value == 0
        ? HStepOne()
        : hStep.value == 1
            ? const HStepTwo()
            : HDailyData());
  }

  initPage() {
    // healthDaily.clear();
    // healthInfo.clear();
    load.value = false;
    if (healthInfo.length == 0) {
      hStep.value = 0;
    } else {
      hStep.value = 2;
    }
    // hStep.value = 1 ;
    load.value = true;
  }
}
