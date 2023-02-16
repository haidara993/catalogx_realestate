// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:catalog/controllers/auth_viewmodel.dart';
import 'package:catalog/controllers/control_viewmodel.dart';
import 'package:catalog/controllers/favorite_view_model.dart';
import 'package:catalog/controllers/saved_search_viewmodel.dart';
import 'package:catalog/enums/panel_state.dart';
import 'package:catalog/models/map_marker.dart';
import 'package:catalog/views/property_info.dart';
import 'package:catalog/views/search_filter_view.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:http/http.dart' as http;
import 'package:like_button/like_button.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uuid/uuid.dart';
import 'package:progress_indicators/progress_indicators.dart';

const String ACCESS_TOKEN = String.fromEnvironment(
    "pk.eyJ1IjoiaGFpZGFyYTk5MyIsImEiOiJjbDR3cWFrM2IxOTV1M2ptemh1bXIyeDVqIn0.Wf7fGtHwCX4lg3oY8AwlYA");
const MARKER_COLOR = Color(0xFF3DC5A7);
const MARKER_SIZE_BIG = 100.0;
const MARKER_SIZE_SMALL = 80.0;

class SavedSearchResult extends GetWidget<SavedSearchViewModel> {
  late double initlat, initlong, initzoom;

  SavedSearchResult({
    required this.initlat,
    required this.initlong,
    required this.initzoom,
  });
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(35.363149, 35.932120),
    zoom: 13,
  );
  ScrollController? scrollController;

  var uuid = const Uuid();

  var f = NumberFormat("#,###", "en_US");
  final panelTransation = const Duration(milliseconds: 500);

  void _onVerticalGesture(DragUpdateDetails details) {
    if (details.primaryDelta! < -7 &&
        Get.find<SavedSearchViewModel>().panelState == PanelState.hidden) {
      Get.find<SavedSearchViewModel>().changeToMidOpen();
    } else if (details.primaryDelta! < -7 &&
        Get.find<SavedSearchViewModel>().panelState == PanelState.midopen) {
      Get.find<SavedSearchViewModel>().changeToOpen();
    } else if (details.primaryDelta! > 7 &&
        Get.find<SavedSearchViewModel>().panelState == PanelState.open) {
      Get.find<SavedSearchViewModel>().changeToMidOpen();
    } else if (details.primaryDelta! > 7 &&
        Get.find<SavedSearchViewModel>().panelState == PanelState.midopen) {
      Get.find<SavedSearchViewModel>().changeToHidden();
      Get.find<SavedSearchViewModel>().changeSelectedIndex(-1);
    }
  }

  double? _getTopForPanel(PanelState state, Size size) {
    if (state == PanelState.open) {
      return 0;
    } else if (state == PanelState.midopen) {
      return (size.height * 0.5);
    } else if (state == PanelState.hidden) {
      return (size.height);
    }
  }

  double? _getSizeForPanel(PanelState state, Size size) {
    if (state == PanelState.open) {
      return size.height;
    } else if (state == PanelState.midopen) {
      return (size.height * 0.5);
    } else if (state == PanelState.hidden) {
      return (size.height * 0.5);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GetBuilder<SavedSearchViewModel>(builder: (savedcontroller) {
      return AnimatedBuilder(
          animation: SavedSearchViewModel(),
          builder: (context, _) {
            return Stack(
              children: [
                DefaultTabController(
                  length: 2,
                  child: Scaffold(
                    appBar: AppBar(
                      title: Text("العقارات المحفوظة"),
                      bottom: PreferredSize(
                        preferredSize: const Size.fromHeight(50),
                        child: Expanded(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TabBar(
                                  indicatorColor: HexColor("#ffffff"),
                                  isScrollable: true,
                                  tabs: [
                                    Tab(
                                      text: "map".tr,
                                    ),
                                    Tab(
                                      text: "list".tr,
                                    ),
                                  ]),
                              GetBuilder<SavedSearchViewModel>(
                                  builder: (searchController) {
                                return Container(
                                  width: MediaQuery.of(context).size.width / 2,
                                  alignment: Get.locale?.languageCode == 'ar'
                                      ? Alignment.centerLeft
                                      : Alignment.centerRight,
                                  child:
                                      Obx(() => searchController.isLoading.value
                                          ? Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const Text(
                                                  "يجري البحث ",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                JumpingDotsProgressIndicator(
                                                  fontSize: 25.0,
                                                  color: Colors.white,
                                                ),
                                              ],
                                            )
                                          : Text(
                                              "result".tr +
                                                  " (" +
                                                  searchController
                                                      .filteredProperties.length
                                                      .toString() +
                                                  ")",
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            )),
                                );
                              })
                            ],
                          ),
                        ),
                      ),
                    ),
                    body: SafeArea(
                      child: TabBarView(
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            GetBuilder<SavedSearchViewModel>(
                                init: SavedSearchViewModel(),
                                builder: (savecontroller) {
                                  return Stack(
                                    children: [
                                      Obx(() => GoogleMap(
                                            initialCameraPosition:
                                                CameraPosition(
                                              target: LatLng(initlat, initlong),
                                              zoom: initzoom,
                                            ),
                                            zoomControlsEnabled: false,
                                            onTap: (tapPosition) {
                                              Get.find<SavedSearchViewModel>()
                                                  .changeToHidden();
                                              print(tapPosition);
                                            },
                                            onMapCreated: (controller) async {
                                              await this
                                                  .controller
                                                  .setGoolgeMapController(
                                                      controller);
                                              // this.controller.getProperties();
                                            },
                                            compassEnabled: true,
                                            onCameraMove: (position) {
                                              this
                                                  .controller
                                                  .setCurrentPosition(position);
                                            },
                                            onCameraIdle: () {
                                              print("get data");
                                              // controller.getAllSavedSearchs();
                                            },
                                            rotateGesturesEnabled: false,
                                            mapType: MapType.satellite,
                                            markers: Set<Marker>.of(
                                                controller.markerList),
                                          )),
                                    ],
                                  );
                                }),
                            GetBuilder<SavedSearchViewModel>(
                              builder: (savedController) => Container(
                                color: Colors.grey[200],
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: savedController
                                          .filteredProperties.isEmpty
                                      ? const Center(
                                          child: Text("لايوجد أية عقارات"),
                                        )
                                      : Column(
                                          children: [
                                            ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  const BouncingScrollPhysics(),
                                              scrollDirection: Axis.vertical,
                                              itemCount: savedController
                                                  .filteredProperties.length,
                                              itemBuilder: (context, index) {
                                                return Container(
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      SharedPreferences prefs =
                                                          await SharedPreferences
                                                              .getInstance();
                                                      prefs.setInt(
                                                          "homeId",
                                                          int.parse(savedController
                                                              .filteredProperties[
                                                                  index]
                                                              .propertyId!));

                                                      Navigator.of(context)
                                                          .push(
                                                        PageRouteBuilder(
                                                          pageBuilder: (context,
                                                              animation, _) {
                                                            return FadeTransition(
                                                              opacity:
                                                                  animation,
                                                              child:
                                                                  PropertyInfo(),
                                                            );
                                                          },
                                                          transitionDuration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      900),
                                                        ),
                                                      );
                                                    },
                                                    child: Card(
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: 17.0),
                                                      // elevation: 3.0,
                                                      clipBehavior:
                                                          Clip.antiAlias,
                                                      shape:
                                                          const RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .all(
                                                        Radius.circular(15),
                                                      )),
                                                      child: Column(
                                                        children: [
                                                          Card(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    bottom:
                                                                        12.h),
                                                            clipBehavior:
                                                                Clip.antiAlias,
                                                            shape:
                                                                const RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .all(
                                                              Radius.circular(
                                                                  15),
                                                            )),
                                                            child: Container(
                                                              height: 220.h,
                                                              child: Stack(
                                                                children: [
                                                                  Hero(
                                                                    tag:
                                                                        'image_${savedController.filteredProperties[index].propertyId}_details',
                                                                    child: Image
                                                                        .asset(
                                                                      'assets/images/house/house1.jpeg',
                                                                      height:
                                                                          220.h,
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                  ),
                                                                  Container(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            20),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                            gradient:
                                                                                LinearGradient(
                                                                      colors: [
                                                                        Colors
                                                                            .transparent,
                                                                        Colors
                                                                            .black
                                                                            .withOpacity(0.7),
                                                                      ],
                                                                      begin: Alignment
                                                                          .topCenter,
                                                                      end: Alignment
                                                                          .bottomCenter,
                                                                      stops: [
                                                                        5.0,
                                                                        1.0
                                                                      ],
                                                                    )),
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Container(
                                                                              decoration: BoxDecoration(color: Colors.yellow[700], borderRadius: const BorderRadius.all(Radius.circular(5))),
                                                                              width: 80.w,
                                                                              padding: const EdgeInsets.symmetric(vertical: 4),
                                                                              child: Center(
                                                                                child: Text(
                                                                                  savedController.filteredProperties[index].category!,
                                                                                  style: const TextStyle(
                                                                                    color: Colors.white,
                                                                                    fontSize: 14,
                                                                                    fontWeight: FontWeight.bold,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            //                   AbsorbPointer(
                                                                            //   absorbing: false,
                                                                            //   child: Container(
                                                                            //     height: 40,
                                                                            //     width: 40,
                                                                            //     decoration:
                                                                            //         BoxDecoration(
                                                                            //       color: Colors
                                                                            //           .grey
                                                                            //           .withOpacity(
                                                                            //               .7),
                                                                            //       shape: BoxShape
                                                                            //           .circle,
                                                                            //     ),
                                                                            //     child: Center(
                                                                            //       child: Obx(() =>
                                                                            //           LikeButton(
                                                                            //             onTap:
                                                                            //                 (isLiked) async {
                                                                            //               print(
                                                                            //                   isLiked);
                                                                            //               if (isLiked) {
                                                                            //                 savedController.unlikeProduct(savedController
                                                                            //                     .filteredProperties[index]
                                                                            //                     .id!);
                                                                            //                 return false;
                                                                            //               } else {
                                                                            //                 savedController
                                                                            //                     .likeProduct(savedController.filteredProperties[index]);
                                                                            //                 return true;
                                                                            //               }
                                                                            //             },
                                                                            //             isLiked: savedController
                                                                            //                 .favoritePropertiesId
                                                                            //                 .contains(savedController
                                                                            //                     .filteredProperties[index]
                                                                            //                     .id!),
                                                                            //             likeBuilder:
                                                                            //                 (bool
                                                                            //                     isLiked) {
                                                                            //               return Icon(
                                                                            //                   isLiked
                                                                            //                       ? Icons.star
                                                                            //                       : Icons.star_border_outlined,
                                                                            //                   color: isLiked ? Colors.yellow[700] : Colors.black,
                                                                            //                   size: 30);
                                                                            //             },
                                                                            //           )),
                                                                            //     ),
                                                                            //   ),
                                                                            // ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        8.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Text(
                                                                  savedController
                                                                      .filteredProperties[
                                                                          index]
                                                                      .addressTitle!,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        15.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .star,
                                                                      color: Colors
                                                                              .yellow[
                                                                          700],
                                                                      size: 14,
                                                                    ),
                                                                    SizedBox(
                                                                      width:
                                                                          4.w,
                                                                    ),
                                                                    Text(
                                                                      "4.3 تقييم",
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            18.sp,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        8.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  f.format(int.parse(savedController
                                                                      .filteredProperties[
                                                                          index]
                                                                      .price!)),
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        18.sp,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 4.h,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        8.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                const Icon(
                                                                  Icons.hotel,
                                                                  color: Colors
                                                                      .black,
                                                                  size: 18,
                                                                ),
                                                                SizedBox(
                                                                  width: 4.w,
                                                                ),
                                                                Text(
                                                                  savedController
                                                                      .filteredProperties[
                                                                          index]
                                                                      .sleepRoomCount!,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        18.sp,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 8.w,
                                                                ),
                                                                const Icon(
                                                                  Icons.bathtub,
                                                                  color: Colors
                                                                      .black,
                                                                  size: 18,
                                                                ),
                                                                SizedBox(
                                                                  width: 4.w,
                                                                ),
                                                                Text(
                                                                  savedController
                                                                      .filteredProperties[
                                                                          index]
                                                                      .bathRoomCount!,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        18.sp,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 8.w,
                                                                ),
                                                                const Icon(
                                                                  Icons
                                                                      .zoom_out_map,
                                                                  color: Colors
                                                                      .black,
                                                                  size: 18,
                                                                ),
                                                                SizedBox(
                                                                  width: 4.w,
                                                                ),
                                                                Text(
                                                                  savedController
                                                                      .filteredProperties[
                                                                          index]
                                                                      .area!,
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        18.sp,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 15.h,
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            )
                                          ],
                                        ),
                                ),
                              ),
                            )
                          ]),
                    ),
                    floatingActionButton: FloatingActionButton(
                      foregroundColor: Colors.black,
                      onPressed: () => controller.googleMapController
                          .animateCamera(CameraUpdate.newCameraPosition(
                              _initialCameraPosition)),
                      child: const Icon(Icons.center_focus_strong),
                    ),
                  ),
                ),
                AnimatedPositioned(
                  duration: panelTransation,
                  curve: Curves.decelerate,
                  left: 0,
                  right: 0,
                  top: _getTopForPanel(savedcontroller.panelState, size),
                  height: _getSizeForPanel(savedcontroller.panelState, size),
                  child: GestureDetector(
                    onVerticalDragUpdate: _onVerticalGesture,
                    child: Container(
                      child: AnimatedSwitcher(
                        duration: panelTransation,
                        child: _buildPanelOption(context),
                      ),
                    ),
                  ),
                )
              ],
            );
          });
    });
  }

  Widget _buildPanelOption(BuildContext context) {
    if (Get.find<SavedSearchViewModel>().panelState == PanelState.midopen) {
      return _buildPanelWidget(context);
    } else if (Get.find<SavedSearchViewModel>().panelState == PanelState.open) {
      return _buildExpandedPanelWidget(context);
    } else {
      return const SizedBox.shrink();
    }
  }

  List<DataRow> buildRoomDetails() {
    List<DataRow> roomlist = [];
    for (var element in Get.find<SavedSearchViewModel>().home.rooms!) {
      var roomcell = new DataRow(cells: [
        DataCell(Text('الأرضي'.tr)),
        DataCell(Text(element.type!)),
        DataCell(Text(element.length! + ' * ' + element.width! + 'meter'.tr)),
      ]);
      roomlist.add(roomcell);
    }
    return roomlist;
  }

  Widget _buildExpandedPanelWidget(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.44,
                child: Stack(
                  children: [
                    CarouselSlider.builder(
                        itemCount:
                            Get.find<SavedSearchViewModel>().home.image!.length,
                        itemBuilder: (BuildContext context, int itemIndex,
                                int pageViewIndex) =>
                            Image.network(
                              Get.find<SavedSearchViewModel>()
                                  .home
                                  .image![itemIndex]
                                  .image!,
                              fit: BoxFit.fill,
                              height: Get.height * 0.44,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                }
                                Get.find<SavedSearchViewModel>()
                                    .homeCarouselIndicator
                                    .value = itemIndex;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
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
                    Positioned(
                      top: 10.h,
                      right: 10.w,
                      child: GestureDetector(
                        onTap: () {
                          Get.find<SavedSearchViewModel>().changeToMidOpen();
                          Get.find<SavedSearchViewModel>()
                              .changeSelectedIndex(-1);
                        },
                        child: Container(
                          height: 40.h,
                          width: 40.w,
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(45),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 7.h, left: 20.w, right: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.blue.shade600,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15.w),
                                child: Center(
                                  child: Text(
                                    'active'.tr,
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.purple.shade400,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15.w),
                                child: Center(
                                  child: Text(
                                    'open'.tr,
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Get.find<SavedSearchViewModel>().isLoading.value
                            ? const CircularProgressIndicator()
                            : Text(
                                Get.find<SavedSearchViewModel>()
                                    .home
                                    .realEstate!
                                    .price!,
                                style: TextStyle(
                                  fontSize: 21.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ],
                    ),
                    Center(
                      child: Icon(
                        Icons.star_border_outlined,
                        size: 30.sp,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text('address'.tr),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Get.find<SavedSearchViewModel>().isLoading.value
                    ? const CircularProgressIndicator()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(Get.find<SavedSearchViewModel>()
                                  .home
                                  .realEstate!
                                  .sleepRoomCount! +
                              'bed_room'.tr),
                          Text(Get.find<SavedSearchViewModel>()
                                  .home
                                  .realEstate!
                                  .bathRoomCount! +
                              'bath_room'.tr),
                          Text(Get.find<SavedSearchViewModel>()
                                  .home
                                  .realEstate!
                                  .area! +
                              'meter'.tr),
                          Text(Get.find<SavedSearchViewModel>()
                                  .home
                                  .realEstate!
                                  .totalArea! +
                              'meter'.tr +
                              'overal'.tr),
                        ],
                      ),
              ),
              Container(
                height: 60.h,
                padding: EdgeInsets.symmetric(vertical: 5.h),
                decoration: const BoxDecoration(
                    border: Border(
                  top: BorderSide(width: 1.0, color: Colors.black12),
                )),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        String generatedDeepLink =
                            // ignore: prefer_interpolation_to_compose_strings
                            "https://haidara993.github.io/#/homeinfo/" +
                                Get.find<SavedSearchViewModel>()
                                    .home
                                    .realEstate!
                                    .id!
                                    .toString();
                        //     await FirebaseDynamicLinkService
                        //         .createDynamicLink(
                        //             false,
                        //             homeController.home
                        //                 .realEstate!.id!);
                        Share.share(generatedDeepLink).then((value) =>
                            Get.find<ControlViewModel>().sendPoints(
                                Get.find<AuthViewModel>()
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
                            padding: const EdgeInsets.all(8.0),
                            child: QrImage(
                              data: "https://haidara993.github.io/#/homeinfo/" +
                                  Get.find<SavedSearchViewModel>()
                                      .home
                                      .realEstate!
                                      .id!
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
              ),
              SizedBox(
                height: 100.h,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                      target: LatLng(
                        double.parse(Get.find<SavedSearchViewModel>()
                            .home
                            .realEstate!
                            .lat!),
                        double.parse(Get.find<SavedSearchViewModel>()
                            .home
                            .realEstate!
                            .long!),
                      ),
                      zoom: 13),
                  zoomControlsEnabled: false,
                  onMapCreated: (controller) => Get.find<SavedSearchViewModel>()
                      .setMiniGoolgeMapController(controller),
                  rotateGesturesEnabled: false,
                  mapType: MapType.normal,
                  markers: Get.find<SavedSearchViewModel>().myMarker,
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
                    child: DataTable(columns: <DataColumn>[
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
                    ], rows: buildRoomDetails()),
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
                          DataCell(Text(Get.find<SavedSearchViewModel>()
                              .home
                              .state!
                              .state!)),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text(
                            'area'.tr,
                            style: const TextStyle(color: Colors.grey),
                          )),
                          DataCell(Text(Get.find<SavedSearchViewModel>()
                                  .home
                                  .realEstate!
                                  .area! +
                              'meter'.tr)),
                        ],
                      ),
                      // DataRow(
                      //   cells: <DataCell>[
                      //     DataCell(Text(
                      //       'direction'.tr,
                      //       style: TextStyle(color: Colors.grey),
                      //     )),
                      //     DataCell(Text(Get.find<SavedSearchViewModel>()
                      //         .home
                      //         .realEstate!
                      //         .direction!)),
                      //   ],
                      // ),
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text(
                            'is_there_chimeny'.tr,
                            style: const TextStyle(color: Colors.grey),
                          )),
                          DataCell(Text(Get.find<SavedSearchViewModel>()
                                      .home
                                      .realEstate!
                                      .options!
                                      .chimney! ==
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
                          DataCell(Text(Get.find<SavedSearchViewModel>()
                                      .home
                                      .realEstate!
                                      .options!
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
                          DataCell(Text(Get.find<SavedSearchViewModel>()
                                      .home
                                      .realEstate!
                                      .options!
                                      .elevator! ==
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
                          DataCell(Text(Get.find<SavedSearchViewModel>()
                                      .home
                                      .realEstate!
                                      .options!
                                      .withRocks! ==
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
                          DataCell(Text(Get.find<SavedSearchViewModel>()
                                      .home
                                      .realEstate!
                                      .options!
                                      .staircase! ==
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
                          DataCell(Text(Get.find<SavedSearchViewModel>()
                                      .home
                                      .realEstate!
                                      .options!
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
                          DataCell(Text(Get.find<SavedSearchViewModel>()
                                      .home
                                      .realEstate!
                                      .options!
                                      .waterWell! ==
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
                          DataCell(Text(Get.find<SavedSearchViewModel>()
                                      .home
                                      .realEstate!
                                      .options!
                                      .hangar! ==
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPanelWidget(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: GetX<SavedSearchViewModel>(
          builder: (controller) => controller.btnLoading.value
              ? Shimmer.fromColors(
                  baseColor: (Colors.grey[300])!,
                  highlightColor: (Colors.grey[100])!,
                  enabled: true,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.3,
                        color: Colors.white,
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(top: 7.h, left: 20.w, right: 20.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
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
                      height: MediaQuery.of(context).size.height * 0.33,
                      child: Stack(
                        children: [
                          CarouselSlider.builder(
                              itemCount: Get.find<SavedSearchViewModel>()
                                  .home
                                  .image!
                                  .length,
                              itemBuilder: (BuildContext context, int itemIndex,
                                      int pageViewIndex) =>
                                  Image.network(
                                    Get.find<SavedSearchViewModel>()
                                        .home
                                        .image![itemIndex]
                                        .image!,
                                    fit: BoxFit.fill,
                                    height: Get.height * 0.44,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      }
                                      Get.find<SavedSearchViewModel>()
                                          .homeCarouselIndicator
                                          .value = itemIndex;
                                      return Center(
                                        child: CircularProgressIndicator(
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
                          Positioned(
                            top: 10.h,
                            right: 10.w,
                            child: GestureDetector(
                              onTap: () {
                                Get.find<SavedSearchViewModel>()
                                    .changeToHidden();
                                Get.find<SavedSearchViewModel>()
                                    .changeSelectedIndex(-1);
                              },
                              child: Container(
                                height: 40.h,
                                width: 40.w,
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(45),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(top: 7.h, left: 20.w, right: 20.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.blue.shade600,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15.w),
                                      child: Center(
                                        child: Text(
                                          'active'.tr,
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.purple.shade400,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 15.w),
                                      child: Center(
                                        child: Text(
                                          'open'.tr,
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Get.find<SavedSearchViewModel>().isLoading.value
                                  ? const CircularProgressIndicator()
                                  : Text(
                                      Get.find<SavedSearchViewModel>()
                                          .home
                                          .realEstate!
                                          .price!,
                                      style: TextStyle(
                                        fontSize: 21.sp,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                            ],
                          ),
                          Center(
                            child: Icon(
                              Icons.star_border_outlined,
                              size: 30.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Text('address'.tr),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Get.find<SavedSearchViewModel>().isLoading.value
                          ? const CircularProgressIndicator()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(Get.find<SavedSearchViewModel>()
                                        .home
                                        .realEstate!
                                        .sleepRoomCount! +
                                    'bed_room'.tr),
                                Text(Get.find<SavedSearchViewModel>()
                                        .home
                                        .realEstate!
                                        .bathRoomCount! +
                                    'bath_room'.tr),
                                Text(Get.find<SavedSearchViewModel>()
                                        .home
                                        .realEstate!
                                        .area! +
                                    'meter'.tr),
                                Text(Get.find<SavedSearchViewModel>()
                                        .home
                                        .realEstate!
                                        .totalArea! +
                                    'meter'.tr +
                                    'overal'.tr),
                              ],
                            ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
