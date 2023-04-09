// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

class About extends GetView {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(centerTitle: true, title: const Text('درباره ما')),
        body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
                padding: const EdgeInsets.only(right: 20, left: 20, top: 10),
                child: const Text(
                  '''شرکت مشاورین«پگاه‌سیستم»پیشرو از بدو تاسیس در سال ۱۳۸۲ در کنار انجام فعالیت‌های تجاری، عمل به مسئولیت‌های اجتماعی از قبیل برگزاری سمینارهای رایگان در دانشکده مدیریت دانشگاه تهران، چاپ کتب تخصصی و موارد مختلف دیگر را در دستور کار خود داشته است.
و «پگاه‌سیستم» در یکی از اقدامات جدید خود در این راستا  با ارائه رایگان اپلیکیشن «پلنر همیار» با بکارگیری متد برنامه‌ریزی و هدف‌گذاری OKR که متد برنامه‌ریزی شرکت‌های بزرگ دنیا و همچنین افراد موفق است، مدیریت کارهای روزانه و هزینه‌های برنامه‌ریزی شده، یادآورها و یادداشت‌ها در خدمت دوستانی‌ است که به دنبال توسعه فردی و نظم در زندگی خود هستند.
''',
                  style: TextStyle(height: 2, fontSize: 16),
                  textAlign: TextAlign.justify,
                )),
            Container(
                padding: const EdgeInsets.only(right: 20, left: 20, top: 0),
                child: const Text(
                  '🥇«پلنر همیار» همیار شما در مسیر موفقیت...',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                )),
            Container(
                padding: const EdgeInsets.only(right: 43, left: 20, top: 10),
                child: InkWell(
                    onTap: () => launchUrlString('https://pegahsystem.com'),
                    child: const Text(
                      'www.pegahsystem.com',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ))),
            Container(
                padding: const EdgeInsets.only(right: 20, left: 20, top: 50),
                child: Image.asset('asset/img/logoType.png'))
          ]),
        ));
  }
}
