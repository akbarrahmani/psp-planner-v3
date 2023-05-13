// ignore_for_file: unnecessary_overrides

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planner/function/dataBase.dart';
import 'package:planner/service/notifications/notification.dart';
import 'package:planner/variables.dart';

import 'mainScreen/mainScreen.dart';

late AnimationController _actl;

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  @override
  Future<void> onInit() async {
    super.onInit();
    _actl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000));

    await readData();
    await MyNotification.init();
    navigate();
  }

  @override
  void onReady() {
    _actl.forward();
    super.onReady();
  }

  readData() async {
    await DataBase.readDate();
  }

  navigate() async {
    await ScheduledNotifications.setEvent();
    await ScheduledNotifications.setKrdo();
    Get.offAll(MainScreen());
  }
}

class Splash extends GetView {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());
    return Scaffold(
        body: Column(children: [
      Expanded(
        child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          RotationTransition(
              turns: Tween(begin: 0.0, end: 2.0).animate(_actl),
              child: Image.asset(
                'asset/img/logo.png',
                width: 100,
              )),
        ]),
      ),
      Expanded(
          child: Align(
        alignment: Alignment.bottomCenter,
        child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          const Text(
            'همیار پگاه‌سیستم',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 10),
          Image.asset(
            'asset/img/logoType.png',
            width: 150,
          ),
          Text('نسخه: $version'),
        ]),
      )),
      const SizedBox(
        height: 10,
      ),
    ]));
  }
}
