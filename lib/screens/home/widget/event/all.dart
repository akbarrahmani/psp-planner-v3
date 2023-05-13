import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planner/components/titledList.dart';
import 'package:planner/variables.dart';

class AllEvent extends GetView {
  const AllEvent({super.key});

  @override
  Widget build(BuildContext context) {
    return TitledList(
        data: event.values.toList(),
        type: TitledListType.event,
        callback: (v) {});
  }
}
