import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkCatPage extends GetView {
  const WorkCatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(centerTitle: true, title: const Text('دسته‌بندی کارها')),
        body: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [])));
  }
}
