// ignore_for_file: avoid_print, file_names, must_be_immutable, unused_local_variable, unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:planner/components/button.dart';
import 'package:planner/components/floatingNavBar/animated_bottom_navigation_bar.dart';
import 'package:planner/components/lockScreen/lockScreen.dart';
import 'package:planner/constant.dart';
import 'package:planner/screens/health/daily/daily.dart';
import 'package:planner/screens/health/health.dart';
import 'package:planner/screens/home/home.dart';
import 'package:planner/screens/home/widget/cost/add.dart';
import 'package:planner/screens/home/widget/event/add.dart';
import 'package:planner/screens/home/widget/note/add.dart';
import 'package:planner/screens/home/widget/work/add.dart';
import 'package:planner/screens/mainScreen/more/about.dart';
import 'package:planner/screens/mainScreen/more/backupRestore.dart';
import 'package:planner/screens/mainScreen/more/weProduct.dart';
import 'package:planner/screens/okr/addVision.dart';
import 'package:planner/screens/okr/okr.dart';
import 'package:planner/screens/setting/setting.dart';
import 'package:planner/service/notifications/notification.dart';
import 'package:planner/variables.dart';
import 'package:url_launcher/url_launcher_string.dart';

RxInt _index = 0.obs;
late TabController tabController;

class MainCTL extends GetxController with GetTickerProviderStateMixin {
  @override
  void onInit() {
    tabController = TabController(vsync: this, length: 4);
    super.onInit();
  }
}

class MainScreen extends GetView {
  MainScreen({super.key});
  int bottomNavIndex = 0;
  RxBool change = false.obs;
  @override
  Widget build(BuildContext context) {
    Get.put(MainCTL());
    int ti = _index.value;
    int eventH = 0;
    int krdoH = 0;
    bool eventD = false;
    bool krdoD = false;
    _index.listen((p0) async {
      if (p0 == 3) {
        var s = setting.getAt(0)!;
        eventH = s.eventHourNotif!;
        krdoH = s.krdoHourNotif!;
        eventD = s.eventDayBreforNotif!;
        krdoD = s.krdoDayBreforNotif!;
      }
      if (ti == 3 && p0 != 3) {
        var s = setting.getAt(0)!;
        if (eventH != s.eventHourNotif! || eventD != s.eventDayBreforNotif!) {
          await ScheduledNotifications.setEvent();
          print('eventSet');
        }
        if (krdoH != s.krdoHourNotif! || krdoD != s.krdoDayBreforNotif!) {
          await ScheduledNotifications.setKrdo();
          print('krSet');
        }
      }
      ti = p0;
    });
    return Obx(() => !isLockApp.value
        ? WillPopScope(
            onWillPop: () async {
              bool exit = false;
              await Get.defaultDialog(
                  barrierDismissible: false,
                  title: 'خروج',
                  content: Column(children: [
                    const Text(
                        'پیشنهاد میکنیم قبل از خروج، از اطلاعات خود پشتیبان بگیرید.'),
                    const SizedBox(height: 10),
                    Row(children: [
                      Flexible(
                        child: MyButton(
                            title: 'خروج',
                            icon: Iconsax.logout,
                            bgColor: grey,
                            textColor: Colors.white,
                            onTap: () async {
                              exit = true;
                              Get.back();
                            }),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: MyButton(
                            title: 'انصراف',
                            icon: Iconsax.close_circle,
                            bgColor: grey,
                            textColor: grey,
                            borderOnly: true,
                            onTap: () async {
                              exit = false;
                              Get.back();
                            }),
                      )
                    ]),
                    const SizedBox(height: 20),
                    Row(children: [
                      MyButton(
                          title: 'تهیه فایل پشتیبان و خروج',
                          icon: Iconsax.strongbox,
                          height: 60,
                          bgColor: orange,
                          textColor: Colors.white,
                          onTap: () async {
                            //exit = await createBackup(context, share: false);
                            Get.back();
                          })
                    ]),
                  ]));
              return exit;
            },
            child: Scaffold(
              appBar: AppBar(
                toolbarHeight: 40,
                centerTitle: true,
                title: const Text(
                  'پلنر همیار',
                  style: TextStyle(height: 1),
                ),
                leading: Container(
                    padding: const EdgeInsets.only(right: 10),
                    child: InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: () {},
                        child: Image.asset(
                          'asset/img/logo.png',
                          height: 40,
                          width: 30,
                        ))),
                actions: [
                  PopupMenuButton(
                      onSelected: onSelected,
                      surfaceTintColor:
                          darkMode.value ? Colors.black : Colors.white,
                      icon: const Icon(Iconsax.more),
                      // splashRadius: 10,
                      // padding: const EdgeInsets.all(30),
                      itemBuilder: (BuildContext context) {
                        return [
                          PopupMenuItem(
                            value: 'پشتیبان‌گیری',
                            // ignore: prefer_const_literals_to_create_immutables
                            height: 40,
                            padding: EdgeInsets.zero,
                            child: Container(
                                padding:
                                    const EdgeInsets.only(bottom: 7, right: 5),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(color: grey2))),
                                child: Row(children: const [
                                  Icon(Iconsax.cloud_add),
                                  SizedBox(width: 5),
                                  Text('پشتیبان‌گیری')
                                ])),
                          ),
                          PopupMenuItem(
                            value: 'درباره ما',
                            height: 40,
                            padding: EdgeInsets.zero,
                            child: Container(
                                padding:
                                    const EdgeInsets.only(bottom: 7, right: 5),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(color: grey2))),
                                child: Row(children: const [
                                  Icon(Iconsax.info_circle),
                                  SizedBox(width: 5),
                                  Text('درباره ما')
                                ])),
                          ),
                          PopupMenuItem(
                            value: 'محصولات ما',
                            height: 40,
                            padding: EdgeInsets.zero,
                            // onTap: () => Get.to(() => WeProduct()),
                            child: Container(
                                padding:
                                    const EdgeInsets.only(bottom: 7, right: 5),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(color: grey2))),
                                child: Row(children: const [
                                  Icon(Iconsax.square),
                                  SizedBox(width: 5),
                                  Text('محصولات ما')
                                ])),
                          ),
                          PopupMenuItem(
                            value: 'تماس با ما',
                            height: 40,
                            padding: EdgeInsets.zero,
                            onTap: () => launchUrlString('tel://02141367000'),
                            child: Container(
                                padding:
                                    const EdgeInsets.only(bottom: 7, right: 5),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(color: grey2))),
                                child: Row(children: const [
                                  Icon(Iconsax.call),
                                  SizedBox(width: 5),
                                  Text('تماس با ما'),
                                  SizedBox(width: 50),
                                ])),
                          ),
                          PopupMenuItem(
                            value: 'وبسایت',
                            height: 40,
                            onTap: () =>
                                launchUrlString('https://pegahsystem.com'),
                            padding: EdgeInsets.zero,
                            child: Container(
                                padding: const EdgeInsets.only(right: 5),
                                // decoration: BoxDecoration(
                                //     border: Border(bottom: BorderSide(color: grey2))),
                                child: Row(children: const [
                                  Icon(Iconsax.global),
                                  SizedBox(width: 5),
                                  Text('وبسایت')
                                ])),
                          ),
                        ];
                      })
                ],
              ),
              body: Stack(children: [
                Obx(() => _index.value >= 0 && (change.isFalse || change.isTrue)
                    ? AnimatedSwitcher(
                        duration: const Duration(milliseconds: 150),
                        switchInCurve: Curves.easeIn,
                        switchOutCurve: Curves.linear,
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          late final Animation<Offset> of = Tween<Offset>(
                            begin: const Offset(1.5, 0.0),
                            end: Offset.zero,
                          ).animate(CurvedAnimation(
                              parent: animation,
                              curve: Curves.linearToEaseOut,
                              reverseCurve: Curves.linearToEaseOut));
                          return SlideTransition(
                            position: of,
                            child: child,
                          );
                          // return ScaleTransition(scale: animation, child: child);
                        },
                        child: Container(
                            padding: const EdgeInsets.only(bottom: 75),
                            key: ValueKey<int>(_index.value),
                            child: _index.value == 0
                                ? Home()
                                : _index.value == 1
                                    ? OKR()
                                    : _index.value == 2
                                        ? Health()
                                        : Setting()
                            // _screen[_index.value]
                            ))
                    : Container()),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: Obx(() => AnimatedBottomNavigationBar(
                        barColor: darkMode.value
                            ? Colors.grey.shade700
                            : Colors.white,
                        bottomBar: [
                          BottomBarItemsModel(
                            icon: const Icon(
                              Iconsax.calendar_tick,
                            ),
                            iconSelected: Icon(
                              Iconsax.calendar_tick,
                              color: orange,
                            ),
                            title: 'خانه',
                            dotColor: orange,
                            onTap: () => _index.value = 0,
                          ),
                          BottomBarItemsModel(
                            icon: const Icon(
                              Iconsax.d_square,
                            ),
                            iconSelected: Icon(
                              Iconsax.d_square,
                              color: orange,
                            ),
                            title: 'هدف‌گذاری',
                            dotColor: orange,
                            onTap: () => _index.value = 1,
                          ),
                          BottomBarItemsModel(
                            icon: const Icon(
                              Iconsax.health,
                            ),
                            iconSelected: Icon(
                              Iconsax.health,
                              color: orange,
                            ),
                            title: 'سلامتی',
                            dotColor: orange,
                            onTap: () => _index.value = 2,
                          ),
                          BottomBarItemsModel(
                            icon: const Icon(
                              Iconsax.setting_3,
                            ),
                            iconSelected: Icon(
                              Iconsax.setting_3,
                              color: orange,
                            ),
                            title: 'تنظیمات',
                            dotColor: orange,
                            onTap: () => _index.value = 3,
                          ),
                        ],
                        addBT: _index == 3
                            ? null
                            : _index == 0
                                ? null
                                : Container(
                                    padding: const EdgeInsets.only(
                                        bottom:
                                            Dimens.bottomPaddingAnimatedButton),
                                    child: InkWell(
                                        borderRadius: BorderRadius.circular(50),
                                        onTap: () {
                                          if (_index == 1) {
                                            addVision((v) {
                                              initVisionPage();
                                            });
                                          } else if (_index == 2) {
                                            addFood(healthSelecteddate, () {
                                              initHealthDailyPage();
                                            });
                                          }
                                        },
                                        child: const CircleAvatar(
                                          radius: 25,
                                          child: Icon(
                                            Icons.add,
                                            color: Colors.white,
                                          ),
                                        ))),
                        bottomBarCenterModel: _index != 0
                            ? null
                            : BottomBarCenterModel(
                                centerBackgroundColor: orange,
                                centerIcon: const FloatingCenterButton(
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                ),
                                centerIconChild: [
                                  FloatingCenterButtonChild(
                                    child: const Icon(
                                      Iconsax.briefcase,
                                      color: AppColors.white,
                                    ),
                                    onTap: () async {
                                      await addWork(callback: (v) {
                                        change.toggle();
                                      });
                                    },
                                  ),
                                  FloatingCenterButtonChild(
                                    child: const Icon(
                                      Iconsax.dollar_square,
                                      color: AppColors.white,
                                    ),
                                    onTap: () async {
                                      await addCost(callback: (v) {
                                        change.toggle();
                                      });
                                    },
                                  ),
                                  FloatingCenterButtonChild(
                                    child: const Icon(
                                      Iconsax.note_2,
                                      color: AppColors.white,
                                    ),
                                    onTap: () async {
                                      await addNote(callback: (v) {
                                        change.toggle();
                                      });
                                    },
                                  ),
                                  FloatingCenterButtonChild(
                                    child: const Icon(
                                      Iconsax.notification,
                                      color: AppColors.white,
                                    ),
                                    onTap: () async {
                                      await addEvent(callback: (v) {
                                        change.toggle();
                                      });
                                    },
                                  ),
                                  // FloatingCenterButtonChild(
                                  //   child: const Icon(
                                  //     Iconsax.reserve,
                                  //     size: 20,
                                  //     color: AppColors.white,
                                  //   ),
                                  //   onTap: () async {
                                  //     await addFood(DateTime.now().obs, (v) {
                                  //       change.toggle();
                                  //     });
                                  //   },
                                  // ),
                                  FloatingCenterButtonChild(
                                    child: const Icon(
                                      Icons.close,
                                      size: 20,
                                      color: AppColors.white,
                                    ),
                                    onTap: () {},
                                  ),
                                ],
                              ),
                      )),
                )
              ]),

              // bottomNavigationBar: AnimatedBottomNavigationBar(
              //   bottomBarItems: [
              //     BottomBarItemsModel(
              //       icon: const Icon(
              //         Iconsax.calendar_tick,
              //       ),
              //       iconSelected: Icon(
              //         Iconsax.calendar_tick,
              //         color: orange,
              //       ),
              //       title: 'خانه',
              //       dotColor: orange,
              //       onTap: () => _index.value = 0,
              //     ),
              //     BottomBarItemsModel(
              //       icon: const Icon(
              //         Iconsax.d_square,
              //       ),
              //       iconSelected: Icon(
              //         Iconsax.d_square,
              //         color: orange,
              //       ),
              //       title: 'OKR',
              //       dotColor: orange,
              //       onTap: () => _index.value = 1,
              //     ),
              //     BottomBarItemsModel(
              //       icon: const Icon(
              //         Iconsax.health,
              //       ),
              //       iconSelected: Icon(
              //         Iconsax.health,
              //         color: orange,
              //       ),
              //       title: 'سلامتی',
              //       dotColor: orange,
              //       onTap: () => _index.value = 2,
              //     ),
              //     BottomBarItemsModel(
              //       icon: const Icon(
              //         Iconsax.setting_3,
              //       ),
              //       iconSelected: Icon(
              //         Iconsax.setting_3,
              //         color: orange,
              //       ),
              //       title: 'تنظیمات',
              //       dotColor: orange,
              //       onTap: () => _index.value = 3,
              //     ),
              //   ],
              //   bottomBarCenterModel: BottomBarCenterModel(
              //     centerBackgroundColor: orange,
              //     centerIcon: const FloatingCenterButton(
              //       child: Icon(
              //         Icons.add,
              //         color: Colors.white,
              //       ),
              //     ),
              //     centerIconChild: [
              //       FloatingCenterButtonChild(
              //         child: const Icon(
              //           Iconsax.document_text_1,
              //           color: AppColors.white,
              //         ),
              //         onTap: () {},
              //       ),
              //       FloatingCenterButtonChild(
              //         child: const Icon(
              //           Iconsax.briefcase,
              //           color: AppColors.white,
              //         ),
              //         onTap: () {},
              //       ),
              //       FloatingCenterButtonChild(
              //         child: const Icon(
              //           Iconsax.dollar_square,
              //           color: AppColors.white,
              //         ),
              //         onTap: () {},
              //       ),
              //       FloatingCenterButtonChild(
              //         child: const Icon(
              //           Iconsax.notification,
              //           color: AppColors.white,
              //         ),
              //         onTap: () {},
              //       ),
              //       FloatingCenterButtonChild(
              //         child: const Icon(
              //           Icons.close,
              //           size: 20,
              //           color: AppColors.white,
              //         ),
              //         onTap: () {},
              //       ),
              //     ],
              //   ),
              // ),
            ))
        : lockScreen());
  }

  onSelected(v) {
    if (v == 'محصولات ما') {
      Get.to(() => WeProduct());
    } else if (v == 'درباره ما') {
      Get.to(() => About());
    } else if (v == 'پشتیبان‌گیری') {
      Get.to(() => Backup());
    }
  }
}
