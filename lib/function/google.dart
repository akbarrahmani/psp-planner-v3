import 'dart:developer';
import 'dart:io';

import "package:googleapis_auth/auth_io.dart";
import 'package:googleapis/calendar/v3.dart';
import 'package:planner/constant.dart';
import 'package:url_launcher/url_launcher_string.dart';

const _scopes = [CalendarApi.calendarScope];

class GoogleCalender {
  static credentials() {
    if (Platform.isAndroid) {
      return ClientId(androidOAuth, "");
    } else if (Platform.isIOS) {
      return ClientId(iosOAuth, "");
    }
  }

  static insertEvent(Event event) {
    try {
      clientViaUserConsent(credentials(), _scopes, _prompt)
          .then((AuthClient client) {
        var calendar = CalendarApi(client);
        String calendarId = "primary";
        calendar.events.insert(event, calendarId).then((value) {
          // print("ADDEDDD_________________${value.status}");
          if (value.status == "confirmed") {
            log('Event added in google calendar');
          } else {
            log("Unable to add event in google calendar");
          }
        });
      });
    } catch (e) {
      log('Error creating event $e');
    }
  }
}

void _prompt(String url) async {
  if (await canLaunchUrlString(url)) {
    await launchUrlString(url);
  } else {
    throw 'Could not launch $url';
  }
}
