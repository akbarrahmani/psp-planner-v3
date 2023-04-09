// ignore_for_file: must_be_immutable, prefer_typing_uninitialized_variables
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:planner/components/Celander/calender.dart';
import 'package:planner/components/bottomSheet.dart';
import 'package:planner/components/button.dart';
import 'package:planner/components/textInput.dart';
import 'package:planner/constant.dart';
import 'package:planner/dbModels/models.dart';
import 'package:planner/screens/home/widget/cost/add.dart';
import 'package:planner/variables.dart';
import 'package:persian_tools/persian_tools.dart';
import 'package:shamsi_date/shamsi_date.dart';

class ShowCostInHome extends GetView {
  var callback;
  ShowCostInHome({super.key, required this.callback});
  RxBool change = false.obs;
  List<Cost> dayCost = [];
  @override
  Widget build(BuildContext context) {
    initpage();
    return Obx(() => change.isFalse || change.isTrue
        ? Column(
            children: dayCost
                .map((e) => CostItem(
                      item: e,
                      callback: (v) {
                        change.toggle();
                        callback('v');
                      },
                    ))
                .toList())
        : Container());
  }

  initpage() {
    dayCost = [];
    dayCost = cost.values
        .where((element) =>
            element.effDate != '' &&
            '${selectedDate.value.day}${selectedDate.value.month}${selectedDate.value.year}' ==
                '${DateTime.parse(element.effDate).day}${DateTime.parse(element.effDate).month}${DateTime.parse(element.effDate).year}')
        .toList();
    dayCost.sort((a, b) =>
        DateTime.parse(a.effDate).compareTo(DateTime.parse(b.effDate)));
  }
}

class CostItem extends GetView {
  Cost? item;
  var callback;
  CostItem({required this.item, required this.callback, super.key});

  @override
  Widget build(BuildContext context) {
    RxBool change = false.obs;
    return Column(children: [
      Obx(() => change.isFalse || change.isTrue
          ? SwipeActionCell(
              index: item!.id,
              key: ValueKey(item!.id),
              firstActionWillCoverAllSpaceOnDeleting: false,
              closeWhenScrolling: false,
              trailingActions: [
                SwipeAction(
                    title: !item!.paid ? "پرداخت" : "پرداخت نشده",
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                    icon: Icon(
                      !item!.paid ? Iconsax.money_send : Iconsax.close_circle,
                      color: Colors.white,
                    ),
                    color: !item!.paid ? orange : Colors.red,
                    widthSpace: 100,
                    forceAlignmentToBoundary: true,
                    performsFirstActionWithFullSwipe: true,
                    nestedAction: item!.paid
                        ? SwipeNestedAction(title: "تغییر به پرداخت نشده")
                        : null,
                    onTap: (handler) async {
                      handler(false);
                      _toDo(item!, (v) => callback('v'));
                    }),

                // if (item!.postponed == 0 && !item!.check)
                //   SwipeAction(
                //       title: "موکول به آینده",
                //       style: const TextStyle(fontSize: 14, color: Colors.white),
                //       icon: const Icon(
                //         Iconsax.arrow_up_1,
                //         color: Colors.white,
                //       ),
                //       color: Colors.blue,
                //       widthSpace: 100,
                //       forceAlignmentToBoundary: true,
                //       performsFirstActionWithFullSwipe: true,
                //       onTap: (handler) async {
                //         handler(false);
                //         _postponed(item!, (v) => callback('v'));
                //       }),
              ],
              leadingActions: const [],
              child: Container(
                  padding: const EdgeInsets.only(
                      right: 10, bottom: 5, top: 5, left: 10),
                  height: 50,
                  child: InkWell(
                      onTap: () => _details(item!, (v) => callback('v')),
                      child: Row(children: [
                        CircleAvatar(
                          backgroundColor: _checkStatus(item!) == 0
                              ? grey
                              : _checkStatus(item!) == 1
                                  ? Colors.red
                                  : orange,
                          child: Icon(
                            _checkStatus(item!) == 0
                                ? Iconsax.timer
                                : _checkStatus(item!) == 1
                                    ? Iconsax.close_circle
                                    : Iconsax.money_send,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                            child: Row(children: [
                          Flexible(
                            fit: FlexFit.tight,
                            child: Row(children: [
                              Text('${item!.title} ',
                                  style: TextStyle(
                                      fontSize: 16,
                                      decoration: item!.paid
                                          ? TextDecoration.lineThrough
                                          : null,
                                      fontWeight: item!.paid
                                          ? FontWeight.normal
                                          : FontWeight.bold)),
                              Text('(${addCommas(item!.price)} تومان)')
                            ]),
                          ),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _checkStatus(item!) == 0
                                      ? 'در انتظار'
                                      : _checkStatus(item!) == 1
                                          ? 'پرداخت نشده'
                                          : 'پرداخت شده در ${DateConvertor.toJalaliShort(DateTime.parse(item!.paidDate))}',
                                  style: TextStyle(color: grey, fontSize: 12),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'ایجاد شده در: ${DateConvertor.toJalaliShort(DateTime.parse(item!.date))}',
                                  style: TextStyle(fontSize: 10, color: grey2),
                                )
                              ])
                        ]))
                      ]))))
          : Container()),
      Container(
        height: 1,
        width: Get.width,
        margin: const EdgeInsets.only(right: 60),
        color: darkMode.isTrue ? Colors.grey.shade800 : Colors.grey.shade300,
      )
    ]);
  }
}

_details(Cost item, callback) {
  String jsd = 'بدون زمان‌بندی';
  String jnd = 'بدون اعلان';
  String jpd = '';
  var jdd = DateTime.parse(item.effDate).toJalali();
  jsd = '${jdd.day} ${jdd.formatter.mN} ${jdd.year} ${jdd.hour}:${jdd.minute}';
  if (item.paidDate != '') {
    var jpdd = DateTime.parse(item.paidDate).toJalali();
    jpd =
        '${jpdd.day} ${jpdd.formatter.mN} ${jpdd.year} ${jpdd.hour}:${jpdd.minute}';
  }
  if (item.notifTime != '') {
    var jdn = DateTime.parse(item.notifTime).toJalali();
    jnd =
        '${jdn.day} ${jdn.formatter.mN} ${jdn.year} ${jdn.hour}:${jdn.minute}';
  }

  MyBottomSheet.view(
      Column(children: [
        MyInput(
          controller: TextEditingController(text: item.title),
          title: 'عنوان',
          icon: Iconsax.receipt,
          type: InputType.text,
          readOnly: true,
        ),
        MyInput(
          controller: TextEditingController(text: '${intToPrice(item.price)}'),
          title: 'مبلغ',
          icon: Iconsax.dollar_square,
          type: InputType.price,
          readOnly: true,
        ),
        MyInput(
          controller: TextEditingController(text: item.desc),
          title: 'توضیحات',
          icon: Iconsax.document,
          line: 3,
          type: InputType.text,
          readOnly: true,
        ),
        MyInput(
          controller: TextEditingController(text: jsd),
          title: 'تاریخ و ساعت',
          icon: Iconsax.clock,
          type: InputType.text,
          readOnly: true,
        ),
        if (setting.getAt(0)!.timeAtWork!)
          MyInput(
            title: 'زمان پرداخت',
            controller: TextEditingController(text: jpd),
            type: InputType.text,
            icon: Iconsax.clock_1,
            readOnly: true,
          ),
        MyInput(
          title: 'اعلان',
          controller: TextEditingController(text: jnd),
          readOnly: true,
          type: InputType.text,
          line: 1,
          icon: Iconsax.notification,
        ),
        MyInput(
          title: 'دسته‌بندی',
          type: InputType.text,
          icon: Iconsax.category,
          controller: TextEditingController(
              text: costCat.values
                  .where((element) => element.id == item.cat)
                  .toList()[0]
                  .name),
          required: true,
          readOnly: true,
        ),
        const SizedBox(height: 10),
        Row(children: [
          MyButton(
            title: !item.paid ? "پرداخت" : "تغییر به پرداخت نشده",
            // style: const TextStyle(fontSize: 14, color: Colors.white),
            icon: !item.paid ? Iconsax.tick_circle : Iconsax.close_circle,
            bgColor: !item.paid ? orange : Colors.red,
            textColor: Colors.white,
            onTap: () {
              Get.back();
              _toDo(item, (v) => callback('v'));
            },
          ),
          const SizedBox(width: 10),
          MyButton(
            title: 'ویرایش',
            bgColor: grey,
            textColor: grey,
            icon: Iconsax.edit,
            onTap: () {
              Get.back();
              addCost(item: item);
            },
            borderOnly: true,
          )
        ])
      ]),
      h: 515);
}

_toDo(Cost item, callback) async {
  if (setting.getAt(0)!.payDate! && !item.paid) {
    await MyCalender.picker(
        time: true,
        end: DateTime.now(),
        callback: (DateTime v) async {
          for (var i = 0; i < cost.length; i++) {
            if (cost.getAt(i)!.id == item.id) {
              item.paid = true;
              item.paidDate = v.toIso8601String();
              await cost.putAt(i, item);
              callback('v');
              break;
            }
          }
        });
  } else {
    for (var i = 0; i < cost.length; i++) {
      if (cost.getAt(i)!.id == item.id) {
        item.paid = !item.paid;
        item.paidDate = item.paid ? DateTime.now().toIso8601String() : '';
        await cost.putAt(i, item);

        callback('v');

        break;
      }
    }
  }
}

_checkStatus(Cost item) {
  if (item.paid) {
    return 2;
  }
  if (item.effDate != '' &&
      DateTime.parse(item.effDate).isBefore(DateTime.now())) {
    return 1;
  }
  return 0;
}
