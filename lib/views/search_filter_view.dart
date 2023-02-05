import 'package:catalog/controllers/search_viewmodel.dart';
import 'package:catalog/utils/app_color.dart';
import 'package:catalog/views/search_filter_view2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:shimmer/shimmer.dart';

class SearchFilterView extends StatelessWidget {
  var directions = ['شرقي', 'غربي', 'شمالي', 'جنوبي'];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        //trigger leaving and use own data
        Get.find<SearchViewModel>().filterProperty();
        Navigator.pop(context, true);

        //we need to return a future
        return Future.value(true);
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: GetBuilder<SearchViewModel>(
              builder: (searchController) => searchController.loading.value
                  ? Shimmer.fromColors(
                      baseColor: (Colors.grey[300])!,
                      highlightColor: (Colors.grey[100])!,
                      enabled: true,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 50.h,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            height: 50.h,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            height: 50.h,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            height: 50.h,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            height: 50.h,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            height: 50.h,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            height: 50.h,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            height: 50.h,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Center(
                            child: Container(
                              height: 30.h,
                              width:
                                  (MediaQuery.of(context).size.width / 2) - 10,
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Center(
                                child: Text("مزيد من الخيارات".tr,
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30.h,
                          ),
                          Container(
                            height: 35.h,
                            width: (MediaQuery.of(context).size.width / 2) - 10,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Center(
                              child: Text("search".tr,
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
                          )
                        ],
                      ),
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Visibility(
                          visible: true,
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: InkWell(
                              onTap: () {
                                final FixedExtentScrollController _controller =
                                    FixedExtentScrollController(
                                        initialItem:
                                            searchController.regionindex);
                                Get.defaultDialog(
                                    barrierDismissible: false,
                                    title: "المحافظة".tr,
                                    content: GetBuilder<SearchViewModel>(
                                      builder: (controller) => Container(
                                        height: Get.height * .30,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Column(
                                          children: [
                                            Flexible(
                                              fit: FlexFit.loose,
                                              child: Stack(
                                                children: [
                                                  ListWheelScrollView
                                                      .useDelegate(
                                                    controller: _controller,
                                                    itemExtent: 50,
                                                    physics:
                                                        const FixedExtentScrollPhysics(),
                                                    onSelectedItemChanged:
                                                        (value) {
                                                      controller
                                                          .updateRegionIdex(
                                                              value);

                                                      // print(controller
                                                      //     .categories[value].category!);
                                                    },
                                                    childDelegate:
                                                        ListWheelChildBuilderDelegate(
                                                      childCount: controller
                                                          .regions.length,
                                                      builder:
                                                          (context, index) {
                                                        return Center(
                                                          child: Text(
                                                            controller
                                                                .regions[index]
                                                                .region!,
                                                            style: TextStyle(
                                                                color: index ==
                                                                        controller
                                                                            .regionindex
                                                                    ? Colors
                                                                        .blue
                                                                    : Colors
                                                                        .black),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  IgnorePointer(
                                                    child: Center(
                                                      child: Container(
                                                        height: 50.h,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: const Color
                                                                            .fromRGBO(
                                                                        255,
                                                                        255,
                                                                        255,
                                                                        1)
                                                                    .withOpacity(
                                                                        0),
                                                                border: Border
                                                                    .symmetric(
                                                                        horizontal:
                                                                            BorderSide(
                                                                  color: AppColor
                                                                      .GreyIcons,
                                                                  width: 1.0,
                                                                ))),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            const Divider(),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              // ignore: prefer_const_literals_to_create_immutables
                                              children: [
                                                InkWell(
                                                    onTap: () {
                                                      controller.updateRegion(
                                                          controller
                                                              .regionindex);
                                                      Get.back();
                                                    },
                                                    child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          horizontal: 25.w,
                                                          vertical: 15.h,
                                                        ),
                                                        child: Text("موافق"))),
                                                InkWell(
                                                  onTap: () {
                                                    Get.back();
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 25.w,
                                                      vertical: 15.h,
                                                    ),
                                                    child: Text("إلغاء"),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ));
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 60.h,
                                    alignment: Get.locale?.languageCode == 'ar'
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 8.h, horizontal: 12.h),
                                      child: Text(
                                        "المحافظة".tr,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8.h, horizontal: 12.h),
                                    child: GetBuilder<SearchViewModel>(
                                        builder: (typecontroller) {
                                      return typecontroller.regionloading.value
                                          ? JumpingDotsProgressIndicator(
                                              fontSize: 25.0,
                                            )
                                          : Text(
                                              typecontroller.region.region!,
                                            );
                                    }),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: true,
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: InkWell(
                              onTap: () {
                                final FixedExtentScrollController _controller =
                                    FixedExtentScrollController(
                                        initialItem:
                                            searchController.cityindex);
                                Get.defaultDialog(
                                    barrierDismissible: false,
                                    title: "المدينة".tr,
                                    content: GetBuilder<SearchViewModel>(
                                      builder: (controller) => Container(
                                        height: Get.height * .30,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Column(
                                          children: [
                                            Flexible(
                                              fit: FlexFit.loose,
                                              child: Stack(
                                                children: [
                                                  ListWheelScrollView
                                                      .useDelegate(
                                                    controller: _controller,
                                                    itemExtent: 50,
                                                    physics:
                                                        const FixedExtentScrollPhysics(),
                                                    onSelectedItemChanged:
                                                        (value) {
                                                      controller.updateCityIdex(
                                                          value);
                                                      // print(controller
                                                      //     .categories[value].category!);
                                                    },
                                                    childDelegate:
                                                        ListWheelChildBuilderDelegate(
                                                      childCount: controller
                                                          .cities.length,
                                                      builder:
                                                          (context, index) {
                                                        return Center(
                                                          child: Text(
                                                            controller
                                                                .cities[index]
                                                                .city!,
                                                            style: TextStyle(
                                                                color: index ==
                                                                        controller
                                                                            .cityindex
                                                                    ? Colors
                                                                        .blue
                                                                    : Colors
                                                                        .black),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  IgnorePointer(
                                                    child: Center(
                                                      child: Container(
                                                        height: 50.h,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: const Color
                                                                            .fromRGBO(
                                                                        255,
                                                                        255,
                                                                        255,
                                                                        1)
                                                                    .withOpacity(
                                                                        0),
                                                                border: Border
                                                                    .symmetric(
                                                                        horizontal:
                                                                            BorderSide(
                                                                  color: AppColor
                                                                      .GreyIcons,
                                                                  width: 1.0,
                                                                ))),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            const Divider(),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              // ignore: prefer_const_literals_to_create_immutables
                                              children: [
                                                InkWell(
                                                    onTap: () {
                                                      controller.updateCity(
                                                          controller.cityindex);
                                                      Get.back();
                                                    },
                                                    child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          horizontal: 25.w,
                                                          vertical: 15.h,
                                                        ),
                                                        child: Text("موافق"))),
                                                InkWell(
                                                  onTap: () {
                                                    Get.back();
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 25.w,
                                                      vertical: 15.h,
                                                    ),
                                                    child: Text("إلغاء"),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ));
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 60.h,
                                    alignment: Get.locale?.languageCode == 'ar'
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 8.h, horizontal: 12.h),
                                      child: Text(
                                        "المدينة".tr,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8.h, horizontal: 12.h),
                                    child: GetBuilder<SearchViewModel>(
                                        builder: (typecontroller) {
                                      return typecontroller.cityloading.value
                                          ? JumpingDotsProgressIndicator(
                                              fontSize: 25.0,
                                            )
                                          : Text(
                                              typecontroller.city.city!,
                                            );
                                    }),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: searchController.isTypeVisible,
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: InkWell(
                              onTap: () {
                                final FixedExtentScrollController _controller =
                                    FixedExtentScrollController(
                                        initialItem:
                                            searchController.typeindex);
                                Get.defaultDialog(
                                    barrierDismissible: false,
                                    title: "property_type".tr,
                                    content: GetBuilder<SearchViewModel>(
                                      builder: (controller) => Container(
                                        height: Get.height * .30,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Flexible(
                                              fit: FlexFit.loose,
                                              child: Stack(
                                                children: [
                                                  ListWheelScrollView
                                                      .useDelegate(
                                                    controller: _controller,
                                                    itemExtent: 50,
                                                    physics:
                                                        const FixedExtentScrollPhysics(),
                                                    onSelectedItemChanged:
                                                        (value) {
                                                      controller.updateTypeIdex(
                                                          value);
                                                      // print(controller
                                                      //     .categories[value].category!);
                                                    },
                                                    childDelegate:
                                                        ListWheelChildBuilderDelegate(
                                                      childCount: controller
                                                          .types.length,
                                                      builder:
                                                          (context, index) {
                                                        return Center(
                                                          child: Text(
                                                            controller
                                                                .types[index]
                                                                .type!,
                                                            style: TextStyle(
                                                                color: index ==
                                                                        controller
                                                                            .typeindex
                                                                    ? Colors
                                                                        .blue
                                                                    : Colors
                                                                        .black),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  IgnorePointer(
                                                    child: Center(
                                                      child: Container(
                                                        height: 50.h,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: const Color
                                                                            .fromRGBO(
                                                                        255,
                                                                        255,
                                                                        255,
                                                                        1)
                                                                    .withOpacity(
                                                                        0),
                                                                border: Border
                                                                    .symmetric(
                                                                        horizontal:
                                                                            BorderSide(
                                                                  color: AppColor
                                                                      .GreyIcons,
                                                                  width: 1.0,
                                                                ))),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            const Divider(),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              // ignore: prefer_const_literals_to_create_immutables
                                              children: [
                                                InkWell(
                                                    onTap: () {
                                                      controller.updateType(
                                                          controller.typeindex);
                                                      Get.back();
                                                    },
                                                    child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          horizontal: 25.w,
                                                          vertical: 15.h,
                                                        ),
                                                        child: Text("موافق"))),
                                                InkWell(
                                                  onTap: () {
                                                    Get.back();
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 25.w,
                                                      vertical: 15.h,
                                                    ),
                                                    child: Text("إلغاء"),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ));
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 60.h,
                                    alignment: Get.locale?.languageCode == 'ar'
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 8.h, horizontal: 12.h),
                                      child: Text(
                                        "property_type".tr,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8.h, horizontal: 12.h),
                                    child: GetBuilder<SearchViewModel>(
                                        builder: (typecontroller) {
                                      return typecontroller.typeloading.value
                                          ? JumpingDotsProgressIndicator(
                                              fontSize: 25.0,
                                            )
                                          : Text(
                                              typecontroller.typeValue.type!,
                                            );
                                    }),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: searchController.isNatureVisible,
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                InkWell(
                                  onTap: () {
                                    final FixedExtentScrollController
                                        _controller =
                                        FixedExtentScrollController(
                                            initialItem:
                                                searchController.natureindex);
                                    Get.defaultDialog(
                                        barrierDismissible: false,
                                        title: "property_nature".tr,
                                        content: GetBuilder<SearchViewModel>(
                                          builder: (controller) => Container(
                                              height: Get.height * .3,
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Flexible(
                                                    fit: FlexFit.loose,
                                                    child: Stack(
                                                      children: [
                                                        ListWheelScrollView
                                                            .useDelegate(
                                                          controller:
                                                              _controller,
                                                          itemExtent: 50,
                                                          physics:
                                                              const FixedExtentScrollPhysics(),
                                                          onSelectedItemChanged:
                                                              (value) {
                                                            controller
                                                                .updateNatureIdex(
                                                                    value);
                                                          },
                                                          childDelegate:
                                                              ListWheelChildBuilderDelegate(
                                                            childCount:
                                                                controller
                                                                    .natures
                                                                    .length,
                                                            builder: (context,
                                                                index) {
                                                              return Center(
                                                                child: Text(
                                                                  controller
                                                                      .natures[
                                                                          index]
                                                                      .nature!,
                                                                  style: TextStyle(
                                                                      color: index ==
                                                                              controller
                                                                                  .natureindex
                                                                          ? Colors
                                                                              .blue
                                                                          : Colors
                                                                              .black),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                        Center(
                                                          child: Container(
                                                            height: 50.h,
                                                            decoration:
                                                                BoxDecoration(
                                                                    color: Colors
                                                                        .white
                                                                        .withOpacity(
                                                                            0),
                                                                    border: Border
                                                                        .symmetric(
                                                                            horizontal:
                                                                                BorderSide(
                                                                      color: AppColor
                                                                          .GreyIcons,
                                                                      width:
                                                                          1.0,
                                                                    ))),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  const Divider(),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    // ignore: prefer_const_literals_to_create_immutables
                                                    children: [
                                                      InkWell(
                                                          onTap: () {
                                                            controller.updateNature(
                                                                controller
                                                                    .natureindex);

                                                            Get.back();
                                                          },
                                                          child: Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                horizontal:
                                                                    25.w,
                                                                vertical: 15.h,
                                                              ),
                                                              child: Text(
                                                                  "موافق"))),
                                                      InkWell(
                                                        onTap: () {
                                                          Get.back();
                                                        },
                                                        child: Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                            horizontal: 25.w,
                                                            vertical: 15.h,
                                                          ),
                                                          child: Text("إلغاء"),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              )),
                                        ));
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        height: 60.h,
                                        alignment:
                                            Get.locale?.languageCode == 'ar'
                                                ? Alignment.centerRight
                                                : Alignment.centerLeft,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 8.h, horizontal: 12.h),
                                          child: Text(
                                            "property_nature".tr,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8.h, horizontal: 12.h),
                                        child: GetBuilder<SearchViewModel>(
                                            builder: (naturecontroller) {
                                          return naturecontroller
                                                  .natureloading.value
                                              ? JumpingDotsProgressIndicator(
                                                  fontSize: 25.0,
                                                )
                                              : Text(
                                                  naturecontroller
                                                      .nature.nature!,
                                                );
                                        }),
                                      )
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: searchController.nature.id == 6,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 50),
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            labelText: "نسق الشاليه".tr,
                                            hintText: "نسق الشاليه".tr,
                                          ),
                                          onSaved: (value) {
                                            searchController
                                                .chalet_layout_number = value!;
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15.h,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: searchController.isCategoryVisible,
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    final FixedExtentScrollController
                                        _controller =
                                        FixedExtentScrollController(
                                            initialItem:
                                                searchController.categoryindex);
                                    Get.defaultDialog(
                                      barrierDismissible: false,
                                      title: "sale/rental".tr,
                                      content: GetBuilder<SearchViewModel>(
                                        builder: (controller) => Container(
                                          height: Get.height * .3,
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Flexible(
                                                fit: FlexFit.loose,
                                                child: Stack(
                                                  children: [
                                                    ListWheelScrollView
                                                        .useDelegate(
                                                      controller: _controller,
                                                      itemExtent: 50,
                                                      physics:
                                                          const FixedExtentScrollPhysics(),
                                                      onSelectedItemChanged:
                                                          (value) {
                                                        controller
                                                            .updateCategoryIdex(
                                                                value);
                                                      },
                                                      childDelegate:
                                                          ListWheelChildBuilderDelegate(
                                                        childCount: controller
                                                            .categories.length,
                                                        builder:
                                                            (context, index) {
                                                          return Center(
                                                            child: Text(
                                                              controller
                                                                  .categories[
                                                                      index]
                                                                  .category!,
                                                              style: TextStyle(
                                                                  color: index ==
                                                                          controller
                                                                              .categoryindex
                                                                      ? Colors
                                                                          .blue
                                                                      : Colors
                                                                          .black),
                                                            ),
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                    Center(
                                                      child: Container(
                                                        height: 50.h,
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .white
                                                                    .withOpacity(
                                                                        0),
                                                                border: Border
                                                                    .symmetric(
                                                                        horizontal:
                                                                            BorderSide(
                                                                  color: AppColor
                                                                      .GreyIcons,
                                                                  width: 1.0,
                                                                ))),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              const Divider(),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                // ignore: prefer_const_literals_to_create_immutables
                                                children: [
                                                  InkWell(
                                                      onTap: () {
                                                        controller.updateCategory(
                                                            controller
                                                                .categoryindex);

                                                        Get.back();
                                                      },
                                                      child: Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                            horizontal: 25.w,
                                                            vertical: 15.h,
                                                          ),
                                                          child:
                                                              Text("موافق"))),
                                                  InkWell(
                                                    onTap: () {
                                                      Get.back();
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        horizontal: 25.w,
                                                        vertical: 15.h,
                                                      ),
                                                      child: Text("إلغاء"),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        height: 60.h,
                                        alignment:
                                            Get.locale?.languageCode == 'ar'
                                                ? Alignment.centerRight
                                                : Alignment.centerLeft,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 8.h, horizontal: 12.h),
                                          child: Text(
                                            "sale/rental".tr,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8.h, horizontal: 12.h),
                                        child: GetBuilder<SearchViewModel>(
                                            builder: (categorycontroller) {
                                          return Text(
                                            categorycontroller
                                                .category.category!,
                                          );
                                        }),
                                      )
                                    ],
                                  ),
                                ),
                                Visibility(
                                  visible: searchController.category.id == 2,
                                  child: SizedBox(
                                    height: 8.h,
                                  ),
                                ),
                                Visibility(
                                  visible: searchController.category.id == 2,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 12.h),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "تحديد نوع الأجار".tr,
                                          style: const TextStyle(
                                            fontSize: 15,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: Get.width * .4,
                                              child: RadioListTile(
                                                title: const Text(
                                                  "يومي",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                value: "1",
                                                groupValue:
                                                    searchController.period,
                                                onChanged: (value) {
                                                  searchController.updatePeriod(
                                                      value.toString());
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                              width: Get.width * .4,
                                              child: RadioListTile(
                                                title: const Text(
                                                  "شهري",
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                  ),
                                                ),
                                                value: "2",
                                                groupValue:
                                                    searchController.period,
                                                onChanged: (value) {
                                                  searchController.updatePeriod(
                                                      value.toString());
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        // Text("مدة الأجار".tr),
                                        // Padding(
                                        //   padding: const EdgeInsets.symmetric(
                                        //       horizontal: 50),
                                        //   child: TextFormField(
                                        //     keyboardType: TextInputType.number,
                                        //     // decoration:
                                        //     //     InputDecoration(suffixText: "sp".tr),
                                        //     onSaved: (period) {
                                        //       controller.period = period;
                                        //     },
                                        //     validator: (text) {
                                        //       if ((text == null || text.isEmpty) &&
                                        //           controller
                                        //                   .isRentOptionsVisibile ==
                                        //               true) {
                                        //         return 'emptytextfieldvalidation'
                                        //             .tr;
                                        //       }
                                        //       return null;
                                        //     },
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: searchController.isPriceVisible,
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: InkWell(
                              onTap: () {
                                final FixedExtentScrollController
                                    _mincontroller =
                                    FixedExtentScrollController(
                                        initialItem:
                                            searchController.minPriceIndex);
                                final FixedExtentScrollController
                                    _maxcontroller =
                                    FixedExtentScrollController(
                                        initialItem:
                                            searchController.maxPriceIndex);
                                int minprice = searchController.minPrice;
                                int maxprice = searchController.maxPrice;
                                int minIndex = searchController.minPriceIndex;
                                int maxIndex = searchController.maxPriceIndex;
                                Get.defaultDialog(
                                  barrierDismissible: false,
                                  title: "price".tr,
                                  content: GetBuilder<SearchViewModel>(
                                    builder: (controller) => Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          // ignore: prefer_const_literals_to_create_immutables
                                          children: [
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            const Center(child: Text("من")),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            const Center(child: Text("إلى")),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Flexible(
                                              fit: FlexFit.loose,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    height: Get.height * .3,
                                                    width: Get.width * .3,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Stack(
                                                      children: [
                                                        ListWheelScrollView
                                                            .useDelegate(
                                                          itemExtent: 50,
                                                          controller:
                                                              _mincontroller,
                                                          physics:
                                                              const FixedExtentScrollPhysics(),
                                                          onSelectedItemChanged:
                                                              (value) {
                                                            minIndex = value;

                                                            minprice = value ==
                                                                    (controller
                                                                            .salePriceRange
                                                                            .length -
                                                                        1)
                                                                ? 2000000000
                                                                : int.parse(controller
                                                                    .salePriceRange[
                                                                        value]
                                                                    .replaceAll(
                                                                        "m",
                                                                        "000000"));
                                                            if (minprice ==
                                                                2000000000) {
                                                              _mincontroller.animateToItem(
                                                                  (controller
                                                                          .salePriceRange
                                                                          .length -
                                                                      2),
                                                                  duration: const Duration(
                                                                      milliseconds:
                                                                          500),
                                                                  curve: Curves
                                                                      .linear);
                                                              minIndex =
                                                                  value - 1;
                                                            }

                                                            if (minprice >=
                                                                maxprice) {
                                                              maxprice = int.parse(controller
                                                                  .salePriceRange[
                                                                      (controller.salePriceRange.length -
                                                                              1) -
                                                                          (value +
                                                                              1)]
                                                                  .replaceAll(
                                                                      "m",
                                                                      "000000"));
                                                              _maxcontroller.animateToItem(
                                                                  (controller.salePriceRange
                                                                              .length -
                                                                          1) -
                                                                      (value +
                                                                          1),
                                                                  duration: const Duration(
                                                                      milliseconds:
                                                                          500),
                                                                  curve: Curves
                                                                      .linear);
                                                            }
                                                            print(minIndex);
                                                            print(controller
                                                                    .salePriceRange[
                                                                minIndex]);

                                                            // controller
                                                            //     .updateMinPrice(
                                                            //         value);
                                                          },
                                                          childDelegate:
                                                              ListWheelChildBuilderDelegate(
                                                            childCount: controller
                                                                .salePriceRange
                                                                .length,
                                                            builder: (context,
                                                                index) {
                                                              return Container(
                                                                child: Center(
                                                                  child: Text(
                                                                      controller
                                                                              .salePriceRange[
                                                                          index]),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                        Center(
                                                          child: Container(
                                                            height: 50.h,
                                                            decoration:
                                                                BoxDecoration(
                                                                    color: Colors
                                                                        .white
                                                                        .withOpacity(
                                                                            0),
                                                                    border: Border
                                                                        .symmetric(
                                                                            horizontal:
                                                                                BorderSide(
                                                                      color: AppColor
                                                                          .GreyIcons,
                                                                      width:
                                                                          1.0,
                                                                    ))),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    height: Get.height * .3,
                                                    width: Get.width * .3,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Stack(
                                                      children: [
                                                        ListWheelScrollView
                                                            .useDelegate(
                                                          itemExtent: 50,
                                                          physics:
                                                              const FixedExtentScrollPhysics(),
                                                          controller:
                                                              _maxcontroller,
                                                          onSelectedItemChanged:
                                                              (value) {
                                                            maxIndex = value;
                                                            maxprice = value ==
                                                                    0
                                                                ? 2000000000
                                                                : int.parse(controller
                                                                    .salePriceRange[
                                                                        (controller.salePriceRange.length -
                                                                                1) -
                                                                            value]
                                                                    .replaceAll(
                                                                        "m",
                                                                        "000000"));
                                                            if (maxprice == 0) {
                                                              _maxcontroller.animateToItem(
                                                                  (controller
                                                                          .salePriceRange
                                                                          .length -
                                                                      2),
                                                                  duration: const Duration(
                                                                      milliseconds:
                                                                          500),
                                                                  curve: Curves
                                                                      .linear);
                                                              maxIndex =
                                                                  value - 1;
                                                            }

                                                            if (maxprice <=
                                                                minprice) {
                                                              minprice = int.parse(controller
                                                                  .salePriceRange[
                                                                      (controller.salePriceRange.length -
                                                                              1) -
                                                                          (value +
                                                                              1)]
                                                                  .replaceAll(
                                                                      "m",
                                                                      "000000"));
                                                              _mincontroller.animateToItem(
                                                                  (controller.salePriceRange
                                                                              .length -
                                                                          1) -
                                                                      (value +
                                                                          1),
                                                                  duration: const Duration(
                                                                      milliseconds:
                                                                          500),
                                                                  curve: Curves
                                                                      .linear);
                                                            }
                                                            print(maxIndex);
                                                            print(controller
                                                                .salePriceRange[(controller
                                                                        .salePriceRange
                                                                        .length -
                                                                    1) -
                                                                maxIndex]);
                                                          },
                                                          childDelegate:
                                                              ListWheelChildBuilderDelegate(
                                                            childCount: controller
                                                                .salePriceRange
                                                                .length,
                                                            builder: (context,
                                                                index) {
                                                              return Container(
                                                                child: Center(
                                                                  child: Text(controller
                                                                      .salePriceRange[(controller
                                                                              .salePriceRange
                                                                              .length -
                                                                          1) -
                                                                      index]),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                        Center(
                                                          child: Container(
                                                            height: 50.h,
                                                            decoration:
                                                                BoxDecoration(
                                                                    color: Colors
                                                                        .white
                                                                        .withOpacity(
                                                                            0),
                                                                    border: Border
                                                                        .symmetric(
                                                                            horizontal:
                                                                                BorderSide(
                                                                      color: AppColor
                                                                          .GreyIcons,
                                                                      width:
                                                                          1.0,
                                                                    ))),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Divider(),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              // ignore: prefer_const_literals_to_create_immutables
                                              children: [
                                                InkWell(
                                                    onTap: () {
                                                      controller.updateMinPrice(
                                                          minIndex);
                                                      controller.updateMaxPrice(
                                                          maxIndex);

                                                      Get.back();
                                                    },
                                                    child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          horizontal: 25.w,
                                                          vertical: 15.h,
                                                        ),
                                                        child: Text("موافق"))),
                                                InkWell(
                                                    onTap: () {
                                                      Get.back();
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        horizontal: 25.w,
                                                        vertical: 15.h,
                                                      ),
                                                      child: Text("إلغاء"),
                                                    )),
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 60.h,
                                    alignment: Get.locale?.languageCode == 'ar'
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 8.h, horizontal: 12.h),
                                      child: Text(
                                        "price".tr,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8.h, horizontal: 12.h),
                                    child: GetBuilder<SearchViewModel>(
                                        builder: (pricecontroller) {
                                      return Text(
                                        pricecontroller.minPrice.toString() +
                                            " - " +
                                            pricecontroller.maxPrice.toString(),
                                      );
                                    }),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: searchController.isAreaVisible,
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: InkWell(
                              onTap: () {
                                final FixedExtentScrollController
                                    _mincontroller =
                                    FixedExtentScrollController(
                                        initialItem:
                                            searchController.minAreaIndex);
                                final FixedExtentScrollController
                                    _maxcontroller =
                                    FixedExtentScrollController(
                                        initialItem:
                                            searchController.maxAreaIndex);
                                int minarea = searchController.minArea;
                                int maxarea = searchController.maxArea;
                                int minIndex = searchController.minAreaIndex;
                                int maxIndex = searchController.maxAreaIndex;
                                Get.defaultDialog(
                                  barrierDismissible: false,
                                  title: "living_area".tr,
                                  content: GetBuilder<SearchViewModel>(
                                    builder: (controller) => Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Container(
                                                child: const Center(
                                                    child: Text("من"))),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Container(
                                                child: const Center(
                                                    child: Text("إلى"))),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                          ],
                                        ),
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Flexible(
                                              fit: FlexFit.loose,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    height: Get.height * .25,
                                                    width: Get.width * .3,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Stack(
                                                      children: [
                                                        ListWheelScrollView
                                                            .useDelegate(
                                                          itemExtent: 50,
                                                          controller:
                                                              _mincontroller,
                                                          physics:
                                                              const FixedExtentScrollPhysics(),
                                                          onSelectedItemChanged:
                                                              (value) {
                                                            // controller
                                                            //         .minAreaIndex =
                                                            //     value;

                                                            minIndex = value;

                                                            minarea = value ==
                                                                    (controller
                                                                            .houseSizeRange
                                                                            .length -
                                                                        1)
                                                                ? 10000
                                                                : int.parse(controller
                                                                    .houseSizeRange[
                                                                        value]
                                                                    .replaceAll(
                                                                        "m",
                                                                        ""));
                                                            if (minarea ==
                                                                10000) {
                                                              _mincontroller.animateToItem(
                                                                  (controller
                                                                          .houseSizeRange
                                                                          .length -
                                                                      2),
                                                                  duration: const Duration(
                                                                      milliseconds:
                                                                          500),
                                                                  curve: Curves
                                                                      .linear);
                                                              minIndex =
                                                                  value - 1;
                                                            }

                                                            if (minarea >=
                                                                maxarea) {
                                                              maxarea = int.parse(controller
                                                                  .houseSizeRange[
                                                                      (controller.houseSizeRange.length -
                                                                              1) -
                                                                          (value +
                                                                              1)]
                                                                  .replaceAll(
                                                                      "m", ""));
                                                              _maxcontroller.animateToItem(
                                                                  (controller.houseSizeRange
                                                                              .length -
                                                                          1) -
                                                                      (value +
                                                                          1),
                                                                  duration: const Duration(
                                                                      milliseconds:
                                                                          500),
                                                                  curve: Curves
                                                                      .linear);
                                                            }
                                                          },
                                                          childDelegate:
                                                              ListWheelChildBuilderDelegate(
                                                            childCount: controller
                                                                .houseSizeRange
                                                                .length,
                                                            builder: (context,
                                                                index) {
                                                              return Container(
                                                                child: Center(
                                                                  child: Text(
                                                                      controller
                                                                              .houseSizeRange[
                                                                          index]),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                        Center(
                                                          child: Container(
                                                            height: 50.h,
                                                            decoration:
                                                                BoxDecoration(
                                                                    color: Colors
                                                                        .white
                                                                        .withOpacity(
                                                                            0),
                                                                    border: Border
                                                                        .symmetric(
                                                                            horizontal:
                                                                                BorderSide(
                                                                      color: AppColor
                                                                          .GreyIcons,
                                                                      width:
                                                                          1.0,
                                                                    ))),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Container(
                                                    height: Get.height * .3,
                                                    width: Get.width * .3,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Stack(
                                                      children: [
                                                        ListWheelScrollView
                                                            .useDelegate(
                                                          itemExtent: 50,
                                                          physics:
                                                              const FixedExtentScrollPhysics(),
                                                          controller:
                                                              _maxcontroller,
                                                          onSelectedItemChanged:
                                                              (value) {
                                                            maxIndex = value;
                                                            maxarea = value == 0
                                                                ? 10000
                                                                : int.parse(controller
                                                                    .houseSizeRange[
                                                                        (controller.houseSizeRange.length -
                                                                                1) -
                                                                            value]
                                                                    .replaceAll(
                                                                        "m",
                                                                        ""));
                                                            if (maxarea == 0) {
                                                              _maxcontroller.animateToItem(
                                                                  (controller
                                                                          .houseSizeRange
                                                                          .length -
                                                                      2),
                                                                  duration: const Duration(
                                                                      milliseconds:
                                                                          500),
                                                                  curve: Curves
                                                                      .linear);
                                                              maxIndex =
                                                                  value - 1;
                                                            }

                                                            if (maxarea <=
                                                                minarea) {
                                                              minarea = int.parse(controller
                                                                  .houseSizeRange[
                                                                      (controller.houseSizeRange.length -
                                                                              1) -
                                                                          (value +
                                                                              1)]
                                                                  .replaceAll(
                                                                      "m", ""));
                                                              _mincontroller.animateToItem(
                                                                  (controller.houseSizeRange
                                                                              .length -
                                                                          1) -
                                                                      (value +
                                                                          1),
                                                                  duration: const Duration(
                                                                      milliseconds:
                                                                          500),
                                                                  curve: Curves
                                                                      .linear);
                                                            }
                                                          },
                                                          childDelegate:
                                                              ListWheelChildBuilderDelegate(
                                                            childCount: controller
                                                                .houseSizeRange
                                                                .length,
                                                            builder: (context,
                                                                index) {
                                                              return Container(
                                                                child: Center(
                                                                  child: Text(controller
                                                                      .houseSizeRange[(controller
                                                                              .houseSizeRange
                                                                              .length -
                                                                          1) -
                                                                      index]),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                        Center(
                                                          child: Container(
                                                            height: 50.h,
                                                            decoration:
                                                                BoxDecoration(
                                                                    color: Colors
                                                                        .white
                                                                        .withOpacity(
                                                                            0),
                                                                    border: Border
                                                                        .symmetric(
                                                                            horizontal:
                                                                                BorderSide(
                                                                      color: AppColor
                                                                          .GreyIcons,
                                                                      width:
                                                                          1.0,
                                                                    ))),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Divider(),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              // ignore: prefer_const_literals_to_create_immutables
                                              children: [
                                                InkWell(
                                                    onTap: () {
                                                      controller.updateMinArea(
                                                          controller
                                                              .minAreaIndex);
                                                      controller.updateMaxArea(
                                                          controller
                                                              .maxAreaIndex);

                                                      Get.back();
                                                    },
                                                    child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          horizontal: 25.w,
                                                          vertical: 15.h,
                                                        ),
                                                        child: Text("موافق"))),
                                                InkWell(
                                                    onTap: () {
                                                      Get.back();
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        horizontal: 25.w,
                                                        vertical: 15.h,
                                                      ),
                                                      child: Text("إلغاء"),
                                                    )),
                                              ],
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 60.h,
                                    alignment: Get.locale?.languageCode == 'ar'
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 8.h, horizontal: 12.h),
                                      child: Text(
                                        "living_area".tr,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8.h, horizontal: 12.h),
                                    child: GetBuilder<SearchViewModel>(
                                        builder: (areacontroller) {
                                      return Text(
                                        areacontroller.minArea.toString() +
                                            "م2" +
                                            " - " +
                                            areacontroller.maxArea.toString() +
                                            "م2",
                                      );
                                    }),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: searchController.isBedroomVisible,
                          child: GetBuilder<SearchViewModel>(
                              builder: (bedroomController) {
                            return Column(
                              children: [
                                const Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5.0, horizontal: 15.0),
                                      child: Text("عدد غرف النوم"),
                                    )),
                                Container(
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            bedroomController.updateRoomNum(0);
                                          },
                                          child: Container(
                                            height: 35.h,
                                            width: 55.w,
                                            padding: EdgeInsets.all(4.h),
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                top: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                bottom: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                right: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                left: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                              ),
                                              borderRadius: BorderRadius.only(
                                                bottomRight: Radius.circular(5),
                                                topRight: Radius.circular(5),
                                              ),
                                            ),
                                            child: const Center(
                                                child: Icon(Icons.hotel)),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            bedroomController.updateRoomNum(1);
                                          },
                                          child: Container(
                                            height: 35.h,
                                            width: 55.w,
                                            padding: EdgeInsets.all(4.h),
                                            decoration: BoxDecoration(
                                              color: bedroomController
                                                          .bedroomindex ==
                                                      1
                                                  ? Colors.blue
                                                  : Colors.white.withOpacity(0),
                                              border: const Border(
                                                top: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                bottom: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                right: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                left: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                              ),
                                            ),
                                            child:
                                                const Center(child: Text("1+")),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            bedroomController.updateRoomNum(2);
                                          },
                                          child: Container(
                                            height: 35.h,
                                            width: 55.w,
                                            padding: EdgeInsets.all(4.h),
                                            decoration: BoxDecoration(
                                              color: bedroomController
                                                          .bedroomindex ==
                                                      2
                                                  ? Colors.blue
                                                  : Colors.white.withOpacity(0),
                                              border: const Border(
                                                top: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                bottom: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                right: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                left: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                              ),
                                            ),
                                            child:
                                                const Center(child: Text("2+")),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            bedroomController.updateRoomNum(3);
                                          },
                                          child: Container(
                                            height: 35.h,
                                            width: 55.w,
                                            padding: EdgeInsets.all(4.h),
                                            decoration: BoxDecoration(
                                              color: bedroomController
                                                          .bedroomindex ==
                                                      3
                                                  ? Colors.blue
                                                  : Colors.white.withOpacity(0),
                                              border: const Border(
                                                top: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                bottom: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                right: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                left: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                              ),
                                            ),
                                            child:
                                                const Center(child: Text("3+")),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            bedroomController.updateRoomNum(4);
                                          },
                                          child: Container(
                                            height: 35.h,
                                            width: 55.w,
                                            padding: EdgeInsets.all(4.h),
                                            decoration: BoxDecoration(
                                              color: bedroomController
                                                          .bedroomindex ==
                                                      4
                                                  ? Colors.blue
                                                  : Colors.white.withOpacity(0),
                                              border: const Border(
                                                top: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                bottom: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                right: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                left: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                              ),
                                            ),
                                            child:
                                                const Center(child: Text("4+")),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            bedroomController.updateRoomNum(5);
                                          },
                                          child: Container(
                                            height: 35.h,
                                            width: 55.w,
                                            padding: EdgeInsets.all(4.h),
                                            decoration: BoxDecoration(
                                              color: bedroomController
                                                          .bedroomindex ==
                                                      5
                                                  ? Colors.blue
                                                  : Colors.white.withOpacity(0),
                                              border: const Border(
                                                top: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                bottom: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                right: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                left: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                              ),
                                              borderRadius:
                                                  const BorderRadius.only(
                                                bottomLeft: Radius.circular(5),
                                                topLeft: Radius.circular(5),
                                              ),
                                            ),
                                            child:
                                                const Center(child: Text("5+")),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                        Visibility(
                          visible: searchController.isBathroomVisible,
                          child: GetBuilder<SearchViewModel>(
                              builder: (bathroomController) {
                            return Column(
                              children: [
                                const Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5.0, horizontal: 15.0),
                                      child: Text("عدد الحمامات"),
                                    )),
                                Container(
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            bathroomController.updatebathNum(0);
                                          },
                                          child: Container(
                                            height: 35.h,
                                            width: 55.w,
                                            padding: EdgeInsets.all(4.h),
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                top: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                bottom: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                right: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                left: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                              ),
                                              borderRadius: BorderRadius.only(
                                                bottomRight: Radius.circular(5),
                                                topRight: Radius.circular(5),
                                              ),
                                            ),
                                            child: const Center(
                                                child: Icon(Icons.bathtub)),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            bathroomController.updatebathNum(1);
                                          },
                                          child: Container(
                                            height: 35.h,
                                            width: 55.w,
                                            padding: EdgeInsets.all(4.h),
                                            decoration: BoxDecoration(
                                              color: bathroomController
                                                          .bathroomindex ==
                                                      1
                                                  ? Colors.blue
                                                  : Colors.white.withOpacity(0),
                                              border: const Border(
                                                top: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                bottom: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                right: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                left: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                              ),
                                            ),
                                            child:
                                                const Center(child: Text("1+")),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            bathroomController.updatebathNum(2);
                                          },
                                          child: Container(
                                            height: 35.h,
                                            width: 55.w,
                                            padding: EdgeInsets.all(4.h),
                                            decoration: BoxDecoration(
                                              color: bathroomController
                                                          .bathroomindex ==
                                                      2
                                                  ? Colors.blue
                                                  : Colors.white.withOpacity(0),
                                              border: const Border(
                                                top: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                bottom: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                right: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                left: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                              ),
                                            ),
                                            child:
                                                const Center(child: Text("2+")),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            bathroomController.updatebathNum(3);
                                          },
                                          child: Container(
                                            height: 35.h,
                                            width: 55.w,
                                            padding: EdgeInsets.all(4.h),
                                            decoration: BoxDecoration(
                                              color: bathroomController
                                                          .bathroomindex ==
                                                      3
                                                  ? Colors.blue
                                                  : Colors.white.withOpacity(0),
                                              border: const Border(
                                                top: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                bottom: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                right: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                left: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                              ),
                                            ),
                                            child:
                                                const Center(child: Text("3+")),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            bathroomController.updatebathNum(4);
                                          },
                                          child: Container(
                                            height: 35.h,
                                            width: 55.w,
                                            padding: EdgeInsets.all(4.h),
                                            decoration: BoxDecoration(
                                              color: bathroomController
                                                          .bathroomindex ==
                                                      4
                                                  ? Colors.blue
                                                  : Colors.white.withOpacity(0),
                                              border: const Border(
                                                top: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                bottom: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                right: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                left: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                              ),
                                            ),
                                            child:
                                                const Center(child: Text("4+")),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            bathroomController.updatebathNum(5);
                                          },
                                          child: Container(
                                            height: 35.h,
                                            width: 55.w,
                                            padding: EdgeInsets.all(4.h),
                                            decoration: BoxDecoration(
                                              color: bathroomController
                                                          .bathroomindex ==
                                                      5
                                                  ? Colors.blue
                                                  : Colors.white.withOpacity(0),
                                              border: const Border(
                                                top: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                bottom: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                right: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                left: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                              ),
                                              borderRadius:
                                                  const BorderRadius.only(
                                                bottomLeft: Radius.circular(5),
                                                topLeft: Radius.circular(5),
                                              ),
                                            ),
                                            child:
                                                const Center(child: Text("5+")),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                        Visibility(
                          visible: searchController.isLevelVisible,
                          child: GetBuilder<SearchViewModel>(
                              builder: (levelController) {
                            return Column(
                              children: [
                                const Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5.0, horizontal: 15.0),
                                      child: Text("ارتفاع الطابق"),
                                    )),
                                Container(
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            levelController
                                                .updatelevelHeight(0);
                                          },
                                          child: Container(
                                            height: 35.h,
                                            width: 55.w,
                                            padding: EdgeInsets.all(4.h),
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                top: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                bottom: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                right: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                left: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                              ),
                                              borderRadius: BorderRadius.only(
                                                bottomRight: Radius.circular(5),
                                                topRight: Radius.circular(5),
                                              ),
                                            ),
                                            child: const Center(
                                                child: Icon(Icons.apartment)),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            levelController
                                                .updatelevelHeight(1);
                                          },
                                          child: Container(
                                            height: 35.h,
                                            width: 33.w,
                                            padding: EdgeInsets.all(4.h),
                                            decoration: BoxDecoration(
                                              color: levelController
                                                          .levelheightindex ==
                                                      1
                                                  ? Colors.blue
                                                  : Colors.white.withOpacity(0),
                                              border: const Border(
                                                top: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                bottom: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                right: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                left: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                              ),
                                            ),
                                            child:
                                                const Center(child: Text("1")),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            levelController
                                                .updatelevelHeight(2);
                                          },
                                          child: Container(
                                            height: 35.h,
                                            width: 33.w,
                                            padding: EdgeInsets.all(4.h),
                                            decoration: BoxDecoration(
                                              color: levelController
                                                          .levelheightindex ==
                                                      2
                                                  ? Colors.blue
                                                  : Colors.white.withOpacity(0),
                                              border: const Border(
                                                top: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                bottom: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                right: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                left: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                              ),
                                            ),
                                            child:
                                                const Center(child: Text("2")),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            levelController
                                                .updatelevelHeight(3);
                                          },
                                          child: Container(
                                            height: 35.h,
                                            width: 33.w,
                                            padding: EdgeInsets.all(4.h),
                                            decoration: BoxDecoration(
                                              color: levelController
                                                          .levelheightindex ==
                                                      3
                                                  ? Colors.blue
                                                  : Colors.white.withOpacity(0),
                                              border: const Border(
                                                top: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                bottom: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                right: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                left: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                              ),
                                            ),
                                            child:
                                                const Center(child: Text("3")),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            levelController
                                                .updatelevelHeight(4);
                                          },
                                          child: Container(
                                            height: 35.h,
                                            width: 33.w,
                                            padding: EdgeInsets.all(4.h),
                                            decoration: BoxDecoration(
                                              color: levelController
                                                          .levelheightindex ==
                                                      4
                                                  ? Colors.blue
                                                  : Colors.white.withOpacity(0),
                                              border: const Border(
                                                top: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                bottom: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                right: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                left: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                              ),
                                            ),
                                            child:
                                                const Center(child: Text("4")),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            levelController
                                                .updatelevelHeight(5);
                                          },
                                          child: Container(
                                            height: 35.h,
                                            width: 33.w,
                                            padding: EdgeInsets.all(4.h),
                                            decoration: BoxDecoration(
                                              color: levelController
                                                          .levelheightindex ==
                                                      5
                                                  ? Colors.blue
                                                  : Colors.white.withOpacity(0),
                                              border: const Border(
                                                top: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                bottom: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                right: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                left: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                              ),
                                            ),
                                            child:
                                                const Center(child: Text("5")),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            levelController
                                                .updatelevelHeight(6);
                                          },
                                          child: Container(
                                            height: 35.h,
                                            width: 33.w,
                                            padding: EdgeInsets.all(4.h),
                                            decoration: BoxDecoration(
                                              color: levelController
                                                          .levelheightindex ==
                                                      6
                                                  ? Colors.blue
                                                  : Colors.white.withOpacity(0),
                                              border: const Border(
                                                top: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                bottom: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                right: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                left: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                              ),
                                            ),
                                            child:
                                                const Center(child: Text("6")),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            levelController
                                                .updatelevelHeight(7);
                                          },
                                          child: Container(
                                            height: 35.h,
                                            width: 33.w,
                                            padding: EdgeInsets.all(4.h),
                                            decoration: BoxDecoration(
                                              color: levelController
                                                          .levelheightindex ==
                                                      7
                                                  ? Colors.blue
                                                  : Colors.white.withOpacity(0),
                                              border: const Border(
                                                top: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                bottom: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                right: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                left: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                              ),
                                            ),
                                            child:
                                                const Center(child: Text("7")),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            levelController
                                                .updatelevelHeight(8);
                                          },
                                          child: Container(
                                            height: 35.h,
                                            width: 33.w,
                                            padding: EdgeInsets.all(4.h),
                                            decoration: BoxDecoration(
                                              color: levelController
                                                          .levelheightindex ==
                                                      8
                                                  ? Colors.blue
                                                  : Colors.white.withOpacity(0),
                                              border: const Border(
                                                top: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                bottom: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                right: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                left: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                              ),
                                            ),
                                            child:
                                                const Center(child: Text("8")),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            levelController
                                                .updatelevelHeight(9);
                                          },
                                          child: Container(
                                            height: 35.h,
                                            width: 33.w,
                                            padding: EdgeInsets.all(4.h),
                                            decoration: BoxDecoration(
                                              color: levelController
                                                          .levelheightindex ==
                                                      9
                                                  ? Colors.blue
                                                  : Colors.white.withOpacity(0),
                                              border: const Border(
                                                top: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                bottom: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                right: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                                left: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                              ),
                                              borderRadius:
                                                  const BorderRadius.only(
                                                bottomLeft: Radius.circular(5),
                                                topLeft: Radius.circular(5),
                                              ),
                                            ),
                                            child:
                                                const Center(child: Text("9+")),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }),
                        ),
                        Visibility(
                          visible: searchController.isDirectionVisible,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(
                                height: 15,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Text(
                                    "direction".tr,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: directions.length ~/ 2,
                                itemBuilder: (_, int index) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Card(
                                        child: SizedBox(
                                          width: Get.width * .4,
                                          child: CheckboxListTile(
                                            title: Text(
                                              directions[index],
                                              style: TextStyle(fontSize: 15),
                                            ),
                                            value: searchController
                                                .selectedDirectionIndex
                                                .contains(index),
                                            onChanged: (_) {
                                              if (searchController
                                                  .selectedDirectionIndex
                                                  .contains(index)) {
                                                searchController
                                                    .removeDirection(
                                                        index); // unselect
                                              } else {
                                                searchController.addDirection(
                                                    index); // select
                                              }
                                            },
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                          ),
                                        ),
                                      ),
                                      Card(
                                        child: SizedBox(
                                          width: Get.width * .4,
                                          child: CheckboxListTile(
                                            title: Text(
                                              directions[index + 2],
                                              style: TextStyle(fontSize: 15),
                                            ),
                                            value: searchController
                                                .selectedDirectionIndex
                                                .contains(index + 2),
                                            onChanged: (_) {
                                              if (searchController
                                                  .selectedDirectionIndex
                                                  .contains(index + 2)) {
                                                searchController
                                                    .removeDirection(
                                                        index + 2); // unselect
                                              } else {
                                                searchController.addDirection(
                                                    index + 2); // select
                                              }
                                            },
                                            controlAffinity:
                                                ListTileControlAffinity.leading,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                              SizedBox(
                                height: 8.h,
                              ),
                              Obx(() {
                                return searchController
                                            .directionmultiValid.value ==
                                        true
                                    ? const SizedBox(
                                        height: 1,
                                      )
                                    : const Text(
                                        "لا يمكن اختيار هاتان الجهتان معاً.",
                                        style: TextStyle(color: Colors.red),
                                      );
                              }),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: searchController.isLotAreaVisible,
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: 60.h,
                                  alignment: Get.locale?.languageCode == 'ar'
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8.h, horizontal: 12.h),
                                    child: Text(
                                      "lot_area".tr,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                InkWell(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8.h, horizontal: 12.h),
                                    child: Text(
                                      "All".tr,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: searchController.isStatesVisible,
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: InkWell(
                              onTap: () {
                                final FixedExtentScrollController _controller =
                                    FixedExtentScrollController(
                                        initialItem:
                                            searchController.stateindex);
                                Get.defaultDialog(
                                  barrierDismissible: false,
                                  title: "property_status".tr,
                                  content: GetBuilder<SearchViewModel>(
                                    builder: (controller) => Container(
                                        height: Get.height * .3,
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Flexible(
                                              fit: FlexFit.loose,
                                              child: Stack(
                                                children: [
                                                  ListWheelScrollView
                                                      .useDelegate(
                                                    controller: _controller,
                                                    itemExtent: 50,
                                                    physics:
                                                        const FixedExtentScrollPhysics(),
                                                    onSelectedItemChanged:
                                                        (value) {
                                                      controller
                                                          .updateStateIdex(
                                                              value);
                                                    },
                                                    childDelegate:
                                                        ListWheelChildBuilderDelegate(
                                                      childCount: controller
                                                          .states.length,
                                                      builder:
                                                          (context, index) {
                                                        return Center(
                                                          child: Text(
                                                            controller
                                                                .states[index]
                                                                .states!,
                                                            style: TextStyle(
                                                                color: index ==
                                                                        controller
                                                                            .stateindex
                                                                    ? Colors
                                                                        .blue
                                                                    : Colors
                                                                        .black),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  Center(
                                                    child: Container(
                                                      height: 50.h,
                                                      decoration: BoxDecoration(
                                                          color: Colors.white
                                                              .withOpacity(0),
                                                          border:
                                                              Border.symmetric(
                                                                  horizontal:
                                                                      BorderSide(
                                                            color: AppColor
                                                                .GreyIcons,
                                                            width: 1.0,
                                                          ))),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            const Divider(),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              // ignore: prefer_const_literals_to_create_immutables
                                              children: [
                                                InkWell(
                                                    onTap: () {
                                                      controller.updateState(
                                                          controller
                                                              .stateindex);

                                                      Get.back();
                                                    },
                                                    child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          horizontal: 25.w,
                                                          vertical: 15.h,
                                                        ),
                                                        child: Text("موافق"))),
                                                InkWell(
                                                    onTap: () {
                                                      Get.back();
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        horizontal: 25.w,
                                                        vertical: 15.h,
                                                      ),
                                                      child: Text("إلغاء"),
                                                    )),
                                              ],
                                            )
                                          ],
                                        )),
                                  ),
                                );
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 60.h,
                                    alignment: Get.locale?.languageCode == 'ar'
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 8.h, horizontal: 12.h),
                                      child: Text(
                                        "property_status".tr,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8.h, horizontal: 12.h),
                                    child: GetBuilder<SearchViewModel>(
                                        builder: (statescontroller) {
                                      return statescontroller
                                              .statusloading.value
                                          ? JumpingDotsProgressIndicator(
                                              fontSize: 25.0,
                                            )
                                          : Text(
                                              statescontroller.state.states!,
                                            );
                                    }),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: searchController.isOwnershipVisible,
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: InkWell(
                              onTap: () {
                                final FixedExtentScrollController _controller =
                                    FixedExtentScrollController(
                                        initialItem:
                                            searchController.propreindex);
                                Get.defaultDialog(
                                  barrierDismissible: false,
                                  title: "property_ownership".tr,
                                  content: GetBuilder<SearchViewModel>(
                                    builder: (controller) => Container(
                                        height: Get.height * .3,
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Flexible(
                                              fit: FlexFit.loose,
                                              child: Stack(
                                                children: [
                                                  ListWheelScrollView
                                                      .useDelegate(
                                                    controller: _controller,
                                                    itemExtent: 50,
                                                    physics:
                                                        const FixedExtentScrollPhysics(),
                                                    onSelectedItemChanged:
                                                        (value) {
                                                      controller
                                                          .updatePropreIdex(
                                                              value);
                                                    },
                                                    childDelegate:
                                                        ListWheelChildBuilderDelegate(
                                                      childCount: controller
                                                          .prores.length,
                                                      builder:
                                                          (context, index) {
                                                        return Container(
                                                          child: Center(
                                                            child: Text(
                                                              controller
                                                                  .prores[index]
                                                                  .type!,
                                                              style: TextStyle(
                                                                  color: index ==
                                                                          controller
                                                                              .propreindex
                                                                      ? Colors
                                                                          .blue
                                                                      : Colors
                                                                          .black),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  Center(
                                                    child: Container(
                                                      height: 50.h,
                                                      decoration: BoxDecoration(
                                                          color: Colors.white
                                                              .withOpacity(0),
                                                          border:
                                                              Border.symmetric(
                                                                  horizontal:
                                                                      BorderSide(
                                                            color: AppColor
                                                                .GreyIcons,
                                                            width: 1.0,
                                                          ))),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            const Divider(),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              // ignore: prefer_const_literals_to_create_immutables
                                              children: [
                                                InkWell(
                                                    onTap: () {
                                                      controller
                                                          .updateOwnership(
                                                              controller
                                                                  .propreindex);

                                                      Get.back();
                                                    },
                                                    child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          horizontal: 25.w,
                                                          vertical: 15.h,
                                                        ),
                                                        child: Text("موافق"))),
                                                InkWell(
                                                    onTap: () {
                                                      Get.back();
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        horizontal: 25.w,
                                                        vertical: 15.h,
                                                      ),
                                                      child: Text("إلغاء"),
                                                    )),
                                              ],
                                            )
                                          ],
                                        )),
                                  ),
                                );
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 60.h,
                                    alignment: Get.locale?.languageCode == 'ar'
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 8.h, horizontal: 12.h),
                                      child: Text(
                                        "property_ownership".tr,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8.h, horizontal: 12.h),
                                    child: GetBuilder<SearchViewModel>(
                                        builder: (ownershipcontroller) {
                                      return Text(
                                        ownershipcontroller.prore.type!,
                                      );
                                    }),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: searchController.isLicenseVisible,
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            child: InkWell(
                              onTap: () {
                                final FixedExtentScrollController _controller =
                                    FixedExtentScrollController(
                                        initialItem:
                                            searchController.licenseindex);
                                Get.defaultDialog(
                                  barrierDismissible: false,
                                  title: "property_registration".tr,
                                  content: GetBuilder<SearchViewModel>(
                                    builder: (controller) => Container(
                                        height: Get.height * .3,
                                        // padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Flexible(
                                              fit: FlexFit.loose,
                                              child: Stack(
                                                children: [
                                                  ListWheelScrollView
                                                      .useDelegate(
                                                    itemExtent: 50,
                                                    controller: _controller,
                                                    physics:
                                                        const FixedExtentScrollPhysics(),
                                                    onSelectedItemChanged:
                                                        (value) {
                                                      controller
                                                          .updateLicenseIdex(
                                                              value);
                                                    },
                                                    childDelegate:
                                                        ListWheelChildBuilderDelegate(
                                                      childCount: controller
                                                          .licenses.length,
                                                      builder:
                                                          (context, index) {
                                                        return Container(
                                                          child: Center(
                                                            child: Text(
                                                              controller
                                                                  .licenses[
                                                                      index]
                                                                  .type!,
                                                              style: TextStyle(
                                                                  color: index ==
                                                                          controller
                                                                              .licenseindex
                                                                      ? Colors
                                                                          .blue
                                                                      : Colors
                                                                          .black),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  Center(
                                                    child: Container(
                                                      height: 50.h,
                                                      decoration: BoxDecoration(
                                                          color: Colors.white
                                                              .withOpacity(0),
                                                          border:
                                                              Border.symmetric(
                                                                  horizontal:
                                                                      BorderSide(
                                                            color: AppColor
                                                                .GreyIcons,
                                                            width: 1.0,
                                                          ))),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            const Divider(),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              // ignore: prefer_const_literals_to_create_immutables
                                              children: [
                                                InkWell(
                                                    onTap: () {
                                                      controller.updateLicense(
                                                          controller
                                                              .licenseindex);

                                                      Get.back();
                                                    },
                                                    child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          horizontal: 25.w,
                                                          vertical: 15.h,
                                                        ),
                                                        child: Text("موافق"))),
                                                InkWell(
                                                    onTap: () {
                                                      Get.back();
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                        horizontal: 25.w,
                                                        vertical: 15.h,
                                                      ),
                                                      child: Text("إلغاء"),
                                                    )),
                                              ],
                                            )
                                          ],
                                        )),
                                  ),
                                );
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 60.h,
                                    alignment: Get.locale?.languageCode == 'ar'
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 8.h, horizontal: 12.h),
                                      child: Text(
                                        "property_registration".tr,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8.h, horizontal: 12.h),
                                    child: GetBuilder<SearchViewModel>(
                                        builder: (licensecontroller) {
                                      return licensecontroller
                                              .licenseloading.value
                                          ? JumpingDotsProgressIndicator(
                                              fontSize: 25.0,
                                            )
                                          : Text(
                                              licensecontroller.license.type!,
                                            );
                                    }),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 25.h,
                        ),
                        Visibility(
                          visible: Get.find<SearchViewModel>()
                                  .isCheminyVisible ||
                              Get.find<SearchViewModel>().isPoolVisible ||
                              Get.find<SearchViewModel>().isElevatorVisible ||
                              Get.find<SearchViewModel>().isRockCoverVisible ||
                              Get.find<SearchViewModel>().isStairCoverVisible ||
                              Get.find<SearchViewModel>().isAltEnergyVisible ||
                              Get.find<SearchViewModel>().isWaterWellVisible ||
                              Get.find<SearchViewModel>().isGreenHouseVisible,
                          child: Center(
                            child: InkWell(
                              onTap: () {
                                Get.to(SearchFilterView2());
                              },
                              child: Container(
                                height: 30.h,
                                width: (MediaQuery.of(context).size.width / 2) -
                                    10,
                                decoration: BoxDecoration(
                                  color: Colors.black12,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Text("مزيد من الخيارات".tr,
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold,
                                      )),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // Container(
                            //   height: 35.h,
                            //   width:
                            //       (MediaQuery.of(context).size.width / 2) - 10,
                            //   decoration: BoxDecoration(
                            //     color: Colors.grey,
                            //     borderRadius: BorderRadius.circular(5),
                            //   ),
                            //   child: Center(
                            //     child: Text("reset".tr,
                            //         style: TextStyle(
                            //           fontSize: 20.sp,
                            //           fontWeight: FontWeight.bold,
                            //         )),
                            //   ),
                            // ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(Get.width * .9, 50),
                              ),
                              onPressed: () {
                                if (searchController
                                    .directionmultiValid.value) {
                                  Get.find<SearchViewModel>()
                                      .filterWithoutmapProperty();
                                }
                              },
                              child: Center(
                                child: Text(
                                  "search".tr,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 25.h,
                        )
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
