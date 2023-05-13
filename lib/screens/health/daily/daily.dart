// ignore_for_file: must_be_immutable, no_leading_underscores_for_local_identifiers, unused_element

import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:planner/screens/health/components/component.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:persian_tools/persian_tools.dart';
import 'package:planner/components/Celander/calender.dart';
import 'package:planner/components/MyDropDown/screen.dart';
import 'package:planner/components/food/foodCategoris.dart';
import 'package:planner/components/titledList.dart';
import 'package:planner/components/toast.dart';
import 'package:planner/components/utility.dart';
import 'package:planner/components/bottomSheet.dart';
import 'package:planner/components/button.dart';
import 'package:planner/components/textInput.dart';
import 'package:planner/constant.dart';
import 'package:planner/dbModels/models.dart';
import 'package:planner/screens/health/components/foodList.dart';
import 'package:planner/variables.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
part 'food.dart';
part 'wather.dart';
part 'chart.dart';

Rx<DateTime> healthSelecteddate = DateTime.now().obs;
RxInt _bmr = 0.obs,
    _fat = 0.obs,
    _prt = 0.obs,
    _crb = 0.obs,
    wather = 0.obs,
    _cpf = 0.obs;
RxDouble _eat = 0.0.obs;
int _drink = -1;
RxBool _drinkChange = false.obs, change = false.obs;
RxString _typeChart = 'bmi'.obs;

class HDailyData extends GetView {
  HDailyData({super.key});

  @override
  Widget build(BuildContext context) {
    initHealthDailyPage();
    return Obx(() => (change.isFalse || change.isTrue) &&
                healthSelecteddate.value == DateTime.now() ||
            healthSelecteddate.value != DateTime.now()
        ? Column(children: [
            SizedBox(
                height: 55,
                child: MyCalender.viewWeek(
                    init: healthSelecteddate.value,
                    callback: (DateTime date) {
                      healthSelecteddate.value = date;
                      initHealthDailyPage();
                    },
                    showBadg: false)),
            Expanded(
                child: SingleChildScrollView(
              child: Column(children: [
                _food(() => initHealthDailyPage()),
                _wather(),
                //_walking(),
                _chart(),
                _addW(() => initHealthDailyPage())
              ]),
            ))
          ])
        : Container());
  }

  Widget _food(callback) {
    return Obx(() => Column(children: [
          const SizedBox(height: 10),
          Row(children: [
            Container(
                padding: const EdgeInsets.only(right: 10, left: 5),
                child: const Text(
                  'غذا و خوراکی',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )),
            Flexible(
                child: Divider(
              color: darkMode.isFalse ? grey2 : grey,
            )),
            Container(
              padding: const EdgeInsets.only(right: 3, left: 5),
              child: Text('نیاز امروز: ${addCommas(_bmr.value)} کالری'),
            )
          ]),
          Container(
              padding: const EdgeInsets.all(5),
              child: Column(children: [
                const SizedBox(height: 10),
                Row(children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: Container(
                        padding:
                            const EdgeInsets.only(right: 10, left: 10, top: 20),
                        height: 200,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                  child: Column(
                                children: [
                                  Text.rich(
                                      TextSpan(
                                          text:
                                              'شما امروز به ${addCommas(_bmr.value)} کالری انرژی نیاز دارید که این میزان انرژی باید از\n',
                                          children: [
                                            TextSpan(
                                              text:
                                                  '${_crb.value} گرم کربوهیدرات ',
                                              style: const TextStyle(
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          255, 146, 208, 119)),
                                            ),
                                            const TextSpan(text: '، '),
                                            TextSpan(
                                                text:
                                                    '${_prt.value} گرم پروتئین ',
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    backgroundColor:
                                                        Color.fromARGB(255, 241,
                                                            162, 125))),
                                            const TextSpan(text: ' و '),
                                            TextSpan(
                                              text: '${_fat.value} گرم چربی',
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  backgroundColor:
                                                      Color.fromARGB(
                                                          255, 255, 196, 59)),
                                            ),
                                            const TextSpan(
                                                text:
                                                    ' تامین شود.\nبرای اندازه‌گیری دقیق‌تر هرچه خوردید ثبت کنید.\n'),
                                            TextSpan(
                                                text: 'نحوه محاسبه...',
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () =>
                                                          MyBottomSheet.view(
                                                              Column(
                                                                  children: const [
                                                                SizedBox(
                                                                    height: 10),
                                                                Text(
                                                                  'نحوه محاسبه نیاز انرژی روزانه',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                SizedBox(
                                                                    height: 10),
                                                                Text(
                                                                  'ما با استفاده از فرمول محاسبه هریس بندیکت (Harris–Benedict) میزان انرژی مورد نیاز شما را بر اساس سطح فعالیت انتخابی، سن، قد و وزن شما محاسبه میکنیم.\nاین محاسبه تقریبی بوده و برای حفظ وضعیت فعلی شما میباشد. برای کاهش و یا افزایش وزن نیاز به تغییر میزان کالری محاسبه شده با نظر کارشناسان و متخصصین دارید.\nبطور تقریبی با کاهش یا افزایش ۱۰۰ کالری در روز به مدت یک هفته به همان میزان وزن شما تغییر خواهد کرد. اما بطور جد توصیه می‌شود که برای کاهش یا افزایش وزن با اطلاعات قبلی و مشورت متخصصین اقدام نمایید.',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .justify,
                                                                )
                                                              ])),
                                                style: const TextStyle(
                                                    color: Colors.blue)),
                                          ]),
                                      textAlign: TextAlign.justify),
                                ],
                              )),
                              Row(
                                children: [
                                  MyButton(
                                      title: 'ثبت خوراکی‌ها',
                                      icon: Iconsax.reserve,
                                      bgColor: grey,
                                      textColor: Colors.white,
                                      onTap: () => addFood(
                                          healthSelecteddate, () => callback()))
                                ],
                              )
                            ])),
                  ),
                  Flexible(
                    fit: FlexFit.tight,
                    child: SizedBox(
                        height: 200,
                        child: SfRadialGauge(axes: <RadialAxis>[
                          RadialAxis(
                              canScaleToFit: true,
                              showLabels: false,
                              showTicks: false,
                              axisLabelStyle: GaugeTextStyle(
                                  fontFamily: 'iran',
                                  color: darkMode.isTrue ? grey2 : grey,
                                  //height: 1,
                                  fontSize: 12),
                              minimum: 0,
                              maximum: _bmr.value.toDouble(),
                              pointers: [
                                MarkerPointer(
                                  value: _eat.value.toDouble(),
                                )
                              ],
                              ranges: [
                                GaugeRange(
                                  startValue: 0,
                                  endValue:
                                      (_crb.value / _cpf.value) * _bmr.value,
                                  color:
                                      const Color.fromARGB(255, 146, 208, 119),
                                ),
                                GaugeRange(
                                  startValue:
                                      (_crb.value / _cpf.value) * _bmr.value,
                                  endValue: ((_crb.value / _cpf.value) +
                                          (_prt.value / _cpf.value)) *
                                      _bmr.value,
                                  color:
                                      const Color.fromARGB(255, 241, 162, 125),
                                ),
                                GaugeRange(
                                  startValue: ((_crb.value / _cpf.value) +
                                          (_prt.value / _cpf.value)) *
                                      _bmr.value,
                                  endValue: _bmr.value.toDouble(),
                                  color:
                                      const Color.fromARGB(255, 255, 196, 59),
                                )
                              ],
                              annotations: <GaugeAnnotation>[
                                GaugeAnnotation(
                                    widget: Container(
                                        padding:
                                            const EdgeInsets.only(bottom: 12),
                                        child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              const Text(
                                                  'انرژی تامین شده امروز'),
                                              Text(
                                                  addCommas(_eat.value.toInt()),
                                                  style: TextStyle(
                                                      fontSize: 40,
                                                      height: 1,
                                                      color: _eat.value >
                                                              _bmr.value
                                                          ? Colors.red
                                                          : null,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              const Text('کالری'),
                                              TextButton(
                                                  onPressed: () => dailyEat(
                                                      healthSelecteddate,
                                                      () => callback()),
                                                  child: const Text(
                                                      'مشاهده خوراک امروز')),
                                              //  const SizedBox(height: 40)
                                            ])),
                                    angle: 90,
                                    positionFactor: 0.0)
                              ])
                        ])),
                  )
                ])
              ])),
        ]));
  }

  Widget _wather() {
    return Column(children: [
      const SizedBox(height: 10),
      Row(children: [
        Container(
            padding: const EdgeInsets.only(right: 10, left: 5),
            child: const Text(
              'آب',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            )),
        Flexible(
            child: Divider(
          color: darkMode.isFalse ? grey2 : grey,
        )),
        Container(
            padding: const EdgeInsets.only(right: 3, left: 5),
            child: Text(
              'نیاز امروز: ${addCommas(wather.value)}ml (حدود ${(wather.value / 250).roundToDouble().toInt()} لیوان ۲۵۰cc)',
            )),
      ]),
      const SizedBox(height: 10),
      Container(
          padding: const EdgeInsets.all(5),
          child: Column(children: [
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                height: (70.0 *
                    ((wather.value / 250).roundToDouble().toInt() / 5).ceil()),
                child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: (wather.value / 250).roundToDouble().toInt(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 5,
                              crossAxisSpacing: 10.0,
                              //childAspectRatio: 1.3,
                              mainAxisSpacing: 4.0),
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () async {
                              if (_drink >= 0 && index == 0) {
                                _drink = -1;
                              } else {
                                if (_drink >= index) {
                                  _drink = index - 1;
                                } else {
                                  _drink = index;
                                }
                              }
                              drinkChangeSubmit(
                                  _drink, healthSelecteddate.value);
                              _drinkChange.toggle();
                              change.toggle();
                            },
                            child: Obx(() => _drinkChange.isFalse ||
                                    _drinkChange.isTrue
                                ? Container(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Image.asset(
                                      _drink + 1 > index
                                          ? 'asset/img/health/glass/full.png'
                                          : 'asset/img/health/glass/free.png',
                                      //  height: 30,
                                      // color: drink < index
                                      //     ? Colors.black.withOpacity(0.3)
                                      //     : null,
                                    ))
                                : Container()));
                      },
                    ))),
            Obx(() => (_drinkChange.isFalse || _drinkChange.isTrue)
                ? Row(children: [
                    IconButton(
                        onPressed: () async {
                          _drink++;
                          drinkChangeSubmit(_drink, healthSelecteddate.value);
                          _drinkChange.toggle();
                          change.toggle();
                        },
                        icon: const Icon(
                          Iconsax.add_circle,
                          color: Color.fromARGB(255, 1, 159, 232),
                        )),
                    Flexible(
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: SfLinearGauge(
                              showLabels: false,
                              showTicks: false,
                              showAxisTrack: false,
                              animationDuration: 1000,
                              maximum: wather.value.toDouble(),
                              barPointers: [
                                LinearBarPointer(
                                  value: wather.value.toDouble(),
                                  thickness: 20,
                                  animationDuration: 500,
                                  // edgeStyle: LinearEdgeStyle.bothCurve,
                                  color:
                                      const Color(0xFF8fceec).withOpacity(0.1),
                                ),
                                LinearBarPointer(
                                  value:
                                      (((_drink + 1) * 250) / (wather.value)) *
                                          wather.value,
                                  animationDuration: 700,
                                  thickness: 20,
                                  // edgeStyle: LinearEdgeStyle.bothCurve,
                                  color: const Color(0xFF8fceec),
                                ),
                                LinearBarPointer(
                                    //  edgeStyle: LinearEdgeStyle.bothCurve,
                                    value: wather.value.toDouble(),
                                    thickness: 20,
                                    color: Colors.transparent,
                                    animationDuration: 700,
                                    child: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          '${((((_drink + 1) * 250) / (wather.value)) * 100).toInt()}% آب مورد نیاز تامین شده (${(_drink + 1) * 250} میلی‌لیتر)',
                                          style: TextStyle(
                                              color: ((_drink + 1) * 250) /
                                                          ((wather.value ~/
                                                                  250) *
                                                              250) <
                                                      1
                                                  ? Colors.black
                                                  : Colors.white),
                                        ))),
                              ])),
                    ),
                    IconButton(
                        onPressed: () async {
                          if (_drink >= 0) {
                            _drink--;
                            drinkChangeSubmit(_drink, healthSelecteddate.value);
                          }
                          _drinkChange.toggle();
                          change.toggle();
                        },
                        icon: const Icon(
                          Iconsax.minus_cirlce,
                          color: Color.fromARGB(255, 1, 159, 232),
                        )),
                  ])
                : Container()),
          ])),
      const SizedBox(height: 10),
    ]);
  }

  Widget _walking() {
    return Column(children: [
      Row(children: [
        Container(
            padding: const EdgeInsets.only(right: 10, left: 5),
            child: const Text(
              'پیاده‌روی',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            )),
        Flexible(
            child: Divider(
          color: darkMode.isFalse ? grey2 : grey,
        ))
      ]),
      Container(
          padding: const EdgeInsets.all(5), child: Column(children: const []))
    ]);
  }

  final RxString _chartType = 'bmi'.obs;
  Widget _chart() {
    List<ChartData>? bmiData = [];
    List<ChartData>? wData = [];
    List<ChartData>? ceData = [];
    List<ChartData>? nData = [];
    List<ChartData>? watherData = [];
    double hw = _chartType.value == 'bmi'
        ? 45
        : _chartType.value == 'wather'
            ? 1
            : 100;
    TrackballBehavior? _trackballBehavior;
    if (_chartType.value == 'bmi' || _chartType.value == 'w') {
      int _h = 0;
      if (healthDaily.length > 30) {
        _h = healthDaily.length - 30;
      }
      List<HealthDaily> hd =
          healthDaily.values.where((element) => true).toList();
      hd.sort(
          (a, b) => DateTime.parse(a.date!).compareTo(DateTime.parse(b.date!)));
      for (var i = _h; i < hd.length; i++) {
        var el = hd[i];
        var date = Jalali.fromDateTime(DateTime.parse(el.date!));
        var xVal = '${date.month}/${date.day}';
        double height = el.height! / 100;
        var _bmi =
            double.parse((el.weight! / (height * height)).toStringAsFixed(1));
        bmiData.add(ChartData(x: xVal, y: _bmi));
        wData.add(ChartData(x: xVal, y: el.weight!));
        hw = max(
            hw,
            _chartType.value == 'bmi'
                ? double.parse(
                        (el.weight! / ((el.height! / 100) * (el.height! / 100)))
                            .toStringAsFixed(1)) +
                    1
                : double.parse(el.weight!.toStringAsFixed(1)) + 5);
      }
    }
    if (_chartType.value == 'wather') {
      DateTime ddd = DateTime.now().add(const Duration(days: -30));
      for (var i = 0; i < 31; i++) {
        var date = ddd.toJalali();
        var wd = findWather(ddd) * 250;
        watherData.add(ChartData(x: '${date.month}/${date.day}', y: wd));
        var nw = findWeight(ddd) * 33;
        nData.add(ChartData(x: '${date.month}/${date.day}', y: nw));
        hw = max(hw, nw.toDouble());
        hw = max(hw, wd.toDouble());
        ddd = ddd.add(const Duration(days: 1));
      }
      hw += 200;
    }
    if (_chartType.value == 'e') {
      DateTime ddd = DateTime.now().add(const Duration(days: -30));
      for (var i = 0; i < 31; i++) {
        var date = ddd.toJalali();
        var cd = findCaleries(ddd);
        ceData.add(ChartData(x: '${date.month}/${date.day}', y: cd.toInt()));
        var nc = calCalories(ddd.obs);
        nData.add(ChartData(x: '${date.month}/${date.day}', y: nc.toInt()));
        hw = max(hw, nc.toDouble());
        hw = max(hw, cd.toDouble());
        ddd = ddd.add(const Duration(days: 1));
      }
      hw += 300;
    }

    List<StackedLineSeries<ChartData, String>> _getStackedLineSeries() {
      return <StackedLineSeries<ChartData, String>>[
        StackedLineSeries<ChartData, String>(
            dataSource: _chartType.value == 'bmi'
                ? bmiData
                : _chartType.value == 'w'
                    ? wData
                    : _chartType.value == 'e'
                        ? ceData
                        : watherData,
            xValueMapper: (ChartData ch, _) => ch.x as String,
            yValueMapper: (ChartData ch, _) => ch.y,
            pointColorMapper: (ChartData ch, _) => _chartType.value == 'bmi'
                ? bmiColor(ch.y!.toDouble())
                : _chartType.value == 'w'
                    ? grey
                    : _chartType.value == 'e'
                        ? orange
                        : const Color.fromARGB(255, 1, 159, 232),
            dataLabelMapper: (ChartData ch, _) => ch.y!.toString(),
            dataLabelSettings: DataLabelSettings(
                isVisible: true,
                margin: EdgeInsets.zero,
                textStyle: TextStyle(
                    height: 0.1,
                    fontFamily: 'iran',
                    color: grey,
                    fontSize: 10)),
            enableTooltip: true,
            animationDuration: 1000,
            //name: 'BMI',
            markerSettings: const MarkerSettings(isVisible: true)),
        if (_chartType.value == 'e' || _chartType.value == 'wather')
          StackedLineSeries<ChartData, String>(
              dataSource: nData,
              xValueMapper: (ChartData ch, _) => ch.x as String,
              yValueMapper: (ChartData ch, _) => ch.y,
              pointColorMapper: (ChartData ch, _) => grey,
              dataLabelMapper: (ChartData ch, _) => ch.y!.toString(),
              dataLabelSettings: DataLabelSettings(
                  isVisible: false,
                  margin: EdgeInsets.zero,
                  textStyle: TextStyle(
                      height: 0.1,
                      fontFamily: 'iran',
                      color: grey,
                      fontSize: 10)),
              enableTooltip: false,
              animationDuration: 1000,
              groupName: 'ss',
              markerSettings: const MarkerSettings(isVisible: false)),
      ];
    }

    _buildStackedLineChart() {
      return Column(children: [
        Row(children: [
          Container(
              padding: const EdgeInsets.only(right: 10, left: 5),
              child: const Text(
                'نمودار و اطلاعات',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              )),
          Flexible(
              child: Divider(
            color: darkMode.isFalse ? grey2 : grey,
          ))
        ]),
        Container(
            alignment: Alignment.topRight,
            padding: const EdgeInsets.only(top: 5, right: 10),
            child: Obx(() => _chartType.value != ''
                ? Row(children: [
                    InkWell(
                        onTap: () => _chartType.value = 'bmi',
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              color: _chartType.value == 'bmi' ? orange : null,
                              border: Border.all(
                                  color: _chartType.value == 'bmi'
                                      ? orange
                                      : grey2),
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10))),
                          child: Text(
                            'BMI',
                            style: TextStyle(
                                color: _chartType.value == 'bmi'
                                    ? Colors.white
                                    : null),
                          ),
                        )),
                    InkWell(
                        onTap: () => _chartType.value = 'w',
                        // borderRadius: const BorderRadius.only(
                        //     topRight: Radius.circular(10),
                        //     bottomRight: Radius.circular(10)),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: _chartType.value == 'w' ? orange : null,
                            border: Border.all(
                                color:
                                    _chartType.value == 'w' ? orange : grey2),
                            // borderRadius: const BorderRadius.only(
                            //     topRight: Radius.circular(10),
                            //     bottomRight: Radius.circular(10))
                          ),
                          child: Text(
                            'وزن',
                            style: TextStyle(
                                color: _chartType.value == 'w'
                                    ? Colors.white
                                    : null),
                          ),
                        )),
                    InkWell(
                        onTap: () => _chartType.value = 'e',
                        // borderRadius: const BorderRadius.only(
                        //     topRight: Radius.circular(10),
                        //     bottomRight: Radius.circular(10)),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            color: _chartType.value == 'e' ? orange : null,
                            border: Border.all(
                                color:
                                    _chartType.value == 'e' ? orange : grey2),
                            // borderRadius: const BorderRadius.only(
                            //     topRight: Radius.circular(10),
                            //     bottomRight: Radius.circular(10))
                          ),
                          child: Text(
                            'تامین کالری',
                            style: TextStyle(
                                color: _chartType.value == 'e'
                                    ? Colors.white
                                    : null),
                          ),
                        )),
                    InkWell(
                        onTap: () => _chartType.value = 'wather',
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10)),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              color:
                                  _chartType.value == 'wather' ? orange : null,
                              border: Border.all(
                                  color: _chartType.value == 'wather'
                                      ? orange
                                      : grey2),
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10))),
                          child: Text(
                            'آب',
                            style: TextStyle(
                                color: _chartType.value == 'wather'
                                    ? Colors.white
                                    : null),
                          ),
                        )),
                  ])
                : Container())),
        SfCartesianChart(
          plotAreaBorderWidth: 0,
          primaryXAxis: CategoryAxis(
            labelStyle: const TextStyle(fontFamily: 'iran'),
            majorGridLines: const MajorGridLines(width: 0),
            labelRotation: -45,
          ),
          primaryYAxis: NumericAxis(
              maximum: hw,
              labelStyle: const TextStyle(fontFamily: 'iran'),
              axisLine: const AxisLine(width: 0),
              majorTickLines: const MajorTickLines(size: 0)),
          series: _getStackedLineSeries(),
          trackballBehavior: _trackballBehavior,
        ),
      ]);
    }

    return _buildStackedLineChart();
  }

  Widget _addW(callback) {
    final _h = TextEditingController(
        text: healthDaily.getAt(healthDaily.length - 1)!.height.toString());
    final _w = TextEditingController();
    DateTime d = DateTime.now();
    final _date =
        TextEditingController(text: DateConvertor.toJalaliLong(d, time: false));

    final _hf = FocusNode();
    final _wf = FocusNode();
    return Container(
        padding:
            const EdgeInsets.only(right: 20, left: 20, bottom: 25, top: 10),
        child: Row(children: [
          MyButton(
              title: 'قد و وزن جدید',
              bgColor: grey,
              textColor: Colors.white,
              onTap: () {
                MyBottomSheet.view(
                    Column(children: [
                      const Text(
                        'افزودن قد و وزن جدید',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Row(children: [
                        Flexible(
                            child: MyInput(
                          title: 'قد',
                          controller: _h,
                          focusNode: _hf,
                          nextFocusNode: _wf,
                          textInputAction: TextInputAction.next,
                          type: InputType.number,
                          icon: Iconsax.ruler,
                          keyboardType: TextInputType.number,
                        )),
                        const SizedBox(width: 10),
                        Flexible(
                            child: MyInput(
                          title: 'وزن',
                          controller: _w,
                          focusNode: _wf,
                          type: InputType.number,
                          icon: Iconsax.weight,
                          keyboardType: TextInputType.number,
                        )),
                      ]),
                      MyInput(
                          title: 'تاریخ',
                          controller: _date,
                          type: InputType.text,
                          icon: Iconsax.clock,
                          readOnly: true,
                          onTap: () => MyCalender.picker(
                                end: DateTime.now(),
                                callback: (DateTime v) {
                                  d = v;
                                  _date.text = DateConvertor.toJalaliLong(v,
                                      time: false);
                                },
                              )),
                      Container(
                          padding: const EdgeInsets.all(5),
                          child: Row(children: [
                            MyButton(
                                title: 'ثبت',
                                bgColor: orange,
                                textColor: Colors.white,
                                icon: Iconsax.tick_circle,
                                onTap: () async {
                                  if (int.tryParse(_w.text) != null &&
                                      int.tryParse(_h.text) != null) {
                                    HealthDaily hd = HealthDaily(
                                        date: d.toIso8601String(),
                                        weight: int.parse(_w.text),
                                        height: int.parse(_h.text));
                                    await healthDaily.add(hd);
                                    MyToast.success(
                                        'اطلاعات با موفقیت ثبت شد.');
                                    callback();
                                    Get.back();
                                  } else {
                                    MyToast.error('قد و وزن را وارد کنید.');
                                  }
                                }),
                            const SizedBox(width: 20),
                            MyButton(
                                title: 'انصراف',
                                bgColor: grey,
                                textColor: Colors.white,
                                icon: Iconsax.close_circle,
                                onTap: () => Get.back()),
                          ]))
                    ]),
                    h: 220);
              })
        ]));
  }
}

initHealthDailyPage() {
  _bmr = 0.obs;
  _fat = 0.obs;
  _prt = 0.obs;
  _crb = 0.obs;
  wather = 0.obs;
  _cpf = 0.obs;
  _eat = 0.0.obs;
  _drink = -1;
  _drinkChange = false.obs;
  _bmr.value = calCalories(healthSelecteddate);
  _fat.value = (_bmr.value * 0.27) ~/ 9;
  _prt.value = (_bmr.value * 0.23) ~/ 4;
  _crb.value = (_bmr.value * 0.5) ~/ 4;
  _cpf.value = _fat.value + _prt.value + _crb.value;
  wather.value = (33 * findWeight(healthSelecteddate.value));
  var eatList = foodEat.values
      .where((element) =>
          element.date!.split('T')[0] ==
          healthSelecteddate.value.toIso8601String().split('T')[0])
      .toList();
  _eat.value = 0.0;
  for (var el in eatList) {
    _eat.value += el.food!.calorie! * el.amount!;
  }
  var dindex = wDrink.values.toList().indexWhere((element) =>
      element.date!.split('T')[0] ==
      healthSelecteddate.value.toIso8601String().split('T')[0]);
  if (dindex > -1) {
    var wd = wDrink.getAt(dindex)!;
    _drink = wd.count!;
  }
  change.toggle();
}
