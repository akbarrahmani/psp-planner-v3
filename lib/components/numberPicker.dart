// ignore_for_file: prefer_typing_uninitialized_variables, file_names, empty_catches

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planner/constant.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

// ignore: must_be_immutable
class MyNumberPicker extends GetView {
  double min, max;
  RxDouble value;
  String? title;
  IconData? icon;
  var callback;
  var endCallback;
  MyNumberPicker(
      {super.key,
      this.title,
      this.icon,
      required this.min,
      required this.max,
      required this.value,
      required this.callback,
      this.endCallback});
  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.only(right: 10),
        height: 40.0,
        decoration: BoxDecoration(
            color: (Get.isDarkMode ? grey : Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10)),
        child: Row(children: [
          Row(children: [
            Icon(
              icon,
              size: 24,
            ),
            const SizedBox(width: 5),
            if (title != null)
              Text(
                title!,
                style: TextStyle(fontSize: 16, color: grey),
              )
          ]),
          Flexible(
            child: SfLinearGauge(
                minimum: min,
                maximum: max,
                axisLabelStyle: TextStyle(
                    fontFamily: 'iran', color: grey, height: 1, fontSize: 12),
                barPointers: [
                  LinearBarPointer(
                    value: value.value,
                  )
                ],
                markerPointers: [
                  LinearWidgetPointer(
                    value: value.value,
                    position: LinearElementPosition.cross,
                    onChanged: (v) {
                      callback(v);
                    },
                    onChangeEnd: (double v) {
                      try {
                        endCallback(v);
                      } catch (e) {}
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: orange,
                          borderRadius: BorderRadius.circular(50)),
                      height: 20,
                      width: 20,
                      alignment: Alignment.center,
                      child: Text(
                        value.value.toInt().toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ]),
          )
        ])));
  }
}
