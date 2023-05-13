import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:appmetrica_push_plugin/appmetrica_push_plugin.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:planner/constant.dart';
import 'package:planner/screens/splash.dart';
import 'package:planner/service/notifications/notification.dart';
import 'package:planner/variables.dart';

Future<void> main() async {
  AppMetrica.runZoneGuarded(() {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    AppMetrica.activate(appMetricaConfig);
    AppMetricaPush.activate();
    runApp(GetMaterialApp(
      home: Obx(() => darkMode.isTrue ? const App() : const App()),
      theme: ThemeData(
          useMaterial3: true,
          fontFamily: 'iran',
          cupertinoOverrideTheme: const CupertinoThemeData(
              textTheme: CupertinoTextThemeData(
                  dateTimePickerTextStyle: TextStyle(fontFamily: 'iran'))),
          colorScheme: ColorScheme(
              brightness: Brightness.light,
              primary: orange,
              onPrimary: Colors.black,
              secondary: grey,
              onSecondary: Colors.black,
              error: Colors.red,
              onError: Colors.white,
              background: Colors.grey.shade100,
              onBackground: Colors.black,
              surface: Colors.grey.shade300,
              onSurface: Colors.black,
              outline: grey),
          // bottomNavigationBarTheme:
          //     const BottomNavigationBarThemeData(backgroundColor: Colors.white),
          appBarTheme: const AppBarTheme(
              toolbarHeight: 40,
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white),
          scaffoldBackgroundColor: Colors.grey.shade100,
          brightness: Brightness.light),
      darkTheme: ThemeData(
          useMaterial3: true,
          fontFamily: 'iran',
          cupertinoOverrideTheme: const CupertinoThemeData(
              textTheme: CupertinoTextThemeData(
                  dateTimePickerTextStyle: TextStyle(fontFamily: 'iran'))),
          // bottomNavigationBarTheme: BottomNavigationBarThemeData(
          //     backgroundColor: Colors.grey.shade800),
          colorScheme: ColorScheme(
              brightness: Brightness.dark,
              primary: orange,
              onPrimary: Colors.white,
              secondary: grey,
              onSecondary: Colors.grey.shade500,
              error: Colors.red,
              onError: Colors.white,
              background: Colors.grey.shade800,
              onBackground: Colors.grey.shade100,
              surface: Colors.grey.shade700,
              onSurface: Colors.white,
              outline: grey),
          appBarTheme: AppBarTheme(
              toolbarHeight: 40,
              backgroundColor: Colors.grey.shade800,
              surfaceTintColor: Colors.grey.shade800),
          scaffoldBackgroundColor: Colors.grey[850],
          //   accentColor: Colors.grey.shade800,
          brightness: Brightness.dark),
      locale: const Locale('fa'),
      debugShowCheckedModeBanner: false,
      builder: BotToastInit(),
      navigatorObservers: [BotToastNavigatorObserver()],
    ));
  });
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<StatefulWidget> createState() => _App();
}

class _App extends State<App> {
  @override
  void initState() {
    super.initState();
    MyNotification.requestPermissions();
    ignoreBatteryOptimizations();
  }

  ignoreBatteryOptimizations() async {
    var s = await Permission.ignoreBatteryOptimizations.status;
    if (s.isDenied) {
      await Permission.ignoreBatteryOptimizations.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Splash();
  }
}

class App1 extends GetView {
  const App1({super.key});

  @override
  Widget build(Object context) {
    MyNotification.requestPermissions();
    return const Splash();
  }
}
