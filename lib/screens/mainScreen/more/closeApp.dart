// ignore_for_file: file_names

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:planner/constant.dart';

class CloseApp extends GetView {
  const CloseApp({super.key});

  @override
  Widget build(BuildContext context) {
    RxInt ti = 5.obs;
    Timer.periodic(const Duration(seconds: 1), (time) {
      ti.value--;
      if (ti.value == 0) exit(0);
    });
    return Scaffold(
      body: Container(
          padding: const EdgeInsets.all(20),
          alignment: Alignment.center,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Iconsax.cloud_change,
                  size: 200,
                  color: grey2,
                ),
                const SizedBox(height: 20),
                const Text(
                  'بازیابی اطلاعات با موفقیت انجام شد.',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.justify,
                ),
                const Text(
                  'برای اتمام فرایند اپلیکیشن بسته می‌شود.',
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 20),
                ),
                Obx(() => Text(
                      '${ti.value} ثانیه',
                      style: TextStyle(fontSize: 20, color: orange),
                    ))
              ])),
    );
  }
}
