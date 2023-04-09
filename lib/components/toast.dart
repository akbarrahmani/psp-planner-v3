// ignore_for_file: empty_catches

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../constant.dart';
import '../variables.dart';

class MyToast {
  static success(message) {
    toast(message, Iconsax.tick_circle, Colors.green);
  }

  static info(message) {
    toast(message, Iconsax.info_circle, Colors.yellow);
  }

  static error(message) {
    toast(message, Iconsax.close_circle, Colors.red);
  }

  static notif({title, required message, icon, page}) {
    BotToast.showNotification(
      backButtonBehavior: BackButtonBehavior.ignore,
      backgroundColor: darkMode.isTrue ? Colors.grey.shade600 : Colors.white,
      duration: const Duration(seconds: 10),
      title: (_) => Text(title),
      subtitle: (_) => Text(message),
      leading: (_) => Icon(
        icon ?? Iconsax.message,
        color: orange,
      ),
      trailing: (cancelFunc) => TextButton(
          onPressed: () {
            cancelFunc();
            try {
              Get.to(page);
            } catch (e) {}
          },
          child: const Text('مشاهده')),
      align: const Alignment(0, -0.95),
    );
  }

  static toast(message, icon, iconColor) {
    BotToast.showCustomText(
      duration: const Duration(seconds: 2),
      onlyOne: true,
      backgroundColor: Colors.transparent,
      backButtonBehavior: BackButtonBehavior.none,
      toastBuilder: (_) => Align(
        alignment: const Alignment(0, -0.95),
        child: Container(
            margin: const EdgeInsets.only(right: 10, left: 10),
            padding:
                const EdgeInsets.only(right: 15, left: 15, top: 7, bottom: 7),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: darkMode.isTrue ? Colors.grey.shade600 : Colors.white,
                boxShadow: const [
                  BoxShadow(
                      blurRadius: 10,
                      // blurStyle: BlurStyle.solid,
                      color: Colors.black12)
                ]),
            child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Icon(
                icon,
                color: iconColor,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(message),
              ),
            ])),
      ),
    );
  }
}
