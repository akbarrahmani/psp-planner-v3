import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Health extends GetView {
  const Health({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
            alignment: Alignment.center, child: const Text('Health')));
  }
}
