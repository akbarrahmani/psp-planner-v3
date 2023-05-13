// ignore_for_file: file_names, must_be_immutable, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import 'textInput.dart';

class MySearchFilter extends GetView {
  var listData;
  String? text;
  var callback;
  List condition;
  MySearchFilter(
      {required this.listData,
      required this.condition,
      required this.callback,
      this.text,
      super.key});
  final searchCtl = TextEditingController();
  final searchF = FocusNode();
  RxString search = ''.obs;
  List searchList = [];
  @override
  Widget build(BuildContext context) {
    return MyInput(
      controller: searchCtl,
      focusNode: searchF,
      title: text ?? 'جستجو',
      type: InputType.text,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.search,
      icon: Iconsax.search_normal,
      callback: () =>
          {searchCtl.clear(), search.value = '', callback(listData)},
      onChanged: (v) => {
        search.value = v,
        searchF.requestFocus(),
        if (v.length >= 1)
          callback(searchCondition(v, condition, listData))
        else
          callback(listData)
      },
    );
  }

  searchCondition(srch, List condition, data) {
    List list = [];
    srch = srch.replaceAll(' ', '').toString().toEnglishDigit();
    if (srch != '' && condition.isNotEmpty) {
      for (var i = 0; i < data.length; i++) {
        for (var c = 0; c < condition.length; c++) {
          if (data[i]
              .toJson()[condition[c]]
              .toString()
              .replaceAll(' ', '')
              .contains(srch)) {
            list.add(data[i]);
            break;
          }
        }
      }
      return list;
    } else {
      return data;
    }
    //
  }
}
