import 'package:hive/hive.dart';
part 'models.g.dart';

//general models
@HiveType(typeId: 10)
class Setting {
  Setting(
      {required this.id,
      required this.eventHourNotif,
      required this.krdoHourNotif,
      required this.app,
      this.darkMode,
      this.calenderEvent,
      this.gDate,
      this.hDate,
      this.myEvent,
      this.myTask,
      this.timeAtWork,
      this.payDate});
  @HiveField(0)
  int? id;
  @HiveField(1)
  int? eventHourNotif;
  @HiveField(2)
  int? krdoHourNotif;
  @HiveField(3)
  String? app;
  @HiveField(4)
  bool? darkMode;
  @HiveField(5, defaultValue: true)
  bool? myTask;
  @HiveField(6, defaultValue: true)
  bool? calenderEvent;
  @HiveField(7, defaultValue: true)
  bool? myEvent;
  @HiveField(8, defaultValue: true)
  bool? hDate;
  @HiveField(9, defaultValue: true)
  bool? gDate;
  @HiveField(10, defaultValue: true)
  bool? timeAtWork;
  @HiveField(11, defaultValue: true)
  bool? payDate;

  Map toJson() => {
        'id': id,
        'eventHourNotif': eventHourNotif,
        'krdoHourNotif': krdoHourNotif,
        'app': app,
        'darkMode': darkMode,
        'calenderEvent': calenderEvent,
        'gDate': gDate,
        'hDate': hDate,
        'myEvent': myEvent,
        'myTask': myTask,
        'timeAtWork': timeAtWork,
        'payDate': payDate
      };
}

@HiveType(typeId: 15)
class DBVersion {
  @HiveField(0)
  int? version;
  DBVersion({this.version});
  Map toJson() => {'version': version};
}

@HiveType(typeId: 11)
class PageHelp {
  PageHelp({
    required this.list,
  });
  @HiveField(0)
  List list;

  Map toJson() => {
        'list': list,
      };
}

//planner App models
@HiveType(typeId: 0)
class Goals {
  Goals(
      {required this.id,
      required this.title,
      required this.desc,
      required this.year,
      required this.date});

  @HiveField(0)
  int id;
  @HiveField(1)
  String title;
  @HiveField(2)
  String desc;
  @HiveField(3)
  int year;
  @HiveField(4)
  String date;

  Map toJson() =>
      {'id': id, 'title': title, 'desc': desc, 'year': year, 'date': date};
}

@HiveType(typeId: 1)
class Objective {
  Objective(
      {required this.id,
      required this.goalID,
      required this.title,
      required this.desc,
      required this.startDate,
      required this.endDate,
      required this.date});

  @HiveField(0)
  int id;
  @HiveField(1)
  int goalID;
  @HiveField(2)
  String title;
  @HiveField(3)
  String desc;
  @HiveField(4)
  String startDate;
  @HiveField(5)
  String endDate;
  @HiveField(6)
  String date;

  Map toJson() => {
        'id': id,
        'goalID': goalID,
        'title': title,
        'desc': desc,
        'startDate': startDate,
        'endDate': endDate,
        'date': date
      };
}

@HiveType(typeId: 2)
class KR {
  KR(
      {required this.id,
      required this.objectiveID,
      required this.title,
      required this.desc,
      required this.rp});

  @HiveField(0)
  int id;
  @HiveField(1)
  int objectiveID;
  @HiveField(2)
  String title;
  @HiveField(3)
  String desc;
  @HiveField(4)
  int rp; //Review period --Day

  Map toJson() => {
        'id': id,
        'objectiveID': objectiveID,
        'title': title,
        'desc': desc,
        'rp': rp,
      };
}

@HiveType(typeId: 3)
class KRdo {
  KRdo(
      {required this.id,
      required this.krID,
      required this.desc,
      required this.check,
      required this.date,
      required this.rate});

  @HiveField(0)
  int id;
  @HiveField(1)
  int krID;
  @HiveField(2)
  String desc;
  @HiveField(3)
  bool check;
  @HiveField(4)
  String date;
  @HiveField(5)
  int rate;

  Map toJson() => {
        'id': id,
        'krID': krID,
        'desc': desc,
        'check': check,
        'date': date,
        'rate': rate
      };
}

@HiveType(typeId: 4)
class Note {
  Note(
      {required this.id,
      required this.title,
      required this.text,
      required this.date,
      required this.cat});
  @HiveField(0)
  int id;
  @HiveField(1)
  String title;
  @HiveField(2)
  String text;
  @HiveField(3)
  String date;
  @HiveField(4)
  int cat;

  Map toJson() => {
        'id': id,
        'title': title,
        'text': text,
        'date': date,
        'cat': cat,
      };
}

@HiveType(typeId: 5)
class WorkCat {
  WorkCat(
      {required this.id,
      required this.name,
      required this.desc,
      required this.date});
  @HiveField(0)
  int id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String desc;
  @HiveField(3)
  String date;

  Map toJson() => {
        'id': id,
        'name': name,
        'desc': desc,
        'date': date,
      };
}

@HiveType(typeId: 6)
class Work {
  Work(
      {required this.id,
      required this.title,
      required this.desc,
      required this.startDate,
      required this.endTime,
      required this.notifTime,
      required this.cat,
      required this.check,
      required this.date,
      required this.project,
      required this.repeat,
      required this.parent,
      required this.postponed});
  @HiveField(0)
  int id;
  @HiveField(1)
  String title;
  @HiveField(2)
  String desc;
  @HiveField(3)
  String startDate;
  @HiveField(4)
  String endTime;
  @HiveField(5)
  String notifTime;
  @HiveField(6)
  int cat;
  @HiveField(7)
  bool check;
  @HiveField(8)
  String date;
  @HiveField(9)
  bool project;
  @HiveField(10)
  List repeat; //day >>> 0=norepeat
  @HiveField(11)
  int parent; //0>no repeat | thisID>this is Parent repeat | otherID>this is child Repeat
  @HiveField(12, defaultValue: 0)
  int postponed; //id
  Map toJson() => {
        'id': id,
        'title': title,
        'desc': desc,
        'startDate': startDate,
        'endDate': endTime,
        'notifTime': notifTime,
        'cat': cat,
        'check': check,
        'date': date,
        'project': project,
        'repeat': repeat,
        'parent': parent,
        'postponed': postponed
      };
}

@HiveType(typeId: 7)
class CostCat {
  CostCat(
      {required this.id,
      required this.name,
      required this.desc,
      required this.date});
  @HiveField(0)
  int id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String desc;
  @HiveField(3)
  String date;

  Map toJson() => {
        'id': id,
        'name': name,
        'desc': desc,
        'date': date,
      };
}

@HiveType(typeId: 8)
class Cost {
  Cost(
      {required this.id,
      required this.title,
      required this.desc,
      required this.effDate,
      required this.price,
      required this.paidDate,
      required this.notifTime,
      required this.cat,
      required this.paid,
      required this.date,
      required this.repeat,
      required this.parent});
  @HiveField(0)
  int id;
  @HiveField(1)
  String title;
  @HiveField(2)
  String desc;
  @HiveField(3)
  String effDate;
  @HiveField(4)
  int price;
  @HiveField(5)
  String paidDate;
  @HiveField(6)
  String notifTime;
  @HiveField(7)
  int cat;
  @HiveField(8)
  bool paid;
  @HiveField(9)
  String date;
  @HiveField(10)
  List repeat; //day >>> 0=norepeat
  @HiveField(11)
  int parent; //0>no repeat | thisID>this is Parent repeat | otherID>this is child Repeat

  Map toJson() => {
        'id': id,
        'title': title,
        'desc': desc,
        'effDate': effDate,
        'price': price,
        'paidDate': paidDate,
        'notifTime': notifTime,
        'cat': cat,
        'paid': paid,
        'date': date,
        'repeat': repeat,
        'parent': parent
      };
}

@HiveType(typeId: 9)
class Event {
  Event(
      {required this.id,
      required this.title,
      required this.date,
      required this.effDate});
  @HiveField(0)
  int id;
  @HiveField(1)
  String title;
  @HiveField(2)
  String date;
  @HiveField(3)
  String effDate;

  Map toJson() => {'id': id, 'title': title, 'date': date, 'effDate': effDate};
}

@HiveType(typeId: 12)
class HealthInfo {
  HealthInfo(
      {required this.gender,
      required this.birthday,
      required this.height,
      required this.weight,
      required this.dailyAct,
      required this.date});
  @HiveField(0)
  String gender;
  @HiveField(1)
  String birthday;
  @HiveField(2)
  int height;
  @HiveField(3)
  int weight;
  @HiveField(4)
  int dailyAct;
  @HiveField(5)
  String date;

  Map toJson() => {
        'gender': gender,
        'birthday': birthday,
        'height': height,
        'weight': weight,
        'dailyAct': dailyAct,
        'date': date
      };
}

@HiveType(typeId: 13)
class HealthDaily {
  HealthDaily({required this.date, this.height, this.weight});
  @HiveField(0)
  String? date;
  @HiveField(1)
  int? height;
  @HiveField(2)
  int? weight;

  Map toJson() => {'date': date, 'height': height, 'weight': weight};
}

@HiveType(typeId: 14)
class FoodDetails {
  @HiveField(0)
  String? name;
  @HiveField(1)
  int? id;
  @HiveField(2)
  bool? isShow;
  @HiveField(3)
  List? categories;
  @HiveField(4)
  String? unit;
  @HiveField(5)
  double? sugar;
  @HiveField(6)
  double? carbo;
  @HiveField(7)
  double? calorie;
  @HiveField(8)
  double? protein;
  @HiveField(9)
  double? fat;

  FoodDetails(
      {this.name,
      this.id,
      this.isShow,
      this.categories,
      this.unit,
      this.sugar,
      this.carbo,
      this.calorie,
      this.protein,
      this.fat});

  Map toJson() => {
        'name': name,
        'id': id,
        'isShow': isShow,
        'categories': categories,
        'unit': unit,
        'sugar': sugar,
        'carbo': carbo,
        'calorie': calorie,
        'protein': protein,
        'fat': fat
      };
}

@HiveType(typeId: 16)
class FavoriteFood {
  @HiveField(0)
  int? id;
  @HiveField(1)
  int? count;

  FavoriteFood({this.id, this.count});
  Map toJson() => {'id': id, 'count': count};
}

@HiveType(typeId: 17)
class FoodEat {
  @HiveField(0)
  int? id;
  @HiveField(1)
  int? mealID;
  @HiveField(2)
  FoodDetails? food;
  @HiveField(3)
  double? amount;
  @HiveField(4)
  String? date;

  FoodEat({this.id, this.mealID, this.food, this.amount, this.date});
  Map toJson() => {
        'id': id,
        'mealID': mealID,
        'food': food,
        'amount': amount,
        'date': date
      };
}

@HiveType(typeId: 18)
class WDrink {
  @HiveField(0)
  int? id;
  @HiveField(1)
  int? count;
  @HiveField(4)
  String? date;

  WDrink({this.id, this.count, this.date});
  Map toJson() => {'id': id, 'count': count, 'date': date};
}

//TODO: cmd=> flutter pub run build_runner build
