// ignore_for_file: file_names, must_be_immutable, prefer_typing_uninitialized_variables, library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:planner/components/Celander/calender.dart';
import 'package:planner/constant.dart';
import 'package:planner/screens/health/components/component.dart';
import 'package:planner/screens/health/components/foodList.dart';
import 'package:planner/screens/health/daily/daily.dart';
import 'package:planner/screens/home/widget/cost/list.dart';
import 'package:planner/screens/home/widget/event/list.dart';
import 'package:planner/screens/home/widget/note/list.dart';

import 'package:planner/screens/home/widget/work/list.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../variables.dart';
import 'customAppBar.dart';

enum TitledListType { work, note, cost, event, food, dayFood }

final _noteFilterCtl = ScrollController();

class TitledList extends GetView {
  TitledList({
    super.key,
    this.date,
    required this.data,
    required type,
    required this.callback,
  }) : _type = type;
  TitledListType get type => _type;
  late final TitledListType _type;
  var data;
  DateTime? date;
  ValueSetter callback;
  var sortList = {};
  RxBool ready = false.obs, reverse = false.obs;
  RxInt sel = 0.obs, deySel = 0.obs, noteItemCat = 1000.obs;
  var allWork, pastWork, dayWork, tomorrowWork, unDateWork, catWork = [];
  var allCost, pastCost, dayCost, tomorrowCost, unDateCost, catCost = [];

  @override
  Widget build(BuildContext context) {
    initPage();
    return Obx(() => ready.isTrue
        ? MyScaffold(
            appBar: Container(),
            expandedAppBar: type == TitledListType.note ||
                    type == TitledListType.event ||
                    type == TitledListType.food ||
                    type == TitledListType.dayFood
                ? Container()
                : exTitle(),
            minExtent: 0,
            maxExtent: type == TitledListType.note ||
                    type == TitledListType.event ||
                    type == TitledListType.food ||
                    type == TitledListType.dayFood
                ? 0
                : 200,
            child: data.isEmpty
                ? Container(
                    padding: EdgeInsets.only(top: (Get.height - 100) / 5),
                    child: Column(children: [
                      Icon(
                        Iconsax.square,
                        color: grey2,
                        size: 100,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'چیزی برای نمایش وجود ندارد.',
                        style: TextStyle(color: grey2, fontSize: 20),
                      ),
                    ]))
                : sortList.isEmpty
                    ? Column(children: [
                        Container(
                            padding: const EdgeInsets.only(bottom: 10),
                            color: darkMode.isTrue
                                ? Colors.grey.shade800
                                : Colors.white,
                            child: type == TitledListType.event ||
                                    type == TitledListType.food ||
                                    type == TitledListType.dayFood
                                ? Container()
                                : type == TitledListType.note
                                    ? noteFilter()
                                    : filter()),
                        Container(
                            padding:
                                EdgeInsets.only(top: (Get.height - 100) / 5),
                            child: Column(children: [
                              Icon(
                                Iconsax.emoji_sad,
                                color: grey2,
                                size: 100,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                type == TitledListType.work
                                    ? 'کاری با فیلترهای انتخابی وجود ندارد.'
                                    : type == TitledListType.cost
                                        ? 'هزینه‌ای با فیلترهای انتخابی وجود ندارد.'
                                        : type == TitledListType.note
                                            ? 'یادداشتی با فیلترهای انتخابی وجود ندارد.'
                                            : 'رویدادی با فیلترهای انتخابی وجود ندارد.',
                                style: TextStyle(color: grey2, fontSize: 20),
                              ),
                              Text(
                                type == TitledListType.work
                                    ? 'برای مشاهده کارها فیلترها را تغییر دهید.'
                                    : type == TitledListType.cost
                                        ? 'برای مشاهده هزینه‌ها فیلترها را تغییر دهید.'
                                        : type == TitledListType.note
                                            ? 'برای مشاهده یادداشت‌ها فیلترها را تغییر دهید.'
                                            : 'برای مشاهده رویدادها فیلترها را تغییر دهید.',
                                style: TextStyle(color: grey2, fontSize: 18),
                              )
                            ]))
                      ])
                    : CustomScrollView(
                        key: const PageStorageKey<String>('name'),
                        slivers: [
                            SliverPinnedHeader(
                                child: Container(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    color: darkMode.isTrue
                                        ? Colors.grey.shade800
                                        : Colors.white,
                                    child: type == TitledListType.event ||
                                            type == TitledListType.food ||
                                            type == TitledListType.dayFood
                                        ? Container()
                                        : type == TitledListType.note
                                            ? noteFilter()
                                            : filter())),
                            for (var i = 0; i < sortList.length; i++)
                              MultiSliver(pushPinnedChildren: true, children: [
                                SliverPinnedHeader(
                                  child: Container(
                                      //margin: const EdgeInsets.only(top: 10),
                                      height: 30,
                                      color: darkMode.isTrue
                                          ? Colors.grey[800]
                                          : Colors.grey[200],
                                      // decoration: BoxDecoration(
                                      //     border:
                                      //         Border(bottom: BorderSide(color: Colors.grey))),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                                flex: 2,
                                                fit: FlexFit.tight,
                                                child: Text(
                                                  sortList.keys.toList()[i] !=
                                                          ''
                                                      ? type ==
                                                              TitledListType
                                                                  .dayFood
                                                          ? mealName(sortList
                                                              .keys
                                                              .toList()[i])
                                                          : type ==
                                                                  TitledListType
                                                                      .food
                                                              ? findFoodCatName(sortList
                                                                  .keys
                                                                  .toList()[i])
                                                              : type ==
                                                                      TitledListType
                                                                          .event
                                                                  ? sortList.keys.toList()[i].split('/')[
                                                                          1] +
                                                                      ' ' +
                                                                      Jalali(1402, int.parse(sortList.keys.toList()[i].split('/')[0]))
                                                                          .formatter
                                                                          .mN
                                                                  : DateConvertor.toJalaliShort(
                                                                      DateTime.parse(sortList
                                                                          .keys
                                                                          .toList()[i]),
                                                                      time: false)
                                                      : 'بدون زمان‌بندی',
                                                  style: const TextStyle(
                                                      fontSize: 16),
                                                )),
                                            Flexible(
                                                flex: 2,
                                                fit: FlexFit.tight,
                                                child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      const Text('تعداد: ',
                                                          style: TextStyle(
                                                              fontSize: 16)),
                                                      SizedBox(
                                                          width: 25,
                                                          child: Text(
                                                              sortList[sortList
                                                                          .keys
                                                                          .toList()[
                                                                      i]]!
                                                                  .length
                                                                  .toString(),
                                                              textAlign:
                                                                  TextAlign.end,
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 16,
                                                              )))
                                                    ])),
                                          ])),
                                ),
                                SliverList(
                                    delegate: SliverChildBuilderDelegate(
                                        (BuildContext context, int index) {
                                  switch (type) {
                                    case TitledListType.work:
                                      return WorkItem(
                                          item: sortList[sortList.keys
                                              .toList()[i]]![index],
                                          callback: (v) {
                                            initPage();
                                          });
                                    case TitledListType.cost:
                                      return CostItem(
                                          item: sortList[sortList.keys
                                              .toList()[i]]![index],
                                          callback: (v) {
                                            initPage();
                                          });
                                    case TitledListType.event:
                                      return EventItem(
                                          item: sortList[sortList.keys
                                              .toList()[i]]![index],
                                          callback: (v) {
                                            initPage();
                                          });
                                    case TitledListType.note:
                                      return NoteItem(
                                          item: sortList[sortList.keys
                                              .toList()[i]]![index],
                                          callback: (v) {
                                            initPage();
                                          });
                                    case TitledListType.food:
                                      return foodItem(
                                          food: sortList[sortList.keys
                                              .toList()[i]]![index],
                                          callback: (f) {
                                            callback(f);
                                            Get.back();
                                          });
                                    case TitledListType.dayFood:
                                      return dayFoodItem(
                                          date!,
                                          sortList[sortList.keys.toList()[i]]![
                                              index],
                                          (v) => callback(v));
                                  }
                                },
                                        childCount:
                                            sortList[sortList.keys.toList()[i]]!
                                                .length)),
                              ])
                          ]))
        : Container());
  }

  List<_ChartData> dataa = [];
  List<_ChartData> dataDo = [];
  helper({Color? color, String? title}) {
    return Row(children: [
      CircleAvatar(maxRadius: 5, backgroundColor: color),
      const SizedBox(width: 5),
      Text(
        title!,
        style: const TextStyle(fontSize: 13),
      )
    ]);
  }

  exTitle() {
    return Obx(() => ready.isTrue
        ? Stack(children: [
            Container(
              padding: const EdgeInsets.only(right: 20),
              alignment: Alignment.topRight,
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                helper(color: grey, title: 'در انتظار زمان'),
                helper(color: Colors.green, title: 'انجام شده'),
                helper(color: Colors.red, title: 'انجام نشده')
              ]),
            ),
            Container(
                height: Get.width * 0.1,
                margin: EdgeInsets.only(top: Get.width * 0.35),
                child: Stack(children: [
                  Container(
                      alignment: Alignment.bottomCenter,
                      child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: SfCircularChart(palette: [
                            grey,
                            Colors.green,
                            Colors.red
                          ], series: [
                            DoughnutSeries<_ChartData, String>(
                              radius: (Get.width / 3).toString(),
                              dataSource: dataDo,
                              xValueMapper: (_ChartData data, _) => data.x,
                              yValueMapper: (_ChartData data, _) => data.y,
                              startAngle: -90,
                              endAngle: 90,
                            )
                          ]))),
                  Container(
                      alignment: Alignment.bottomCenter,
                      child: SfCircularChart(palette: const [
                        Color(0xfff5821f),
                        Color(0xFFF7A440),
                        Color(0xFFF6DCBF),
                        Color(0xffC4C5C6),
                        Color(0xFFAAAAAA)
                      ], series: [
                        DoughnutSeries<_ChartData, String>(
                            radius: ((Get.width / 3) - 6).toString(),
                            dataSource: dataa,
                            xValueMapper: (_ChartData dataa, _) => dataa.x,
                            yValueMapper: (_ChartData dataa, _) => dataa.y,
                            startAngle: -90,
                            endAngle: 90,
                            dataLabelMapper: (_ChartData dataa, _) =>
                                dataa.x, // + ': ' + data.y.toString(),
                            dataLabelSettings: const DataLabelSettings(
                              textStyle: TextStyle(
                                fontFamily: 'iran',
                              ),
                              isVisible: true,
                              useSeriesColor: true,
                              showCumulativeValues: true,
                              showZeroValue: false,
                            ))
                      ])),
                ]))
          ])
        : Container());
  }

  filter() {
    return Container(
        padding: const EdgeInsets.only(right: 10, left: 10),
        child: Obx(() => Row(children: [
              Row(children: [
                InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () {
                      sel.value = 0;
                      initPage();
                    },
                    child: Icon(
                      Iconsax.calendar_circle,
                      color: sel.value == 0 ? orange : grey,
                    )),
                const SizedBox(width: 10),
                InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () {
                      sel.value = 1;
                      initPage();
                    },
                    child: Icon(
                      Iconsax.tick_circle,
                      color: sel.value == 1 ? orange : grey,
                    )),
                const SizedBox(width: 10),
                InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () {
                      sel.value = 2;
                      initPage();
                    },
                    child: CircleAvatar(
                        maxRadius: 11,
                        backgroundColor: sel.value == 2 ? orange : grey,
                        child: CircleAvatar(
                          maxRadius: 9.5,
                          backgroundColor: darkMode.isTrue
                              ? Colors.grey.shade800
                              : Colors.white,
                        ))),
                const SizedBox(width: 10),
              ]),
              Flexible(
                  fit: FlexFit.tight,
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            titleItem(deySel.value == 0, 'همه', () {
                              deySel.value = 0;
                              initPage();
                            }),
                            titleItem(deySel.value == 1, 'امروز', () {
                              deySel.value = 1;
                              initPage();
                            }),
                            titleItem(deySel.value == 2, 'فردا', () {
                              deySel.value = 2;
                              initPage();
                            }),
                            titleItem(deySel.value == 3, 'بدون زمان', () {
                              deySel.value = 3;
                              initPage();
                            }),
                          ]))),
              InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: () {
                    reverse.toggle();
                    initPage();
                  },
                  child: Icon(
                    Iconsax.arrow_swap,
                    color: grey,
                  )),
              // Icon(
              //   Iconsax.search_normal,
              //   color: grey,
              // )
            ])));
  }

  noteFilter() {
    return Container(
        width: Get.width,
        padding: const EdgeInsets.only(right: 10, left: 10),
        child: Row(
          children: [
            InkWell(
                onTap: () async {
                  await _noteFilterCtl.animateTo(_noteFilterCtl.offset - 40,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.bounceInOut);
                },
                child: const Icon(Iconsax.arrow_right_3)),
            Flexible(
                child: SingleChildScrollView(
                    controller: _noteFilterCtl,
                    scrollDirection: Axis.horizontal,
                    child: Row(children: [
                      titleItem(noteItemCat.value == 1000, 'همه', () {
                        noteItemCat.value = 1000;
                        initPage();
                        _noteFilterCtl.animateTo(0,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.bounceInOut);
                      }, verticalPadding: 0, border: 1.35),
                      for (int i = 0; i < noteCat.length; i++)
                        IconButton(
                            onPressed: () async {
                              var sp = _noteFilterCtl.offset;
                              noteItemCat.value = i;
                              initPage();
                              if ((i > 2 &&
                                      ((sp > 470 && i < 12) || sp <= 470)) ||
                                  (i <= 2 && sp > 90)) {
                                double off = (30 + (i * 40));
                                await _noteFilterCtl.animateTo(off,
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.bounceInOut);
                              }
                            },
                            icon: Icon(
                              noteCat[i],
                              color: i == noteItemCat.value ? orange : grey,
                            ))
                    ]))),
            InkWell(
                onTap: () async {
                  await _noteFilterCtl.animateTo(_noteFilterCtl.offset + 45,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.bounceInOut);
                },
                child: const Icon(Iconsax.arrow_left_2))
          ],
        ));
  }

  titleItem(bool selected, name, onTap,
      {double verticalPadding = 5, double border = 1}) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => onTap(),
            child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: verticalPadding, horizontal: 7),
                decoration: BoxDecoration(
                    color: selected ? orange : Colors.transparent,
                    border: Border.all(
                        color: selected ? orange : grey, width: border),
                    borderRadius: BorderRadius.circular(10)),
                child: Text(name,
                    style: TextStyle(
                        color: selected ? Colors.white : grey,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)))));
  }

  initPage() {
    ready.value = false;
    sortList = {};
    if (type == TitledListType.work) {
      for (var i = reverse.value ? data.length - 1 : 0;
          (reverse.value ? 0 : i) < (reverse.value ? i : data.length);
          reverse.value ? i-- : i++) {
        if ((sel.value == 1 && data[i].check) ||
            (sel.value == 2 && !data[i].check && data[i].postponed == 0) ||
            sel.value == 0) {
          if (deySel.value == 0 ||
              (deySel.value == 1 &&
                  (data[i].startDate.split('T')[0] ==
                      DateTime.now().toIso8601String().split('T')[0])) ||
              (deySel.value == 2 &&
                  (data[i].startDate.split('T')[0] ==
                      DateTime.now()
                          .add(const Duration(days: 1))
                          .toIso8601String()
                          .split('T')[0])) ||
              (deySel.value == 3 && data[i].startDate == '')) {
            if (sortList.containsKey(data[i].startDate.split('T')[0])) {
              sortList.update(data[i].startDate.split('T')[0],
                  (value) => [...value, data[i]]);
            } else {
              sortList.putIfAbsent(
                  data[i].startDate.split('T')[0], () => [data[i]]);
            }
          }
        }
      }
      allWork = work.values.toList();
      allWork.sort((a, b) {
        try {
          return DateTime.parse(b.startDate)
              .compareTo(DateTime.parse(a.startDate));
        } catch (e) {
          return -1000000000;
        }
      });
      pastWork = work.values
          .where((element) =>
              element.startDate != '' &&
              element.check == false &&
              element.postponed != 0 &&
              DateConvertor.toJalaliShort(DateTime.parse(element.startDate),
                      time: false) !=
                  DateConvertor.toJalaliShort(DateTime.now(), time: false) &&
              DateTime.parse(element.startDate).isBefore(DateTime.now()))
          .toList();
      pastWork.sort((a, b) =>
          DateTime.parse(b.startDate).compareTo(DateTime.parse(a.startDate)));
      dayWork = work.values
          .where((element) =>
              element.startDate != '' &&
              DateTime.parse(element.startDate).toString().split(' ')[0] ==
                  DateTime.now().toString().split(' ')[0])
          .toList();
      tomorrowWork = work.values
          .where((element) =>
              element.startDate != '' &&
              DateTime.parse(element.startDate).toString().split(' ')[0] ==
                  DateTime.now()
                      .add(const Duration(days: 1))
                      .toString()
                      .split(' ')[0])
          .toList();
      unDateWork =
          work.values.where((element) => element.startDate == '').toList();
      catWork = [];
      for (var cat in workCat.values) {
        var ww = work.values
            .where((element) => element.cat == cat.id && element.postponed == 0)
            .toList();
        var wudo = work.values
            .where((element) =>
                element.cat == cat.id &&
                element.check == false &&
                element.postponed == 0 &&
                ((element.startDate != '' &&
                        DateTime.parse(element.startDate)
                            .isBefore(DateTime.now())) ||
                    element.startDate == ''))
            .toList();
        var unDue = work.values
            .where((element) =>
                element.cat == cat.id &&
                element.check == false &&
                element.postponed == 0 &&
                (element.startDate != '' &&
                    !DateTime.parse(element.startDate)
                        .isBefore(DateTime.now())))
            .toList();

        catWork.add({
          'cat': cat.name,
          'catID': cat.id,
          'catDesc': cat.desc,
          'work': ww,
          'unDo': wudo,
          'unDue': unDue
        });
      }

      dataa = [];
      dataDo = [];
      for (var i = 0; i < catWork.length; i++) {
        dataa.add(_ChartData(catWork[i]['cat'], catWork[i]['work'].length));
        dataDo.add(_ChartData(catWork[i]['cat'], catWork[i]['unDue'].length));
        dataDo.add(_ChartData(
            catWork[i]['cat'],
            catWork[i]['work'].length -
                catWork[i]['unDo'].length -
                catWork[i]['unDue'].length));
        dataDo.add(_ChartData(catWork[i]['cat'], catWork[i]['unDo'].length));
      }
    } else if (type == TitledListType.cost) {
      for (var i = reverse.value ? data.length - 1 : 0;
          (reverse.value ? 0 : i) < (reverse.value ? i : data.length);
          reverse.value ? i-- : i++) {
        if ((sel.value == 1 && data[i].paid) ||
            (sel.value == 2 && !data[i].paid) ||
            sel.value == 0) {
          if (deySel.value == 0 ||
              (deySel.value == 1 &&
                  (data[i].effDate.split('T')[0] ==
                      DateTime.now().toIso8601String().split('T')[0])) ||
              (deySel.value == 2 &&
                  (data[i].effDate.split('T')[0] ==
                      DateTime.now()
                          .add(const Duration(days: 1))
                          .toIso8601String()
                          .split('T')[0])) ||
              (deySel.value == 3 && data[i].effDate == '')) {
            if (sortList.containsKey(data[i].effDate.split('T')[0])) {
              sortList.update(data[i].effDate.split('T')[0],
                  (value) => [...value, data[i]]);
            } else {
              sortList.putIfAbsent(
                  data[i].effDate.split('T')[0], () => [data[i]]);
            }
          }
        }
      }
      allCost = cost.values.toList();
      allCost.sort((a, b) {
        try {
          return DateTime.parse(b.startDate)
              .compareTo(DateTime.parse(a.startDate));
        } catch (e) {
          return -1000000000;
        }
      });
      pastCost = cost.values
          .where((element) =>
              element.effDate != '' &&
              element.paid == false &&
              DateConvertor.toJalaliShort(DateTime.parse(element.effDate),
                      time: false) !=
                  DateConvertor.toJalaliShort(DateTime.now(), time: false) &&
              DateTime.parse(element.effDate).isBefore(DateTime.now()))
          .toList();
      pastCost.sort((a, b) =>
          DateTime.parse(b.effDate).compareTo(DateTime.parse(a.effDate)));
      dayCost = cost.values
          .where((element) =>
              element.effDate != '' &&
              DateTime.parse(element.effDate).toString().split(' ')[0] ==
                  DateTime.now().toString().split(' ')[0])
          .toList();
      tomorrowCost = cost.values
          .where((element) =>
              element.effDate != '' &&
              DateTime.parse(element.effDate).toString().split(' ')[0] ==
                  DateTime.now()
                      .add(const Duration(days: 1))
                      .toString()
                      .split(' ')[0])
          .toList();
      unDateCost =
          cost.values.where((element) => element.effDate == '').toList();
      dataa = [];
      dataDo = [];
      catCost = [];
      for (var cat in costCat.values) {
        var cc = cost.values.where((element) => element.cat == cat.id).toList();
        var cudo = cost.values
            .where((element) =>
                element.cat == cat.id &&
                element.paid == false &&
                (element.effDate != '' &&
                        DateTime.parse(element.effDate)
                            .isBefore(DateTime.now()) ||
                    element.effDate == ''))
            .toList();
        var notDueList = cost.values
            .where((element) =>
                element.cat == cat.id &&
                element.paid == false &&
                element.effDate != '' &&
                !DateTime.parse(element.effDate).isBefore(DateTime.now()))
            .toList();
        var total = 0, unPaid = 0, notDue = 0;
        for (var element in cc) {
          total += element.price;
        }
        for (var element in cudo) {
          unPaid += element.price;
        }
        for (var element in notDueList) {
          notDue += element.price;
        }
        catCost.add({
          'cat': cat.name,
          'catID': cat.id,
          'catDesc': cat.desc,
          'total': total,
          'unPaidPrice': unPaid,
          'notDue': notDue,
          'cost': cc,
          'unPaid': cudo
        });
      }
      for (var i = 0; i < catCost.length; i++) {
        dataa.add(_ChartData(catCost[i]['cat'], catCost[i]['total']));
        dataDo.add(_ChartData(catCost[i]['cat'], catCost[i]['notDue']));
        dataDo.add(_ChartData(
            catCost[i]['cat'],
            catCost[i]['total'] -
                catCost[i]['unPaidPrice'] -
                catCost[i]['notDue']));
        dataDo.add(_ChartData(catCost[i]['cat'], catCost[i]['unPaidPrice']));
      }
    } else if (type == TitledListType.note) {
      for (var i = reverse.value ? data.length - 1 : 0;
          (reverse.value ? 0 : i) < (reverse.value ? i : data.length);
          reverse.value ? i-- : i++) {
        if (((noteItemCat.value != 1000 && data[i].cat == noteItemCat.value) ||
            noteItemCat.value == 1000)) {
          if (sortList.containsKey(data[i].date.split('T')[0])) {
            sortList.update(
                data[i].date.split('T')[0], (value) => [...value, data[i]]);
          } else {
            sortList.putIfAbsent(data[i].date.split('T')[0], () => [data[i]]);
          }
        }
      }
    } else if (type == TitledListType.event) {
      for (var i = reverse.value ? data.length - 1 : 0;
          (reverse.value ? 0 : i) < (reverse.value ? i : data.length);
          reverse.value ? i-- : i++) {
        if (sortList.containsKey(data[i].effDate)) {
          sortList.update(data[i].effDate, (value) => [...value, data[i]]);
        } else {
          sortList.putIfAbsent(data[i].effDate, () => [data[i]]);
        }
      }
    } else if (type == TitledListType.food) {
      for (var i = reverse.value ? data.length - 1 : 0;
          (reverse.value ? 0 : i) < (reverse.value ? i : data.length);
          reverse.value ? i-- : i++) {
        for (var c = 0; c < data[i].categories.length; c++) {
          if (sortList.containsKey(data[i].categories[c])) {
            sortList.update(
                data[i].categories[c], (value) => [...value, data[i]]);
          } else {
            sortList.putIfAbsent(data[i].categories[c], () => [data[i]]);
          }
        }
      }
    } else if (type == TitledListType.dayFood) {
      for (var i = reverse.value ? data.length - 1 : 0;
          (reverse.value ? 0 : i) < (reverse.value ? i : data.length);
          reverse.value ? i-- : i++) {
        if (sortList.containsKey(data[i].mealID)) {
          sortList.update(data[i].mealID, (value) => [...value, data[i]]);
        } else {
          sortList.putIfAbsent(data[i].mealID, () => [data[i]]);
        }
      }
    }
    ready.value = true;
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final int y;
}
