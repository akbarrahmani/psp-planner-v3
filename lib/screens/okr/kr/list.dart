// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:planner/components/bottomSheet.dart';
import 'package:planner/constant.dart';
import 'package:planner/dbModels/models.dart';
import 'package:planner/screens/okr/kr/add.dart';
import 'package:planner/screens/okr/krdo/list.dart';
import 'package:planner/variables.dart';

class KRList extends GetView {
  Goals goal;
  Objective obj;
  var callback;
  KRList(this.goal, this.obj, this.callback, {super.key});
  RxBool change = false.obs;
  List krList = [];

  @override
  Widget build(BuildContext context) {
    if (kr.values
        .where((element) => element.objectiveID == obj.id)
        .toList()
        .isEmpty) {
      Future.delayed(
          const Duration(milliseconds: 100),
          () => addKR(goal, obj, (v) {
                initPage();
              }));
    }
    initPage();
    return Obx(() => change.isFalse || change.isTrue
        ? Scaffold(
            appBar: AppBar(
                title:
                    Text('نتایج هدف ${obj.title}، ${goal.title}-${goal.year}')),
            floatingActionButton: Container(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () => addKR(goal, obj, (v) {
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
            body: krList.isNotEmpty
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        ...krList.map((e) => item(e)).toList(),
                        Container(
                            padding: const EdgeInsets.all(10),
                            alignment: Alignment.topRight,
                            child: const Text(
                                'توصیه میشود حداکثر ۵ نتیجه برای هر هدف مشخص کنید.'))
                      ],
                    ),
                  )
                : const Center(
                    child: Text('هیچ نتیجه‌ای برای این هدف تعیین نشده است.')),
          )
        : Container());
  }

  initPage() {
    krList =
        kr.values.where((element) => element.objectiveID == obj.id).toList();
    change.toggle();
  }

  int _eff(KR k) {
    List<KRdo> kd = [];
    int kdc = 0;
    kd = kd +
        krdo.values
            .where((element) => element.krID == k.id && element.check)
            .toList();
    for (var i = 0; i < kd.length; i++) {
      kdc = kdc + kd[i].rate;
    }
    try {
      return (kdc ~/ kd.length);
    } catch (e) {
      return 0;
    }
  }

  Widget item(KR e) {
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

                  addKR(goal, obj, (v) {
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
                  onTap: () => Get.to(() => KRDOList(goal, obj, e, (v) {
                        initPage();
                        callback('v');
                      })),
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
                                  value: ((krdo.values
                                                  .where((element) =>
                                                      element.krID == e.id &&
                                                      element.check)
                                                  .toList()
                                                  .length *
                                              100) /
                                          krdo.values
                                              .where((element) =>
                                                  element.krID == e.id)
                                              .toList()
                                              .length) /
                                      100,
                                  strokeWidth: 2,
                                )),
                            Container(
                                alignment: Alignment.center,
                                child: Text(
                                  "${((krdo.values.where((element) => element.krID == e.id && element.check).toList().length * 100) / krdo.values.where((element) => element.krID == e.id).toList().length).toStringAsFixed(0)}%",
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
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                        fit: FlexFit.tight,
                                        child: Text(
                                          e.title,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal),
                                        )),
                                    Text(
                                      'امتیاز: ${_eff(e)}',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color:
                                              darkMode.isTrue ? grey2 : grey),
                                    ),
                                  ]),
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                        fit: FlexFit.tight,
                                        child: (e.desc != '')
                                            ? Text(
                                                e.desc,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    color: grey, fontSize: 12),
                                              )
                                            : Container()),
                                    Text('دوره بررسی: ${e.rp} روز',
                                        style: TextStyle(
                                            color:
                                                darkMode.isTrue ? grey2 : grey,
                                            fontSize: 12))
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

showDetailKR(KR e) {
  MyBottomSheet.view(Column());
}
