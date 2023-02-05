import 'dart:ui';

import 'package:get/get.dart';

class TranslationController extends GetxController {
  String? _lang;
  String? get lang => _lang;

  @override
  void onInit() {
    // ignore: todo
    // TODO: implement onInit
    _lang = Get.locale?.languageCode;
    update();
    super.onInit();
  }

  void changeLang(String value) {
    _lang = value;
    update();
  }

  void changeLanguage(String langCode, String countryCode) {
    var locale = Locale(langCode, countryCode);
    Get.updateLocale(locale);
    update();
  }
}
