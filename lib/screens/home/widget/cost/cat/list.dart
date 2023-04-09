import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CostCatPage extends GetView {
  const CostCatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            AppBar(centerTitle: true, title: const Text('دسته‌بندی هزینه‌ها')),
        body: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [])));
  }
}
