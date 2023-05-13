// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:planner/components/Celander/calender.dart';
import 'package:planner/dbModels/models.dart';
import 'package:planner/screens/home/widget/work/cat/add.dart';

import '../../../../../constant.dart';
import '../../../../../variables.dart';

RxList<WorkCat> wc = workCat.values.toList().obs;
_intPage() {
  wc.value = workCat.values.toList();
}

class WorkCatPage extends GetView {
  const WorkCatPage({super.key});

  @override
  Widget build(BuildContext context) {
    _intPage();
    return Scaffold(
        appBar: AppBar(centerTitle: true, title: const Text('دسته‌بندی کارها')),
        body: Obx(() => SingleChildScrollView(
            child: Column(children: wc.map((e) => WorkCatItem(e)).toList()))));
  }
}

class WorkCatItem extends GetView {
  WorkCat item;
  WorkCatItem(this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SwipeActionCell(
          index: item.id,
          key: ValueKey(item.id),
          firstActionWillCoverAllSpaceOnDeleting: false,
          closeWhenScrolling: false,
          trailingActions: [
            if (work.values
                    .where((element) => element.cat == item.id)
                    .toList()
                    .isEmpty &&
                item.id != 0)
              SwipeAction(
                  title: "حذف",
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                  icon: const Icon(
                    Iconsax.trash,
                    color: Colors.white,
                  ),
                  color: Colors.red,
                  widthSpace: 100,
                  forceAlignmentToBoundary: true,
                  performsFirstActionWithFullSwipe: true,
                  // nestedAction: item!.check
                  //     ? SwipeNestedAction(title: "تغییر به انجام نشده")
                  //     : null,
                  onTap: (handler) async {
                    handler(false);
                    for (var i = 0; i < workCat.length; i++) {
                      var e = workCat.getAt(i)!;
                      if (e.id == item.id) {
                        await workCat.deleteAt(i);
                        break;
                      }
                    }
                  }),
            //if (item!.postponed == 0 && !item!.check)
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
                  workCatAdd(
                      item: item,
                      callback: (v) {
                        _intPage();
                      });
                }),
          ],
          leadingActions: const [],
          child: Container(
              padding:
                  const EdgeInsets.only(right: 10, bottom: 5, top: 5, left: 10),
              height: 60,
              child: Row(children: [
                CircleAvatar(
                  backgroundColor: orange,
                  child: Text(
                    work.values
                        .where((element) => element.cat == item.id)
                        .toList()
                        .length
                        .toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Text(
                              item.name,
                              style: const TextStyle(fontSize: 16),
                            ),
                            Flexible(
                                child: Text(
                              item.desc.replaceAll('\n', ' '),
                              maxLines: item.desc.isNotEmpty ? 2 : 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  height: 1, fontSize: 13, color: grey),
                            ))
                          ])),
                      Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            'ایجاد شده در: ${DateConvertor.toJalaliShort(DateTime.parse(item.date))}',
                            style: TextStyle(fontSize: 10, color: grey2),
                          ))
                    ]))
              ]))),
      Container(
        height: 1,
        width: Get.width,
        margin: const EdgeInsets.only(right: 60),
        color: darkMode.isTrue ? Colors.grey.shade800 : Colors.grey.shade300,
      )
    ]);
  }
}
