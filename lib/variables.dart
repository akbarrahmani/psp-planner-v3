import 'dart:io';

import 'package:appmetrica_plugin/appmetrica_plugin.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:planner/dbModels/models.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
late NotificationAppLaunchDetails? notificationAppLaunchDetails;
AppMetricaConfig get appMetricaConfig =>
    const AppMetricaConfig('a306f9d0-dafd-4e1b-b075-d01c8f72b316', logs: true);
RxBool darkMode = false.obs;
Directory? dir;
String version = '3.0.0';
int dbv = 3;

Rx<DateTime> selectedDate = DateTime.now().obs;
late Box<Goals> goals;
late Box<Objective> objective;
late Box<KR> kr;
late Box<KRdo> krdo;
late Box<Note> note;
late Box<WorkCat> workCat;
late Box<Work> work;
late Box<CostCat> costCat;
late Box<Cost> cost;
late Box<Event> event;
late Box<Setting> setting;
late Box<PageHelp> pageHelp;
late Box<HealthInfo> healthInfo;
late Box<HealthDaily> healthDaily;
late Box<FoodDetails> foodDetails;
late Box<DBVersion> dbversion;
late Box<FavoriteFood> favoriteFood;
late Box<FoodEat> foodEat;
late Box<WDrink> wDrink;

RxInt hijriOffset = 0.obs;
RxBool isLockApp = false.obs;
