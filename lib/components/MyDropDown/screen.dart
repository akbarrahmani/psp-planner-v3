// ignore_for_file: must_be_immutable, library_private_types_in_public_api, unused_local_variable

library animated_custom_dropdown;

export 'screen.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constant.dart';

part './components/animated_section.dart';
part './components/dropdown_field.dart';
part './components/dropdown_overlay.dart';
part './components/overlay_builder.dart';

class MyDropdown extends StatefulWidget {
  final List<String> items;
  final TextEditingController controller;
  final String? hintText;
  final String? desc;
  final TextStyle? hintStyle;
  final TextStyle? selectedStyle;
  final String? errorText;
  final TextStyle? errorStyle;
  final TextStyle? listItemStyle;
  final BorderSide? borderSide;
  final BorderSide? errorBorderSide;
  final BorderRadius? borderRadius;
  final BorderRadius? fieldBorderRadius;
  final Widget? suffixIcon;
  final Function(String)? onChanged;
  final bool? excludeSelected;
  final bool? titled;
  final bool? required;
  final Color? fillColor;
  final IconData? icon;
  final FocusNode focusNode;
  bool? isRow;
  MyDropdown({
    Key? key,
    required this.items,
    required this.controller,
    required this.focusNode,
    this.isRow,
    this.required,
    this.hintText,
    this.titled,
    this.hintStyle,
    this.desc,
    this.selectedStyle,
    this.errorText,
    this.errorStyle,
    this.listItemStyle,
    this.errorBorderSide,
    this.borderRadius,
    this.fieldBorderRadius,
    this.borderSide,
    this.suffixIcon,
    this.onChanged,
    this.excludeSelected = true,
    this.icon,
    this.fillColor,
  })  : assert(
          controller.text.isEmpty || items.contains(controller.text),
          'Controller value must match with one of the item in items list.',
        ),
        super(key: key);

  @override
  _MyDropdownState createState() => _MyDropdownState();
}

class _MyDropdownState extends State<MyDropdown> {
  final layerLink = LayerLink();

  @override
  Widget build(BuildContext context) {
    /// hint text
    final hintText = widget.hintText ?? 'Select value';
    // final desc = widget.desc;
    // bool isRow = widget.isRow ?? false;
    // bool titled = widget.titled ?? true;
    IconData? icon = widget.icon;
    // hint style :: if provided then merge with default
    final hintStyle = const TextStyle(
      fontSize: 16,
      //color: Color(0xFFA7A7A7),
      fontWeight: FontWeight.w400,
    ).merge(widget.hintStyle);

    // selected item style :: if provided then merge with default
    final selectedStyle = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ).merge(widget.selectedStyle);

    return _OverlayBuilder(
      overlay: (size, hideCallback) {
        return _DropdownOverlay(
          items: widget.items,
          controller: widget.controller,
          size: size,
          icon: widget.icon,
          layerLink: layerLink,
          hideOverlay: hideCallback,
          headerStyle:
              widget.controller.text.isNotEmpty ? selectedStyle : hintStyle,
          suffixIcon: widget.suffixIcon,
          hintText: widget.hintText ?? 'انتخاب کنید',
          listItemStyle: widget.listItemStyle,
          excludeSelected: widget.excludeSelected,
          borderRadius: widget.borderRadius,
        );
      },
      child: (showCallback) {
        return CompositedTransformTarget(
          link: layerLink,
          child: _DropDownField(
            //fillColor: widget.fillColor,
            focusNode: widget.focusNode,
            controller: widget.controller,
            required: widget.required,
            icon: widget.icon,
            onTap: showCallback,
            hintText: widget.hintText ?? 'انتخاب کنید',
            borderRadius: widget.fieldBorderRadius,
            onChanged: widget.onChanged,
          ),
        );
      },
    );
    //   )
    // ]));
  }
}
