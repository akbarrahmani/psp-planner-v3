// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingAdapter extends TypeAdapter<Setting> {
  @override
  final int typeId = 10;

  @override
  Setting read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Setting(
      id: fields[0] as int?,
      eventHourNotif: fields[1] as int?,
      krdoHourNotif: fields[2] as int?,
      app: fields[3] as String?,
      darkMode: fields[4] as bool?,
      calenderEvent: fields[6] == null ? true : fields[6] as bool?,
      gDate: fields[9] == null ? true : fields[9] as bool?,
      hDate: fields[8] == null ? true : fields[8] as bool?,
      myEvent: fields[7] == null ? true : fields[7] as bool?,
      myTask: fields[5] == null ? true : fields[5] as bool?,
      myCost: fields[16] == null ? true : fields[16] as bool?,
      timeAtWork: fields[10] == null ? true : fields[10] as bool?,
      payDate: fields[11] == null ? true : fields[11] as bool?,
      hijriOffset: fields[12] == null ? 0 : fields[12] as int?,
      workPriority: fields[13] == null ? true : fields[13] as bool?,
      eventDayBreforNotif: fields[14] == null ? true : fields[14] as bool?,
      krdoDayBreforNotif: fields[15] == null ? false : fields[15] as bool?,
      password: fields[17] == null ? '' : fields[17] as String?,
      addWorkToGCalender: fields[18] == null ? false : fields[18] as bool?,
      addCostToGCalender: fields[19] == null ? false : fields[19] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, Setting obj) {
    writer
      ..writeByte(20)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.eventHourNotif)
      ..writeByte(2)
      ..write(obj.krdoHourNotif)
      ..writeByte(3)
      ..write(obj.app)
      ..writeByte(4)
      ..write(obj.darkMode)
      ..writeByte(5)
      ..write(obj.myTask)
      ..writeByte(6)
      ..write(obj.calenderEvent)
      ..writeByte(7)
      ..write(obj.myEvent)
      ..writeByte(8)
      ..write(obj.hDate)
      ..writeByte(9)
      ..write(obj.gDate)
      ..writeByte(10)
      ..write(obj.timeAtWork)
      ..writeByte(11)
      ..write(obj.payDate)
      ..writeByte(12)
      ..write(obj.hijriOffset)
      ..writeByte(13)
      ..write(obj.workPriority)
      ..writeByte(14)
      ..write(obj.eventDayBreforNotif)
      ..writeByte(15)
      ..write(obj.krdoDayBreforNotif)
      ..writeByte(16)
      ..write(obj.myCost)
      ..writeByte(17)
      ..write(obj.password)
      ..writeByte(18)
      ..write(obj.addWorkToGCalender)
      ..writeByte(19)
      ..write(obj.addCostToGCalender);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DBVersionAdapter extends TypeAdapter<DBVersion> {
  @override
  final int typeId = 15;

  @override
  DBVersion read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DBVersion(
      version: fields[0] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, DBVersion obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.version);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DBVersionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PageHelpAdapter extends TypeAdapter<PageHelp> {
  @override
  final int typeId = 11;

  @override
  PageHelp read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PageHelp(
      list: (fields[0] as List).cast<dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, PageHelp obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.list);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PageHelpAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GoalsAdapter extends TypeAdapter<Goals> {
  @override
  final int typeId = 0;

  @override
  Goals read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Goals(
      id: fields[0] as int,
      title: fields[1] as String,
      desc: fields[2] as String,
      year: fields[3] as int,
      date: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Goals obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.desc)
      ..writeByte(3)
      ..write(obj.year)
      ..writeByte(4)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GoalsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ObjectiveAdapter extends TypeAdapter<Objective> {
  @override
  final int typeId = 1;

  @override
  Objective read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Objective(
      id: fields[0] as int,
      goalID: fields[1] as int,
      title: fields[2] as String,
      desc: fields[3] as String,
      startDate: fields[4] as String,
      endDate: fields[5] as String,
      date: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Objective obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.goalID)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.desc)
      ..writeByte(4)
      ..write(obj.startDate)
      ..writeByte(5)
      ..write(obj.endDate)
      ..writeByte(6)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ObjectiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class KRAdapter extends TypeAdapter<KR> {
  @override
  final int typeId = 2;

  @override
  KR read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return KR(
      id: fields[0] as int,
      objectiveID: fields[1] as int,
      title: fields[2] as String,
      desc: fields[3] as String,
      rp: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, KR obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.objectiveID)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.desc)
      ..writeByte(4)
      ..write(obj.rp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KRAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class KRdoAdapter extends TypeAdapter<KRdo> {
  @override
  final int typeId = 3;

  @override
  KRdo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return KRdo(
      id: fields[0] as int,
      krID: fields[1] as int,
      desc: fields[2] as String,
      check: fields[3] as bool,
      date: fields[4] as String,
      rate: fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, KRdo obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.krID)
      ..writeByte(2)
      ..write(obj.desc)
      ..writeByte(3)
      ..write(obj.check)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj.rate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is KRdoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NoteAdapter extends TypeAdapter<Note> {
  @override
  final int typeId = 4;

  @override
  Note read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Note(
      id: fields[0] as int,
      title: fields[1] as String,
      text: fields[2] as String,
      date: fields[3] as String,
      cat: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Note obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.text)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.cat);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WorkCatAdapter extends TypeAdapter<WorkCat> {
  @override
  final int typeId = 5;

  @override
  WorkCat read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorkCat(
      id: fields[0] as int,
      name: fields[1] as String,
      desc: fields[2] as String,
      date: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, WorkCat obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.desc)
      ..writeByte(3)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkCatAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WorkAdapter extends TypeAdapter<Work> {
  @override
  final int typeId = 6;

  @override
  Work read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Work(
      id: fields[0] as int,
      title: fields[1] as String,
      desc: fields[2] as String,
      startDate: fields[3] as String,
      endTime: fields[4] as String,
      notifTime: fields[5] as String,
      cat: fields[6] as int,
      check: fields[7] as bool,
      date: fields[8] as String,
      project: fields[9] as bool,
      repeat: (fields[10] as List).cast<dynamic>(),
      parent: fields[11] as int,
      postponed: fields[12] == null ? 0 : fields[12] as int,
      priority: fields[13] == null ? 1 : fields[13] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Work obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.desc)
      ..writeByte(3)
      ..write(obj.startDate)
      ..writeByte(4)
      ..write(obj.endTime)
      ..writeByte(5)
      ..write(obj.notifTime)
      ..writeByte(6)
      ..write(obj.cat)
      ..writeByte(7)
      ..write(obj.check)
      ..writeByte(8)
      ..write(obj.date)
      ..writeByte(9)
      ..write(obj.project)
      ..writeByte(10)
      ..write(obj.repeat)
      ..writeByte(11)
      ..write(obj.parent)
      ..writeByte(12)
      ..write(obj.postponed)
      ..writeByte(13)
      ..write(obj.priority);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CostCatAdapter extends TypeAdapter<CostCat> {
  @override
  final int typeId = 7;

  @override
  CostCat read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CostCat(
      id: fields[0] as int,
      name: fields[1] as String,
      desc: fields[2] as String,
      date: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CostCat obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.desc)
      ..writeByte(3)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CostCatAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CostAdapter extends TypeAdapter<Cost> {
  @override
  final int typeId = 8;

  @override
  Cost read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Cost(
      id: fields[0] as int,
      title: fields[1] as String,
      desc: fields[2] as String,
      effDate: fields[3] as String,
      price: fields[4] as int,
      paidDate: fields[5] as String,
      notifTime: fields[6] as String,
      cat: fields[7] as int,
      paid: fields[8] as bool,
      date: fields[9] as String,
      repeat: (fields[10] as List).cast<dynamic>(),
      parent: fields[11] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Cost obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.desc)
      ..writeByte(3)
      ..write(obj.effDate)
      ..writeByte(4)
      ..write(obj.price)
      ..writeByte(5)
      ..write(obj.paidDate)
      ..writeByte(6)
      ..write(obj.notifTime)
      ..writeByte(7)
      ..write(obj.cat)
      ..writeByte(8)
      ..write(obj.paid)
      ..writeByte(9)
      ..write(obj.date)
      ..writeByte(10)
      ..write(obj.repeat)
      ..writeByte(11)
      ..write(obj.parent);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CostAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EventAdapter extends TypeAdapter<Event> {
  @override
  final int typeId = 9;

  @override
  Event read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Event(
      id: fields[0] as int,
      title: fields[1] as String,
      date: fields[2] as String,
      effDate: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Event obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.effDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HealthInfoAdapter extends TypeAdapter<HealthInfo> {
  @override
  final int typeId = 12;

  @override
  HealthInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HealthInfo(
      gender: fields[0] as String,
      birthday: fields[1] as String,
      height: fields[2] as int,
      weight: fields[3] as int,
      dailyAct: fields[4] as int,
      date: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HealthInfo obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.gender)
      ..writeByte(1)
      ..write(obj.birthday)
      ..writeByte(2)
      ..write(obj.height)
      ..writeByte(3)
      ..write(obj.weight)
      ..writeByte(4)
      ..write(obj.dailyAct)
      ..writeByte(5)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HealthInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HealthDailyAdapter extends TypeAdapter<HealthDaily> {
  @override
  final int typeId = 13;

  @override
  HealthDaily read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HealthDaily(
      date: fields[0] as String?,
      height: fields[1] as int?,
      weight: fields[2] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, HealthDaily obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.height)
      ..writeByte(2)
      ..write(obj.weight);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HealthDailyAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FoodDetailsAdapter extends TypeAdapter<FoodDetails> {
  @override
  final int typeId = 14;

  @override
  FoodDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FoodDetails(
      name: fields[0] as String?,
      id: fields[1] as int?,
      isShow: fields[2] as bool?,
      categories: (fields[3] as List?)?.cast<dynamic>(),
      unit: fields[4] as String?,
      sugar: fields[5] as double?,
      carbo: fields[6] as double?,
      calorie: fields[7] as double?,
      protein: fields[8] as double?,
      fat: fields[9] as double?,
      peronal: fields[10] == null ? false : fields[10] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, FoodDetails obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.isShow)
      ..writeByte(3)
      ..write(obj.categories)
      ..writeByte(4)
      ..write(obj.unit)
      ..writeByte(5)
      ..write(obj.sugar)
      ..writeByte(6)
      ..write(obj.carbo)
      ..writeByte(7)
      ..write(obj.calorie)
      ..writeByte(8)
      ..write(obj.protein)
      ..writeByte(9)
      ..write(obj.fat)
      ..writeByte(10)
      ..write(obj.peronal);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FoodDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FavoriteFoodAdapter extends TypeAdapter<FavoriteFood> {
  @override
  final int typeId = 16;

  @override
  FavoriteFood read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavoriteFood(
      id: fields[0] as int?,
      count: fields[1] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, FavoriteFood obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.count);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteFoodAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FoodEatAdapter extends TypeAdapter<FoodEat> {
  @override
  final int typeId = 17;

  @override
  FoodEat read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FoodEat(
      id: fields[0] as int?,
      mealID: fields[1] as int?,
      food: fields[2] as FoodDetails?,
      amount: fields[3] as double?,
      date: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, FoodEat obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.mealID)
      ..writeByte(2)
      ..write(obj.food)
      ..writeByte(3)
      ..write(obj.amount)
      ..writeByte(4)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FoodEatAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class WDrinkAdapter extends TypeAdapter<WDrink> {
  @override
  final int typeId = 18;

  @override
  WDrink read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WDrink(
      id: fields[0] as int?,
      count: fields[1] as int?,
      date: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, WDrink obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.count)
      ..writeByte(4)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WDrinkAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
