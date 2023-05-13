// ignore_for_file: file_names, prefer_typing_uninitialized_variables, unused_catch_clause

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:local_auth/local_auth.dart';
import 'package:planner/variables.dart';

// ignore: must_be_immutable
class KeyPad extends GetView {
  var output;
  int? length;
  bool biometric;
  KeyPad(
      {super.key,
      required this.output,
      required this.length,
      this.biometric = true});
  var out = '';
  RxBool bioOk = false.obs;
  @override
  Widget build(BuildContext context) {
    if (biometric) checkBio();
    return SizedBox(
        height: Get.height * 0.5,
        child: Column(children: [
          Expanded(
              child: SizedBox(
                  width: 250,
                  child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: GridView.count(
                          crossAxisCount: 3,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            ...List.generate(
                                    9, (index) => item((index + 1).toString()))
                                .toList(),
                            Obx(() =>
                                bioOk.value ? item('biometric') : Container()),
                            item('0'),
                            item('back')
                          ])))),
        ]));
  }

  checkBio() async {
    bioOk.value = await _checkDeviceSupportBiometric();
    if (bioOk.value) authBio();
  }

  Widget item(String val) {
    return InkWell(
      onTap: val == 'biometric'
          ? () => authBio()
          : val == 'back'
              ? () {
                  if (out.isNotEmpty) {
                    out = out.toString().substring(0, out.length - 1);
                  }
                  output(out);
                }
              : () {
                  if (out.length == length!) out = '';
                  if (out.length < length!) out += val;
                  output(out);
                },
      borderRadius: BorderRadius.circular(50),
      child: CircleAvatar(
          maxRadius: 30,
          backgroundColor: Colors.grey.shade300.withOpacity(0.7),
          child: val == 'biometric'
              ? Icon(
                  Platform.isIOS ? Iconsax.scan : Iconsax.finger_scan,
                  size: 42,
                )
              : val == 'back'
                  ? const Icon(Icons.backspace_outlined)
                  : Text(
                      val,
                      style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: Colors.black),
                    )),
    );
  }

  authBio() async {
    bool auth = await _authenticateWithBiometrics();
    if (auth) {
      output(setting.getAt(0)!.password);
    }
  }
}

Future<bool> _checkDeviceSupportBiometric() async {
  final LocalAuthentication auth = LocalAuthentication();
  bool au = await auth.isDeviceSupported();
  return au;
}

Future<bool> _authenticateWithBiometrics() async {
  final LocalAuthentication auth = LocalAuthentication();
  bool authenticated = false;
  try {
    authenticated = await auth.authenticate(
      localizedReason: 'ورود به پلنر همیار',
      authMessages: [],
      options: const AuthenticationOptions(
        stickyAuth: true,
        biometricOnly: true,
      ),
    );
    // ignore: empty_catches
  } on PlatformException catch (e) {}
  return authenticated;
}
