// ignore_for_file: unnecessary_null_comparison, must_be_immutable, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:get/get.dart';

typedef Func = Function();

class MyButton extends GetView {
  String title;
  int badg;
  double? height;
  Color badgColor;
  IconData? icon;
  EdgeInsets? margin;
  Color bgColor;
  Color textColor;
  bool? borderOnly;
  bool? isSpaceBetween = false;
  var onTap;
  MyButton(
      {super.key,
      required this.title,
      this.badg = 0,
      this.height,
      this.badgColor = Colors.red,
      this.icon,
      this.borderOnly,
      this.isSpaceBetween = false,
      this.margin,
      required this.bgColor,
      required this.textColor,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Flexible(
        flex: 1,
        //fit: FlexFit.loose,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
              margin: margin,
              height: height ?? 34,
              //width: 110,
              decoration: BoxDecoration(
                  color: borderOnly == true ? Colors.transparent : bgColor,
                  border: borderOnly == true
                      ? Border.all(color: bgColor, width: 1)
                      : null,
                  borderRadius: BorderRadius.circular(10)),
              // padding: EdgeInsets.symmetric(horizontal: 20),
              child: Stack(children: [
                if (badg > 0)
                  Container(
                      alignment: Alignment.topLeft,
                      child: CircleAvatar(
                        backgroundColor: badgColor,
                        maxRadius: 8,
                        child: Text(
                          badg > 9 ? '9+' : badg.toString(),
                          style:
                              const TextStyle(height: 1, color: Colors.white),
                        ),
                      )),
                Container(
                  alignment: Alignment.center,
                  child: Row(
                      mainAxisAlignment: isSpaceBetween!
                          ? MainAxisAlignment.spaceBetween
                          : MainAxisAlignment.center,
                      children: [
                        if (icon != null)
                          Container(
                              padding: EdgeInsets.only(
                                  right: isSpaceBetween! ? 5 : 0),
                              child: Icon(
                                icon,
                                color: textColor,
                              )),
                        if (icon != null) const SizedBox(width: 5),
                        Container(
                            padding:
                                EdgeInsets.only(left: isSpaceBetween! ? 5 : 0),
                            child: Text(
                              title,
                              style: TextStyle(
                                  color: textColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ))
                      ]),
                )
              ])),
        ));
  }
}
