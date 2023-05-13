// ignore_for_file: no_leading_underscores_for_local_identifiers

part of 'daily.dart';

String mealBestTime(id) {
  switch (id) {
    case 1:
      return 'زمان پیشنهادی: ۸ تا ۱۰ صبح';
    case 2:
      return 'زمان پیشنهادی: ۱۱ تا ۱۳ ';
    case 3:
      return 'زمان پیشنهادی: ۱۳ تا ۱۴';
    case 4:
      return 'زمان پیشنهادی: ۱۴ تا ۱۵';
    case 5:
      return 'زمان پیشنهادی: ۱۷ تا ۱۸:۳۰';
    case 6:
      return 'زمان پیشنهادی: ۲۰ تا ۲۱';
    default:
      'زمان پیشنهادی';
  }
  return 'زمان پیشنهادی';
}

addNewFood(callback) {
  final nameCtl = TextEditingController();
  final nameF = FocusNode();
  final carboCtl = TextEditingController();
  final carboF = FocusNode();
  final calorieCtl = TextEditingController();
  final calorieF = FocusNode();
  final proteinCtl = TextEditingController();
  final proteinF = FocusNode();
  final fatCtl = TextEditingController();
  final fatF = FocusNode();
  final catCtl = TextEditingController();
  final catF = FocusNode();
  RxList catID = [].obs;
  MyBottomSheet.view(
      Column(children: [
        const Text(
          'افزودن خوراکی شخصی',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        MyInput(
            controller: nameCtl,
            focusNode: nameF,
            title: 'نام خوراکی',
            icon: Iconsax.reserve,
            type: InputType.text),
        const Text('مقادیر زیر را بر اساس یک گرم از خوراکی خود وارد کنید.'),
        Row(children: [
          Flexible(
              child: MyInput(
            controller: calorieCtl,
            focusNode: calorieF,
            title: 'کالری',
            fillColor: orange.withOpacity(0.3),
            icon: Iconsax.sound,
            type: InputType.number,
            keyboardType: TextInputType.number,
          )),
          const SizedBox(width: 5),
          Flexible(
              child: MyInput(
            controller: carboCtl,
            focusNode: carboF,
            title: 'کربوهیدرات',
            fillColor:
                const Color.fromARGB(255, 146, 208, 119).withOpacity(0.3),
            icon: Iconsax.sound,
            type: InputType.number,
            keyboardType: TextInputType.number,
          )),
        ]),
        Row(children: [
          Flexible(
              child: MyInput(
            controller: proteinCtl,
            focusNode: proteinF,
            title: 'پروتئین',
            fillColor:
                const Color.fromARGB(255, 241, 162, 125).withOpacity(0.3),
            icon: Iconsax.sound,
            type: InputType.number,
            keyboardType: TextInputType.number,
          )),
          const SizedBox(width: 5),
          Flexible(
              child: MyInput(
            controller: fatCtl,
            focusNode: fatF,
            title: 'چربی',
            fillColor: const Color.fromARGB(255, 255, 196, 59).withOpacity(0.3),
            icon: Iconsax.sound,
            type: InputType.number,
            keyboardType: TextInputType.number,
          )),
        ]),
        MyInput(
            controller: catCtl,
            focusNode: catF,
            title: 'دسته‌بندی',
            icon: Iconsax.category,
            type: InputType.text,
            readOnly: true,
            onTap: () {
              RxList catt = [20].obs;
              MyBottomSheet.view(
                  SizedBox(
                      height: 250,
                      child: Column(children: [
                        Expanded(
                            child: Obx(() => Wrap(
                                alignment: WrapAlignment.spaceBetween,
                                children: foodCatgoriesDB
                                    .map((e) => InkWell(
                                        borderRadius: BorderRadius.circular(10),
                                        onTap: () {
                                          if (catt.contains(e['id'])) {
                                            catt.removeAt(
                                                catt.indexOf(e['id']));
                                          } else {
                                            catt.add(e['id']);
                                          }
                                        },
                                        child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 3),
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 3),
                                            decoration: BoxDecoration(
                                                border: catt.contains(e['id'])
                                                    ? null
                                                    : Border.all(color: grey2),
                                                color: catt.contains(e['id'])
                                                    ? grey
                                                    : null,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Text(
                                              e['name'],
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: darkMode.isTrue
                                                      ? Colors.white
                                                      : catt.contains(e['id'])
                                                          ? Colors.white
                                                          : Colors.black),
                                            ))))
                                    .toList()))),
                        Row(children: [
                          MyButton(
                              title: 'تایید',
                              bgColor: orange,
                              textColor: Colors.white,
                              onTap: () {
                                // ignore: invalid_use_of_protected_member
                                catID.value = catt.value;
                                for (var i = 0; i < catID.length; i++) {
                                  if (catCtl.text.isNotEmpty) {
                                    catCtl.text += ' - ';
                                  }
                                  catCtl.text += foodCatgoriesDB
                                      .where((element) =>
                                          element['id'] == catID[i])
                                      .toList()[0]['name'];
                                }
                                Get.back();
                              })
                        ])
                      ])),
                  h: 300);
            }),
        const SizedBox(height: 10),
        Row(children: [
          MyButton(
              title: 'تایید و افزودن خوراکی شخصی',
              bgColor: orange,
              textColor: Colors.white,
              icon: Iconsax.tick_square,
              onTap: () async {
                if (nameCtl.text.isEmpty) {
                  return MyToast.error('نام خوراکی را وارد کنید');
                } else if (catID.isEmpty) {
                  return MyToast.error('دسته‌بندی خوراکی را انتخاب کنید');
                } else {
                  FoodDetails nf = FoodDetails(
                      name: nameCtl.text,
                      id: foodDetails.length + 1,
                      isShow: true,
                      categories: catID,
                      unit: 'گرم',
                      sugar: null,
                      carbo: double.tryParse(carboCtl.text),
                      calorie: double.tryParse(calorieCtl.text),
                      protein: double.tryParse(proteinCtl.text),
                      fat: double.tryParse(fatCtl.text),
                      peronal: true);
                  await foodDetails.add(nf);
                  callback(nf);
                  Get.back();
                }
              })
        ])
      ]),
      h: 330);
}

_cal(FoodDetails food, int eat, callback) {
  if (food.name != null && eat != 0) {
    callback(
      (food.calorie ?? 0) * eat,
      (food.fat ?? 0) * eat,
      (food.protein ?? 0) * eat,
      (food.carbo ?? 0) * eat,
    );
  }
}

addFood(sdate, callback, {FoodDetails? food, int? eat, int? meal, int? feid}) {
  RxInt mealID = meal != null ? meal.obs : 0.obs;
  final mealCtl = TextEditingController(text: mealName(mealID.value));
  final mealF = FocusNode();
  final foodCtl = TextEditingController();
  final foodF = FocusNode();
  final eatCtl = TextEditingController(text: eat != null ? eat.toString() : '');
  final eatF = FocusNode();
  Rx<FoodDetails> foodSel = food != null ? food.obs : FoodDetails().obs;
  if (food != null) {
    foodCtl.text = food.name!;
  }
  RxDouble _bmr = 0.0.obs, _fat = 0.0.obs, _prt = 0.0.obs, _crb = 0.0.obs;
  eatCtl.addListener(() =>
      _cal(foodSel.value, int.tryParse(eatCtl.text) ?? 0, (bmr, fat, prt, crb) {
        _bmr.value = bmr;
        _fat.value = fat;
        _prt.value = prt;
        _crb.value = crb;
      }));
  foodSel.listen((p0) =>
      _cal(foodSel.value, int.tryParse(eatCtl.text) ?? 0, (bmr, fat, prt, crb) {
        _bmr.value = bmr;
        _fat.value = fat;
        _prt.value = prt;
        _crb.value = crb;
      }));
  MyBottomSheet.view(
      Column(children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(children: [
            Text(
              feid != null ? 'ویرایش خوراکی' : 'افزودن خوراکی',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 10),
            Text(DateConvertor.toJalaliShort(sdate.value, time: false))
          ]),
          TextButton(
              onPressed: () => addNewFood((FoodDetails f) {
                    foodSel.value = f;
                    foodCtl.text = f.name!;
                  }),
              child: const Text('اضافه‌کردن خوراکی شخصی'))
        ]),
        MyDropdown(
          items: const [
            'صبحانه',
            'میان‌وعده صبح',
            'قبل ناهار ',
            'ناهار',
            'میان‌وعده عصر',
            'شام'
          ],
          hintText: 'انتخاب وعده',
          onChanged: (p0) {
            switch (p0) {
              case 'صبحانه':
                mealID.value = 1;
                break;
              case 'میان‌وعده صبح':
                mealID.value = 2;
                break;
              case 'قبل ناهار ':
                mealID.value = 3;
                break;
              case 'ناهار':
                mealID.value = 4;
                break;
              case 'میان‌وعده عصر':
                mealID.value = 5;
                break;
              case 'شام':
                mealID.value = 6;
                break;
              default:
            }
          },
          controller: mealCtl,
          focusNode: mealF,
          icon: Iconsax.search_status_1,
        ),
        Obx(() => Container(
            padding: const EdgeInsets.only(left: 20),
            alignment: Alignment.centerLeft,
            child: Text(mealBestTime(mealID.value)))),
        MyInput(
          controller: foodCtl,
          focusNode: foodF,
          title: 'انتخاب خوراکی',
          type: InputType.text,
          readOnly: true,
          icon: Iconsax.reserve,
          onTap: () => foodList(callback: (FoodDetails v) {
            foodCtl.text = v.name!;
            foodSel.value = v;
          }),
        ),
        MyInput(
          controller: eatCtl,
          focusNode: eatF,
          title: 'مقدار مصرف(گرم)',
          suffix: const Text('گرم  '),
          type: InputType.number,
          keyboardType: TextInputType.number,
          icon: Iconsax.bubble,
        ),
        Obx(() => Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              Column(children: [
                const Text('کالری'),
                Container(
                  alignment: Alignment.center,
                  //  width: 50,
                  constraints: const BoxConstraints(minWidth: 50),
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10), color: orange),
                  child: Text(
                    addCommas(doubleToString(_bmr.value, 4)),
                    style: const TextStyle(color: Colors.white),
                  ),
                )
              ]),
              const SizedBox(width: 5),
              Column(children: [
                const Text('کربوهیدات'),
                Container(
                  alignment: Alignment.center,
                  constraints: const BoxConstraints(minWidth: 50),
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 146, 208, 119)),
                  child: Text(
                    doubleToString(_crb.value, 4),
                    style: const TextStyle(color: Colors.white),
                  ),
                )
              ]),
              const SizedBox(width: 5),
              Column(children: [
                const Text('پروتئین'),
                Container(
                  alignment: Alignment.center,
                  constraints: const BoxConstraints(minWidth: 50),
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 241, 162, 125)),
                  child: Text(
                    doubleToString(_prt.value, 4),
                    style: const TextStyle(color: Colors.white),
                  ),
                )
              ]),
              const SizedBox(width: 5),
              Column(children: [
                const Text('چربی'),
                Container(
                  alignment: Alignment.center,
                  constraints: const BoxConstraints(minWidth: 50),
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 255, 196, 59)),
                  child: Text(
                    doubleToString(_fat.value, 4),
                    style: const TextStyle(color: Colors.white),
                  ),
                )
              ])
            ])),
        const SizedBox(height: 10),
        Row(children: [
          MyButton(
              title: feid != null ? 'ویرایش خوراکی' : 'ثبت خوراکی',
              bgColor: orange,
              textColor: Colors.white,
              onTap: () async {
                if (mealID.value > 0 &&
                    foodSel.value.name != null &&
                    int.tryParse(eatCtl.text) != null) {
                  if (feid == null) {
                    var ne = FoodEat(
                        id: foodEat.isNotEmpty
                            ? foodEat.getAt(foodEat.length - 1)!.id! + 1
                            : 1,
                        mealID: mealID.value,
                        food: foodSel.value,
                        amount: double.parse(eatCtl.text),
                        date: sdate.value.toIso8601String());
                    await foodEat.add(ne);
                    int index = favoriteFood.values.toList().indexWhere(
                        (element) => element.id == foodSel.value.id);
                    if (index > -1) {
                      var ff = favoriteFood.getAt(index)!;
                      ff.count = ff.count! + 1;
                      await favoriteFood.putAt(index, ff);
                    } else {
                      var nff = FavoriteFood(id: foodSel.value.id, count: 1);
                      await favoriteFood.add(nff);
                    }
                    callback();
                    Get.back();
                    MyToast.success('خوراکی افزوده شد.');
                  } else {
                    FoodEat fe = foodEat.values
                        .where((element) => element.id == feid)
                        .toList()[0];
                    fe.mealID = mealID.value;
                    fe.food = foodSel.value;
                    fe.amount = double.parse(eatCtl.text);
                    for (var i = 0; i < foodEat.length; i++) {
                      if (foodEat.getAt(i)!.id == feid) {
                        await foodEat.putAt(i, fe);
                        break;
                      }
                      callback();
                      Get.back();
                      MyToast.success('خوراکی ویرایش شد.');
                    }
                  }
                } else {
                  MyToast.error('تمام موارد را کامل کنید');
                }
              })
        ])
      ]),
      h: 350);
}

String mealName(id) {
  switch (id) {
    case 1:
      return 'صبحانه';
    case 2:
      return 'میان‌وعده صبح';
    case 3:
      return 'قبل از ناهار';
    case 4:
      return 'ناهار';
    case 5:
      return 'میان‌وعده عصر';
    case 6:
      return 'شام';
    default:
      '';
  }
  return '';
}

dailyEat(Rx<DateTime> sdate, callback) {
  List<FoodEat> dayfood = foodEat.values
      .where((element) =>
          element.date!.split('T')[0] ==
          sdate.value.toIso8601String().split('T')[0])
      .toList();
  RxBool change = false.obs;
  MyBottomSheet.view(
    Obx(() => change.isFalse || change.isTrue
        ? Column(children: [
            Text(
              'خوراک امروز ${DateConvertor.toJalaliLong(sdate.value, time: false)}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(
                height: dayfood.isEmpty ? 300 : (dayfood.length * 75) + 80,
                child: TitledList(
                    date: sdate.value,
                    data: dayfood,
                    type: TitledListType.dayFood,
                    callback: (v) => {
                          dayfood = foodEat.values
                              .where((element) =>
                                  element.date!.split('T')[0] ==
                                  sdate.value.toIso8601String().split('T')[0])
                              .toList(),
                          change.toggle(),
                          callback()
                        }))
          ])
        : Container()),
  );
}

dayFoodItem(DateTime sdate, FoodEat item, callback) {
  return Column(children: [
    Container(
        height: 50,
        padding: const EdgeInsets.only(right: 10),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          SizedBox(
              width: Get.width / 6,
              child: Text(
                item.food!.name!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              )),
          Row(children: [
            Column(children: [
              const Text('کالری'),
              Container(
                alignment: Alignment.center,
                width: 50,
                padding: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), color: orange),
                child: Text(
                  item.food!.calorie == null
                      ? '-'
                      : addCommas(doubleToString(
                          item.food!.calorie! * item.amount!, 4)),
                  style: const TextStyle(color: Colors.white),
                ),
              )
            ]),
            const SizedBox(width: 5),
            Column(children: [
              const Text('ک'),
              Container(
                alignment: Alignment.center,
                width: 50,
                padding: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 146, 208, 119)),
                child: Text(
                  item.food!.carbo == null
                      ? '-'
                      : doubleToString(item.food!.carbo! * item.amount!, 4),
                  style: const TextStyle(color: Colors.white),
                ),
              )
            ]),
            const SizedBox(width: 5),
            Column(children: [
              const Text('پ'),
              Container(
                alignment: Alignment.center,
                width: 50,
                padding: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 241, 162, 125)),
                child: Text(
                  item.food!.protein == null
                      ? '-'
                      : doubleToString(item.food!.protein! * item.amount!, 4),
                  style: const TextStyle(color: Colors.white),
                ),
              )
            ]),
            const SizedBox(width: 5),
            Column(children: [
              const Text('چ'),
              Container(
                alignment: Alignment.center,
                width: 50,
                padding: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 255, 196, 59)),
                child: Text(
                  item.food!.fat == null
                      ? '-'
                      : doubleToString(item.food!.fat! * item.amount!, 4),
                  style: const TextStyle(color: Colors.white),
                ),
              )
            ])
          ]),
          Row(children: [
            IconButton(
                onPressed: () => addFood(
                    DateTime.parse(item.date!).obs, () => callback('v'),
                    food: item.food,
                    eat: item.amount!.toInt(),
                    meal: item.mealID,
                    feid: item.id),
                icon: const Icon(Iconsax.edit)),
            InkWell(
                onTap: () => MyToast.info('برای حذف نگه دارید.'),
                onLongPress: () async {
                  for (var i = 0; i < foodEat.length; i++) {
                    if (foodEat.getAt(i)!.id == item.id) {
                      await foodEat.deleteAt(i);
                      callback('v');
                      //Get.back();
                      MyToast.success('خوراکی حذف شد.');
                      //  dailyEat(sdate.obs, () => callback());
                      break;
                    }
                  }
                },
                child: const Icon(Iconsax.trash))
          ])
        ])),
    Container(
      height: 1,
      width: Get.width,
      margin: const EdgeInsets.only(right: 30),
      color: darkMode.isTrue ? Colors.grey.shade800 : Colors.grey.shade300,
    )
  ]);
}
