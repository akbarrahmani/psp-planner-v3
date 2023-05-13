// ignore_for_file: must_be_immutable, file_names, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:persian_tools/persian_tools.dart';

import '../constant.dart';

enum InputType {
  username,
  password,
  text,
  number,
  price,
  email,
  mobile,
  tel,
  postal,
  national
}

bool _obscureText = true;

class MyInput extends StatefulWidget {
  String title;
  IconData? icon;
  var callback;
  Color? fillColor;
  TextEditingController? controller;
  FocusNode? focusNode;
  FocusNode? nextFocusNode;
  int? line;
  int? length;
  double? fontSize;
  TextAlign? textAlign;
  var onChanged;
  var onTap;
  bool? required;
  bool? readOnly;
  bool? rtl;
  bool? isCollapsed;
  TextInputType? keyboardType;
  TextInputAction? textInputAction;
  InputType type;
  Widget? suffix;

  MyInput(
      {super.key,
      required this.title,
      required this.type,
      this.fillColor,
      this.icon,
      this.suffix,
      this.callback,
      this.required,
      this.controller,
      this.focusNode,
      this.nextFocusNode,
      this.onChanged,
      this.onTap,
      this.readOnly,
      this.keyboardType,
      this.textInputAction,
      this.rtl,
      this.isCollapsed,
      this.textAlign,
      this.fontSize,
      this.line,
      this.length});
  // : _type = type,
  //       super(key: key);
  // InputType get type => _type;
  // late InputType _type;
  // set type(InputType value) {
  //   if (_type != value) {
  //     _type = value;
  //   }
  // }

  @override
  State<StatefulWidget> createState() => _MyInputState();
}

RxBool directText = false.obs;

class _MyInputState extends State<MyInput> {
  @override
  Widget build(BuildContext context) {
    //  controller!.addListener(() {
    //   controller!.text.length > 0 ? directText.value = true : directText.value = false;
    // });
    return Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.only(right: 10),
        height: 40.0 * (widget.line ?? 1),
        decoration: BoxDecoration(
            color: widget.fillColor ??
                (Get.isDarkMode ? grey : Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10)),
        child: Directionality(
            textDirection: widget.rtl == null || widget.rtl == true
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: Row(children: [
              Icon(widget.icon),
              const SizedBox(width: 5),
              Flexible(
                  child: TextFormField(
                textAlign: widget.textAlign ?? TextAlign.start,
                style: widget.fontSize != null
                    ? TextStyle(fontSize: widget.fontSize)
                    : null,
                onFieldSubmitted: (value) => widget.nextFocusNode != null
                    ? widget.nextFocusNode!.requestFocus()
                    : {},
                validator: (value) => validator(value),
                inputFormatters: inputFormatter(),
                controller: widget.controller ?? TextEditingController(),
                focusNode: widget.focusNode ?? FocusNode(),
                onChanged: widget.onChanged,
                onTap: widget.onTap,
                readOnly: widget.readOnly ?? false,
                keyboardType: widget.keyboardType,
                textInputAction: widget.textInputAction,
                minLines: widget.line ?? 1,
                maxLines: widget.line ?? 1,
                obscureText:
                    widget.type == InputType.password ? _obscureText : false,
                // textAlign: direct == 'ltr' && directText.isTrue
                //     ? TextAlign.end
                //     : TextAlign.start,
                decoration: InputDecoration(
                  fillColor: Colors.transparent,
                  //  widget.fillColor ??
                  //     (Get.isDarkMode ? grey : Colors.grey.shade300),
                  isCollapsed: true, //widget.isCollapsed ?? false,
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  hintText: widget.required != null && widget.required!
                      ? '  ${widget.title} *'
                      : '  ${widget.title}',
                  filled: true,
                  hintTextDirection: TextDirection.rtl,
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),

                  suffix:
                      widget.type != InputType.password ? widget.suffix : null,
                  suffixIcon: widget.type == InputType.password
                      ? IconButton(
                          onPressed: () => setState(() {
                                _obscureText = !_obscureText;
                              }),
                          icon: Icon(_obscureText
                              ? Icons.visibility
                              : Icons.visibility_off))
                      : null,
                ),
              ))
            ])));
  }

  validator(value) {
    if (widget.required != null && widget.required! && value!.isEmpty) {
      return '${widget.title} الزامی است.';
    } else if (value!.isNotEmpty) {
      switch (widget.type) {
        case InputType.mobile:
          if (value!.length < 11) {
            return '${widget.title} به درستی وارد کنید.';
          }
          break;
        case InputType.postal:
          if (value!.length < 10) {
            return '${widget.title} به درستی وارد کنید.';
          }
          break;
        case InputType.national:
          if (value!.length < 10) {
            return '${widget.title} به درستی وارد کنید.';
          }
          break;
        case InputType.tel:
          if (value!.length < 11) {
            return '${widget.title} به درستی وارد کنید.';
          }
          break;
        default:
      }
    }
  }

  List<TextInputFormatter> inputFormatter() {
    switch (widget.type) {
      case InputType.email:
        return [];
      case InputType.price:
        return [
          CurrencyInputFormatter()
          // CurrencyTextInputFormatter(
          //     decimalDigits: 0, customPattern: '###,###', turnOffGrouping: true)
        ];
      case InputType.mobile:
        return [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(11)
        ];
      case InputType.postal:
        return [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(10)
        ];
      case InputType.national:
        return [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(10)
        ];
      case InputType.number:
        var limit = [];
        if (widget.length != null) {
          limit.add(LengthLimitingTextInputFormatter(widget.length));
        }
        return [FilteringTextInputFormatter.digitsOnly, ...limit];
      case InputType.tel:
        return [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(11)
        ];
      default:
        var limit = [];
        if (widget.length != null) {
          limit.add(LengthLimitingTextInputFormatter(widget.length));
        }
        return [...limit];
    }
  }
}

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.selection.baseOffset == 0) {
      return newValue.copyWith(text: '0');
    } else {
      String newText = intToPrice(priceToInt(newValue.text));

      return newValue.copyWith(
          text: newText,
          selection: TextSelection.collapsed(offset: newText.length - 6));
    }
  }
}

int priceToInt(String value) {
  if (value.replaceAll('تومان', '') == '') {
    return 0;
  } else {
    return int.tryParse(value.replaceAll(RegExp('[^0-9]'), '')) ?? 0;
  }
}

intToPrice(value) {
  return '${addCommas(value ?? 0)} تومان';
}
