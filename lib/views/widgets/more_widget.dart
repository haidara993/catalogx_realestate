import 'package:catalog/translations/translation_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class MoreItemView extends StatelessWidget {
  final String name;
  final IconData moreicon;
  final VoidCallback? onPressed;
  final Widget? themeanim;
  MoreItemView(
      {required this.name,
      required this.moreicon,
      this.onPressed,
      this.themeanim});
  final langController = Get.put(TranslationController());
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: (Colors.grey),
              width: 1.0,
            ),
          ),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        padding: Get.locale?.languageCode == 'ar'
            ? EdgeInsets.only(top: 8.h, right: 8.w)
            : EdgeInsets.only(top: 8.h, left: 8.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              moreicon,
              size: 23,
            ),
            SizedBox(
              width: 10.w,
            ),
            Expanded(
              child: name == "languague".tr
                  ? GestureDetector(
                      onTap: () {
                        Get.defaultDialog(
                            title: "languague".tr,
                            content: GetBuilder<TranslationController>(
                              builder: (controller) => Column(
                                children: <Widget>[
                                  RadioListTile<String>(
                                    title: const Text('العربية'),
                                    value: 'ar',
                                    groupValue: langController.lang,
                                    onChanged: (String? value) {
                                      langController.changeLanguage('ar', 'SY');

                                      langController.changeLang(value!);
                                    },
                                  ),
                                  RadioListTile<String>(
                                    title: const Text('English'),
                                    value: 'en',
                                    groupValue: langController.lang,
                                    onChanged: (String? value) {
                                      langController.changeLanguage('en', 'US');
                                      langController.changeLang(value!);
                                    },
                                  ),
                                ],
                              ),
                            ));
                      },
                      child: Container(
                        height: 65.h,
                        alignment: Get.locale?.languageCode == 'ar'
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              Get.locale?.languageCode == 'ar'
                                  ? "العربية"
                                  : "English",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(
                      height: 60.h,
                      alignment: Get.locale?.languageCode == 'ar'
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
            ),
            name == "الثيم".tr
                ? themeanim!
                : const Icon(Icons.arrow_forward_ios, size: 19),
            SizedBox(
              width: 5.w,
            ),
          ],
        ),
      ),
    );
  }
}
