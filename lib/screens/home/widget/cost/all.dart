import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planner/components/titledList.dart';
import 'package:planner/variables.dart';

class AllCost extends GetView {
  const AllCost({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(centerTitle: true, title: const Text('هزینه‌ها')),
        body: TitledList(
            data: cost.values.toList(),
            type: TitledListType.cost,
            callback: (v) {}));
  }
}
