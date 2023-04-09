// ignore_for_file: unused_local_variable

import 'dart:convert';

import 'package:iconsax/iconsax.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../components/toast.dart';

class ActionNotification {
  static click(payload) async {
    if (payload != null) {
      var data = jsonDecode(payload);
      if (data['link'] != null) {
        if (await canLaunchUrl(Uri.parse(data['link']))) {
          await launchUrl(Uri.parse(data['link']),
              mode: LaunchMode.externalApplication);
        }
      }
      MyToast.notif(
          title: data['title'],
          message: data['body'],
          icon: Iconsax.info_circle);
    }
  }

  static openAndroid(event) {
    var data = event.data;
    var notif = event.notification;
    MyToast.notif(
        title: notif.title, message: notif.body, icon: Iconsax.info_circle);
  }

  static openIOS(event) {
    var data = event.data;
    var notif = event.notification;
    MyToast.notif(
        title: notif.title, message: notif.body, icon: Iconsax.info_circle);
  }
}
