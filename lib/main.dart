import 'package:catalog/helpers/bindings.dart';
import 'package:catalog/themes/theme_controller.dart';
import 'package:catalog/themes/themes.dart';
import 'package:catalog/translations/messages.dart';
import 'package:catalog/utils/app_color.dart';
import 'package:catalog/views/control_view.dart';
import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  final themeController = Get.put(ThemeController());
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) => ScreenUtilInit(
        designSize: orientation == Orientation.portrait
            ? const Size(375, 812)
            : const Size(812, 375),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: "catalog",
            translations: Messages(),
            locale: const Locale('ar', 'SY'),
            fallbackLocale: const Locale('ar', 'SY'),
            theme: Themes.lightTheme,
            darkTheme: Themes.darkTheme,
            themeMode: themeController.theme,
            initialBinding: Binding(),
            home: EasySplashScreen(
              logoWidth: 120,
              logo: Image.asset('assets/images/across_mena.jfif'),
              // title: const Text(
              //   "مرحبا بك إلى كتالوج",
              //   style: TextStyle(
              //     fontSize: 18,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              backgroundColor: Colors.white,
              showLoader: true,
              // loadingText: const Text("تحميل..."),
              loaderColor: AppColor.Kuhli,
              navigator: ControlView(),
              durationInSeconds: 5,
            ),
          );
        },
      ),
    );
  }
}
