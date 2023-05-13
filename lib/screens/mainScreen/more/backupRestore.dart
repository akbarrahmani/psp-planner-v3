// ignore_for_file: file_names, use_key_in_widget_constructors, use_build_context_synchronously, depend_on_referenced_packages

import 'dart:async';
import 'dart:io';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:archive/archive_io.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cross_file/cross_file.dart';
import 'package:iconsax/iconsax.dart';
import 'package:path_provider/path_provider.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:planner/components/Celander/calender.dart';
import 'package:planner/components/button.dart';
import 'package:planner/components/toast.dart';
import 'package:planner/constant.dart';
import 'package:planner/screens/mainScreen/more/closeApp.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../../variables.dart';

RxBool _load = true.obs;
List dbname = [
  'goals',
  'objective',
  'kr',
  'krdo',
  'note',
  'workcat',
  'work',
  'costcat',
  'cost',
  'event',
  'setting',
  'healthInfo',
  'healthDaily',
  'foodDetails',
  'dbversion',
  'favoriteFood',
  'foodEat',
  'wDrink'
];
List dbItem = [
  goals,
  objective,
  kr,
  krdo,
  note,
  workCat,
  work,
  costCat,
  cost,
  event,
  setting,
  healthInfo,
  healthDaily,
  foodDetails,
  dbversion,
  favoriteFood,
  foodEat,
  wDrink
];

class Backup extends GetView {
  @override
  Widget build(BuildContext context) {
    permissionHandler();
    return Obx(() => _load.isTrue
        ? Scaffold(
            appBar: AppBar(title: const Text('پشتیبان‌گیری و بازیابی')),
            body: Column(children: [
              Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(children: [
                    const Text(
                      'پیشنهاد می‌شود با استفاده از دکمه (پشتیبان‌گیری و ارسال فایل پشتیبان) همواره اطلاعات خود را در محلی بجز تلفن‌همراه خود نگه‌داری کنید.',
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 10),
                    Row(children: [
                      MyButton(
                          title: 'پشتیبان‌گیری بر روی حافظه دستگاه',
                          bgColor: grey,
                          textColor: Colors.white,
                          height: 60,
                          icon: Iconsax.mobile,
                          onTap: () async {
                            createBackup(context, share: false);
                          })
                    ]),
                    const SizedBox(height: 10),
                    Row(children: [
                      MyButton(
                          title: 'پشتیبان‌گیری و ارسال فایل پشتیبان',
                          bgColor: orange,
                          height: 60,
                          textColor: Colors.white,
                          icon: Iconsax.share,
                          onTap: () async {
                            createBackup(context, share: true);
                          })
                    ]),
                  ])),
              Divider(
                color: grey2,
              ),
              Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(children: [
                    const Text(
                      'برای بازیابی اطلاعات خود فایل مورد نظر را انتخاب کنید.\n درنظر داشته باشید با بازیابی فایل پشتیبان تمام اطلاعات برنامه حذف و اطلاعات فایل جایگزین می‌شود. و این عملیات قابل بازگشت نخواهد بود.',
                      textAlign: TextAlign.justify,
                    ),
                    const SizedBox(height: 10),
                    Row(children: [
                      MyButton(
                          title: 'بازیابی اطلاعات',
                          bgColor: orange,
                          height: 50,
                          textColor: orange,
                          borderOnly: true,
                          icon: Iconsax.cloud_add,
                          onTap: () async {
                            // await _backupStorage.requestPermissions();
                            var zipPath = await FilePicker.platform.pickFiles(
                              type: FileType.any,
                              // allowedExtensions: ['pegahSystem']
                            );
                            if (zipPath != null &&
                                zipPath.files.first.path != null) {
                              if (zipPath.files.first.name.split('.').last !=
                                  'psp') {
                                return MyToast.error(
                                    'فایل انتخابی صحیح نیست.\nفایل با پسوند psp را انتخاب کنید.');
                              }
                              if (goals.isNotEmpty ||
                                  objective.isNotEmpty ||
                                  kr.isNotEmpty ||
                                  krdo.isNotEmpty ||
                                  note.isNotEmpty ||
                                  workCat.isNotEmpty ||
                                  work.isNotEmpty ||
                                  costCat.isNotEmpty ||
                                  cost.isNotEmpty ||
                                  event.isNotEmpty ||
                                  setting.isNotEmpty) {
                                return Get.defaultDialog(
                                    title: 'تایید بازیابی اطلاعات',
                                    barrierDismissible: false,
                                    content: Column(children: [
                                      const Text(
                                          'با بازیابی اطلاعات، تمام داده‌های فعلی پاک شده و اطلاعات از فایل بازیابی جایگزین خواهد شد.\nاز بازیابی اطلاعات اطمینان دارید؟'),
                                      const SizedBox(height: 10),
                                      Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Row(children: [
                                            Flexible(
                                              child: MyButton(
                                                  title: 'بله',
                                                  bgColor: orange,
                                                  textColor: Colors.white,
                                                  onTap: () {
                                                    Get.back();
                                                    restorDate(
                                                        context,
                                                        zipPath
                                                            .files.first.path);
                                                  }),
                                            ),
                                            const SizedBox(width: 10),
                                            Flexible(
                                                child: MyButton(
                                                    title: 'انصراف',
                                                    bgColor: grey,
                                                    textColor: grey,
                                                    borderOnly: true,
                                                    onTap: () {
                                                      return Get.back();
                                                    }))
                                          ]))
                                    ]));
                              } else {
                                restorDate(context, zipPath.files.first.path);
                              }
                            }
                          })
                    ]),
                  ])),
              if (Platform.isIOS) const SizedBox(height: 20),
              if (Platform.isIOS)
                Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Text(
                      '⚠️ بعد از اتمام عملیات بازیابی اطلاعات، برنامه را کاملا بسته و مجددا باز کنید، تا بارگذاری داده‌ها به درستی انجام گیرد.',
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 18),
                    ))
            ]),
          )
        : Scaffold(
            body: Stack(children: [
            Container(
                alignment: Alignment.center,
                child: Image.asset('asset/img/loading.gif')),
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(top: 100),
                child: const Text(
                  'لطفا منتظر بمانید...',
                  style: TextStyle(fontSize: 16),
                )),
          ])));
  }
}

createBackup(context, {share}) async {
  final key = encrypt.Key.fromLength(32);
  final iv = encrypt.IV.fromLength(16);
  final encrypter = encrypt.Encrypter(encrypt.AES(key));

  var path = await FilePicker.platform.getDirectoryPath();

  if (path != null) {
    _load.value = false;
    String fileName =
        '/plannerBackup${Jalali.now().year}-${Jalali.now().month}-${Jalali.now().day}-${Jalali.now().time.toString().split('.')[0].replaceAll(':', '')}.psp';
    File file = File(path + fileName);
    var tempDir = await getTemporaryDirectory();
    var tempDirZipFile = tempDir.path + fileName;
    var encoder = ZipFileEncoder();
    encoder.create(tempDirZipFile);
    // path +
    //   '/plannerBackup${Jalali.now().year}-${Jalali.now().month}-${Jalali.now().day}-${Jalali.now().time.toString().split('.')[0].replaceAll(':', '')}.zip');
    for (var i = 0; i < dbItem.length; i++) {
      var boxPath = dbItem[i].path;
      encoder.addFile(File(boxPath!));
    }
    // for (var item in dbname) {
    //   var box = Hive.box(item);
    //   var boxPath = box.path;
    //   encoder.addFile(File(boxPath!));
    //   // File('${dir!.path}/$item.hive'));
    // }
    encoder.close();
    final encrypted =
        encrypter.encryptBytes(File(tempDirZipFile).readAsBytesSync(), iv: iv);
    file.writeAsBytesSync(encrypted.bytes);
    _load.value = true;
    MyToast.success('فایل پشتیبان با موفقیت ایجاد شد.');

    if (share == true) {
      await Share.shareXFiles(
        [XFile(path + fileName)],
        subject: fileName.substring(1),
        text:
            "فایل پشتیبان پلنر همیار ${DateConvertor.toJalaliLong(DateTime.now())}\n🥇«پلنر همیار» همیار شما در مسیر موفقیت...\nhttps://pegahsystem.com",
      );
    }
    return true;
  }
  return false;
}

restorDate(context, zipPath) async {
  final key = encrypt.Key.fromLength(32);
  final iv = encrypt.IV.fromLength(16);
  final encrypter = encrypt.Encrypter(encrypt.AES(key));

  _load.value = false;
  var tempPath = await getTemporaryDirectory();
  File file = File(zipPath);
  File zipFile = File('${tempPath.path}/bk.zip');
  encrypt.Encrypted readData = encrypt.Encrypted(file.readAsBytesSync());
  final decrypted = encrypter.decryptBytes(readData, iv: iv);
  zipFile.writeAsBytesSync(decrypted);
  final archive = ZipDecoder().decodeBytes(zipFile.readAsBytesSync());
  for (final file in archive) {
    final filename = file.name;
    if (file.isFile) {
      final data = file.content as List<int>;
      File('${dir!.path}/$filename')
        ..createSync(recursive: true)
        ..writeAsBytesSync(data);
    } else {
      Directory('${dir!.path}/$filename').create(recursive: true);
    }
  }
  MyToast.info('بازیابی اطلاعات با موفقیت انجام شد.');

  Timer(const Duration(seconds: 1), () async {
    _load.value = true;
    Get.offAll(const CloseApp());
  });
}

permissionHandler() async {
  var status = await Permission.storage.status;
  if (status.isDenied) {
    await Permission.storage.request();
  }
  var writeStatus = await Permission.manageExternalStorage.status;
  if (writeStatus.isDenied) {
    await Permission.manageExternalStorage.request();
  }
}
