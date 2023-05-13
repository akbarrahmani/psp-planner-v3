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
import 'package:planner/screens/home/widget/note/add.dart';
import 'package:planner/variables.dart';
import 'package:shamsi_date/shamsi_date.dart';

class ShowNoteInHome extends GetView {
  var callback;
  ShowNoteInHome({super.key, required this.callback});
  RxBool change = false.obs;
  List<Note> dayNote = [];
  @override
  Widget build(BuildContext context) {
    initpage();
    return Obx(() => change.isFalse || change.isTrue
        ? Column(
            children: dayNote
                .map((e) => NoteItem(
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
    dayNote = [];
    dayNote = note.values
        .where((element) =>
            element.date != '' &&
            '${selectedDate.value.day}${selectedDate.value.month}${selectedDate.value.year}' ==
                '${DateTime.parse(element.date).day}${DateTime.parse(element.date).month}${DateTime.parse(element.date).year}')
        .toList();
    dayNote.sort(
        (a, b) => DateTime.parse(a.date).compareTo(DateTime.parse(b.date)));
  }
}

class NoteItem extends GetView {
  Note item;
  var callback;
  NoteItem({super.key, required this.item, this.callback});

  @override
  Widget build(BuildContext context) {
    RxBool change = false.obs;
    return Column(children: [
      Obx(() => change.isFalse || change.isTrue
          ? SwipeActionCell(
              index: item.id,
              key: ValueKey(item.id),
              firstActionWillCoverAllSpaceOnDeleting: false,
              closeWhenScrolling: false,
              trailingActions: const [
                // SwipeAction(
                //     title: "انجام نشده",
                //     style: const TextStyle(fontSize: 14, color: Colors.white),
                //     icon: const Icon(
                //       Iconsax.close_circle,
                //       color: Colors.white,
                //     ),
                //     color: Colors.red,
                //     widthSpace: 100,
                //     forceAlignmentToBoundary: true,
                //     performsFirstActionWithFullSwipe: true,
                //     // nestedAction: item!.check
                //     //     ? SwipeNestedAction(title: "تغییر به انجام نشده")
                //     //     : null,
                //     onTap: (handler) async {
                //       handler(false);
                //       //_toDo(item!, (v) => callback('v'));
                //     }),
              ],
              leadingActions: const [],
              child: Container(
                  padding: const EdgeInsets.only(
                      right: 10, bottom: 5, top: 5, left: 10),
                  height: 60,
                  child: InkWell(
                      onTap: () => _itemDetails(item, (v) => callback(v)),
                      child: Row(children: [
                        CircleAvatar(
                          backgroundColor: orange.withOpacity(0.8),
                          child: Icon(
                            noteCat[item.cat],
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                    if (item.title.isNotEmpty)
                                      Text(
                                        item.title,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    Flexible(
                                        child: Text(
                                      item.text.replaceAll('\n', ' '),
                                      maxLines: item.title.isNotEmpty ? 2 : 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          height: 1, fontSize: 13, color: grey),
                                    ))
                                  ])),
                              Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    'ایجاد شده در: ${DateConvertor.toJalaliShort(DateTime.parse(item.date))}',
                                    style:
                                        TextStyle(fontSize: 10, color: grey2),
                                  ))
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

_itemDetails(Note item, callback) {
  String jd = '';
  var jdd = DateTime.parse(item.date).toJalali();
  jd = '${jdd.day} ${jdd.formatter.mN} ${jdd.year}';
  MyBottomSheet.view(
      Column(children: [
        MyInput(
          controller: TextEditingController(text: item.title),
          title: 'عنوان',
          icon: Iconsax.note_2,
          type: InputType.text,
          readOnly: true,
        ),
        Row(children: [
          Flexible(
              child: MyInput(
            controller: TextEditingController(text: jd),
            title: 'تاریخ و ساعت',
            icon: Iconsax.clock,
            type: InputType.text,
            readOnly: true,
          )),
          IconButton(
              onPressed: null,
              icon: Icon(
                noteCat[item.cat],
                color: orange,
              ))
        ]),
        MyInput(
          controller: TextEditingController(text: item.text),
          title: 'توضیحات',
          icon: Iconsax.document,
          line: 4,
          type: InputType.text,
          readOnly: true,
        ),
        const SizedBox(height: 10),
        Row(children: [
          MyButton(
            title: 'ویرایش',
            bgColor: grey,
            textColor: grey,
            icon: Iconsax.edit,
            onTap: () {
              Get.back();
              addNote(
                  item: item,
                  callback: (v) {
                    callback(v);
                  });
            },
            borderOnly: true,
          ),
          const SizedBox(width: 10),
          MyButton(
            title: 'حذف',
            bgColor: Colors.red,
            textColor: Colors.red,
            icon: Iconsax.trash,
            onTap: () {
              Get.back();
              MyBottomSheet.view(
                  Column(children: [
                    const Text(
                      'عملیات حذف قابل بازگشت نیست!',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const Text('از حذف اطمینان دارید؟'),
                    const SizedBox(height: 10),
                    Row(children: [
                      MyButton(
                        title: 'تایید و حذف',
                        bgColor: Colors.red,
                        textColor: Colors.white,
                        icon: Iconsax.trash,
                        onTap: () async {
                          Get.back();
                          for (var i = 0; i < note.length; i++) {
                            if (note.getAt(i)!.id == item.id) {
                              await note.deleteAt(i);
                              callback('v');
                              break;
                            }
                          }
                        },
                      ),
                      const SizedBox(width: 10),
                      MyButton(
                          title: 'انصراف',
                          bgColor: grey,
                          textColor: grey,
                          icon: Iconsax.close_circle,
                          borderOnly: true,
                          onTap: () {
                            Get.back();
                          })
                    ])
                  ]),
                  h: 130);
            },
            borderOnly: true,
          )
        ])
      ]),
      h: 360);
}
