// ignore_for_file: file_names

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:planner/components/food/foodDetails.dart';
import 'package:planner/dbModels/models.dart';
import 'package:planner/variables.dart';
import 'package:path_provider/path_provider.dart';

class DataBase {
  static init() async {
    if (!kIsWeb) {
      dir = await getApplicationDocumentsDirectory();
      Hive.init(dir!.path);
    }
    Hive
      ..registerAdapter(GoalsAdapter())
      ..registerAdapter(ObjectiveAdapter())
      ..registerAdapter(KRAdapter())
      ..registerAdapter(KRdoAdapter())
      ..registerAdapter(NoteAdapter())
      ..registerAdapter(WorkAdapter())
      ..registerAdapter(WorkCatAdapter())
      ..registerAdapter(CostCatAdapter())
      ..registerAdapter(CostAdapter())
      ..registerAdapter(EventAdapter())
      ..registerAdapter(SettingAdapter())
      ..registerAdapter(PageHelpAdapter())
      ..registerAdapter(HealthInfoAdapter())
      ..registerAdapter(HealthDailyAdapter())
      ..registerAdapter(FoodDetailsAdapter())
      ..registerAdapter(DBVersionAdapter())
      ..registerAdapter(FavoriteFoodAdapter())
      ..registerAdapter(FoodEatAdapter())
      ..registerAdapter(WDrinkAdapter());
  }

  static readDate() async {
    if (!Hive.isAdapterRegistered(0)) {
      await init();
    }
    setting = await Hive.openBox<Setting>('setting');
    goals = await Hive.openBox<Goals>('goals');
    objective = await Hive.openBox<Objective>('objective');
    kr = await Hive.openBox<KR>("kr");
    krdo = await Hive.openBox<KRdo>('krdo');
    note = await Hive.openBox<Note>('note');
    workCat = await Hive.openBox<WorkCat>('workCat');
    work = await Hive.openBox<Work>('work');
    costCat = await Hive.openBox<CostCat>('costCat');
    cost = await Hive.openBox<Cost>('cost');
    event = await Hive.openBox<Event>('event');
    pageHelp = await Hive.openBox<PageHelp>('pageHelp');
    healthInfo = await Hive.openBox<HealthInfo>('healthInfo');
    healthDaily = await Hive.openBox<HealthDaily>('healthDaily');
    foodDetails = await Hive.openBox<FoodDetails>('foodDetails');
    dbversion = await Hive.openBox<DBVersion>('dbversion');
    favoriteFood = await Hive.openBox<FavoriteFood>('favoriteFood');
    foodEat = await Hive.openBox<FoodEat>('foodEat');
    wDrink = await Hive.openBox<WDrink>('wDrink');
    if (dbversion.values
            .toList()
            .indexWhere((element) => element.version == dbv) ==
        -1) await updateDB();
    if (pageHelp.isEmpty) {
      PageHelp ph = PageHelp(list: []);
      await pageHelp.add(ph);
    }
    if (setting.isEmpty) {
      Setting sett = Setting(
          id: 0,
          eventHourNotif: 9,
          krdoHourNotif: 11,
          app: 'planner',
          calenderEvent: true,
          myEvent: true,
          myTask: true,
          hDate: true,
          gDate: true,
          darkMode: false);
      await setting.add(sett);
    }
    if (workCat.isEmpty) {
      WorkCat e = WorkCat(
          id: 0,
          name: 'بدون دسته‌بندی',
          desc: '',
          date: DateTime.now().toIso8601String());
      workCat.add(e);
    }
    if (costCat.isEmpty) {
      CostCat e = CostCat(
          id: 0,
          name: 'بدون دسته‌بندی',
          desc: '',
          date: DateTime.now().toIso8601String());
      costCat.add(e);
    }
    //prf = await SharedPreferences.getInstance();
  }

  static updateDB() async {
    if (foodDetails.isEmpty) {
      for (var el in foodDetailsDB) {
        var nf = FoodDetails(
          name: el['name'],
          id: el['id'],
          isShow: el['isShow'],
          categories: el['categories'],
          unit: el['unit'],
          sugar:
              el['sugar'] != null ? double.parse(el['sugar'].toString()) : null,
          carbo:
              el['carbo'] != null ? double.parse(el['carbo'].toString()) : null,
          calorie: el['calorie'] != null
              ? double.parse(el['calorie'].toString())
              : null,
          protein: el['protein'] != null
              ? double.parse(el['protein'].toString())
              : null,
          fat: el['fat'] != null ? double.parse(el['fat'].toString()) : null,
        );
        await foodDetails.add(nf);
      }
    } else {
      for (var el in foodDetailsUpdate) {
        var index = foodDetails.values
            .toList()
            .indexWhere((element) => element.id == el['id']);
        var nf = FoodDetails(
          name: el['name'],
          id: el['id'],
          isShow: el['isShow'],
          categories: el['categories'],
          unit: el['unit'],
          sugar:
              el['sugar'] != null ? double.parse(el['sugar'].toString()) : null,
          carbo:
              el['carbo'] != null ? double.parse(el['carbo'].toString()) : null,
          calorie: el['calorie'] != null
              ? double.parse(el['calorie'].toString())
              : null,
          protein: el['protein'] != null
              ? double.parse(el['protein'].toString())
              : null,
          fat: el['fat'] != null ? double.parse(el['fat'].toString()) : null,
        );
        if (index > -1) {
          await foodDetails.putAt(index, nf);
        } else {
          await foodDetails.add(nf);
        }
      }
    }
    if (setting.isNotEmpty && setting.getAt(0)!.app == null) {
      var sss = setting.getAt(0)!;
      sss.app = 'planner';
      sss.darkMode = false;
      setting.putAt(0, sss);
    }
    if (setting.isNotEmpty && setting.getAt(0)!.calenderEvent == null) {
      var sss = setting.getAt(0)!;
      sss.calenderEvent = true;
      sss.myEvent = true;
      sss.myTask = true;
      sss.hDate = true;
      sss.gDate = true;
      sss.darkMode = false;
      setting.putAt(0, sss);
    }
    var nv = DBVersion(version: dbv);
    await dbversion.add(nv);
  }
}
