// ignore_for_file: file_names, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:planner/constant.dart';
import 'package:url_launcher/url_launcher_string.dart';

class WeProduct extends GetView {
  @override
  Widget build(BuildContext context) {
    const catName = [
      'حوزه حسابداری مالی',
      'حوزه حسابداری مدیریت',
      'حوزه زنجیره تامین',
      'حوزه مدیریت',
      'حوزه بازار و مشتری',
      'حوزه اداری و سازمان',
      'حوزه مدیریت کارخانه',
      'تضمین کیفیت',
      'حوزه مدیریت پیمان',
      'ارزیابی و پایش',
      'حوزه مدیریت HSE',
    ];
    const acc = [
      [
        'نرم‌افزار حسابداری',
        'https://pegahsystem.com/finance-accounting-software/'
      ],
      [
        'نرم‌افزار خزانه‌داری',
        'https://pegahsystem.com/treasury-software-finnance/'
      ],
      [
        'نرم‌افزار دارایی‌ ثابت',
        'https://pegahsystem.com/fixed-assets-software-finance/'
      ],
      [
        'نرم‌افزار حسابداری تجمیعی',
        'https://pegahsystem.com/aggregate-accounting-software-finnance/'
      ],
      ['نرم‌افزار سهام', 'https://pegahsystem.com/stocks-software-finnance/']
    ];
    const accManage = [
      [
        'نرم‌افزار بهای تمام شده',
        'https://pegahsystem.com/cost-software-management-accounting/'
      ],
      [
        'نرم‌افزار بودجه',
        'https://pegahsystem.com/budget-software-management-accounting/'
      ],
      [
        'نرم‌افزار صورت‌های مالی',
        'https://pegahsystem.com/reports-software-management-accounting/'
      ],
    ];
    const tamin = [
      [
        'نرم‌افزار انبار',
        'https://pegahsystem.com/warehouse-software-finance/'
      ],
      [
        'نرم‌افزار تدارکات داخلی',
        'https://pegahsystem.com/internal-procurement-software-finance/'
      ],
      [
        'نرم‌افزار تدارکات خارجی',
        'https://pegahsystem.com/external-procurement-software-finance/'
      ],
    ];
    const manage = [
      ['نرم‌افزار مدیریت پیام', 'https://pegahsystem.com/message-management'],
      [
        'نرم‌افزار گزارش‌ساز',
        'https://pegahsystem.com/mrs-software-management/'
      ],
      [
        'نرم‌افزار داشبرد مدیریت',
        'https://pegahsystem.com/dashboard-software-management/'
      ],
      [
        'نرم‌افزار هوش تجاری',
        'https://pegahsystem.com/bi-software-management/'
      ],
      [
        'نرم‌افزار مدیریت عملکرد',
        'https://pegahsystem.com/performance-management-software/'
      ],
    ];
    const costumer = [
      [
        'نرم‌افزار فروش',
        'https://pegahsystem.com/sale-software-market-customer/'
      ],
      [
        'نرم‌افزار مدیریت ارتباط با مشتری',
        'https://pegahsystem.com/crm-software/'
      ],
      [
        'نرم‌افزار مدیریت ارتباط با مشتری ابری',
        'https://pegahsystem.com/cloud-crm/'
      ],
      [
        'نرم‌افزار خدمات پس از فروش',
        'https://pegahsystem.com/customer-support-system/'
      ],
      [
        'نرم‌افزار باشگاه مشتریان',
        'https://pegahsystem.com/club-software-market-customer/'
      ],
      ['نرم‌افزار فروشگاه اینترنتی', 'https://pegahsystem.com/online-store/'],
    ];
    const org = [
      [
        'نرم‌افزار اتوماسیون اداری',
        'https://pegahsystem.com/automation-software-finance/'
      ],
      [
        'نرم‌افزار مدیریت فرایند‌های سازمانی',
        'https://pegahsystem.com/bpms-software-finnance/'
      ],
      [
        'نرم‌افزار حقوق و دستمزد',
        'https://pegahsystem.com/salary-software-finance/'
      ],
      ['نرم‌افزار تایم شیفت', 'https://pegahsystem.com/time-sheet-software/'],
    ];
    const factory = [
      ['نرم‌افزار برنامه‌ریزی تولید', 'https://pegahsystem.com/'],
      ['نرم‌افزار کنترل عملیات تولید', 'https://pegahsystem.com/'],
      [
        'نرم‌افزار نگهداری و تعمیرات',
        'https://pegahsystem.com/preventive-maintenance-software-manufactory/'
      ],
      [
        'نرم‌افزار کنترل کیفیت',
        'https://pegahsystem.com/manufactory-quality-control-software/'
      ],
      [
        'نرم‌افزار کالیبراسیون',
        'https://pegahsystem.com/calibration-software-manufactory/'
      ],
      [
        'نرم‌افزار آزمایشگاه',
        'https://pegahsystem.com/manufactory-laboratory-software/'
      ],
    ];
    const quality = [
      ['نرم‌افزار مدیریت ریسک', 'https://pegahsystem.com/risk-management/'],
      [
        'نرم‌افزار مدیریت فرایندها و اهداف',
        'https://pegahsystem.com/processes-software-iso/'
      ],
      [
        'نرم‌افزار مدیریت مدارک',
        'https://pegahsystem.com/document-software-iso/'
      ],
      [
        'نرم‌افزار مدیریت سوابق',
        'https://pegahsystem.com/experience-software-iso/'
      ],
      [
        'نرم‌افزار مدیریت اقدامات اصلاحی',
        'https://pegahsystem.com/correction-software-iso/'
      ],
      [
        'نرم‌افزار مدیریت تکوین محصول',
        'https://pegahsystem.com/manufactory-product-development-software/'
      ],
      [
        'نرم‌افزار مدیریت آموزش',
        'https://pegahsystem.com/education-software-iso/'
      ],
      ['نرم‌افزار ممیزی داخلی', 'https://pegahsystem.com/audit-software-iso/'],
      [
        'نرم‌افزار مدیریت جلسات بازنگری مدیریت',
        'https://pegahsystem.com/meetings-management-software-iso/'
      ],
      ['نرم‌افزار هزینه‌یابی کیفیت ضعیف', 'https://pegahsystem.com/copq/'],
    ];
    const peyman = [
      ['سیستم پیمان‌کاری', 'https://pegahsystem.com/contracting-system/'],
    ];
    const eval = [
      ['سامانه رضایت سنجی', 'https://pegahsystem.com/satisfaction-system/'],
      [
        'نرم‌افزار ارزیابی کارکنان',
        'https://pegahsystem.com/staff-satisfaction-software-iso/'
      ],
      [
        'رضایت‌سنجی و شکایات مشتریان',
        'https://pegahsystem.com/csm-software-market-customer/'
      ],
      [
        'نرم‌افزار ارزیابی تامین‌کنندگان',
        'https://pegahsystem.com/suppliers-software-iso/'
      ],
    ];
    const hse = [
      [
        'نرم‌افزار مدیریت ریسک‌های ایمنی',
        'https://pegahsystem.com/risk-software-hse/'
      ],
      [
        'نرم‌افزار مدیریت مانور و بازدید',
        'https://pegahsystem.com/maneuver-software-hse/'
      ],
      [
        'نرم‌افزار ایمنی و بهداشت',
        'https://pegahsystem.com/safety-software-hse/'
      ],
    ];
    const catPr = [
      acc,
      accManage,
      tamin,
      manage,
      costumer,
      org,
      factory,
      quality,
      peyman,
      eval,
      hse
    ];

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('محصولات ما')),
      body: SingleChildScrollView(
        child: Column(children: [
          Container(
              padding: const EdgeInsets.only(right: 20, left: 20),
              child: const Text(
                'با لمس هرکدام از عناوین برای اطلاعات بیشتر به صفحه محصول در سایت پگاه‌سیستم منتقل خواهید شد.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              )),
          for (var i = 0; i < catName.length; i++)
            productCat(catName[i], catPr[i]),
        ]),
      ),
    );
  }

  productCat(catName, pr) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: grey2),
            borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.only(top: 2, bottom: 2, right: 20, left: 20),
        //  padding: EdgeInsets,
        child: ExpansionTile(
            title: Text(
              catName,
              style: TextStyle(
                  fontSize: 17, fontWeight: FontWeight.bold, color: orange),
            ),
            children: [
              for (var i = 0; i < pr.length; i++) prChild(pr[i][0], pr[i][1])
            ]));
  }

  prChild(name, url) {
    return Container(
        padding: const EdgeInsets.only(right: 40, bottom: 8),
        alignment: Alignment.centerRight,
        width: Get.width,
        child: InkWell(
            onTap: () => launchUrlString(url),
            child: Text(
              name,
              style: const TextStyle(fontSize: 16),
            )));
  }
}
