// ignore_for_file: library_prefixes, use_key_in_widget_constructors, must_be_immutable

import 'package:catalog/controllers/network_controller.dart';
import 'package:catalog/controllers/property_controller.dart';
import 'package:catalog/models/item_key_model.dart';
import 'package:catalog/utils/app_color.dart';
import 'package:catalog/views/add_property/add_property_2.dart';
import 'package:catalog/views/add_property/add_property_3.dart';
import 'package:catalog/views/widgets/location_picker.dart';
import 'package:catalog/views/widgets/no_internet_connection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
// import 'package:map_location_picker/map_location_picker.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:progress_indicators/progress_indicators.dart';
import 'package:shimmer/shimmer.dart';

class AddProperty extends GetWidget<PropertyController> {
  final _formKey = GlobalKey<FormState>();
  String dropdownValue = 'One';
  Set<Marker> myMarker = {};

  var directions = ['شرقي', 'غربي', 'شمالي', 'جنوبي'];

  // List<Widget> buildRegion() {
  //   List<Widget> regions = [];
  //   for (var element in controller.regions) {
  //     regions.add(InkWell(
  //       onTap: () {
  //         controller.updateRegion(element);
  //       },
  //       child: Container(
  //         margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
  //         height: 35.h,
  //         width: 65,
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(5),
  //           border: Border.all(
  //             color: Colors.black,
  //           ),
  //         ),
  //         child: Center(child: Text(element.region!)),
  //       ),
  //     ));
  //   }
  //   return regions;
  // }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: Text(
            "add_property".tr,
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          child: Get.find<NetworkController>().connectionStatus.value == 1 ||
                  Get.find<NetworkController>().connectionStatus.value == 2
              ? (GetBuilder<PropertyController>(
                  init: Get.put(PropertyController()),
                  builder: (controller) => controller.isLoading.value
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
                                      (MediaQuery.of(context).size.width / 2) -
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
                              SizedBox(
                                height: 30.h,
                              ),
                              Container(
                                height: 35.h,
                                width: (MediaQuery.of(context).size.width / 2) -
                                    10,
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
                          ))
                      : Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                color: Colors.white,
                                padding: EdgeInsets.symmetric(
                                    vertical: 5.h,
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            .05),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    controller.address_longitude == null
                                        ? FittedBox(
                                            fit: BoxFit.fitWidth,
                                            child: Text(
                                              "property_location".tr,
                                              style: TextStyle(
                                                  fontSize: 17.sp,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              FittedBox(
                                                fit: BoxFit.fitWidth,
                                                child: Text(
                                                  "property_location".tr,
                                                  style: TextStyle(
                                                    fontSize: 17.sp,
                                                  ),
                                                ),
                                              ),
                                              IconButton(
                                                  onPressed: () async {
                                                    Get.to(
                                                        LocationPickerView());
                                                  },
                                                  icon: const Icon(
                                                      Icons.location_pin))
                                            ],
                                          ),
                                    controller.address_longitude == null
                                        ? Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10.w),
                                            child: GestureDetector(
                                              onTap: () async {
                                                Get.to(LocationPickerView());
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Obx(() {
                                                    return controller
                                                            .locationValid.value
                                                        ? FittedBox(
                                                            fit:
                                                                BoxFit.fitWidth,
                                                            child: Text(
                                                              "property_location_specification"
                                                                  .tr,
                                                            ),
                                                          )
                                                        : FittedBox(
                                                            fit:
                                                                BoxFit.fitWidth,
                                                            child: Text(
                                                                "property_location_specification"
                                                                    .tr,
                                                                style: const TextStyle(
                                                                    color: Colors
                                                                        .red)),
                                                          );
                                                  }),
                                                  IconButton(
                                                      onPressed: () async {
                                                        Get.to(
                                                            LocationPickerView());
                                                      },
                                                      icon: const Icon(
                                                          Icons.location_pin))
                                                ],
                                              ),
                                            ),
                                          )
                                        : SizedBox(
                                            height: 100.h,
                                            child: GoogleMap(
                                              initialCameraPosition:
                                                  CameraPosition(
                                                      target: LatLng(
                                                        double.parse(controller
                                                            .address_latitude!),
                                                        double.parse(controller
                                                            .address_longitude!),
                                                      ),
                                                      zoom: 13),
                                              zoomControlsEnabled: false,
                                              onMapCreated: (controller) => this
                                                  .controller
                                                  .setGoolgeMapController(
                                                      controller),
                                              rotateGesturesEnabled: false,
                                              mapType: MapType.normal,
                                              markers: controller.myMarker,
                                            ),
                                          ),
                                    SizedBox(
                                      height: 8.h,
                                    ),
                                    const Divider(),
                                    SizedBox(
                                      height: 6.h,
                                    ),
                                    Text(
                                      "address".tr,
                                      style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text("address_description".tr),
                                    TextFormField(
                                      onSaved: (address) {
                                        controller.address_address = address;
                                      },
                                      validator: (text) {
                                        if (text == null || text.isEmpty) {
                                          return 'emptytextfieldvalidation'.tr;
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(
                                      height: 15.h,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                color: Colors.white,
                                padding: EdgeInsets.symmetric(
                                    vertical: 5.h,
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            .05),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 6.h,
                                    ),
                                    // Text(
                                    //   "المحافظة".tr,
                                    //   style: TextStyle(
                                    //       fontSize: 18.sp,
                                    //       fontWeight: FontWeight.bold),
                                    // ),
                                    // Text("الرجاء اختيار المحافظة".tr),
                                    // SizedBox(
                                    //   height: 8.h,
                                    // ),
                                    // SizedBox(
                                    //   height: 50.h,
                                    //   child: ListView.builder(
                                    //     scrollDirection: Axis.horizontal,
                                    //     itemCount: controller.regions.length,
                                    //     shrinkWrap: true,
                                    //     itemBuilder: (context, index) {
                                    //       return InkWell(
                                    //         onTap: () {
                                    //           controller.updateRegion(
                                    //               controller.regions[index],
                                    //               index);
                                    //         },
                                    //         child: UnconstrainedBox(
                                    //           child: Container(
                                    //             padding:
                                    //                 const EdgeInsets.symmetric(
                                    //                     vertical: 4,
                                    //                     horizontal: 7),
                                    //             margin:
                                    //                 const EdgeInsets.symmetric(
                                    //                     vertical: 3,
                                    //                     horizontal: 5),
                                    //             height: 35.h,
                                    //             // width: 65,
                                    //             decoration: BoxDecoration(
                                    //               color:
                                    //                   controller.regionindex ==
                                    //                           index
                                    //                       ? Colors.blue
                                    //                       : Colors.white,
                                    //               borderRadius:
                                    //                   BorderRadius.circular(5),
                                    //               border: Border.all(
                                    //                 color: controller
                                    //                             .regionindex ==
                                    //                         index
                                    //                     ? Colors.white
                                    //                     : Colors.black,
                                    //               ),
                                    //             ),
                                    //             child: Center(
                                    //                 child: Text(
                                    //               controller
                                    //                   .regions[index].region!,
                                    //               style: TextStyle(
                                    //                 color: controller
                                    //                             .regionindex ==
                                    //                         index
                                    //                     ? Colors.white
                                    //                     : Colors.black,
                                    //               ),
                                    //             )),
                                    //           ),
                                    //         ),
                                    //       );
                                    //     },
                                    //   ),
                                    // ),
                                    InkWell(
                                      onTap: () {
                                        final FixedExtentScrollController
                                            _controller =
                                            FixedExtentScrollController(
                                                initialItem:
                                                    controller.regionindex);
                                        Get.defaultDialog(
                                            barrierDismissible: false,
                                            title: "المحافظة".tr,
                                            content:
                                                GetBuilder<PropertyController>(
                                              builder: (controller) =>
                                                  Container(
                                                height: Get.height * .30,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8.0),
                                                child: Column(
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
                                                                const AlwaysScrollableScrollPhysics(),
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
                                                              childCount:
                                                                  controller
                                                                      .regions
                                                                      .length,
                                                              builder: (context,
                                                                  index) {
                                                                return Center(
                                                                  child: Text(
                                                                    controller
                                                                        .regions[
                                                                            index]
                                                                        .region!,
                                                                    style: TextStyle(
                                                                        color: index ==
                                                                                controller.regionindex
                                                                            ? Colors.blue
                                                                            : Colors.black),
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
                                                                        color: const Color.fromRGBO(
                                                                                255,
                                                                                255,
                                                                                255,
                                                                                1)
                                                                            .withOpacity(0),
                                                                        border: Border.symmetric(
                                                                            horizontal: BorderSide(
                                                                          color:
                                                                              AppColor.GreyIcons,
                                                                          width:
                                                                              1.0,
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
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      // ignore: prefer_const_literals_to_create_immutables
                                                      children: [
                                                        InkWell(
                                                            onTap: () {
                                                              controller
                                                                  .updateRegion(
                                                                      controller
                                                                          .regionindex);
                                                              Get.back();
                                                            },
                                                            child:
                                                                const Padding(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .symmetric(
                                                                      horizontal:
                                                                          15,
                                                                      vertical:
                                                                          5,
                                                                    ),
                                                                    child: Text(
                                                                        "موافق"))),
                                                        InkWell(
                                                          onTap: () {
                                                            Get.back();
                                                          },
                                                          child: const Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                              horizontal: 15,
                                                              vertical: 5,
                                                            ),
                                                            child:
                                                                Text("إلغاء"),
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
                                            height: 50.h,
                                            alignment:
                                                Get.locale?.languageCode == 'ar'
                                                    ? Alignment.centerRight
                                                    : Alignment.centerLeft,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8.h,
                                                  horizontal: 12.h),
                                              child: Text(
                                                "المحافظة".tr,
                                                style: TextStyle(
                                                    fontSize: 18.sp,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8.h,
                                                horizontal: 12.h),
                                            child:
                                                GetBuilder<PropertyController>(
                                                    builder: (typecontroller) {
                                              return typecontroller
                                                      .regionloading.value
                                                  ? JumpingDotsProgressIndicator(
                                                      fontSize: 25.0,
                                                    )
                                                  : Text(
                                                      typecontroller
                                                          .region.region!,
                                                      style: const TextStyle(
                                                        color: Colors.black87,
                                                      ),
                                                    );
                                            }),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8.h,
                                    ),
                                    const Divider(),
                                    SizedBox(
                                      height: 6.h,
                                    ),
                                    // Text(
                                    //   "المدينة".tr,
                                    //   style: TextStyle(
                                    //       fontSize: 18.sp,
                                    //       fontWeight: FontWeight.bold),
                                    // ),
                                    // Text("الرجاء اختيار المدينة".tr),
                                    // SizedBox(
                                    //   height: 8.h,
                                    // ),
                                    // SizedBox(
                                    //   height: 50.h,
                                    //   child: ListView.builder(
                                    //     scrollDirection: Axis.horizontal,
                                    //     itemCount: controller.cities.length,
                                    //     shrinkWrap: true,
                                    //     itemBuilder: (context, index) {
                                    //       return InkWell(
                                    //         onTap: () {
                                    //           controller.updateCity(
                                    //               controller.cities[index],
                                    //               index);
                                    //         },
                                    //         child: UnconstrainedBox(
                                    //           child: Container(
                                    //             padding:
                                    //                 const EdgeInsets.symmetric(
                                    //                     vertical: 4,
                                    //                     horizontal: 7),
                                    //             margin:
                                    //                 const EdgeInsets.symmetric(
                                    //                     vertical: 3,
                                    //                     horizontal: 5),
                                    //             height: 35.h,
                                    //             // width: 65,
                                    //             decoration: BoxDecoration(
                                    //               color: controller.cityindex ==
                                    //                       index
                                    //                   ? Colors.blue
                                    //                   : Colors.white,
                                    //               borderRadius:
                                    //                   BorderRadius.circular(5),
                                    //               border: Border.all(
                                    //                 color:
                                    //                     controller.cityindex ==
                                    //                             index
                                    //                         ? Colors.white
                                    //                         : Colors.black,
                                    //               ),
                                    //             ),
                                    //             child: Center(
                                    //                 child: Text(
                                    //               controller
                                    //                   .cities[index].city!,
                                    //               style: TextStyle(
                                    //                 color:
                                    //                     controller.cityindex ==
                                    //                             index
                                    //                         ? Colors.white
                                    //                         : Colors.black,
                                    //               ),
                                    //             )),
                                    //           ),
                                    //         ),
                                    //       );
                                    //     },
                                    //   ),
                                    // ),
                                    InkWell(
                                      onTap: () {
                                        final FixedExtentScrollController
                                            _controller =
                                            FixedExtentScrollController(
                                                initialItem:
                                                    controller.cityindex);
                                        Get.defaultDialog(
                                            barrierDismissible: false,
                                            title: "المدينة".tr,
                                            content:
                                                GetBuilder<PropertyController>(
                                              builder: (controller) =>
                                                  Container(
                                                height: Get.height * .30,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8.0),
                                                child: Column(
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
                                                                const AlwaysScrollableScrollPhysics(),
                                                            onSelectedItemChanged:
                                                                (value) {
                                                              controller
                                                                  .updateCityIdex(
                                                                      value);
                                                              // print(controller
                                                              //     .categories[value].category!);
                                                            },
                                                            childDelegate:
                                                                ListWheelChildBuilderDelegate(
                                                              childCount:
                                                                  controller
                                                                      .cities
                                                                      .length,
                                                              builder: (context,
                                                                  index) {
                                                                return Center(
                                                                  child: Text(
                                                                    controller
                                                                        .cities[
                                                                            index]
                                                                        .city!,
                                                                    style: TextStyle(
                                                                        color: index ==
                                                                                controller.cityindex
                                                                            ? Colors.blue
                                                                            : Colors.black),
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
                                                                        color: const Color.fromRGBO(
                                                                                255,
                                                                                255,
                                                                                255,
                                                                                1)
                                                                            .withOpacity(0),
                                                                        border: Border.symmetric(
                                                                            horizontal: BorderSide(
                                                                          color:
                                                                              AppColor.GreyIcons,
                                                                          width:
                                                                              1.0,
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
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      // ignore: prefer_const_literals_to_create_immutables
                                                      children: [
                                                        InkWell(
                                                            onTap: () {
                                                              controller.updateCity(
                                                                  controller
                                                                      .cityindex);
                                                              Get.back();
                                                            },
                                                            child:
                                                                const Padding(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .symmetric(
                                                                      horizontal:
                                                                          15,
                                                                      vertical:
                                                                          5,
                                                                    ),
                                                                    child: Text(
                                                                        "موافق"))),
                                                        InkWell(
                                                          onTap: () {
                                                            Get.back();
                                                          },
                                                          child: const Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                              horizontal: 15,
                                                              vertical: 5,
                                                            ),
                                                            child:
                                                                Text("إلغاء"),
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
                                            height: 50.h,
                                            alignment:
                                                Get.locale?.languageCode == 'ar'
                                                    ? Alignment.centerRight
                                                    : Alignment.centerLeft,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8.h,
                                                  horizontal: 12.h),
                                              child: Text(
                                                "المدينة".tr,
                                                style: TextStyle(
                                                    fontSize: 18.sp,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8.h,
                                                horizontal: 12.h),
                                            child:
                                                GetBuilder<PropertyController>(
                                                    builder: (typecontroller) {
                                              return typecontroller
                                                      .cityloading.value
                                                  ? JumpingDotsProgressIndicator(
                                                      fontSize: 25.0,
                                                    )
                                                  : Text(
                                                      typecontroller.city.city!,
                                                      style: const TextStyle(
                                                        color: Colors.black87,
                                                      ),
                                                    );
                                            }),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8.h,
                                    ),
                                    // Column(
                                    //   children: [
                                    //     Padding(
                                    //       padding: const EdgeInsets.symmetric(
                                    //           horizontal: 50),
                                    //       child: DropdownButton<City>(
                                    //         isExpanded: true,
                                    //         value: controller.city,
                                    //         icon: const Icon(
                                    //             Icons.arrow_drop_down_outlined),
                                    //         elevation: 16,
                                    //         style: const TextStyle(
                                    //             color: Colors.blue),
                                    //         underline: Container(
                                    //           height: 2,
                                    //           color: Colors.blueAccent,
                                    //         ),
                                    //         onChanged: (City? newValue) {
                                    //           controller.updateCity(newValue!);
                                    //         },
                                    //         items: controller.cities
                                    //             .map<DropdownMenuItem<City>>(
                                    //                 (City value) {
                                    //           return DropdownMenuItem<City>(
                                    //             value: value,
                                    //             child: Center(
                                    //                 child: Text(value.city!)),
                                    //           );
                                    //         }).toList(),
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                    // SizedBox(
                                    //   height: 8.h,
                                    // ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                color: Colors.white,
                                padding: EdgeInsets.symmetric(
                                    vertical: 5.h,
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            .05),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 6.h,
                                    ),
                                    Text(
                                      "porpose".tr,
                                      style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text("porpose_specification".tr),
                                    SizedBox(
                                      height: 8.h,
                                    ),
                                    SizedBox(
                                      height: 50.h,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: controller.categories.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () {
                                              controller.updateCategory(
                                                  controller.categories[index],
                                                  index);
                                            },
                                            child: UnconstrainedBox(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4,
                                                        horizontal: 7),
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 3,
                                                        horizontal: 5),
                                                height: 35.h,
                                                // width: 65,
                                                decoration: BoxDecoration(
                                                  color: controller
                                                              .categoryindex ==
                                                          index
                                                      ? Colors.blue
                                                      : Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border: Border.all(
                                                    color: controller
                                                                .categoryindex ==
                                                            index
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                ),
                                                child: Center(
                                                    child: Text(
                                                  controller.categories[index]
                                                      .category!,
                                                  style: TextStyle(
                                                    color: controller
                                                                .categoryindex ==
                                                            index
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                )),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),

                                    SizedBox(
                                      height: 8.h,
                                    ),
                                    // Column(
                                    //   children: [
                                    //     Padding(
                                    //       padding: const EdgeInsets.symmetric(
                                    //           horizontal: 50),
                                    //       child: DropdownButton<Category>(
                                    //         isExpanded: true,
                                    //         value: controller.category,
                                    //         icon: const Icon(
                                    //             Icons.arrow_drop_down_outlined),
                                    //         elevation: 16,
                                    //         style: const TextStyle(
                                    //             color: Colors.blue),
                                    //         underline: Container(
                                    //           height: 2,
                                    //           color: Colors.blueAccent,
                                    //         ),
                                    //         onChanged: (Category? newValue) {
                                    //           controller
                                    //               .updateCategory(newValue!);
                                    //         },
                                    //         items: controller.categories
                                    //             .map<DropdownMenuItem<Category>>(
                                    //                 (Category value) {
                                    //           return DropdownMenuItem<Category>(
                                    //             value: value,
                                    //             child: Center(
                                    //                 child: Text(value.category!)),
                                    //           );
                                    //         }).toList(),
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                    // SizedBox(
                                    //   height: 8.h,
                                    // ),
                                    Visibility(
                                      visible: controller.isRentOptionsVisibile,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("تحديد نوع الأجار".tr),
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: Get.width * .4,
                                                child: RadioListTile(
                                                  title: const Text("يومي"),
                                                  value: "1",
                                                  groupValue: controller.period,
                                                  onChanged: (value) {
                                                    controller.updatePeriod(
                                                        value.toString());
                                                  },
                                                ),
                                              ),
                                              SizedBox(
                                                width: Get.width * .4,
                                                child: RadioListTile(
                                                  title: const Text("شهري"),
                                                  value: "2",
                                                  groupValue: controller.period,
                                                  onChanged: (value) {
                                                    controller.updatePeriod(
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
                                    SizedBox(
                                      height: 8.h,
                                    ),
                                    const Divider(),
                                    SizedBox(
                                      height: 6.h,
                                    ),
                                    Text(
                                      "property_type".tr,
                                      style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text("type_specification".tr),
                                    SizedBox(
                                      height: 8.h,
                                    ),
                                    SizedBox(
                                      height: 50.h,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: controller.types.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () {
                                              controller.updateType(
                                                  controller.types[index],
                                                  index);
                                            },
                                            child: UnconstrainedBox(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4,
                                                        horizontal: 7),
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 3,
                                                        horizontal: 5),
                                                height: 35.h,
                                                decoration: BoxDecoration(
                                                  color: controller.typeindex ==
                                                          index
                                                      ? Colors.blue
                                                      : Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border: Border.all(
                                                    color:
                                                        controller.typeindex ==
                                                                index
                                                            ? Colors.white
                                                            : Colors.black,
                                                  ),
                                                ),
                                                child: Center(
                                                    child: Text(
                                                  controller.types[index].type!,
                                                  style: TextStyle(
                                                    color:
                                                        controller.typeindex ==
                                                                index
                                                            ? Colors.white
                                                            : Colors.black,
                                                  ),
                                                )),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),

                                    SizedBox(
                                      height: 8.h,
                                    ),
                                    // Column(
                                    //   children: [
                                    //     Padding(
                                    //       padding: const EdgeInsets.symmetric(
                                    //           horizontal: 50),
                                    //       child: DropdownButton<Type>(
                                    //         isExpanded: true,
                                    //         value: controller.typeValue,
                                    //         icon: const Icon(
                                    //             Icons.arrow_drop_down_outlined),
                                    //         elevation: 16,
                                    //         style: const TextStyle(
                                    //             color: Colors.blue),
                                    //         underline: Container(
                                    //           height: 2,
                                    //           color: Colors.blueAccent,
                                    //         ),
                                    //         onChanged: (Type? newValue) {
                                    //           controller.updateType(newValue!);
                                    //         },
                                    //         items: controller.types
                                    //             .map<DropdownMenuItem<Type>>(
                                    //                 (Type value) {
                                    //           return DropdownMenuItem<Type>(
                                    //             value: value,
                                    //             child: Center(
                                    //                 child: Text(value.type!)),
                                    //           );
                                    //         }).toList(),
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                    // SizedBox(
                                    //   height: 8.h,
                                    // ),
                                    const Divider(),
                                    SizedBox(
                                      height: 6.h,
                                    ),
                                    Text(
                                      "property_nature".tr,
                                      style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text("nature_specification".tr),
                                    controller.loading.value
                                        ? Container(
                                            color: Colors.white,
                                            child: const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          )
                                        : Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 50.h,
                                                child: ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount:
                                                      controller.natures.length,
                                                  shrinkWrap: true,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return InkWell(
                                                      onTap: () {
                                                        controller.updateNature(
                                                            controller
                                                                .natures[index],
                                                            index);
                                                      },
                                                      child: UnconstrainedBox(
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 4,
                                                                  horizontal:
                                                                      7),
                                                          margin:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 3,
                                                                  horizontal:
                                                                      5),
                                                          height: 35.h,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: controller
                                                                        .natureindex ==
                                                                    index
                                                                ? Colors.blue
                                                                : Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            border: Border.all(
                                                              color: controller
                                                                          .natureindex ==
                                                                      index
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black,
                                                            ),
                                                          ),
                                                          child: Center(
                                                              child: Text(
                                                            controller
                                                                .natures[index]
                                                                .nature!,
                                                            style: TextStyle(
                                                              color: controller
                                                                          .natureindex ==
                                                                      index
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black,
                                                            ),
                                                          )),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                              Visibility(
                                                visible: controller
                                                    .isChaletNumVisible,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height: 5.h,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 50),
                                                      child: TextFormField(
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        decoration:
                                                            InputDecoration(
                                                          labelText:
                                                              "نسق الشاليه".tr,
                                                          hintText:
                                                              "نسق الشاليه".tr,
                                                        ),
                                                        onSaved: (value) {
                                                          controller
                                                                  .chalet_layout_number =
                                                              value!;
                                                        },
                                                        validator: (text) {
                                                          if ((text == null ||
                                                                  text
                                                                      .isEmpty) &&
                                                              controller
                                                                      .isChaletNumVisible ==
                                                                  true) {
                                                            return 'emptytextfieldvalidation'
                                                                .tr;
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                    SizedBox(
                                      height: 8.h,
                                    ),
                                    const Divider(),
                                    Visibility(
                                      visible: controller.isStatusVisible,
                                      child: SizedBox(
                                        height: 6.h,
                                      ),
                                    ),
                                    Visibility(
                                      visible: controller.isStatusVisible,
                                      child: Text(
                                        "property_status".tr,
                                        style: TextStyle(
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Visibility(
                                      visible: controller.isStatusVisible,
                                      child: SizedBox(
                                        height: 50.h,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: controller.states.length,
                                          shrinkWrap: true,
                                          itemBuilder: (context, index) {
                                            return InkWell(
                                              onTap: () {
                                                controller.updateState(
                                                    controller.states[index],
                                                    index);
                                              },
                                              child: UnconstrainedBox(
                                                child: Container(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 4,
                                                      horizontal: 7),
                                                  margin: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 3,
                                                      horizontal: 5),
                                                  height: 35.h,
                                                  decoration: BoxDecoration(
                                                    color: controller
                                                                .statusindex ==
                                                            index
                                                        ? Colors.blue
                                                        : Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    border: Border.all(
                                                      color: controller
                                                                  .statusindex ==
                                                              index
                                                          ? Colors.white
                                                          : Colors.black,
                                                    ),
                                                  ),
                                                  child: Center(
                                                      child: Text(
                                                    controller
                                                        .states[index].states!,
                                                    style: TextStyle(
                                                      color: controller
                                                                  .statusindex ==
                                                              index
                                                          ? Colors.white
                                                          : Colors.black,
                                                    ),
                                                  )),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: controller.isStatusVisible,
                                      child: SizedBox(
                                        height: 8.h,
                                      ),
                                    ),
                                    Visibility(
                                        visible: controller.isStatusVisible,
                                        child: const Divider()),
                                    SizedBox(
                                      height: 6.h,
                                    ),
                                    Text(
                                      "property_ownership".tr,
                                      style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text("property_ownership_specification".tr),
                                    SizedBox(
                                      height: 50.h,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: controller.prores.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () {
                                              controller.updateOwnership(
                                                  controller.prores[index],
                                                  index);
                                            },
                                            child: UnconstrainedBox(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4,
                                                        horizontal: 7),
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 3,
                                                        horizontal: 5),
                                                height: 35.h,
                                                decoration: BoxDecoration(
                                                  color:
                                                      controller.propreindex ==
                                                              index
                                                          ? Colors.blue
                                                          : Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border: Border.all(
                                                    color: controller
                                                                .propreindex ==
                                                            index
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                ),
                                                child: Center(
                                                    child: Text(
                                                  controller
                                                      .prores[index].type!,
                                                  style: TextStyle(
                                                    color: controller
                                                                .propreindex ==
                                                            index
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                )),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8.h,
                                    ),
                                    const Divider(),
                                    SizedBox(
                                      height: 6.h,
                                    ),
                                    Text(
                                      "property_license".tr,
                                      style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    controller.loading.value
                                        ? Container(
                                            color: Colors.white,
                                            child: const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          )
                                        : SizedBox(
                                            height: 50.h,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount:
                                                  controller.licenses.length,
                                              shrinkWrap: true,
                                              itemBuilder: (context, index) {
                                                return InkWell(
                                                  onTap: () {
                                                    controller.updateLicense(
                                                        controller
                                                            .licenses[index],
                                                        index);
                                                  },
                                                  child: UnconstrainedBox(
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 4,
                                                          horizontal: 7),
                                                      margin: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 3,
                                                          horizontal: 5),
                                                      height: 35.h,
                                                      decoration: BoxDecoration(
                                                        color: controller
                                                                    .licenseindex ==
                                                                index
                                                            ? Colors.blue
                                                            : Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        border: Border.all(
                                                          color: controller
                                                                      .licenseindex ==
                                                                  index
                                                              ? Colors.white
                                                              : Colors.black,
                                                        ),
                                                      ),
                                                      child: Center(
                                                          child: Text(
                                                        controller
                                                            .licenses[index]
                                                            .type!,
                                                        style: TextStyle(
                                                          color: controller
                                                                      .licenseindex ==
                                                                  index
                                                              ? Colors.white
                                                              : Colors.black,
                                                        ),
                                                      )),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                    SizedBox(
                                      height: 8.h,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                color: Colors.white,
                                padding: EdgeInsets.symmetric(
                                    vertical: 5.h,
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            .05),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "property_percentage".tr,
                                      style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    // Text("property_percentage_specification"),
                                    SizedBox(
                                      height: 50.h,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount:
                                            controller.percentageList.length,
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () {
                                              controller.updatePercentage(
                                                  controller
                                                      .percentageList[index],
                                                  index);
                                            },
                                            child: UnconstrainedBox(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4,
                                                        horizontal: 7),
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 3,
                                                        horizontal: 5),
                                                height: 35.h,
                                                width: 65,
                                                decoration: BoxDecoration(
                                                  color: controller
                                                              .percentageindex ==
                                                          index
                                                      ? Colors.blue
                                                      : Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border: Border.all(
                                                    color: controller
                                                                .percentageindex ==
                                                            index
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                ),
                                                child: Center(
                                                    child: Text(
                                                  controller
                                                          .percentageList[index]
                                                          .toString() +
                                                      "%",
                                                  style: TextStyle(
                                                    color: controller
                                                                .percentageindex ==
                                                            index
                                                        ? Colors.white
                                                        : Colors.black,
                                                  ),
                                                )),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    // Column(
                                    //   children: [
                                    //     Padding(
                                    //       padding: const EdgeInsets.symmetric(
                                    //           horizontal: 50),
                                    //       child: DropdownButton<int>(
                                    //         isExpanded: true,
                                    //         value: controller.percentageValue,
                                    //         icon: const Icon(
                                    //             Icons.arrow_drop_down_outlined),
                                    //         elevation: 16,
                                    //         style: const TextStyle(
                                    //             color: Colors.blue),
                                    //         underline: Container(
                                    //           height: 2,
                                    //           color: Colors.blueAccent,
                                    //         ),
                                    //         onChanged: (int? newValue) {
                                    //           controller
                                    //               .updatePercentage(newValue!);
                                    //         },
                                    //         items: controller.percentageList
                                    //             .map<DropdownMenuItem<int>>(
                                    //                 (int value) {
                                    //           return DropdownMenuItem<int>(
                                    //             value: value,
                                    //             child: Center(
                                    //                 child: Text(
                                    //                     value.toString() + "%")),
                                    //           );
                                    //         }).toList(),
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                    SizedBox(
                                      height: 15.h,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                color: Colors.white,
                                padding: EdgeInsets.symmetric(
                                    vertical: 5.h,
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            .05),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 6.h,
                                    ),
                                    Text(
                                      "price".tr,
                                      style: TextStyle(
                                          fontSize: 17.sp,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text("price_specification".tr),
                                    TextFormField(
                                      keyboardType: TextInputType.number,
                                      decoration:
                                          InputDecoration(suffixText: "sp".tr),
                                      onSaved: (price) {
                                        controller.amount = price!;
                                      },
                                      validator: (text) {
                                        if (text == null || text.isEmpty) {
                                          return 'emptytextfieldvalidation'.tr;
                                        }
                                        return null;
                                      },
                                    ),
                                    Visibility(
                                      visible: controller.isAreaVisible ||
                                          controller.isTotalAreaVisible,
                                      child: SizedBox(
                                        height: 15.h,
                                      ),
                                    ),
                                    Visibility(
                                        visible: controller.isAreaVisible ||
                                            controller.isTotalAreaVisible,
                                        child: Text(
                                          "info".tr,
                                          style: TextStyle(
                                              fontSize: 17.sp,
                                              fontWeight: FontWeight.bold),
                                        )),
                                    Visibility(
                                      visible: controller.isAreaVisible ||
                                          controller.isTotalAreaVisible,
                                      child: Row(
                                        children: [
                                          Visibility(
                                            visible: controller.isAreaVisible,
                                            child: Expanded(
                                              child: TextFormField(
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: InputDecoration(
                                                  suffixText: "meter".tr,
                                                  hintText: "area".tr,
                                                  labelText: "area".tr,
                                                ),
                                                onSaved: (area) {
                                                  controller.area = area!;
                                                },
                                                validator: (text) {
                                                  if (text == null ||
                                                      text.isEmpty) {
                                                    return 'emptytextfieldvalidation'
                                                        .tr;
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                          ),
                                          Visibility(
                                            visible: controller.isAreaVisible,
                                            child: SizedBox(
                                              width: 15.w,
                                            ),
                                          ),
                                          Visibility(
                                            visible:
                                                controller.isTotalAreaVisible,
                                            child: Expanded(
                                              child: TextFormField(
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: InputDecoration(
                                                    labelText:
                                                        "المساحة الكلية".tr,
                                                    hintText:
                                                        "المساحة الكلية".tr),
                                                onSaved: (totalArea) {
                                                  controller.total_area =
                                                      totalArea!;
                                                },
                                                validator: (text) {
                                                  if (text == null ||
                                                      text.isEmpty) {
                                                    return "emptytextfieldvalidation"
                                                        .tr;
                                                  }

                                                  return null;
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 6.h,
                                    ),
                                    Visibility(
                                      visible:
                                          controller.isBedAndBathroomNumVisible,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                hintText: "room_num".tr,
                                                labelText: "room_num".tr,
                                              ),
                                              onSaved: (roomNum) {
                                                controller.sleep_room_count =
                                                    roomNum!;
                                              },
                                              validator: (text) {
                                                if (text == null ||
                                                    text.isEmpty) {
                                                  return 'emptytextfieldvalidation'
                                                      .tr;
                                                }

                                                return null;
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            width: 15.w,
                                          ),
                                          Expanded(
                                            child: TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                hintText: "bath_num".tr,
                                                labelText: "bath_num".tr,
                                              ),
                                              onSaved: (bathNum) {
                                                controller.bath_room_count =
                                                    bathNum!;
                                              },
                                              validator: (text) {
                                                if (text == null ||
                                                    text.isEmpty) {
                                                  return 'emptytextfieldvalidation'
                                                      .tr;
                                                }

                                                return null;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Visibility(
                                      visible:
                                          controller.isBedAndBathroomNumVisible,
                                      child: SizedBox(
                                        height: 6.h,
                                      ),
                                    ),
                                    Visibility(
                                      visible: controller.isLevelNumVisible,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: TextFormField(
                                              keyboardType:
                                                  TextInputType.number,
                                              decoration: InputDecoration(
                                                hintText: "level_height".tr,
                                                labelText: "level_height".tr,
                                              ),
                                              onSaved: (levelHeight) {
                                                controller.floor_height =
                                                    levelHeight!;
                                              },
                                              validator: (text) {
                                                if (text == null ||
                                                    text.isEmpty) {
                                                  return "emptytextfieldvalidation"
                                                      .tr;
                                                }

                                                return null;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15.h,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                color: Colors.white,
                                padding: EdgeInsets.symmetric(
                                    vertical: 5.h,
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            .05),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 6.h,
                                    ),
                                    Text(
                                      "direction".tr,
                                      style: TextStyle(
                                          fontSize: 17.sp,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: directions.length ~/ 2,
                                      itemBuilder: (_, int index) {
                                        return Row(
                                          children: [
                                            Card(
                                              color: Colors.white,
                                              child: SizedBox(
                                                width: Get.width * .4,
                                                child: CheckboxListTile(
                                                  title:
                                                      Text(directions[index]),
                                                  value: controller
                                                      .selectedDirectionIndex
                                                      .contains(index),
                                                  onChanged: (_) {
                                                    if (controller
                                                        .selectedDirectionIndex
                                                        .contains(index)) {
                                                      controller.removeDirection(
                                                          index); // unselect
                                                    } else {
                                                      controller.addDirection(
                                                          index); // select
                                                    }
                                                  },
                                                  controlAffinity:
                                                      ListTileControlAffinity
                                                          .leading,
                                                ),
                                              ),
                                            ),
                                            Card(
                                              color: Colors.white,
                                              child: SizedBox(
                                                width: Get.width * .4,
                                                child: CheckboxListTile(
                                                  title: Text(
                                                      directions[index + 2]),
                                                  value: controller
                                                      .selectedDirectionIndex
                                                      .contains(index + 2),
                                                  onChanged: (_) {
                                                    if (controller
                                                        .selectedDirectionIndex
                                                        .contains(index + 2)) {
                                                      controller.removeDirection(
                                                          index +
                                                              2); // unselect
                                                    } else {
                                                      controller.addDirection(
                                                          index + 2); // select
                                                    }
                                                  },
                                                  controlAffinity:
                                                      ListTileControlAffinity
                                                          .leading,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                        // return Card(
                                        //   color: Colors.white,
                                        //   child: CheckboxListTile(
                                        //     title: Text(this.directions[index]),
                                        //     value: controller.selectedDirectionIndex
                                        //         .contains(index),
                                        //     onChanged: (_) {
                                        //       if (controller.selectedDirectionIndex
                                        //           .contains(index)) {
                                        //         controller
                                        //             .removeDirection(index); // unselect
                                        //       } else {
                                        //         controller
                                        //             .addDirection(index); // select
                                        //       }
                                        //     },
                                        //     controlAffinity:
                                        //         ListTileControlAffinity.leading,
                                        //   ),
                                        // );
                                      },
                                    ),
                                    SizedBox(
                                      height: 8.h,
                                    ),
                                    Obx(() {
                                      return controller
                                                  .directionmultiValid.value ==
                                              true
                                          ? const SizedBox(
                                              height: 1,
                                            )
                                          : const Text(
                                              "لا يمكن اختيار هاتان الجهتان معاً.",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            );
                                    }),
                                    Obx(() {
                                      return controller.directionValid.value
                                          ? const SizedBox(
                                              height: 1,
                                            )
                                          : const Text(
                                              "الرجاء تحديد واجهة العقار على الطريق.",
                                              style:
                                                  TextStyle(color: Colors.red),
                                            );
                                    }),
                                    SizedBox(
                                      height: 15.h,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 25.h),
                                child: Center(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      fixedSize: Size(Get.width * .9, 50),
                                    ),
                                    onPressed: () async {
                                      print(controller
                                          .selectedDirectionIndex.length);
                                      if (_formKey.currentState!.validate() &&
                                          (controller.address_latitude !=
                                                  null &&
                                              controller.selectedDirectionIndex
                                                  .isNotEmpty &&
                                              controller
                                                  .directionValid.value)) {
                                        _formKey.currentState!.save();
                                        if (Get.find<PropertyController>()
                                                .isCheminyVisible ||
                                            Get.find<PropertyController>()
                                                .isPoolVisible ||
                                            Get.find<PropertyController>()
                                                .isElevatorVisible ||
                                            Get.find<PropertyController>()
                                                .isRockCoverVisible ||
                                            Get.find<PropertyController>()
                                                .isStairCoverVisible ||
                                            Get.find<PropertyController>()
                                                .isAltEnergyVisible ||
                                            Get.find<PropertyController>()
                                                .isWaterWellVisible ||
                                            Get.find<PropertyController>()
                                                .isGreenHouseVisible) {
                                          Get.to(AddPropertyTwo());
                                        } else {
                                          Get.to(AddPropertyThree());
                                        }
                                      } else {
                                        if (controller.address_latitude ==
                                            null) {
                                          controller.locationValid.value =
                                              false;
                                        }

                                        if (controller
                                            .selectedDirectionIndex.isEmpty) {
                                          controller.directionValid.value =
                                              false;
                                        }
                                      }
                                    },
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10.h),
                                      child: Text(
                                        'next'.tr,
                                        style: TextStyle(
                                            fontSize: 17.sp,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                ))
              : NoInternetConnection(),
        ),
      ),
    );
  }
}
