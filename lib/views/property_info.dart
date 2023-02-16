import 'package:catalog/controllers/auth_viewmodel.dart';
import 'package:catalog/controllers/firebase_dynamic_link.dart';
import 'package:catalog/controllers/home_info_controller.dart';
import 'package:catalog/controllers/search_viewmodel.dart';
import 'package:catalog/helpers/http_helper.dart';
import 'package:catalog/views/broker_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class PropertyInfo extends GetWidget<HomeInfoController> {
  PropertyInfo({Key? key}) : super(key: key);

  var f = NumberFormat("#,###", "en_US");
  final CarouselController _carouselcontroller = CarouselController();

  List<DataRow> buildRoomDetails() {
    List<DataRow> roomlist = [];
    for (var element in Get.find<HomeInfoController>().home.rooms!) {
      var roomcell = new DataRow(cells: [
        DataCell(Text(element.type!)),
        DataCell(
          FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(element.length! +
                'meter'.tr +
                ' * ' +
                element.width! +
                'meter'.tr),
          ),
        ),
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
        child: Stack(
          children: [
            SingleChildScrollView(
              child: GetBuilder<HomeInfoController>(
                  init: Get.put(HomeInfoController()),
                  builder: (homeController) {
                    return homeController.isLoading.value
                        ? Shimmer.fromColors(
                            baseColor: (Colors.grey[300])!,
                            highlightColor: (Colors.grey[100])!,
                            enabled: true,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                  color: Colors.white,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 7.h, left: 20.w, right: 20.w),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        height: 30.h,
                                        width: 175.w,
                                        color: Colors.white,
                                      ),
                                      Container(
                                        height: 30,
                                        width: 30,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.w),
                                  child: Container(
                                    height: 50.h,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.w),
                                  child: Container(
                                    height: 50.h,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.w),
                                  child: Container(
                                    height: 50.h,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.w),
                                  child: Container(
                                    height: 50.h,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ))
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                child: Stack(
                                  alignment: AlignmentDirectional.bottomCenter,
                                  children: [
                                    Hero(
                                      tag:
                                          'image_${homeController.home.realEstate?.id}_details',
                                      child: CarouselSlider.builder(
                                          itemCount:
                                              homeController.home.image!.length,
                                          itemBuilder: (BuildContext context,
                                                  int itemIndex,
                                                  int pageViewIndex) =>
                                              Image.network(
                                                homeController.home
                                                    .image![itemIndex].image!,
                                                fit: BoxFit.fill,
                                                height: Get.height * 0.44,
                                                loadingBuilder: (context, child,
                                                    loadingProgress) {
                                                  if (loadingProgress == null) {
                                                    return child;
                                                  }
                                                  homeController
                                                      .homeCarouselIndicator
                                                      .value = itemIndex;
                                                  return Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      value: loadingProgress
                                                                  .expectedTotalBytes !=
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
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 7.h, left: 20.w, right: 20.w),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            f.format(int.parse(homeController
                                                .home.realEstate!.price!)),
                                            style: TextStyle(
                                              fontSize: 21.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Center(
                                            child: LikeButton(
                                              onTap: (isLiked) async {
                                                print(isLiked);
                                                if (isLiked) {
                                                  Get.find<SearchViewModel>()
                                                      .unlikeProduct(
                                                          homeController.home
                                                              .realEstate!.id!);
                                                  return false;
                                                } else {
                                                  Get.find<SearchViewModel>()
                                                      .likeProductInfo(
                                                          homeController.home);
                                                  return true;
                                                }
                                              },
                                              isLiked:
                                                  Get.find<SearchViewModel>()
                                                      .favoritePropertiesId
                                                      .contains(homeController
                                                          .home
                                                          .realEstate!
                                                          .id!),
                                              likeBuilder: (bool isLiked) {
                                                return Icon(
                                                  isLiked
                                                      ? Icons.star
                                                      : Icons
                                                          .star_border_outlined,
                                                  color: isLiked
                                                      ? Colors.yellow[700]
                                                      : Get.isDarkMode
                                                          ? Colors.white
                                                          : Colors.black,
                                                  size: 35,
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.w),
                                      child: Text(
                                          homeController
                                              .home.realEstate!.addressTitle!,
                                          style: const TextStyle(fontSize: 20)),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.w),
                                      child:
                                          (homeController.home.realEstate!
                                                          .natureId! ==
                                                      "1" ||
                                                  homeController
                                                          .home
                                                          .realEstate!
                                                          .natureId! ==
                                                      "2" ||
                                                  homeController
                                                          .home
                                                          .realEstate!
                                                          .natureId! ==
                                                      "6")
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const Icon(
                                                                Icons.hotel),
                                                            Text("  " +
                                                                homeController
                                                                    .home
                                                                    .realEstate!
                                                                    .sleepRoomCount! +
                                                                " " +
                                                                'bed_room'.tr),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const Icon(
                                                                Icons.bathtub),
                                                            Text("  " +
                                                                homeController
                                                                    .home
                                                                    .realEstate!
                                                                    .bathRoomCount! +
                                                                " " +
                                                                'bath_room'.tr),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const Icon(
                                                                Icons.house),
                                                            Text("  " +
                                                                homeController
                                                                    .home
                                                                    .realEstate!
                                                                    .area! +
                                                                " " +
                                                                'meter'.tr),
                                                          ],
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const Icon(Icons
                                                                .zoom_out_map),
                                                            Text("  " +
                                                                homeController
                                                                    .home
                                                                    .realEstate!
                                                                    .totalArea! +
                                                                " " +
                                                                'meter'.tr +
                                                                " " +
                                                                'overal'.tr),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                )
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                const Icon(Icons
                                                                    .house),
                                                                Text("  " +
                                                                    homeController
                                                                        .home
                                                                        .realEstate!
                                                                        .area! +
                                                                    " " +
                                                                    'meter'.tr),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            const Icon(Icons
                                                                .zoom_out_map),
                                                            Text("  " +
                                                                homeController
                                                                    .home
                                                                    .realEstate!
                                                                    .totalArea! +
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
                                  height: 10,
                                  color: Get.isDarkMode
                                      ? Colors.grey
                                      : Colors.grey[200]),
                              Container(
                                height: 100.h,
                                child: GoogleMap(
                                  initialCameraPosition: CameraPosition(
                                      target: LatLng(
                                        double.parse(
                                            (controller.home.realEstate?.lat)!),
                                        double.parse((controller
                                            .home.realEstate?.long)!),
                                      ),
                                      zoom: 13),
                                  zoomControlsEnabled: false,
                                  onMapCreated: (controller) => this
                                      .controller
                                      .setGoolgeMapController(controller),
                                  rotateGesturesEnabled: false,
                                  mapType: MapType.normal,
                                  markers: controller.myMarker,
                                ),
                              ),
                              Container(
                                  height: 10,
                                  color: Get.isDarkMode
                                      ? Colors.grey
                                      : Colors.grey[200]),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20.w, vertical: 5.h),
                                child: Column(
                                  children: [
                                    const Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        "شارك هذا العقار مع الأخرين",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    Divider(),
                                    SizedBox(
                                      height: 7.h,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            String generatedDeepLink =
                                                // ignore: prefer_interpolation_to_compose_strings
                                                "https://haidara993.github.io/#/homeinfo/" +
                                                    homeController
                                                        .home.realEstate!.id!
                                                        .toString();

                                            Share.share(generatedDeepLink).then(
                                                (value) =>
                                                    homeController.sendPoints(
                                                        Get.find<
                                                                AuthViewModel>()
                                                            .userModel!
                                                            .id!
                                                            .toString(),
                                                        10));
                                          },
                                          child: const Icon(
                                            Icons.share,
                                            size: 35,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Get.defaultDialog(
                                              title: 'امسح رمز QR',
                                              content: Container(
                                                height: 200.h,
                                                width: 200.w,
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: QrImage(
                                                  data:
                                                      "https://haidara993.github.io/#/homeinfo/" +
                                                          homeController.home
                                                              .realEstate!.id!
                                                              .toString(),
                                                  version: QrVersions.auto,
                                                  size: 200.0,
                                                ),
                                              ),
                                            );
                                          },
                                          child: const Icon(
                                            Icons.qr_code,
                                            size: 35,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                  height: 10,
                                  color: Get.isDarkMode
                                      ? Colors.grey
                                      : Colors.grey[200]),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20.w, vertical: 5.h),
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        "room_details".tr,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    Divider(),
                                    SizedBox(
                                      height: 7.h,
                                    ),
                                    homeController.home.rooms?.length == 0
                                        ? const Align(
                                            alignment: Alignment.centerRight,
                                            child: Text(
                                              "لايوجد تفاصيل لهذا العقار",
                                              textAlign: TextAlign.right,
                                            ),
                                          )
                                        : Container(
                                            padding: EdgeInsets.all(10.h),
                                            child: DataTable(
                                              columns: <DataColumn>[
                                                DataColumn(
                                                  label: Text(
                                                    'room'.tr,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'dimensions'.tr,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'الطابق'.tr,
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                              rows: buildRoomDetails(),
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                              Container(
                                  height: 10,
                                  color: Get.isDarkMode
                                      ? Colors.grey
                                      : Colors.grey[200]),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 5.h),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.w),
                                      child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          "features".tr,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Divider(),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.w),
                                      child: DataTable(
                                        columnSpacing: 90,
                                        columns: const <DataColumn>[
                                          DataColumn(
                                            label: Text(
                                              'الميزة',
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              '',
                                            ),
                                          ),
                                        ],
                                        rows: <DataRow>[
                                          // DataRow(
                                          //   cells: <DataCell>[
                                          //     DataCell(Row(
                                          //       children: [
                                          //         SvgPicture.asset(
                                          //             'assets/icons/category.svg',
                                          //             height: 20.h),
                                          //         Text(
                                          //           " " + 'category'.tr,
                                          //         ),
                                          //       ],
                                          //     )),
                                          //     DataCell(Text(homeController
                                          //         .home.state!.state!)),
                                          //   ],
                                          // ),
                                          // DataRow(
                                          //   cells: <DataCell>[
                                          //     DataCell(Row(
                                          //       children: [
                                          //         SvgPicture.asset(
                                          //             'assets/icons/area.svg',
                                          //             height: 20.h),
                                          //         Text(
                                          //           " " + 'area'.tr,
                                          //         ),
                                          //       ],
                                          //     )),
                                          //     DataCell(Text(homeController.home
                                          //             .realEstate!.totalArea! +
                                          //         'meter'.tr)),
                                          //   ],
                                          // ),
                                          // DataRow(
                                          //   cells: <DataCell>[
                                          //     DataCell(Text(
                                          //       'direction'.tr,
                                          //       style: const TextStyle(
                                          //           color: Colors.grey),
                                          //     )),
                                          //     DataCell(Text(homeController
                                          //         .home.realEstate!.direction_id!)),
                                          //   ],
                                          // ),
                                          DataRow(
                                            cells: <DataCell>[
                                              DataCell(Row(
                                                children: [
                                                  SvgPicture.asset(
                                                      'assets/icons/chimney.svg',
                                                      height: 20.h),
                                                  Text(
                                                    " " + 'is_there_chimeny'.tr,
                                                  ),
                                                ],
                                              )),
                                              DataCell(Icon(
                                                homeController
                                                            .home
                                                            .realEstate!
                                                            .options!
                                                            .chimney! ==
                                                        "true"
                                                    ? Icons.check
                                                    : Icons.dangerous_outlined,
                                                color: homeController
                                                            .home
                                                            .realEstate!
                                                            .options!
                                                            .chimney! ==
                                                        "true"
                                                    ? Colors.green
                                                    : Colors.red,
                                              )),
                                            ],
                                          ),
                                          DataRow(
                                            cells: <DataCell>[
                                              DataCell(Row(
                                                children: [
                                                  SvgPicture.asset(
                                                      'assets/icons/pool.svg',
                                                      height: 20.h),
                                                  Text(
                                                    " " + 'is_there_pool'.tr,
                                                  ),
                                                ],
                                              )),
                                              DataCell(Icon(
                                                homeController
                                                            .home
                                                            .realEstate!
                                                            .options!
                                                            .swimmingPool! ==
                                                        "true"
                                                    ? Icons.check
                                                    : Icons.dangerous_outlined,
                                                color: homeController
                                                            .home
                                                            .realEstate!
                                                            .options!
                                                            .swimmingPool! ==
                                                        "true"
                                                    ? Colors.green
                                                    : Colors.red,
                                              )),
                                            ],
                                          ),
                                          DataRow(
                                            cells: <DataCell>[
                                              DataCell(Row(
                                                children: [
                                                  SvgPicture.asset(
                                                      'assets/icons/elevator.svg',
                                                      height: 20.h),
                                                  Text(
                                                    " " +
                                                        'is_there_elevator'.tr,
                                                  ),
                                                ],
                                              )),
                                              DataCell(Icon(
                                                homeController
                                                            .home
                                                            .realEstate!
                                                            .options!
                                                            .elevator! ==
                                                        "true"
                                                    ? Icons.check
                                                    : Icons.dangerous_outlined,
                                                color: homeController
                                                            .home
                                                            .realEstate!
                                                            .options!
                                                            .elevator! ==
                                                        "true"
                                                    ? Colors.green
                                                    : Colors.red,
                                              )),
                                            ],
                                          ),
                                          DataRow(
                                            cells: <DataCell>[
                                              DataCell(Row(
                                                children: [
                                                  SvgPicture.asset(
                                                      'assets/icons/rock_cover.svg',
                                                      height: 20.h),
                                                  FittedBox(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    fit: BoxFit.contain,
                                                    child: Text(
                                                      " " +
                                                          'is_thee_building_cover'
                                                              .tr,
                                                      style: TextStyle(
                                                          fontSize: 14),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                              DataCell(Icon(
                                                homeController
                                                            .home
                                                            .realEstate!
                                                            .options!
                                                            .withRocks! ==
                                                        "true"
                                                    ? Icons.check
                                                    : Icons.dangerous_outlined,
                                                color: homeController
                                                            .home
                                                            .realEstate!
                                                            .options!
                                                            .withRocks! ==
                                                        "true"
                                                    ? Colors.green
                                                    : Colors.red,
                                              )),
                                            ],
                                          ),
                                          DataRow(
                                            cells: <DataCell>[
                                              DataCell(Row(
                                                children: [
                                                  SvgPicture.asset(
                                                      'assets/icons/stairs.svg',
                                                      height: 20.h),
                                                  Text(
                                                    " " +
                                                        'is_the_stairs_cover'
                                                            .tr,
                                                  ),
                                                ],
                                              )),
                                              DataCell(Icon(
                                                homeController
                                                            .home
                                                            .realEstate!
                                                            .options!
                                                            .staircase! ==
                                                        "true"
                                                    ? Icons.check
                                                    : Icons.dangerous_outlined,
                                                color: homeController
                                                            .home
                                                            .realEstate!
                                                            .options!
                                                            .staircase! ==
                                                        "true"
                                                    ? Colors.green
                                                    : Colors.red,
                                              )),
                                            ],
                                          ),
                                          DataRow(
                                            cells: <DataCell>[
                                              DataCell(Row(
                                                children: [
                                                  SvgPicture.asset(
                                                      'assets/icons/alt_energy.svg',
                                                      height: 20.h),
                                                  Text(
                                                    " " +
                                                        'is_equipped_with_solar_power'
                                                            .tr,
                                                  ),
                                                ],
                                              )),
                                              DataCell(Icon(
                                                homeController
                                                            .home
                                                            .realEstate!
                                                            .options!
                                                            .alternativeEnergy! ==
                                                        "true"
                                                    ? Icons.check
                                                    : Icons.dangerous_outlined,
                                                color: homeController
                                                            .home
                                                            .realEstate!
                                                            .options!
                                                            .alternativeEnergy! ==
                                                        "true"
                                                    ? Colors.green
                                                    : Colors.red,
                                              )),
                                            ],
                                          ),
                                          DataRow(
                                            cells: <DataCell>[
                                              DataCell(Row(
                                                children: [
                                                  SvgPicture.asset(
                                                      'assets/icons/well.svg',
                                                      height: 20.h),
                                                  Text(
                                                    " " + 'is_there_well'.tr,
                                                  ),
                                                ],
                                              )),
                                              DataCell(Icon(
                                                homeController
                                                            .home
                                                            .realEstate!
                                                            .options!
                                                            .waterWell! ==
                                                        "true"
                                                    ? Icons.check
                                                    : Icons.dangerous_outlined,
                                                color: homeController
                                                            .home
                                                            .realEstate!
                                                            .options!
                                                            .waterWell! ==
                                                        "true"
                                                    ? Colors.green
                                                    : Colors.red,
                                              )),
                                            ],
                                          ),
                                          DataRow(
                                            cells: <DataCell>[
                                              DataCell(Row(
                                                children: [
                                                  SvgPicture.asset(
                                                      'assets/icons/hangar.svg',
                                                      height: 20.h),
                                                  Text(
                                                    " " + 'is_there_hanger'.tr,
                                                  ),
                                                ],
                                              )),
                                              DataCell(Icon(
                                                homeController.home.realEstate!
                                                            .options!.hangar! ==
                                                        "true"
                                                    ? Icons.check
                                                    : Icons.dangerous_outlined,
                                                color: homeController
                                                            .home
                                                            .realEstate!
                                                            .options!
                                                            .hangar! ==
                                                        "true"
                                                    ? Colors.green
                                                    : Colors.red,
                                              )),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                  height: 10,
                                  color: Get.isDarkMode
                                      ? Colors.grey
                                      : Colors.grey[200]),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 5.h),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Text(
                                        "المكتب العقاري".tr,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 10.h),
                                      child: GestureDetector(
                                        onTap: () {
                                          Get.to(BrokerInfo());
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10.h),
                                              child: const CircleAvatar(
                                                radius: 32,
                                                backgroundColor: Colors.grey,
                                                child: CircleAvatar(
                                                  radius: 30,
                                                  backgroundColor: Colors.blue,
                                                  // backgroundImage: NetworkImage(
                                                  //   controller.cartProductModel[index].image,
                                                  // ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 15.w),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    homeController.broker.name!,
                                                    style: TextStyle(
                                                        fontSize: 20.sp,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(homeController
                                                      .broker.region!),
                                                  // Text(homeController.broker.phone!),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                  height: 100,
                                  color: Get.isDarkMode
                                      ? Colors.grey
                                      : Colors.grey[200]),
                            ],
                          );
                  }),
            ),
            Positioned(
                bottom: 0,
                top: Get.height - 100.h,
                child: Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        top: BorderSide(
                          width: 1,
                          color: Colors.black,
                        ),
                      )),
                  height: 90.h,
                  width: Get.width,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // InkWell(
                        //   onTap:()async{
                        //     final Uri launchUri = Uri(
                        //       scheme: 'tel',
                        //       path: "+963936902307",
                        //     );
                        //     await launchUrl(launchUri);
                        //   },
                        //   child: Container(
                        //     decoration: BoxDecoration(
                        //       color: Colors.green,
                        //       borderRadius: BorderRadius.circular(10),
                        //     ),
                        //     height: 50.h,
                        //     width: Get.width / 3,
                        //     child: const Icon(
                        //       Icons.wechat,
                        //       size: 25,
                        //       color: Colors.white,
                        //     ),
                        //   ),
                        // ),
                        InkWell(
                          onTap: () async {
                            final Uri launchUri = Uri(
                              scheme: 'tel',
                              path:
                                  Get.find<HomeInfoController>().broker.phone!,
                            );
                            await launchUrl(launchUri);
                            Get.find<HomeInfoController>().callBroker();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: 50.h,
                            width: Get.width / 2,
                            child: const Icon(
                              Icons.call,
                              size: 25,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
