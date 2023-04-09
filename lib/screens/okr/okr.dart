import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OKR extends GetView {
  const OKR({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child:
            Container(alignment: Alignment.center, child: const Text('OKR')));
  }
}
