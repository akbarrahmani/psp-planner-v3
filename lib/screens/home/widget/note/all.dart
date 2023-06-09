import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planner/components/titledList.dart';
import 'package:planner/variables.dart';

class AllNote extends GetView {
  const AllNote({super.key});

  @override
  Widget build(BuildContext context) {
    return TitledList(
        data: note.values.toList(),
        type: TitledListType.note,
        callback: (v) {});
  }
}
