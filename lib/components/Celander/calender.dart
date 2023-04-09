// ignore_for_file: prefer_interpolation_to_compose_strings, empty_catches

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:planner/components/Celander/event/gregorian.dart';
import 'package:planner/components/Celander/event/hejri.dart';
import 'package:planner/components/Celander/event/persian.dart';
import 'package:planner/components/bottomSheet.dart';
import 'package:planner/components/button.dart';
import 'package:planner/components/toast.dart';
import 'package:planner/constant.dart';
import 'package:planner/variables.dart';
import 'package:shamsi_date/shamsi_date.dart';

class MyCalenderFX {
  static Map<DateTime, List<dynamic>> findMonthEvent(DateTime gdate) {
    Map<DateTime, List<dynamic>> eventList = {};
    final jdate = gdate.toJalali();
    final firstDate = Jalali(jdate.year, jdate.month, 1).toDateTime();
//shamsi event
    for (var i = 0; i < jdate.monthLength; i++) {
      List de = [];
      for (var j = 0; j < persianEvent.length; j++) {
        if (persianEvent[j]['Month'] == jdate.month) {
          if (persianEvent[j]['Day'] == i + 1) {
            de.add(persianEvent[j]['Title'].toString());
            //break;
          }
        }
      }
      final gd = Jalali(jdate.year, jdate.month, i + 1).toDateTime();
      final hd = HijriCalendar.fromDate(gd);
      //hijri
      for (var j = 0; j < hejriEvent.length; j++) {
        if (hejriEvent[j]['Month'] == hd.hMonth) {
          if (hejriEvent[j]['Day'] == hd.hDay) {
            de.add(hejriEvent[j]['Title'].toString());
          }
        }
      }

      //gerigory
      for (var j = 0; j < gregorianEvent.length; j++) {
        if (gregorianEvent[j]['Month'] == gd.month) {
          if (gregorianEvent[j]['Day'] == gd.day) {
            de.add(gregorianEvent[j]['Title'].toString());
          }
        }
      }

      if (de.isNotEmpty) {
        eventList.addEntries({firstDate.add(Duration(days: i)): de}.entries);
      }
    }
    return eventList;
  }

  static List findDayEvent(DateTime gdate) {
    List eventList = [];
    // final gdate = DateTime.parse(date.toString());
    final jdate = gdate.toJalali();
    final hdate = HijriCalendar.fromDate(gdate);

    //shamsi event
    for (var j = 0; j < persianEvent.length; j++) {
      if (persianEvent[j]['Month'] == jdate.month) {
        if (persianEvent[j]['Day'] == jdate.day) {
          eventList.add(persianEvent[j]['Title'].toString());
          //break;
        }
      }
    }

    //hejri event
    for (var j = 0; j < hejriEvent.length; j++) {
      if (hejriEvent[j]['Month'] == hdate.hMonth) {
        if (hejriEvent[j]['Day'] == hdate.hDay) {
          eventList.add(hejriEvent[j]['Title'].toString());
          //break;
        }
      }
    }

    //gerigory event
    for (var j = 0; j < gregorianEvent.length; j++) {
      if (gregorianEvent[j]['Month'] == gdate.month) {
        if (gregorianEvent[j]['Day'] == gdate.day) {
          eventList.add(gregorianEvent[j]['Title'].toString());
          //break;
        }
      }
    }

    return eventList;
  }

  static bool dayIsVacation(DateTime date) {
    bool isVacation = false;
    final jdate = date.toJalali();
    final hdate = HijriCalendar.fromDate(date);
    for (var i = 0; i < persianEvent.length; i++) {
      if (persianEvent[i]['Month'] == jdate.month) {
        if (persianEvent[i]['Day'] == jdate.day) {
          if (persianEvent[i]['IsVacation'] != null &&
              persianEvent[i]['IsVacation'] == true) isVacation = true;
          break;
        }
      }
    }
    if (!isVacation) {
      for (var i = 0; i < hejriEvent.length; i++) {
        if (hejriEvent[i]['Month'] == hdate.hMonth) {
          if (hejriEvent[i]['Day'] == hdate.hDay) {
            if (hejriEvent[i]['IsVacation'] != null &&
                hejriEvent[i]['IsVacation'] == true) isVacation = true;
            break;
          }
        }
      }
    }
    return isVacation;
  }
}

class MyCalender {
  static viewMonth({DateTime? init, required callback}) {
    init = init ?? DateTime.now();
    final jDate = init.toJalali();
    final startDayMonth = Jalali(jDate.year, jDate.month, 1).weekDay;
    RxList listOfDay = [].obs;
    listOfDay.addAll(weekDayH);
    listOfDay.addAll(List.generate(startDayMonth - 1, (index) => '0'));
    listOfDay.addAll(List.generate(
        init.toJalali().monthLength, (index) => (index + 1).toString()));
    if (listOfDay.length > 42) {
      List extra = [];
      extra.addAll(listOfDay.sublist(0, 7));
      extra.addAll(listOfDay.sublist(42));
      extra.addAll(listOfDay.sublist(extra.length, 42));
      listOfDay.value = extra;
    }
    RxInt selectedDay = jDate.day.obs;
    RxInt selectedMonth = jDate.month.obs;
    RxInt selectedYear = jDate.year.obs;
    return Container(
        height: 280,
        padding: const EdgeInsets.only(top: 10),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Expanded(
              flex: 2,
              child: Column(children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                          borderRadius: BorderRadius.circular(50),
                          onTap: () {
                            selectedMonth.value--;
                            if (selectedMonth.value == 0) {
                              selectedMonth.value = 12;
                              if (selectedDay.value > 29) {
                                selectedDay.value = 29;
                              }
                              selectedYear.value--;
                            }
                            Jalali thisMonth = Jalali(
                                selectedYear.value, selectedMonth.value, 1);
                            listOfDay.value = [];
                            listOfDay.addAll(weekDayH);
                            listOfDay.addAll(List.generate(
                                thisMonth.weekDay - 1, (index) => '0'));
                            listOfDay.addAll(List.generate(
                                thisMonth.monthLength,
                                (index) => (index + 1).toString()));
                            if (listOfDay.length > 42) {
                              List extra = [];
                              extra.addAll(listOfDay.sublist(0, 7));
                              extra.addAll(listOfDay.sublist(42));
                              extra.addAll(listOfDay.sublist(extra.length, 42));
                              listOfDay.value = extra;
                            }
                            callback(Jalali(selectedYear.value,
                                    selectedMonth.value, selectedDay.value)
                                .toDateTime());
                          },
                          child: Icon(
                            Iconsax.arrow_right_1,
                            color: grey,
                          )),
                      Obx(() => Flexible(
                            child: Column(children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                        fit: FlexFit.tight, child: Container()),
                                    Flexible(
                                        fit: FlexFit.tight,
                                        child: Text(
                                          Jalali(selectedYear.value,
                                                  selectedMonth.value)
                                              .formatter
                                              .mN,
                                          style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Flexible(
                                        fit: FlexFit.tight,
                                        child: Text(
                                          '${selectedYear.value}',
                                          textAlign: TextAlign.end,
                                          style: const TextStyle(fontSize: 17),
                                        )),
                                    Flexible(
                                        fit: FlexFit.tight, child: Container()),
                                  ]),
                              _showMonthName(jDate),
                            ]),
                          )),
                      InkWell(
                          onTap: () {
                            selectedMonth.value++;
                            if (selectedMonth.value == 13) {
                              selectedMonth.value = 1;
                              selectedYear.value++;
                            }
                            if (selectedMonth.value == 12 &&
                                selectedDay.value > 29) {
                              selectedDay.value = 29;
                            }
                            Jalali thisMonth = Jalali(
                                selectedYear.value, selectedMonth.value, 1);
                            listOfDay.value = [];
                            listOfDay.addAll(weekDayH);
                            listOfDay.addAll(List.generate(
                                thisMonth.weekDay - 1, (index) => '0'));
                            listOfDay.addAll(List.generate(
                                thisMonth.monthLength,
                                (index) => (index + 1).toString()));
                            if (listOfDay.length > 42) {
                              List extra = [];
                              extra.addAll(listOfDay.sublist(0, 7));
                              extra.addAll(listOfDay.sublist(42));
                              extra.addAll(listOfDay.sublist(extra.length, 42));
                              listOfDay.value = extra;
                            }
                            callback(Jalali(selectedYear.value,
                                    selectedMonth.value, selectedDay.value)
                                .toDateTime());
                          },
                          borderRadius: BorderRadius.circular(50),
                          child: Icon(
                            Iconsax.arrow_left,
                            color: grey,
                          )),
                    ]),
                Expanded(
                    child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Obx(() => GridView.count(
                            crossAxisCount: 7,
                            mainAxisSpacing: 3,
                            crossAxisSpacing: 3,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            children: listOfDay
                                .map((e) => InkWell(
                                    borderRadius: BorderRadius.circular(5),
                                    onTap: e != '0' && int.tryParse(e) != null
                                        ? () {
                                            selectedDay.value = int.parse(e);
                                            callback(Jalali(
                                                    selectedYear.value,
                                                    selectedMonth.value,
                                                    selectedDay.value)
                                                .toDateTime());
                                          }
                                        : null,
                                    onLongPress: e != '0' &&
                                            int.tryParse(e) != null
                                        ? () => {
                                              selectedDay.value = int.parse(e),
                                              callback(Jalali(
                                                      selectedYear.value,
                                                      selectedMonth.value,
                                                      selectedDay.value)
                                                  .toDateTime()),
                                              _showEvent(
                                                  selectedYear.value,
                                                  selectedMonth.value,
                                                  selectedDay.value)
                                            }
                                        : null,
                                    child: Stack(children: [
                                      Obx(() => selectedDay.value >= 0
                                          ? Container(
                                              alignment: Alignment.center,
                                              decoration: e != '0' &&
                                                      int.tryParse(e) != null
                                                  ? BoxDecoration(
                                                      color: int.tryParse(e) ==
                                                              selectedDay.value
                                                          ? orange
                                                          : Colors.transparent,
                                                      border: Border.all(
                                                          color:
                                                              grey2.withOpacity(
                                                                  0.2)),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5))
                                                  : null,
                                              child: Text(
                                                e != '0' ? e : '',
                                                style: _style(jDate, e,
                                                    selectedDay.value, 'month'),
                                              ))
                                          : Container()),
                                      _eventBadg(jDate, e),
                                      Obx(() => _mytaskBadg(
                                          jDate, e, selectedDay.value)),
                                      Obx(() => _hijridate(
                                          jDate, e, selectedDay.value)),
                                      Obx(() =>
                                          _gdate(jDate, e, selectedDay.value)),
                                    ])))
                                .toList())))),
              ])),
          Expanded(
              child: ListView.builder(
            itemCount: 1,
            itemBuilder: (context, index) {
              return Obx(() =>
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                    const SizedBox(height: 10),
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(children: [
                          MyButton(
                              title: 'امروز',
                              icon: Iconsax.back_square,
                              bgColor:
                                  darkMode.value ? Colors.grey.shade100 : grey,
                              borderOnly: true,
                              textColor:
                                  darkMode.value ? Colors.grey.shade100 : grey,
                              onTap: () {
                                Jalali jd = DateTime.now().toJalali();
                                selectedDay.value = jd.day;
                                selectedMonth.value = jd.month;
                                selectedYear.value = jd.year;
                                Jalali thisMonth = Jalali(
                                    selectedYear.value, selectedMonth.value, 1);
                                listOfDay.value = [];
                                listOfDay.addAll(weekDayH);
                                listOfDay.addAll(List.generate(
                                    thisMonth.weekDay - 1, (index) => '0'));
                                listOfDay.addAll(List.generate(
                                    thisMonth.monthLength,
                                    (index) => (index + 1).toString()));
                                if (listOfDay.length > 42) {
                                  List extra = [];
                                  extra.addAll(listOfDay.sublist(0, 7));
                                  extra.addAll(listOfDay.sublist(42));
                                  extra.addAll(
                                      listOfDay.sublist(extra.length, 42));
                                  listOfDay.value = extra;
                                }
                                callback(Jalali(selectedYear.value,
                                        selectedMonth.value, selectedDay.value)
                                    .toDateTime());
                              })
                        ])),
                    const SizedBox(height: 15),
                    Text(
                        Jalali(selectedYear.value, selectedMonth.value,
                                selectedDay.value)
                            .formatter
                            .wN,
                        style: TextStyle(color: grey, fontSize: 30, height: 1)),
                    Text(
                        // Jalali(selectedYear.value, selectedMonth.value,
                        //         selectedDay.value)
                        //     .day
                        selectedDay.value.toString(),
                        style: TextStyle(
                            color: orange,
                            fontSize: 100,
                            fontWeight: FontWeight.bold,
                            height: 1)),
                    Text(
                        Jalali(selectedYear.value, selectedMonth.value,
                                selectedDay.value)
                            .formatter
                            .mN,
                        style: TextStyle(color: grey, fontSize: 20, height: 1)),
                    const SizedBox(height: 15),
                    Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(children: [
                          MyButton(
                              title: 'مناسبت‌ها',
                              bgColor:
                                  darkMode.value ? Colors.grey.shade100 : grey,
                              icon: Iconsax.calendar_search,
                              borderOnly: true,
                              textColor:
                                  darkMode.value ? Colors.grey.shade100 : grey,
                              onTap: () => _showEvent(selectedYear.value,
                                  selectedMonth.value, selectedDay.value))
                        ]))
                  ]));
            },
          ))
        ]));
  }

  static viewWeek({DateTime? init, required callback}) {
    init = init ?? DateTime.now();
    final jDate = init.toJalali();
    RxInt selectedDay = jDate.day.obs;
    RxInt selectedMonth = jDate.month.obs;
    RxInt selectedYear = jDate.year.obs;
    RxList listOfDay = [].obs;
    List glist = [];
    int startWeekOffset = jDate.weekDay - 1;
    DateTime startWeekDate = init.add(Duration(days: -startWeekOffset));
    for (var i = 0; i < 7; i++) {
      listOfDay.add(
          '${wdn[i]}\n${startWeekDate.add(Duration(days: i)).toJalali().day}');
      glist.add(startWeekDate.add(Duration(days: i)));
    }
    return Container(
      height: 100,
      padding: const EdgeInsets.only(top: 5, right: 5, left: 5),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: () {
            DateTime newDate = Jalali(
                    selectedYear.value, selectedMonth.value, selectedDay.value)
                .toDateTime()
                .add(const Duration(days: -1));
            Jalali jNewDate = newDate.toJalali();
            selectedDay.value = jNewDate.day;
            selectedMonth.value = jNewDate.month;
            selectedYear.value = jNewDate.year;
            callback(newDate);

            listOfDay.value = [];
            glist = [];
          },
          child: const Icon(Iconsax.arrow_right_4),
        ),
        Expanded(
            child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Obx(() => GridView.count(
                    crossAxisCount: 7,
                    mainAxisSpacing: 3,
                    crossAxisSpacing: 3,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    children: listOfDay
                        .map((e) => InkWell(
                            borderRadius: BorderRadius.circular(5),
                            onTap: () {
                              Jalali jd = DateTime.parse(
                                      glist[listOfDay.indexOf(e)].toString())
                                  .toJalali();
                              selectedDay.value = jd.day;
                              selectedMonth.value = jd.month;
                              selectedYear.value = jd.year;
                              callback(DateTime.parse(
                                  glist[listOfDay.indexOf(e)].toString()));
                            },
                            onLongPress: () {
                              Jalali jd = DateTime.parse(
                                      glist[listOfDay.indexOf(e)].toString())
                                  .toJalali();
                              selectedDay.value = jd.day;
                              selectedMonth.value = jd.month;
                              selectedYear.value = jd.year;
                              callback(DateTime.parse(
                                  glist[listOfDay.indexOf(e)].toString()));
                              _showEvent(selectedYear.value,
                                  selectedMonth.value, selectedDay.value);
                            },
                            child: Obx(() => selectedDay.value >= 0
                                ? Stack(children: [
                                    Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            color: int.tryParse(e
                                                        .toString()
                                                        .split('\n')[1]) ==
                                                    selectedDay.value
                                                ? orange
                                                : Colors.transparent,
                                            border: Border.all(
                                                color: grey2.withOpacity(0.5)),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: Text(
                                          e,
                                          textAlign: TextAlign.center,
                                          style: _style(
                                              DateTime.parse(glist[
                                                          listOfDay.indexOf(e)]
                                                      .toString())
                                                  .toJalali(),
                                              e.toString().split('\n')[1],
                                              selectedDay.value,
                                              'week'),
                                        )),
                                    _eventBadg(
                                        DateTime.parse(
                                                glist[listOfDay.indexOf(e)]
                                                    .toString())
                                            .toJalali(),
                                        e.toString().split('\n')[1]),
                                    _mytaskBadg(
                                        DateTime.parse(
                                                glist[listOfDay.indexOf(e)]
                                                    .toString())
                                            .toJalali(),
                                        e.toString().split('\n')[1],
                                        selectedDay.value),
                                    _hijridate(
                                        DateTime.parse(
                                                glist[listOfDay.indexOf(e)]
                                                    .toString())
                                            .toJalali(),
                                        e.toString().split('\n')[1],
                                        selectedDay.value),
                                    _gdate(
                                        DateTime.parse(
                                                glist[listOfDay.indexOf(e)]
                                                    .toString())
                                            .toJalali(),
                                        e.toString().split('\n')[1],
                                        selectedDay.value)
                                  ])
                                : Container())))
                        .toList())))),
        InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: () {
            DateTime newDate = Jalali(
                    selectedYear.value, selectedMonth.value, selectedDay.value)
                .toDateTime()
                .add(const Duration(days: 1));
            Jalali jNewDate = newDate.toJalali();
            selectedDay.value = jNewDate.day;
            selectedMonth.value = jNewDate.month;
            selectedYear.value = jNewDate.year;
            callback(newDate);

            listOfDay.value = [];
            glist = [];
            // int newStartWeekOffset = newDate.toJalali().weekDay - 1;
            // DateTime newtartWeekDate =
            //     newDate.add(Duration(days: -newStartWeekOffset));
            // for (var i = 0; i < 7; i++) {
            //   listOfDay.add(
            //       '${wdn[i]}\n${newtartWeekDate.add(Duration(days: i)).toJalali().day}');
            //   glist.add(newtartWeekDate.add(Duration(days: i)));
            // }
          },
          child: const Icon(Iconsax.arrow_left_1),
        )
      ]),
    );
  }

  static picker(
      {DateTime? init,
      DateTime? start,
      DateTime? end,
      bool noTime = false,
      bool time = false,
      required callback}) {
    init = init ?? DateTime.now();
    Jalali jDate = init.toJalali();
    final startDayMonth = Jalali(jDate.year, jDate.month, 1).weekDay;
    RxList listOfDay = [].obs;
    listOfDay.addAll(weekDayH);
    listOfDay.addAll(List.generate(startDayMonth - 1, (index) => '0'));
    listOfDay.addAll(List.generate(
        init.toJalali().monthLength, (index) => (index + 1).toString()));
    if (listOfDay.length > 42) {
      List extra = [];
      extra.addAll(listOfDay.sublist(0, 7));
      extra.addAll(listOfDay.sublist(42));
      extra.addAll(listOfDay.sublist(extra.length, 42));
      listOfDay.value = extra;
    }
    RxInt selectedDay = jDate.day.obs;
    RxInt selectedMonth = jDate.month.obs;
    RxInt selectedYear = jDate.year.obs;
    DateTime selectedTime = DateTime.now();
    RxBool change = false.obs;
    MyBottomSheet.view(
        Obx(() => change.isTrue || change.isFalse
            ? Container(
                height: time ? 550 : 450,
                padding: const EdgeInsets.only(top: 10),
                child: Column(children: [
                  const Text(
                    'انتخاب تاریخ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                            borderRadius: BorderRadius.circular(50),
                            onTap: () {
                              selectedMonth.value--;
                              if (selectedMonth.value == 0) {
                                selectedMonth.value = 12;
                                if (selectedDay.value > 29) {
                                  selectedDay.value = 29;
                                }
                                selectedYear.value--;
                              }
                              Jalali thisMonth = Jalali(
                                  selectedYear.value, selectedMonth.value, 1);
                              listOfDay.value = [];
                              listOfDay.addAll(weekDayH);
                              listOfDay.addAll(List.generate(
                                  thisMonth.weekDay - 1, (index) => '0'));
                              listOfDay.addAll(List.generate(
                                  thisMonth.monthLength,
                                  (index) => (index + 1).toString()));
                              if (listOfDay.length > 42) {
                                List extra = [];
                                extra.addAll(listOfDay.sublist(0, 7));
                                extra.addAll(listOfDay.sublist(42));
                                extra.addAll(
                                    listOfDay.sublist(extra.length, 42));
                                listOfDay.value = extra;
                              }
                              change.toggle();
                              // callback(Jalali(selectedYear.value, selectedMonth.value,
                              //         selectedDay.value)
                              //     .toDateTime());
                            },
                            child: Icon(
                              Iconsax.arrow_right_1,
                              color: grey,
                            )),
                        Obx(() => Flexible(
                              child: Column(children: [
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                          fit: FlexFit.tight,
                                          child: Container()),
                                      Flexible(
                                          fit: FlexFit.tight,
                                          child: Text(
                                            Jalali(selectedYear.value,
                                                    selectedMonth.value)
                                                .formatter
                                                .mN,
                                            style: const TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold),
                                          )),
                                      Flexible(
                                          fit: FlexFit.tight,
                                          child: Text(
                                            '${selectedYear.value}',
                                            textAlign: TextAlign.end,
                                            style:
                                                const TextStyle(fontSize: 17),
                                          )),
                                      Flexible(
                                          fit: FlexFit.tight,
                                          child: Container()),
                                    ]),
                                _showMonthName(jDate),
                              ]),
                            )),
                        InkWell(
                            borderRadius: BorderRadius.circular(50),
                            onTap: () {
                              selectedMonth.value++;
                              if (selectedMonth.value == 13) {
                                selectedMonth.value = 1;
                                selectedYear.value++;
                              }
                              if (selectedMonth.value == 12 &&
                                  selectedDay.value > 29) {
                                selectedDay.value = 29;
                              }
                              Jalali thisMonth = Jalali(
                                  selectedYear.value, selectedMonth.value, 1);
                              listOfDay.value = [];
                              listOfDay.addAll(weekDayH);
                              listOfDay.addAll(List.generate(
                                  thisMonth.weekDay - 1, (index) => '0'));
                              listOfDay.addAll(List.generate(
                                  thisMonth.monthLength,
                                  (index) => (index + 1).toString()));
                              jDate = thisMonth;
                              if (listOfDay.length > 42) {
                                List extra = [];
                                extra.addAll(listOfDay.sublist(0, 7));
                                extra.addAll(listOfDay.sublist(42));
                                extra.addAll(
                                    listOfDay.sublist(extra.length, 42));
                                listOfDay.value = extra;
                              }
                              change.toggle();
                              // callback(Jalali(selectedYear.value, selectedMonth.value,
                              //         selectedDay.value)
                              //     .toDateTime());
                            },
                            child: Icon(
                              Iconsax.arrow_left,
                              color: grey,
                            )),
                      ]),
                  //const SizedBox(height: 10),
                  Expanded(
                      child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Obx(() => GridView.count(
                              crossAxisCount: 7,
                              mainAxisSpacing: 3,
                              crossAxisSpacing: 3,
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              children: listOfDay
                                  .map((e) => InkWell(
                                      borderRadius: BorderRadius.circular(5),
                                      onTap: _checkCondition(
                                        e,
                                        start,
                                        end,
                                        selectedYear,
                                        selectedMonth,
                                      )
                                          ? () {
                                              selectedDay.value = int.parse(e);
                                            }
                                          : null,
                                      onLongPress: _checkCondition(
                                        e,
                                        start,
                                        end,
                                        selectedYear,
                                        selectedMonth,
                                      )
                                          ? () => {
                                                selectedDay.value =
                                                    int.parse(e),
                                                _showEvent(
                                                    selectedYear.value,
                                                    selectedMonth.value,
                                                    selectedDay.value)
                                              }
                                          : null,
                                      child: Stack(children: [
                                        Obx(() => selectedDay.value >= 0
                                            ? Container(
                                                alignment: Alignment.center,
                                                decoration: e != '0' &&
                                                        int.tryParse(e) != null
                                                    ? BoxDecoration(
                                                        color: int.tryParse(
                                                                    e) ==
                                                                selectedDay
                                                                    .value
                                                            ? orange
                                                            : Colors
                                                                .transparent,
                                                        border: Border.all(
                                                            color: grey2
                                                                .withOpacity(
                                                                    0.2)),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5))
                                                    : null,
                                                child: Text(
                                                  e != '0' ? e : '',
                                                  style: _checkCondition(
                                                            e,
                                                            start,
                                                            end,
                                                            selectedYear,
                                                            selectedMonth,
                                                          ) ||
                                                          int.tryParse(e) ==
                                                              null
                                                      ? _style(
                                                          jDate,
                                                          e,
                                                          selectedDay.value,
                                                          'month')
                                                      : TextStyle(color: grey2),
                                                ))
                                            : Container()),
                                        _eventBadg(jDate, e),
                                        Obx(() => _mytaskBadg(
                                            jDate, e, selectedDay.value)),
                                        Obx(() => _hijridate(
                                            jDate, e, selectedDay.value)),
                                        Obx(() => _gdate(
                                            jDate, e, selectedDay.value)),
                                      ])))
                                  .toList())))),
                  if (time)
                    Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        height: 100,
                        child: Row(children: [
                          const Text(
                            'ساعت: ',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Flexible(
                              child: Obx(() => selectedYear.value != 0 &&
                                      selectedMonth.value != 0 &&
                                      (selectedDay.value != selectedTime.day ||
                                          selectedDay.value == selectedTime.day)
                                  ? CupertinoDatePicker(
                                      use24hFormat: true,
                                      initialDateTime: Jalali(
                                              selectedYear.value,
                                              selectedMonth.value,
                                              selectedDay.value,
                                              selectedTime.hour,
                                              selectedTime.minute)
                                          .toDateTime(),
                                      mode: CupertinoDatePickerMode.time,
                                      onDateTimeChanged: (v) {
                                        selectedTime = v;
                                      })
                                  : Container()))
                        ])),
                  Row(children: [
                    MyButton(
                        title: 'تایید',
                        bgColor: orange,
                        textColor: Colors.white,
                        onTap: () {
                          callback(Jalali(
                                  selectedYear.value,
                                  selectedMonth.value,
                                  selectedDay.value,
                                  selectedTime.hour,
                                  selectedTime.minute)
                              .toDateTime());
                          Get.back();
                        }),
                    const SizedBox(width: 10),
                    MyButton(
                        title: 'انصراف',
                        bgColor: grey,
                        textColor: grey,
                        borderOnly: true,
                        onTap: () {
                          //callback('cancel');
                          Get.back();
                        }),
                    if (noTime) const SizedBox(width: 10),
                    if (noTime)
                      MyButton(
                          title: 'بدون زمان‌بندی',
                          bgColor: grey,
                          textColor: Colors.white,
                          onTap: () {
                            callback(null);
                            Get.back();
                          })
                  ]),
                ]),
              )
            : Container()),
        showClose: false,
        isDismissible: false,
        h: time ? 610 : 500);
  }
}

bool _checkCondition(
  e,
  start,
  end,
  selectedYear,
  selectedMonth,
) {
  return e != '0' &&
      int.tryParse(e) != null &&
      ((end != null &&
              Jalali(selectedYear.value, selectedMonth.value, int.parse(e), 0,
                      0)
                  .toDateTime()
                  .isBefore(end)) ||
          end == null) &&
      ((start != null &&
              Jalali(selectedYear.value, selectedMonth.value, int.parse(e), 23,
                      59)
                  .toDateTime()
                  .isAfter(start)) ||
          start == null);
}

class DateConvertor {
  static String toJalaliLong(DateTime date, {bool time = true}) {
    var jdd = date.toJalali();
    return time
        ? '${jdd.day} ${jdd.formatter.mN} ${jdd.year} ${jdd.hour}:${jdd.minute}'
        : '${jdd.day} ${jdd.formatter.mN} ${jdd.year}';
  }

  static String toJalaliShort(DateTime date, {bool time = true}) {
    var jdd = date.toJalali();
    return time
        ? '${jdd.hour}:${jdd.minute}-${jdd.year}/${jdd.month}/${jdd.day}'
        : '${jdd.year}/${jdd.month}/${jdd.day}';
  }
}

_showEvent(selectedYear, selectedMonth, selectedDay) {
  var ev = MyCalenderFX.findDayEvent(
      Jalali(selectedYear, selectedMonth, selectedDay).toDateTime());
  if (ev.isEmpty) {
    return MyToast.info('هیچ مناسبت تقویمی برای امروز وجود ندارد.');
  }
  bool isVacation = MyCalenderFX.dayIsVacation(
          Jalali(selectedYear, selectedMonth, selectedDay).toDateTime()) ||
      Jalali(selectedYear, selectedMonth, selectedDay).weekDay == 7;
  DateTime gdate =
      Jalali(selectedYear, selectedMonth, selectedDay).toDateTime();
  HijriCalendar hdate = HijriCalendar.fromDate(gdate);
  MyBottomSheet.view(
      (Column(children: [
        Text(
          isVacation
              ? 'مناسبتهای تقویمی ${Jalali(selectedYear, selectedMonth, selectedDay).formatter.wN} $selectedDay ${Jalali(selectedYear, selectedMonth, selectedDay).formatter.mN} $selectedYear (تعطیل)'
              : 'مناسبتهای تقویمی ${Jalali(selectedYear, selectedMonth, selectedDay).formatter.wN} $selectedDay ${Jalali(selectedYear, selectedMonth, selectedDay).formatter.mN} $selectedYear',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isVacation ? Colors.red : null),
        ),
        Container(
            padding: EdgeInsets.symmetric(horizontal: Get.width / 6.5),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(gdate.day.toString() +
                      ' ${gMonthName[gdate.month]} ' +
                      gdate.year.toString()),
                  const SizedBox(width: 30),
                  Text(hdate.hDay.toString() +
                      ' ${hMonthName[hdate.hMonth]} ' +
                      hdate.hYear.toString())
                ])),
        Column(
            children: ev
                .map((e) => Row(children: [
                      const Icon(Iconsax.minus),
                      const SizedBox(width: 5),
                      Flexible(child: Text(e))
                    ]))
                .toList())
      ])),
      h: 90 + (ev.length * 26));
}

_style(Jalali date, day, selDay, mode) {
  Color color = day.toString().startsWith('ج')
      ? Colors.red
      : darkMode.value
          ? Colors.white
          : Colors.black;
  try {
    if (int.tryParse(day) != null &&
        int.parse(day) != 0 &&
        (Jalali(date.year, date.month, int.parse(day)).weekDay == 7 ||
            MyCalenderFX.dayIsVacation(
                Jalali(date.year, date.month, int.parse(day)).toDateTime()))) {
      color = Colors.red;
    }
  } catch (e) {}

  return TextStyle(
      // fontWeight: FontWeight.bold,
      height: 1,
      color: int.tryParse(day) == selDay ? Colors.white : color,
      fontSize: int.tryParse(day) == null || mode == 'week' ? 14 : 16);
}

_eventBadg(Jalali date, day) {
  try {
    if (setting.getAt(0)!.calenderEvent! &&
        int.tryParse(day) != null &&
        int.parse(day) != 0) {
      var ev = MyCalenderFX.findDayEvent(
          Jalali(date.year, date.month, int.parse(day)).toDateTime());
      if (ev.isNotEmpty) {
        return Positioned(
            top: 0,
            left: 0,
            child: Container(
              height: 12,
              width: 12,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: grey2.withOpacity(0.5)),
              alignment: Alignment.center,
              child: Text(
                ev.length.toString(),
                style: const TextStyle(height: 1, fontSize: 10),
              ),
            ));
      }
    }
  } catch (e) {}
  return Container();
}

_mytaskBadg(Jalali date, day, selDay) {
  if (setting.getAt(0)!.myTask! &&
      int.tryParse(day) != null &&
      int.parse(day) != 0) {
    var ev = ['l'];
    //print(ev);
    if (ev.isNotEmpty) {
      return Positioned(
          top: 0,
          right: 0,
          child: Container(
            height: 12,
            width: 12,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: int.tryParse(day) == selDay
                    ? Colors.white.withOpacity(0.9)
                    : orange.withOpacity(0.5)),
            alignment: Alignment.center,
            child: Text(
              ev.length.toString(),
              style: TextStyle(
                  height: 1,
                  fontSize: 10,
                  color: int.tryParse(day) == selDay ? orange : Colors.black),
            ),
          ));
    }
  }
  return Container();
}

_hijridate(Jalali date, day, selDay) {
  try {
    return (setting.getAt(0)!.hDate! && int.tryParse(day) != null && day != '0')
        ? Positioned(
            bottom: 1,
            right: 2,
            child: Container(
              alignment: Alignment.center,
              child: Text(
                HijriCalendar.fromDate(
                        Jalali(date.year, date.month, int.parse(day))
                            .toDateTime())
                    .hDay
                    .toString(),
                style: TextStyle(fontSize: 10, height: 1, color: grey2),
              ),
            ))
        : Container();
  } catch (e) {
    return Container();
  }
}

_gdate(Jalali date, day, selDay) {
  try {
    return (setting.getAt(0)!.gDate! && int.tryParse(day) != null && day != '0')
        ? Positioned(
            bottom: 2,
            left: 2,
            child: Container(
              alignment: Alignment.center,
              child: Text(
                Jalali(date.year, date.month, int.parse(day))
                    .toDateTime()
                    .day
                    .toString(),
                style: TextStyle(
                    fontFamily: 'ss', fontSize: 9, height: 1, color: grey2),
              ),
            ))
        : Container();
  } catch (e) {
    return Container();
  }
}

_findHijriMonthName(Jalali date) {
  Jalali sjd = Jalali(date.year, date.month, 1);
  String hmName = '';
  List hm = [];
  for (var i = 0; i < sjd.monthLength; i++) {
    int hmn = HijriCalendar.fromDate(
            Jalali(date.year, date.month, i + 1).toDateTime())
        .hMonth;
    if (!hm.contains(hmn)) {
      hm.add(hmn);
      hmName =
          hmName.isEmpty ? hMonthName[hmn] : hmName + '-' + hMonthName[hmn];
    }
  }
  return Text(
    hmName,
    style: TextStyle(color: grey2, height: 1, fontSize: 10),
  );
}

_findGMonthName(Jalali date) {
  Jalali sjd = Jalali(date.year, date.month, 1);
  String gmName = '';
  List gm = [];
  for (var i = 0; i < sjd.monthLength; i++) {
    int gmn = Jalali(date.year, date.month, i + 1).toDateTime().month;
    if (!gm.contains(gmn)) {
      gm.add(gmn);
      gmName =
          gmName.isEmpty ? gMonthName[gmn] : gmName + '-' + gMonthName[gmn];
    }
  }
  return Text(
    gmName,
    style: TextStyle(color: grey2, height: 1, fontSize: 10),
  );
}

_showMonthName(jDate) {
  return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        if (setting.getAt(0)!.hDate!) _findHijriMonthName(jDate),
        if (setting.getAt(0)!.hDate! && setting.getAt(0)!.gDate!)
          const SizedBox(width: 10),
        if (setting.getAt(0)!.gDate!) _findGMonthName(jDate),
      ]));
}
