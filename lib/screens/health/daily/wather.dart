part of 'daily.dart';

drinkChangeSubmit(int drink, DateTime date) async {
  var dindex = wDrink.values.toList().indexWhere((element) =>
      element.date!.split('T')[0] == date.toIso8601String().split('T')[0]);
  if (dindex > -1) {
    var wd = wDrink.getAt(dindex)!;
    wd.count = drink + 1;
    await wDrink.putAt(dindex, wd);
  } else {
    var nwd = WDrink(
        id: wDrink.isNotEmpty ? wDrink.getAt(wDrink.length - 1)!.id! + 1 : 1,
        count: drink + 1,
        date: date.toIso8601String());
    await wDrink.add(nwd);
  }
}
