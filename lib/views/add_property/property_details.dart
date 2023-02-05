// ignore_for_file: must_be_immutable

import 'package:carousel_slider/carousel_slider.dart';
import 'package:catalog/models/property_model.dart';
import 'package:catalog/views/add_property/payment_page.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';

import '../../controllers/property_controller.dart';
import '../../utils/app_color.dart';

class PropertyDetails extends GetWidget<PropertyController> {
  PropertyModel home;
  PropertyDetails({Key? key, required this.home}) : super(key: key);

  var f = NumberFormat("#,###", "en_US");

  List<DataRow> buildRoomDetails() {
    List<DataRow> roomlist = [];
    for (var element in controller.home.rooms!) {
      // ignore: unnecessary_new
      var roomcell = new DataRow(cells: [
        DataCell(Text('الأرضي'.tr)),
        DataCell(Text(element.type!)),
        DataCell(Text(element.length! + ' * ' + element.width! + 'meter'.tr)),
        DataCell(Text(element.floor!)),
      ]);
      roomlist.add(roomcell);
    }
    return roomlist;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    Hero(
                      tag: 'image_${home.realEstate?.id}_details',
                      child: CarouselSlider.builder(
                          itemCount: home.image!.length,
                          itemBuilder: (BuildContext context, int itemIndex,
                                  int pageViewIndex) =>
                              Image.network(
                                home.image![itemIndex].image!,
                                fit: BoxFit.fill,
                                height: Get.height * 0.44,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  controller.homeCarouselIndicator.value =
                                      itemIndex;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    ),
                                  );
                                },
                              ),
                          options: CarouselOptions(
                            height: Get.height * 0.44,
                            viewportFraction: 1,
                            initialPage: 0,
                            enableInfiniteScroll: false,
                            enlargeCenterPage: true,
                            scrollDirection: Axis.horizontal,
                          )),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 15),
                margin: const EdgeInsets.only(bottom: 10),
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.only(top: 7.h, left: 20.w, right: 20.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            f.format(int.parse(home.realEstate!.price!)),
                            style: TextStyle(
                              fontSize: 21.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Text(home.realEstate!.addressTitle!,
                          style: const TextStyle(fontSize: 20)),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(Icons.hotel),
                                  Text("  " +
                                      home.realEstate!.sleepRoomCount! +
                                      " " +
                                      'bed_room'.tr),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(Icons.bathtub),
                                  Text("  " +
                                      home.realEstate!.bathRoomCount! +
                                      " " +
                                      'bath_room'.tr),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(Icons.house),
                                  Text("  " +
                                      home.realEstate!.area! +
                                      " " +
                                      'meter'.tr),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(Icons.zoom_out_map),
                                  Text("  " +
                                      home.realEstate!.totalArea! +
                                      " " +
                                      'meter'.tr +
                                      " " +
                                      'overal'.tr),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 100.h,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                      target: LatLng(
                        double.parse(controller.address_latitude!),
                        double.parse(controller.address_longitude!),
                      ),
                      zoom: 13),
                  zoomControlsEnabled: false,
                  onMapCreated: (controller) =>
                      this.controller.setGoolgeMapController(controller),
                  rotateGesturesEnabled: false,
                  mapType: MapType.normal,
                  markers: controller.myMarker,
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              Container(
                decoration: const BoxDecoration(
                    border: Border(
                  top: BorderSide(color: Colors.black12, width: 1.0),
                  bottom: BorderSide(color: Colors.black12, width: 1.0),
                )),
                child: ExpandablePanel(
                  theme: const ExpandableThemeData(
                    headerAlignment: ExpandablePanelHeaderAlignment.center,
                    tapBodyToCollapse: true,
                  ),
                  header: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "room_details".tr,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )),
                  collapsed: const SizedBox.shrink(),
                  expanded: Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(10.h),
                    child: DataTable(
                      columns: <DataColumn>[
                        DataColumn(
                          label: Text(
                            'level'.tr,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'room'.tr,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'dimensions'.tr,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'الطابق'.tr,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                      rows: buildRoomDetails(),
                    ),
                  ),
                  builder: (_, collapsed, expanded) {
                    return Padding(
                      padding: EdgeInsets.only(
                          left: 10.w, right: 10.w, bottom: 10.h),
                      child: Expandable(
                        collapsed: collapsed,
                        expanded: expanded,
                        theme: const ExpandableThemeData(crossFadePoint: 0),
                      ),
                    );
                  },
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.black12, width: 1.0),
                  ),
                ),
                child: ExpandablePanel(
                  theme: const ExpandableThemeData(
                    headerAlignment: ExpandablePanelHeaderAlignment.center,
                    tapBodyToCollapse: true,
                  ),
                  header: Padding(
                      padding: EdgeInsets.all(10.h),
                      child: Text(
                        "features".tr,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )),
                  collapsed: const SizedBox.shrink(),
                  expanded: DataTable(
                    columnSpacing: 100,
                    columns: const <DataColumn>[
                      DataColumn(
                        label: Text(
                          '',
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          '',
                        ),
                      ),
                    ],
                    rows: <DataRow>[
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text(
                            'category'.tr,
                            style: const TextStyle(color: Colors.grey),
                          )),
                          DataCell(Text(controller.home.state!.state!)),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text(
                            'area'.tr,
                            style: const TextStyle(color: Colors.grey),
                          )),
                          DataCell(Text(
                              controller.home.realEstate!.area! + 'meter'.tr)),
                        ],
                      ),
                      // DataRow(
                      //   cells: <DataCell>[
                      //     DataCell(Text(
                      //       'direction'.tr,
                      //       style: TextStyle(color: Colors.grey),
                      //     )),
                      //     DataCell(
                      //         Text(controller.home.realEstate!.direction!)),
                      //   ],
                      // ),
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text(
                            'is_there_chimeny'.tr,
                            style: const TextStyle(color: Colors.grey),
                          )),
                          DataCell(Text(
                              controller.home.realEstate!.options!.chimney! ==
                                      "true"
                                  ? "true".tr
                                  : "false".tr)),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text(
                            'is_there_pool'.tr,
                            style: const TextStyle(color: Colors.grey),
                          )),
                          DataCell(Text(controller.home.realEstate!.options!
                                      .swimmingPool! ==
                                  "true"
                              ? "true".tr
                              : "false".tr)),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text(
                            'is_there_elevator'.tr,
                            style: const TextStyle(color: Colors.grey),
                          )),
                          DataCell(Text(
                              controller.home.realEstate!.options!.elevator! ==
                                      "true"
                                  ? "true".tr
                                  : "false".tr)),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text(
                            'is_thee_building_cover'.tr,
                            style: const TextStyle(color: Colors.grey),
                          )),
                          DataCell(Text(
                              controller.home.realEstate!.options!.withRocks! ==
                                      "true"
                                  ? "true".tr
                                  : "false".tr)),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text(
                            'is_the_stairs_cover'.tr,
                            style: const TextStyle(color: Colors.grey),
                          )),
                          DataCell(Text(
                              controller.home.realEstate!.options!.staircase! ==
                                      "true"
                                  ? "true".tr
                                  : "false".tr)),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text(
                            'is_equipped_with_solar_power'.tr,
                            style: const TextStyle(color: Colors.grey),
                          )),
                          DataCell(Text(controller.home.realEstate!.options!
                                      .alternativeEnergy! ==
                                  "true"
                              ? "true".tr
                              : "false".tr)),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text(
                            'is_there_well'.tr,
                            style: const TextStyle(color: Colors.grey),
                          )),
                          DataCell(Text(
                              controller.home.realEstate!.options!.waterWell! ==
                                      "1"
                                  ? "true".tr
                                  : "false".tr)),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text(
                            'is_there_hanger'.tr,
                            style: const TextStyle(color: Colors.grey),
                          )),
                          DataCell(Text(
                              controller.home.realEstate!.options!.hangar! ==
                                      "1"
                                  ? "true".tr
                                  : "false".tr)),
                        ],
                      ),
                    ],
                  ),
                  builder: (_, collapsed, expanded) {
                    return Padding(
                      padding: EdgeInsets.only(
                          left: 10.w, right: 10.w, bottom: 10.h),
                      child: Expandable(
                        collapsed: collapsed,
                        expanded: expanded,
                        theme: const ExpandableThemeData(crossFadePoint: 0),
                      ),
                    );
                  },
                ),
              ),
              // Container(
              //   decoration: const BoxDecoration(
              //     border: Border(
              //       bottom: BorderSide(color: Colors.black12, width: 1.0),
              //     ),
              //   ),
              //   child: ExpandablePanel(
              //     theme: const ExpandableThemeData(
              //       headerAlignment: ExpandablePanelHeaderAlignment.center,
              //       tapBodyToCollapse: true,
              //     ),
              //     header: Padding(
              //         padding: EdgeInsets.all(10.h),
              //         child: Text(
              //           "listed_brokers".tr,
              //           style: const TextStyle(fontWeight: FontWeight.bold),
              //         )),
              //     collapsed: const SizedBox.shrink(),
              //     expanded: ListView.separated(
              //         shrinkWrap: true,
              //         padding: EdgeInsets.zero,
              //         itemBuilder: (context, index) {
              //           return Column(
              //             children: [
              //               Padding(
              //                 padding: EdgeInsets.only(bottom: 10.h),
              //                 child: Row(
              //                   mainAxisAlignment: MainAxisAlignment.start,
              //                   children: [
              //                     Padding(
              //                       padding:
              //                           EdgeInsets.symmetric(horizontal: 10.h),
              //                       child: const CircleAvatar(
              //                         radius: 30,
              //                         backgroundColor: Colors.blue,
              //                         // backgroundImage: NetworkImage(
              //                         //   controller.cartProductModel[index].image,
              //                         // ),
              //                       ),
              //                     ),
              //                     Padding(
              //                       padding:
              //                           EdgeInsets.symmetric(horizontal: 15.w),
              //                       child: Column(
              //                         crossAxisAlignment:
              //                             CrossAxisAlignment.start,
              //                         children: [
              //                           Text(
              //                             DataConstants.brokers[index].name!,
              //                             style: TextStyle(
              //                                 fontSize: 20.sp,
              //                                 fontWeight: FontWeight.bold),
              //                           ),
              //                           Text(DataConstants
              //                               .brokers[index].address!),
              //                           Text(DataConstants
              //                               .brokers[index].phonenumber!),
              //                         ],
              //                       ),
              //                     )
              //                   ],
              //                 ),
              //               ),
              //               Padding(
              //                 padding: EdgeInsets.symmetric(horizontal: 10.w),
              //                 child: Row(
              //                   mainAxisAlignment:
              //                       MainAxisAlignment.spaceBetween,
              //                   children: [
              //                     Column(
              //                       children: [
              //                         const Icon(Icons.home),
              //                         const Text("معلومات"),
              //                       ],
              //                     ),
              //                     Column(
              //                       children: [
              //                         const Icon(Icons.phone),
              //                         const Text("اتصل بنا"),
              //                       ],
              //                     ),
              //                     Column(
              //                       children: [
              //                         const Icon(Icons.email),
              //                         const Text("أرسل ايميل"),
              //                       ],
              //                     ),
              //                     Column(
              //                       children: [
              //                         const Icon(Icons.insert_drive_file),
              //                         const Text("موقع الويب"),
              //                       ],
              //                     ),
              //                   ],
              //                 ),
              //               )
              //             ],
              //           );
              //         },
              //         separatorBuilder: (context, index) =>
              //             const Divider(color: Colors.grey),
              //         itemCount: DataConstants.brokers.length),
              //     builder: (_, collapsed, expanded) {
              //       return Padding(
              //         padding: EdgeInsets.only(
              //             left: 10.w, right: 10.w, bottom: 10.h),
              //         child: Expandable(
              //           collapsed: collapsed,
              //           expanded: expanded,
              //           theme: const ExpandableThemeData(crossFadePoint: 0),
              //         ),
              //       );
              //     },
              //   ),
              // ),
              // SizedBox(
              //   height: 15.h,
              // ),
              Center(
                child: ElevatedButton(
                  style: ButtonStyle(
                    minimumSize:
                        MaterialStateProperty.all<Size>(Size(200.w, 0)),
                    backgroundColor:
                        MaterialStateProperty.resolveWith<Color>((states) {
                      if (states.contains(MaterialState.disabled)) {
                        return AppColor.BlueBtn;
                      }
                      return AppColor.BlueBtn;
                    }),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    )),
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w)),
                    elevation: MaterialStateProperty.all<double>(0.5),
                  ),
                  onPressed: () async {
                    Get.off(const PaymentPage());
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 5.h),
                    child: Text(
                      'next'.tr,
                      style: TextStyle(fontSize: 15.sp, color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
