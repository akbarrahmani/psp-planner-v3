// ignore_for_file: unused_element

part of '../screen.dart';

const _textFieldIcon = Icon(
  Icons.keyboard_arrow_down_rounded,
  color: Colors.black,
  size: 20,
);

class _DropDownField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onTap;
  final Function(String)? onChanged;
  final String? hintText;
  final BorderRadius? borderRadius;
  final bool? required;
  final EdgeInsets? margin;

  final Color? fillColor;
  final IconData? icon;
  const _DropDownField(
      {Key? key,
      required this.controller,
      required this.focusNode,
      required this.onTap,
      required this.icon,
      required this.margin,
      this.onChanged,
      this.required,
      this.hintText,
      this.fillColor,
      this.borderRadius})
      : super(key: key);

  @override
  State<_DropDownField> createState() => _DropDownFieldState();
}

class _DropDownFieldState extends State<_DropDownField> {
  String? prevText;
  bool listenChanges = true;

  @override
  void initState() {
    super.initState();
    if (widget.onChanged != null) {
      widget.controller.addListener(listenItemChanges);
    }
  }

  @override
  void dispose() {
    super.dispose();
    widget.controller.removeListener(listenItemChanges);
  }

  @override
  void didUpdateWidget(covariant _DropDownField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.onChanged != null) {
      widget.controller.addListener(listenItemChanges);
    } else {
      listenChanges = false;
    }
  }

  void listenItemChanges() {
    if (listenChanges) {
      final text = widget.controller.text;
      if (prevText != null && prevText != text && text.isNotEmpty) {
        widget.onChanged!(text);
      }
      prevText = text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: widget.margin ?? const EdgeInsets.all(5),
        padding: const EdgeInsets.only(right: 10),
        height: 40.0,
        decoration: BoxDecoration(
            color: widget.fillColor ??
                (Get.isDarkMode ? grey : Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10)),
        child: Row(children: [
          Icon(widget.icon),
          Flexible(
              child: TextFormField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            validator: (val) {
              if (widget.required != null && widget.required! && val!.isEmpty) {
                return 'انتخاب ${widget.hintText} الزامی است.';
              }
              return null;
            },
            readOnly: true,
            onTap: widget.onTap,
            onChanged: widget.onChanged,
            //  style: widget.style,
            decoration: InputDecoration(
              fillColor: widget.fillColor ??
                  (Get.isDarkMode ? grey : Colors.grey.shade300),
              contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              hintText: widget.required != null && widget.required!
                  ? '${widget.hintText} *'
                  : widget.hintText,
              filled: true,
              suffixIcon: _textFieldIcon,
              // focusedBorder: OutlineInputBorder(
              //     borderSide: const BorderSide(color: grey),
              //     borderRadius: widget.borderRadius ?? BorderRadius.circular(20)),
              // enabledBorder: OutlineInputBorder(
              //     borderRadius: widget.borderRadius ?? BorderRadius.circular(20),
              //     borderSide: const BorderSide(color: grey)),
              // disabledBorder: OutlineInputBorder(
              //     borderSide: BorderSide(color: Colors.grey.shade100)),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
          ))
        ]));
  }
}
