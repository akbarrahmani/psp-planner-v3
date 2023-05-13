// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:planner/components/Celander/calender.dart';
import 'package:planner/constant.dart';
import 'package:planner/dbModels/models.dart';
import 'package:planner/screens/okr/object/add.dart';
import 'package:planner/screens/okr/kr/list.dart';
import 'package:planner/variables.dart';

class ObjectList extends GetView {
  Goals goal;
  var callback;
  ObjectList(this.goal, this.callback, {super.key});
  RxBool change = false.obs;
  List objList = [];
  @override
  Widget build(BuildContext context) {
    if (objective.values
        .where((element) => element.goalID == goal.id)
        .toList()
        .isEmpty) {
      Future.delayed(
          const Duration(milliseconds: 100),
          () => addObj(goal, (v) {
                initPage();
              }));
    }
    initPage();
    return Obx(() => change.isFalse || change.isTrue
        ? Scaffold(
            appBar: AppBar(title: Text('اهداف ${goal.title}-${goal.year}')),
            floatingActionButton: Container(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () => addObj(goal, (v) {
                      initPage();
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
                  if (objective.values
                      .where((element) => element.goalID == goal.id)
                      .toList()
                      .isEmpty)
                    Row(
                      children: const [
                        SizedBox(width: 5),
                        Icon(Iconsax.arrow_right_1),
                        SizedBox(width: 5),
                        Text(
                          'افزودن اهداف چشم‌انداز',
                          style: TextStyle(fontSize: 16),
                        )
                      ],
                    )
                ])),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.startDocked,
            body: objList.isNotEmpty
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        ...objList.map((e) => item(e)).toList(),
                        Container(
                            padding: const EdgeInsets.all(10),
                            alignment: Alignment.topRight,
                            child: const Text(
                                'توصیه میشود حداکثر ۵ هدف برای هر چشم‌انداز مشخص کنید.'))
                      ],
                    ),
                  )
                : const Center(
                    child: Text('هیچ هدفی برای این چشم‌انداز تعیین نشده است.')),
          )
        : Container());
  }

  initPage() async {
    // await objective.clear();
    // await kr.clear();
    // await krdo.clear();
    // await goals.clear();
    objList =
        objective.values.where((element) => element.goalID == goal.id).toList();
    change.toggle();
  }

  double _findPercent(Objective e) {
    int krd = 0;
    int krdc = 0;
    List k = kr.values.where((element) => element.objectiveID == e.id).toList();
    for (var c = 0; c < k.length; c++) {
      krd = krd +
          krdo.values
              .where((element) => element.krID == k[c]!.id)
              .toList()
              .length;
      krdc = krdc +
          krdo.values
              .where((element) => element.krID == k[c]!.id && element.check)
              .toList()
              .length;
    }
    if (krdc == 0 && krd == 0) return 0;
    return (krdc * 100) / krd;
  }

  int _eff(Objective e) {
    List k = kr.values.where((element) => element.objectiveID == e.id).toList();
    List<KRdo> kd = [];
    int kdc = 0;
    for (var c = 0; c < k.length; c++) {
      kd = kd +
          krdo.values
              .where((element) => element.krID == k[c]!.id && element.check)
              .toList();
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

  Widget item(Objective e) {
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
                  addObj(goal, (v) {
                    initPage();
                  }, item: e);
                }),
          ],
          leadingActions: const [],
          child: Container(
              padding:
                  const EdgeInsets.only(right: 10, bottom: 5, top: 5, left: 10),
              // height: 80,
              child: InkWell(
                  onTap: () => Get.to(
                      KRList(goal, e, (v) => {initPage(), callback('v')})),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 22,
                          child: Stack(children: [
                            Container(
                                alignment: Alignment.center,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  value: (_findPercent(e) / 100),
                                  strokeWidth: 2,
                                )),
                            Container(
                                alignment: Alignment.center,
                                child: Text(
                                  '${_findPercent(e).toStringAsFixed(0)}%',
                                  style: const TextStyle(color: Colors.white),
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
                                      '${e.title} (${DateConvertor.toJalaliShort(DateTime.parse(e.startDate), time: false)} تا ${DateConvertor.toJalaliShort(DateTime.parse(e.endDate), time: false)})',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal),
                                    )),
                                Text(
                                  'امتیاز: ${_eff(e)}',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: darkMode.isTrue ? grey2 : grey),
                                )
                              ]),
                              if (e.desc != '')
                                Text(
                                  e.desc,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: grey, fontSize: 12),
                                ),
                              const SizedBox(height: 5),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'ایجاد شده در: ${DateConvertor.toJalaliShort(DateTime.parse(e.date))}',
                                      style:
                                          TextStyle(fontSize: 10, color: grey2),
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
    ]);
  }
}
