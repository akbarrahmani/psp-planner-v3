// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:planner/components/Celander/calender.dart';
import 'package:planner/components/button.dart';
import 'package:planner/constant.dart';
import 'package:planner/dbModels/models.dart';
import 'package:planner/screens/okr/addVision.dart';
import 'package:planner/screens/okr/object/list.dart';
import 'package:planner/variables.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:url_launcher/url_launcher_string.dart';

List _lst = [];
RxBool _change = false.obs;

class OKR extends GetView {
  const OKR({super.key});

  @override
  Widget build(BuildContext context) {
    initVisionPage();
    return Obx(() => (_change.isFalse || _change.isTrue) && goals.isEmpty
        ? SafeArea(
            child: Stack(children: [
            Positioned(
              bottom: -50,
              left: -200,
              child: Icon(
                Iconsax.chart_3,
                size: Get.width * 1.2,
                color: grey2.withOpacity(0.3),
              ),
            ),
            Column(children: [
              Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  alignment: Alignment.center,
                  child: const Text(
                    'هدف‌گذاری به روش OKR',
                    style: TextStyle(
                        height: 2, fontSize: 16, fontWeight: FontWeight.bold),
                  )),
              Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  alignment: Alignment.center,
                  child: const Text(
                    '''OKR خلاصه عبارت (Objectives and Key Results) به معنای اهداف و نتایج کلیدی است و یک روش عالی برای تعیین اهداف شرکت، گروه‌ها و افراد به حساب می‌آید. این سیستم فقط اهداف را تعیین نمی‌کند بلکه می‌تواند آن اهداف را با تعدادی نتیجه (معمولا سه تا چهار نتیجه) قابل اندازه‌گیری مرتبط کند.
بنابراین ما یک هدف خاص برای کسب و کار خودمان تعریف می‌کنیم و سه تا چهار نتیجه کلیدی برای آن هدف خودمان تعیین می‌کنیم. در نتیجه وقتی آن نتایج کلیدی محقق شد می‌توانیم بگوییم که به هدف خودمان دست پیدا کرده‌ایم. با استفاده از سیستم OKR فردی و یا سازمانی می‌توانیم میزان پیشرفت خودمان در راستای تحقق آن اهداف را اندازه‌گیری کنیم و نتایج را با سایر اعضای سازمان در میان بگذاریم.''',
                    textAlign: TextAlign.justify,
                    style: TextStyle(height: 2),
                  )),
              Container(
                  padding: const EdgeInsets.only(right: 20, left: 20, top: 30),
                  child: Row(children: [
                    MyButton(
                        title: 'مطالعه بیشتر...',
                        bgColor: grey,
                        textColor: Colors.white,
                        onTap: () => launchUrlString(
                            'https://pegahsystem.com/okr-چیست/',
                            mode: LaunchMode.externalNonBrowserApplication))
                  ])),
              Container(
                  padding: const EdgeInsets.only(right: 20, left: 20, top: 20),
                  child: Row(children: [
                    MyButton(
                        title: 'شروع هدف‌گذاری',
                        height: 90,
                        bgColor: orange,
                        textColor: Colors.white,
                        onTap: () {
                          addVision((v) async {
                            initVisionPage();
                            await Future.delayed(
                                const Duration(milliseconds: 100));
                            Get.to(() => ObjectList(v, (v) {
                                  initVisionPage();
                                }));
                          });
                        })
                  ])),
            ]),
          ]))
        : SafeArea(
            child: Column(children: [
            Expanded(
                child: SingleChildScrollView(
                    child: Column(
                        children: _lst.map((e) => showItem(e)).toList()))),
            // Container(
            //     padding: const EdgeInsets.only(left: 10, right: 100, bottom: 5),
            //     child: Row(children: [
            //       Flexible(flex: 1, fit: FlexFit.tight, child: Container()),
            //       MyButton(
            //           title: 'افزودن چشم انداز جدید',
            //           bgColor: grey2,
            //           textColor: Colors.black,
            //           onTap: () => addVision((v) async {
            //                 initVisionPage();
            //                 await Future.delayed(
            //                     const Duration(milliseconds: 100));
            //                 Get.to(() => ObjectList(v, (v) {
            //                       initVisionPage();
            //                     }));
            //               }))
            //     ]))
          ])));
  }

  int _eff(Goals g) {
    List obj =
        objective.values.where((element) => element.goalID == g.id).toList();
    List<KRdo> kd = [];
    int kdc = 0;
    for (var i = 0; i < obj.length; i++) {
      List k = kr.values
          .where((element) => element.objectiveID == obj[i].id)
          .toList();

      for (var c = 0; c < k.length; c++) {
        kd = kd +
            krdo.values
                .where((element) => element.krID == k[c]!.id && element.check)
                .toList();
      }
    }
    for (var i = 0; i < kd.length; i++) {
      kdc = kdc + kd[i].rate;
    }
    try {
      return (kdc ~/ kd.length);
    } catch (e) {
      return 0;
    }
  }

  Widget showItem(g) {
    [1, 2, 3, 5, 4].sort((a, b) => a.compareTo(b));
    return Column(
      children: [
        SwipeActionCell(
            index: g!.id,
            key: ValueKey(g!.id),
            firstActionWillCoverAllSpaceOnDeleting: false,
            closeWhenScrolling: false,
            trailingActions: [
              if (g.year >= Jalali.now().year)
                SwipeAction(
                    title: "ویرایش",
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                    icon: const Icon(
                      Iconsax.edit,
                      color: Colors.white,
                    ),
                    color: orange,
                    widthSpace: 100,
                    forceAlignmentToBoundary: true,
                    performsFirstActionWithFullSwipe: true,
                    onTap: (handler) async {
                      handler(false);
                      addVision((v) {
                        initVisionPage();
                      }, item: g);
                    }),
            ],
            leadingActions: const [],
            child: Container(
                padding: const EdgeInsets.only(
                    right: 10, bottom: 5, top: 5, left: 10),
                // height: 80,
                child: InkWell(
                    onTap: () => Get.to(() => ObjectList(g, (v) {
                          _change.toggle();
                        })),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 40,
                            height: g.desc == '' ? 42 : 60,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: g.year == Jalali.now().year
                                    ? orange
                                    : g.year < Jalali.now().year
                                        ? grey2
                                        : grey),
                            child: Stack(children: [
                              Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    '${g.year}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  )),
                              Align(
                                  alignment: Alignment.center,
                                  child: Icon(
                                    g.year == Jalali.now().year
                                        ? Iconsax.play
                                        : g.year < Jalali.now().year
                                            ? Iconsax.close_circle
                                            : Iconsax.timer,
                                    color: Colors.white24,
                                    size: 30,
                                  ))
                            ]),
                          ),
                          const SizedBox(width: 5),
                          Flexible(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                Row(children: [
                                  Flexible(
                                      fit: FlexFit.tight,
                                      child: Text(
                                        g!.title,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal),
                                      )),
                                  Text(
                                    'امتیاز: ${_eff(g)}',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: darkMode.isTrue ? grey2 : grey),
                                  )
                                ]),
                                if (g.desc != '')
                                  Text(
                                    '${g.desc}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(color: grey, fontSize: 12),
                                  ),
                                const SizedBox(height: 5),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        'ایجاد شده در: ${DateConvertor.toJalaliShort(DateTime.parse(g!.date))}',
                                        style: TextStyle(
                                            fontSize: 10, color: grey2),
                                      )
                                    ])
                              ]))
                        ])))),
        Container(
          height: 1,
          width: Get.width,
          margin: const EdgeInsets.only(right: 60),
          color: darkMode.isTrue ? Colors.grey.shade800 : Colors.grey.shade300,
        )
      ],
    );
  }
}

initVisionPage() {
  _lst = goals.values.toList();
  _lst.sort((a, b) => a.year.compareTo(b.year));
  _change.toggle();
}
