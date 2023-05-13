// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:planner/components/Celander/calender.dart';
import 'package:planner/components/bottomSheet.dart';
import 'package:planner/components/button.dart';
import 'package:planner/components/numberPicker.dart';
import 'package:planner/components/textInput.dart';
import 'package:planner/components/toast.dart';
import 'package:planner/constant.dart';
import 'package:planner/dbModels/models.dart';
import 'package:planner/screens/okr/krdo/add.dart';
import 'package:planner/variables.dart';

class KRDOList extends GetView {
  Goals goal;
  Objective obj;
  KR k;
  var callback;
  KRDOList(this.goal, this.obj, this.k, this.callback, {super.key});
  RxBool change = false.obs;
  List krdoList = [];
  @override
  Widget build(BuildContext context) {
    if (krdo.values.where((element) => element.krID == k.id).toList().isEmpty) {
      Future.delayed(
          const Duration(milliseconds: 100),
          () => addKRDO(goal, obj, k, (v) {
                initPage();
                callback('v');
              }));
    }
    initPage();
    return Obx(() => change.isFalse || change.isTrue
        ? Scaffold(
            appBar: AppBar(
                title: Text(
                    'بررسی نتیجه ${k.title}، هدف ${obj.title}، ${goal.title}-${goal.year}')),
            floatingActionButton: Container(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () => addKRDO(goal, obj, k, (v) {
                      initPage();
                      callback('v');
                    }),
                    child: const CircleAvatar(
                      maxRadius: 25,
                      child: Icon(
                        Iconsax.add,
                        size: 25,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  if (kr.values
                      .where((element) => element.objectiveID == obj.id)
                      .toList()
                      .isEmpty)
                    Row(
                      children: [
                        const SizedBox(width: 5),
                        const Icon(Iconsax.arrow_right_1),
                        const SizedBox(width: 5),
                        Text(
                          'افزودن نتایج هدف ${obj.title} ${goal.title}-${goal.year}',
                          style: const TextStyle(fontSize: 16),
                        )
                      ],
                    )
                ])),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.startDocked,
            body: krdoList.isNotEmpty
                ? SingleChildScrollView(
                    child: Column(
                      children: krdoList.map((e) => item(e)).toList(),
                    ),
                  )
                : const Center(
                    child: Text('هیچ نتیجه‌ای برای این هدف تعیین نشده است.')),
          )
        : Container());
  }

  initPage() {
    krdoList = krdo.values.where((element) => element.krID == k.id).toList();
    change.toggle();
  }

  Widget item(KRdo e) {
    return Column(children: [
      SwipeActionCell(
          index: e.id,
          key: ValueKey(e.id),
          firstActionWillCoverAllSpaceOnDeleting: false,
          closeWhenScrolling: false,
          trailingActions: [
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
                  addKRDO(goal, obj, k, (v) {
                    initPage();
                    callback('v');
                  }, item: e);
                }),
          ],
          leadingActions: const [],
          child: Container(
              padding:
                  const EdgeInsets.only(right: 10, bottom: 5, top: 5, left: 10),
              // height: 80,
              child: InkWell(
                  onTap: () => showDetailKRdo(goal, obj, k, e, (v) {
                        initPage();
                        callback('v');
                      }),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                            radius: 22,
                            backgroundColor: e.check
                                ? orange
                                : DateTime.parse(e.date)
                                        .isBefore(DateTime.now())
                                    ? Colors.red
                                    : grey,
                            child: Stack(children: [
                              if (e.check)
                                Container(
                                    alignment: Alignment.center,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      value: e.rate / 100,
                                      strokeWidth: 2,
                                    )),
                              if (!e.check || (e.check && e.rate == 0))
                                Container(
                                    alignment: Alignment.center,
                                    child: Icon(
                                      e.check
                                          ? Iconsax.tick_circle
                                          : DateTime.parse(e.date)
                                                  .isBefore(DateTime.now())
                                              ? Iconsax.close_circle
                                              : Iconsax.timer,
                                      color: e.check
                                          ? Colors.white24
                                          : Colors.white,
                                    )),
                              if (e.check)
                                Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      e.rate.toString(),
                                      //(krdoList.indexOf(e) + 1).toString(),
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    )),
                            ])),
                        const SizedBox(width: 5),
                        Flexible(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                //crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                        fit: FlexFit.tight,
                                        child: Text(
                                          DateConvertor.toJalaliShort(
                                              DateTime.parse(e.date),
                                              time: false),
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal),
                                        )),
                                    if (e.check)
                                      Text('امتیاز: ${e.rate}',
                                          style: TextStyle(
                                              color: grey, fontSize: 12))
                                  ]),
                              if (e.desc != '')
                                Text(
                                  e.desc,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: grey, fontSize: 12),
                                ),
                            ]))
                      ])))),
      Container(
        height: 1,
        width: Get.width,
        margin: const EdgeInsets.only(right: 60),
        color: darkMode.isTrue ? Colors.grey.shade800 : Colors.grey.shade300,
      )
    ]);
  }
}

showDetailKRdo(Goals g, Objective o, KR k, KRdo e, callback) {
  RxDouble v = e.rate.toDouble().obs;
  MyBottomSheet.view(
      Column(children: [
        Text(
          'تعیین امتیاز بررسی ${DateConvertor.toJalaliShort(DateTime.parse(e.date), time: false)}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          'نتیجه ${k.title}، هدف ${o.title}، چشم‌انداز ${g.title}-${g.year}',
        ),
        const SizedBox(height: 5),
        MyNumberPicker(
          icon: Iconsax.ruler,
          min: 0,
          max: 100,
          value: v,
          callback: (vl) {
            v.value = vl;
          },
          endCallback: (double vl) async {
            e.rate = vl.toInt();
            e.check = true;
            for (var i = 0; i < krdo.length; i++) {
              if (krdo.getAt(i)!.id == e.id) {
                await krdo.putAt(i, e);
                Get.back();
                callback('v');
                MyToast.success('امتیاز بررسی ثبت شد.');
                break;
              }
            }
          },
        ),
        if (e.desc != '')
          MyInput(
              title: 'توضیحات',
              readOnly: true,
              controller: TextEditingController(text: e.desc),
              line: 3,
              icon: Iconsax.document,
              type: InputType.text),
        const SizedBox(height: 5),
        Row(children: [
          MyButton(
              title: 'ویرایش توضیحات',
              bgColor: darkMode.isTrue ? grey2 : grey,
              textColor: darkMode.isTrue ? grey2 : grey,
              borderOnly: true,
              onTap: () {
                Get.back();
                addKRDO(g, o, k, (v) {
                  callback('v');
                }, item: e);
              })
        ])
      ]),
      h: e.desc != '' ? 310 : 180);
}

class KRDOItemShowInHome extends GetView {
  KRdo kd;
  KR? k;
  Objective? obj;
  Goals? goal;
  var callback;
  KRDOItemShowInHome({required this.kd, required this.callback, super.key});
  @override
  Widget build(BuildContext context) {
    k = kr.values.where((element) => element.id == kd.krID).toList()[0];
    obj = objective.values
        .where((element) => element.id == k!.objectiveID)
        .toList()[0];
    goal =
        goals.values.where((element) => element.id == obj!.goalID).toList()[0];
    return Column(children: [
      SwipeActionCell(
          index: kd.id,
          key: ValueKey(kd.id),
          firstActionWillCoverAllSpaceOnDeleting: false,
          closeWhenScrolling: false,
          trailingActions: [
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
                  addKRDO(goal!, obj!, k!, (v) {
                    //initPage();
                    callback('v');
                  }, item: kd);
                }),
          ],
          leadingActions: const [],
          child: Container(
              height: 50,
              padding:
                  const EdgeInsets.only(right: 10, bottom: 5, top: 5, left: 10),
              child: InkWell(
                  onTap: () => showDetailKRdo(goal!, obj!, k!, kd, (v) {
                        callback('v');
                        // initPage();
                      }),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                            radius: 22,
                            backgroundColor: kd.check
                                ? orange
                                : DateTime.parse(kd.date)
                                        .isBefore(DateTime.now())
                                    ? Colors.red
                                    : grey,
                            child: Stack(children: [
                              if (kd.check)
                                Container(
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                        width: 33,
                                        height: 33,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          value: kd.rate / 100,
                                          strokeWidth: 2,
                                        ))),
                              if (!kd.check || (kd.check && kd.rate == 0))
                                Container(
                                    alignment: Alignment.center,
                                    child: Icon(
                                      kd.check
                                          ? Iconsax.tick_circle
                                          : DateTime.parse(kd.date)
                                                  .isBefore(DateTime.now())
                                              ? Iconsax.close_circle
                                              : Iconsax.timer,
                                      color: kd.check
                                          ? Colors.white24
                                          : Colors.white,
                                    )),
                              if (kd.check)
                                Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      kd.rate.toString(),
                                      //(krdoList.indexOf(e) + 1).toString(),
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    )),
                            ])),
                        const SizedBox(width: 5),
                        Flexible(
                            fit: FlexFit.tight,
                            child: Text(
                              'بررسی نتیجه ${k!.title}، هدف ${obj!.title}، چشم‌انداز ${goal!.title}',
                              style: TextStyle(
                                  decoration: kd.check
                                      ? TextDecoration.lineThrough
                                      : null,
                                  fontSize: 16,
                                  fontWeight: kd.check
                                      ? FontWeight.normal
                                      : FontWeight.bold),
                            )),
                      ])))),
      Container(
        height: 1,
        width: Get.width,
        margin: const EdgeInsets.only(right: 60),
        color: darkMode.isTrue ? Colors.grey.shade800 : Colors.grey.shade300,
      )
    ]);
  }
}
