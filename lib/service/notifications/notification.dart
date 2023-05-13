// ignore_for_file: empty_catches, unnecessary_null_comparison, unused_local_variable

import 'dart:io';

import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:appmetrica_push_plugin/appmetrica_push_plugin.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:planner/components/Celander/calender.dart';
import 'package:planner/screens/home/widget/cost/list.dart';
import 'package:planner/screens/home/widget/work/list.dart';
import 'package:planner/screens/okr/krdo/list.dart';
import 'package:planner/service/notifications/action.dart';
import 'package:push/push.dart';

import 'package:planner/variables.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class MyNotification {
  static init() async {
    try {
      await MyNotification.configureLocalTimeZone();
      await MyNotification.initialNotif();
      notificationAppLaunchDetails = await flutterLocalNotificationsPlugin
          .getNotificationAppLaunchDetails();

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
            MyNotification.cancelNotification(
                int.parse(pl.split('-')[1].substring(1)));
            if (pl.startsWith('localwork')) {
              int id = int.parse(pl.split('-2')[1]);
              var obj =
                  work.values.where((element) => element.id == id).toList()[0];
              workItemDetails(obj, (v) {});
            } else if (pl.startsWith('localcost')) {
              int id = int.parse(pl.split('-3')[1]);
              var obj =
                  cost.values.where((element) => element.id == id).toList()[0];
              costItemDetails(obj, (v) {});
            } else if (pl.startsWith('localevent')) {
              int id = int.parse(pl.split('-4')[1]);
              var obj =
                  event.values.where((element) => element.id == id).toList()[0];

              //  Get.to(() => AddEvent(item: obj), transition: Transition.downToUp);
            } else if (pl.startsWith('localkrdo')) {
              int id = int.parse(pl.split('-1')[1]);
              var kd =
                  krdo.values.where((element) => element.id == id).toList()[0];
              var k = kr.values
                  .where((element) => element.id == kd.krID)
                  .toList()[0];
              var o = objective.values
                  .where((element) => element.id == k.objectiveID)
                  .toList()[0];
              var g = goals.values
                  .where((element) => element.id == o.goalID)
                  .toList()[0];
              showDetailKRdo(g, o, k, kd, (v) {
                workListHomePageChange();
              });
            }
          }
          ActionNotification.click(data['payload']);
        }
      });
      AppMetrica.sendEventsBuffer();
    } catch (e) {}
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

class ScheduledNotifications {
  static setEvent() {
    int eventHour = setting.getAt(0)!.eventHourNotif!;
    DateTime tomorrow = DateTime.now().add(const Duration(days: 1));
    DateTime afterTomorrow = DateTime.now().add(const Duration(days: 2));
    String tj =
        '${DateConvertor.toJalaliShort(tomorrow, time: false).split('/')[1]}/${DateConvertor.toJalaliShort(tomorrow, time: false).split('/')[2]}';
    String atj =
        '${DateConvertor.toJalaliShort(afterTomorrow, time: false).split('/')[1]}/${DateConvertor.toJalaliShort(afterTomorrow, time: false).split('/')[2]}';
    for (var i = 0; i < event.length; i++) {
      var env = event.getAt(i)!;
      if (env.effDate == tj || env.effDate == atj) {
        var date = Jalali(
                Jalali.now().year,
                int.parse(env.effDate.split('/')[0]),
                int.parse(env.effDate.split('/')[1]))
            .toUtcDateTime()
            .add(Duration(
                days: setting.getAt(0)!.eventDayBreforNotif! ? -1 : 0));
        MyNotification.scheduleNotification(
            id: int.parse('4${env.id}'),
            title: env.title,
            body: 'رویداد در تاریخ ${env.effDate}/${Jalali.now().year}',
            date: tz.TZDateTime(
                tz.local, date.year, date.month, date.day, eventHour, 0, 0),
            payload: 'localevent-${int.parse('4${env.id}')}');
      }
    }
  }

  static setKrdo() {
    int krdoHour = setting.getAt(0)!.krdoHourNotif!;
    String tomorrow = DateTime.now()
        .add(const Duration(days: 1))
        .toIso8601String()
        .split('T')[0];
    String afterTomorrow = DateTime.now()
        .add(const Duration(days: 2))
        .toIso8601String()
        .split('T')[0];
    for (var i = 0; i < krdo.length; i++) {
      var kd = krdo.getAt(i)!;
      if (kd.date.split('T')[0] == tomorrow ||
          kd.date.split('T')[0] == afterTomorrow) {
        var k = kr.values.where((element) => element.id == kd.krID).toList()[0];
        var obj = objective.values
            .where((element) => element.id == k.objectiveID)
            .toList()[0];
        var g = goals.values
            .where((element) => element.id == obj.goalID)
            .toList()[0];
        String title =
            'بررسی نتیجه ${k.title} از هدف ${obj.title} چشم‌انداز ${g.title}';
        DateTime dd = DateTime.parse(kd.date).add(
            Duration(days: setting.getAt(0)!.krdoDayBreforNotif! ? -1 : 0));
        MyNotification.scheduleNotification(
            id: int.parse('1${kd.id}'),
            title: title,
            body: 'بررسی هدف',
            date: tz.TZDateTime(
                tz.local, dd.year, dd.month, dd.day, krdoHour, 0, 0),
            payload: 'localkrdo-${int.parse('1${kd.id}')}');
      }
    }
  }
}
