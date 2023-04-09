import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planner/components/titledList.dart';
import 'package:planner/variables.dart';

class AllWork extends GetView {
  const AllWork({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(centerTitle: true, title: const Text('کارها')),
        body: TitledList(
            data: work.values.toList(),
            type: TitledListType.work,
            callback: (v) {}));
  }
}
