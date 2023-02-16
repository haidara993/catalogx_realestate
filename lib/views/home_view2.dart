// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:catalog/controllers/control_viewmodel.dart';
import 'package:catalog/controllers/favorite_view_model.dart';
import 'package:catalog/controllers/property_controller.dart';
import 'package:catalog/controllers/saved_search_viewmodel.dart';
import 'package:catalog/controllers/search_viewmodel.dart';
import 'package:catalog/utils/app_color.dart';
import 'package:catalog/views/add_property/add_property.dart';
import 'package:catalog/views/add_property/add_property_2.dart';
import 'package:catalog/views/add_property/add_property_3.dart';
import 'package:catalog/views/favorite_view.dart';
import 'package:catalog/views/filter_vew.dart';
import 'package:catalog/views/saved_search_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomeView2 extends StatelessWidget {
  const HomeView2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: SizedBox(
          height: Get.height,
          child: Column(
            children: [
              SizedBox(
                height: 14.h,
              ),
              SvgPicture.asset('assets/images/AcrossMENA _logo.svg',
                  height: 95.h),
              SizedBox(
                height: 14.h,
              ),
              GridView(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, childAspectRatio: .7),
                children: [
                  GestureDetector(
                    onTap: () {
                      var searchController = Get.put(SearchViewModel());
                      Get.find<ControlViewModel>()
                          .changeSelectedValue2(selectedValue: 1);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Get.locale?.languageCode == 'ar'
                            ? Border(
                                left: BorderSide(
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : AppColor.GreyIcons,
                                  width: 1.0,
                                ),
                                bottom: BorderSide(
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : AppColor.GreyIcons,
                                  width: 1.0,
                                ),
                              )
                            : Border(
                                right: BorderSide(
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : AppColor.GreyIcons,
                                  width: 1.0,
                                ),
                                bottom: BorderSide(
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : AppColor.GreyIcons,
                                  width: 1.0,
                                ),
                              ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Get.isDarkMode
                              ? Image.asset(
                                  'assets/icons/map-search-w.png',
                                  height: 50.h,
                                )
                              : Image.asset(
                                  'assets/icons/map-search-b.png',
                                  height: 50.h,
                                ),
                          // SvgPicture.asset('assets/icons/map-search -01.svg',
                          //     height: 50.h),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text('map_search'.tr),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      var advancedsearchController = Get.put(SearchViewModel());

                      Get.to(FilterView());
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Get.locale?.languageCode == 'ar'
                            ? Border(
                                left: BorderSide(
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : AppColor.GreyIcons,
                                  width: 1.0,
                                ),
                                bottom: BorderSide(
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : AppColor.GreyIcons,
                                  width: 1.0,
                                ),
                              )
                            : Border(
                                right: BorderSide(
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : AppColor.GreyIcons,
                                  width: 1.0,
                                ),
                                bottom: BorderSide(
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : AppColor.GreyIcons,
                                  width: 1.0,
                                ),
                              ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Get.isDarkMode
                              ? Image.asset(
                                  'assets/icons/advanced-search-w.png',
                                  height: 50.h,
                                )
                              : Image.asset(
                                  'assets/icons/advanced-search-b.png',
                                  height: 50.h,
                                ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text('advanced_search'.tr),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.find<ControlViewModel>()
                          .changeSelectedValue2(selectedValue: 0);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Get.isDarkMode
                                ? Colors.white
                                : AppColor.GreyIcons,
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Get.isDarkMode
                              ? Image.asset(
                                  'assets/icons/qr-w.png',
                                  height: 50.h,
                                )
                              : Image.asset(
                                  'assets/icons/qr-b.png',
                                  height: 50.h,
                                ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text('qr_search'.tr),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      var savedController = Get.put(SavedSearchViewModel());
                      Get.to(() => SavedSearchView());
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Get.locale?.languageCode == 'ar'
                            ? Border(
                                left: BorderSide(
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : AppColor.GreyIcons,
                                  width: 1.0,
                                ),
                                bottom: BorderSide(
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : AppColor.GreyIcons,
                                  width: 1.0,
                                ),
                              )
                            : Border(
                                right: BorderSide(
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : AppColor.GreyIcons,
                                  width: 1.0,
                                ),
                                bottom: BorderSide(
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : AppColor.GreyIcons,
                                  width: 1.0,
                                ),
                              ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Get.isDarkMode
                              ? Image.asset(
                                  'assets/icons/search-log-w.png',
                                  height: 50.h,
                                )
                              : Image.asset(
                                  'assets/icons/search-log-b.png',
                                  height: 50.h,
                                ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5.0,
                            ),
                            child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'saved_search'.tr,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      var favoriteController = Get.put(FavoriteViewModel());
                      Get.to(FavoriteView());
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Get.locale?.languageCode == 'ar'
                            ? Border(
                                left: BorderSide(
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : AppColor.GreyIcons,
                                  width: 1.0,
                                ),
                                bottom: BorderSide(
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : AppColor.GreyIcons,
                                  width: 1.0,
                                ),
                              )
                            : Border(
                                right: BorderSide(
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : AppColor.GreyIcons,
                                  width: 1.0,
                                ),
                                bottom: BorderSide(
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : AppColor.GreyIcons,
                                  width: 1.0,
                                ),
                              ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Get.isDarkMode
                              ? Image.asset(
                                  'assets/icons/star-w.png',
                                  height: 50.h,
                                )
                              : Image.asset(
                                  'assets/icons/star-b.png',
                                  height: 50.h,
                                ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text('favorites'.tr),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.find<ControlViewModel>()
                          .changeSelectedValue2(selectedValue: 3);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Get.isDarkMode
                                ? Colors.white
                                : AppColor.GreyIcons,
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Get.isDarkMode
                              ? Image.asset(
                                  'assets/icons/service-w.png',
                                  height: 50.h,
                                )
                              : Image.asset(
                                  'assets/icons/service-b.png',
                                  height: 50.h,
                                ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text('services'.tr),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      var propertyController = Get.put(PropertyController());
                      Get.to(() => AddProperty());
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Get.locale?.languageCode == 'ar'
                            ? Border(
                                left: BorderSide(
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : AppColor.GreyIcons,
                                  width: 1.0,
                                ),
                              )
                            : Border(
                                right: BorderSide(
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : AppColor.GreyIcons,
                                  width: 1.0,
                                ),
                              ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Get.isDarkMode
                              ? Image.asset(
                                  'assets/icons/add_home-w.png',
                                  height: 50.h,
                                )
                              : Image.asset(
                                  'assets/icons/add_home-b.png',
                                  height: 50.h,
                                ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text('add_property'.tr),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Get.locale?.languageCode == 'ar'
                            ? Border(
                                left: BorderSide(
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : AppColor.GreyIcons,
                                  width: 1.0,
                                ),
                              )
                            : Border(
                                right: BorderSide(
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : AppColor.GreyIcons,
                                  width: 1.0,
                                ),
                              ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Get.isDarkMode
                                  ? Image.asset(
                                      'assets/icons/hotel-white.png',
                                      height: 50.h,
                                    )
                                  : Image.asset(
                                      'assets/icons/hotel-black.png',
                                      height: 50.h,
                                    ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Text('hotel'.tr),
                            ],
                          ),
                          Positioned(
                            top: 10.h,
                            left: 10.w,
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              height: 30.h,
                              width: 40.w,
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Center(
                                child: Text(
                                  "قريباً",
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20))),
                          builder: ((context) => Center(
                                child: Column(
                                  children: [
                                    Text(
                                      "شارك هذا التطبيق مع الأخرين",
                                      style: TextStyle(fontSize: 19),
                                    ),
                                    SizedBox(
                                      height: 12.h,
                                    ),
                                    Text("التطبيق متوفر على"),
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    Image.asset(
                                      'assets/icons/google-play-store.png',
                                      height: 10.h,
                                    ),
                                    SizedBox(
                                      height: 7.h,
                                    ),
                                    Image.asset(
                                      'assets/icons/google-play-store.png',
                                      height: 10.h,
                                    ),
                                  ],
                                ),
                              )));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Get.isDarkMode
                              ? Image.asset(
                                  'assets/icons/share-w.png',
                                  height: 50.h,
                                )
                              : Image.asset(
                                  'assets/icons/share-b.png',
                                  height: 50.h,
                                ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text("share".tr),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // SizedBox(
              //   height: 20.h,
              // ),
              // ElevatedButton(
              //   style: ButtonStyle(
              //     minimumSize:
              //         MaterialStateProperty.all<Size>(Size(200.w, 0)),
              //     backgroundColor:
              //         MaterialStateProperty.resolveWith<Color>((states) {
              //       if (states.contains(MaterialState.disabled)) {
              //         return AppColor.BlueBtn;
              //       }
              //       return AppColor.BlueBtn;
              //     }),
              //     shape: MaterialStateProperty.all<OutlinedBorder>(
              //         RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(5),
              //     )),
              //     padding: MaterialStateProperty.all<EdgeInsets>(
              //         EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w)),
              //     elevation: MaterialStateProperty.all<double>(0.5),
              //   ),
              //   onPressed: () {},
              //   child: Padding(
              //     padding: EdgeInsets.symmetric(vertical: 5.h),
              //     child: Text(
              //       'instaView'.tr,
              //       style: TextStyle(fontSize: 15.sp, color: Colors.white),
              //     ),
              //   ),
              // ),
              // Text(
              //   'instaViewText'.tr,
              //   textAlign: TextAlign.center,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
