// ignore_for_file: empty_catches, unnecessary_null_comparison, unused_local_variable

import 'dart:io';

import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:appmetrica_push_plugin/appmetrica_push_plugin.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:planner/service/notifications/action.dart';
import 'package:push/push.dart';

import 'package:planner/variables.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class MyNotification {
  static init() async {
    await MyNotification.configureLocalTimeZone();
    await MyNotification.initialNotif();
    notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

    await AppMetricaPush.getTokens().then((tokens) async {});

    try {
      Push.instance.onMessage.listen((message) {
        if (Platform.isIOS) {
          ActionNotification.openIOS(message);
        } else {
          ActionNotification.openAndroid(message);
        }
      });
    } catch (e) {}
    Push.instance.notificationTapWhichLaunchedAppFromTerminated.then((data) {
      if (data == null) {
      } else {
        String pl = data['payload'].toString();
        if (pl.startsWith('local')) {
          if (pl != null) {
            MyNotification.cancelNotification(
                int.parse(pl.split('-')[1].substring(1)));
            if (pl.startsWith('localwork')) {
              int id = int.parse(pl.split('-2')[1]);
              var obj =
                  work.values.where((element) => element.id == id).toList()[0];
              // addWork(item: obj);
              //  Get.to(() => AddWork(item: obj), transition: Transition.downToUp);
            } else if (pl.startsWith('localcost')) {
              int id = int.parse(pl.split('-3')[1]);
              var obj =
                  cost.values.where((element) => element.id == id).toList()[0];
              // Get.to(() => AddCost(item: obj), transition: Transition.downToUp);
            } else if (pl.startsWith('localevent')) {
              int id = int.parse(pl.split('-4')[1]);
              var obj =
                  event.values.where((element) => element.id == id).toList()[0];
              //  Get.to(() => AddEvent(item: obj), transition: Transition.downToUp);
            } else if (pl.startsWith('localkrdo')) {
              int id = int.parse(pl.split('-1')[1]);
              var kd =
                  krdo.values.where((element) => element.id == id).toList()[0];
              var k = kr.values.where((element) => element.id == kd.krID);
              // changeKrDo(dayPageContext, itemDo: kd, krObj: k, callback: () {
              //   homePageLoad.value = false;
              //   kardoFind();
              //   homePageLoad.value = true;
              // });
            }
          }
        }
        ActionNotification.click(data['payload']);
      }
    });
    AppMetrica.sendEventsBuffer();
  }

  static configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  static cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  static initialNotif() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    await AppMetricaPush.requestPermission(
        alert: true, badge: true, sound: true);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
            requestAlertPermission: true,
            requestBadgePermission: true,
            requestSoundPermission: true,
            onDidReceiveLocalNotification: (
              int id,
              String? title,
              String? body,
              String? payload,
            ) async {});
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: initializationSettingsIOS,
      linux: null,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {
      switch (notificationResponse.notificationResponseType) {
        case NotificationResponseType.selectedNotification:
          //  selectNotificationStream.add(notificationResponse.payload);
          break;
        case NotificationResponseType.selectedNotificationAction:
          // if (notificationResponse.actionId == navigationActionId) {
          //   //selectNotificationStream.add(notificationResponse.payload);
          // }
          break;
      }
    });
  }

  static requestPermissions() {
    AppMetricaPush.requestPermission(alert: true, badge: true, sound: true);
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(badge: true, sound: true, alert: true);
  }

  ///notif ID 1xx>>xx=KrdoID 2xx>>xx=workID 3xx>>xx=CostID 4xx>>xx=EventID
  static scheduleNotification(
      {required int id,
      required String title,
      required String body,
      required tz.TZDateTime date,
      required String payload}) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        date,
        const NotificationDetails(
            android: AndroidNotificationDetails('PegahSystem', 'Planner',
                onlyAlertOnce: true),
            iOS: DarwinNotificationDetails(sound: 'slow_spring_board.aiff')),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dateAndTime,
        androidAllowWhileIdle: true,
        payload: payload);
  }
}
