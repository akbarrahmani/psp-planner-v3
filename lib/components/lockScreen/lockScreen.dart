// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planner/components/lockScreen/keyPad.dart';
import 'package:planner/components/toast.dart';
import 'package:planner/constant.dart';
import 'package:planner/variables.dart';

RxString _password = ''.obs;
RxBool _error = false.obs;
var pass = '';
var passConf = '';
RxBool conf = false.obs;
lockScreen({biometric = true, setPass = false, setOff = false, callback}) {
  _password = ''.obs;
  _error = false.obs;
  pass = '';
  passConf = '';
  conf = false.obs;
  return Scaffold(
    body: Container(
      height: Get.height,
      width: Get.width,
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
            alignment: Alignment.center,
            child: Obx(() => conf.isTrue || conf.isFalse
                ? Text(
                    setPass
                        ? conf.isTrue
                            ? 'رمز عبور را مجددا وارد کنید'
                            : 'رمز عبور جدید را وارد کنید'
                        : setOff
                            ? 'برای حذف پسورد آن را وارد کنید'
                            : 'رمز عبور را وارد کنید: ',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  )
                : Container())),
        _enterPass(),
        Container(
          alignment: Alignment.center,
          child: Obx(() => _error.isTrue
              ? const Text(
                  'رمز صحیح نیست!',
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                )
              : Container()),
        ),
        Obx(() => SizedBox(
              height: _error.isTrue ? 30 : 60,
            )),
        Align(
            alignment: Alignment.bottomCenter,
            child: KeyPad(
              length: 4,
              biometric: biometric,
              output: setPass
                  ? (p) {
                      conf.isFalse ? pass = p : passConf = p;
                      _password.value = p;
                      if (conf.isFalse && p.length == 4) {
                        conf.value = true;
                        _password.value = '';
                      } else if (conf.isTrue && p.length == 4) {
                        _submit((v) {
                          callback(v);
                        });
                      }
                    }
                  : setOff
                      ? (p) async {
                          _password.value = p;
                          _error.value = false;
                          if (p.length == 4 &&
                              p != setting.getAt(0)!.password) {
                            _password.value = '';
                            _error.value = true;
                          } else if (p == setting.getAt(0)!.password) {
                            var set = setting.getAt(0)!;
                            set.password = '';
                            await setting.putAt(0, set);
                            callback('v');
                            Get.back();
                            MyToast.success('قفل برنامه غیرفعال شد.');
                          }
                        }
                      : (p) {
                          _password.value = p;
                          _error.value = false;
                          if (p.length == 4 &&
                              p != setting.getAt(0)!.password) {
                            _password.value = '';
                            _error.value = true;
                          } else if (p == setting.getAt(0)!.password) {
                            isLockApp.value = false;
                          }
                        },
            )),
      ]),
    ),
  );
}

_enterPass() {
  return SizedBox(
      height: 50,
      child: Obx(() =>
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            for (int i = 0; i < 4; i++) _enterItem(_password.value.length > i)
          ])));
}

_enterItem(bool enter) {
  return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        width: 40,
        height: 40,
        padding: const EdgeInsets.all(9),
        // decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(10),
        //     border: Border.all(color: Colors.grey.shade600)),
        child: enter
            ? CircleAvatar(
                maxRadius: 14,
                backgroundColor: darkMode.value ? Colors.grey : Colors.black,
              )
            : CircleAvatar(
                maxRadius: 14,
                backgroundColor: grey,
                child: CircleAvatar(
                  maxRadius: 9.1,
                  backgroundColor: darkMode.isTrue
                      ? Colors.grey.shade800
                      : Colors.grey.shade200,
                )),
      ));
}

_submit(callback) async {
  if (pass != passConf) {
    MyToast.error('رمز و تکرار رمز یکسان نیست!!!');
    pass = passConf = '';
    conf.value = false;
  } else {
    var set = setting.getAt(0)!;
    set.password = pass;
    await setting.putAt(0, set);
    pass = passConf = '';
    conf.value = false;
    callback('v');
    Get.back();
    MyToast.success('قفل برنامه فعال شد.');
  }
}
