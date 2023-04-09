import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllEvent extends GetView {
  const AllEvent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(centerTitle: true, title: const Text('رویدادها')),
        body: SingleChildScrollView(
            child: Column(
          children: const [Text('تمام رویدادها')],
        )));
  }
}
