// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:catalog/controllers/control_viewmodel.dart';
import 'package:catalog/controllers/favorite_view_model.dart';
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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:uuid/uuid.dart';
import 'package:catalog/views/widgets/property_panel_info.dart';
import 'package:catalog/controllers/search_viewmodel.dart';

const String ACCESS_TOKEN = String.fromEnvironment(
    "pk.eyJ1IjoiaGFpZGFyYTk5MyIsImEiOiJjbDR3cWFrM2IxOTV1M2ptemh1bXIyeDVqIn0.Wf7fGtHwCX4lg3oY8AwlYA");
const MARKER_COLOR = Color(0xFF3DC5A7);
const MARKER_SIZE_BIG = 100.0;
const MARKER_SIZE_SMALL = 80.0;

class FavoriteView extends GetWidget<FavoriteViewModel> {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(35.363149, 35.932120),
    zoom: 13,
  );

  final panelTransation = const Duration(milliseconds: 500);

  ScrollController? scrollController;

  var uuid = const Uuid();

  var f = NumberFormat("#,###", "en_US");

  void _onVerticalGesture(DragUpdateDetails details) {
    if (details.primaryDelta! < -7 &&
        Get.find<FavoriteViewModel>().panelState == PanelState.hidden) {
      Get.find<FavoriteViewModel>().changeToMidOpen();
    } else if (details.primaryDelta! < -7 &&
        Get.find<FavoriteViewModel>().panelState == PanelState.midopen) {
      Get.find<FavoriteViewModel>().changeToOpen();
    } else if (details.primaryDelta! > 7 &&
        Get.find<FavoriteViewModel>().panelState == PanelState.open) {
      Get.find<FavoriteViewModel>().changeToMidOpen();
    } else if (details.primaryDelta! > 7 &&
        Get.find<FavoriteViewModel>().panelState == PanelState.midopen) {
      Get.find<FavoriteViewModel>().changeToHidden();
      Get.find<FavoriteViewModel>().changeSelectedIndex(-1);
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
    return GetBuilder<FavoriteViewModel>(builder: (favcontroller) {
      return AnimatedBuilder(
          animation: FavoriteViewModel(),
          builder: (context, _) {
            return Stack(
              children: [
                DefaultTabController(
                  length: 2,
                  child: Scaffold(
                    appBar: AppBar(
                      backgroundColor: Get.theme.primaryColor,
                      title: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Container(
                          height: 35,
                          child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Text(
                                "المفضلة",
                                // style: const TextStyle(color: Colors.white),
                              )),
                        ),
                      ),
                      bottom: PreferredSize(
                        preferredSize: const Size.fromHeight(50),
                        child: Expanded(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TabBar(
                                  labelColor: Get.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  isScrollable: true,
                                  tabs: [
                                    Tab(
                                      text: "map".tr,
                                    ),
                                    Tab(
                                      text: "list".tr,
                                    ),
                                  ]),
                              GetBuilder<FavoriteViewModel>(
                                  builder: (searchController) {
                                return Container(
                                  width: MediaQuery.of(context).size.width / 2,
                                  alignment: Get.locale?.languageCode == 'ar'
                                      ? Alignment.centerLeft
                                      : Alignment.centerRight,
                                  child: Text(
                                    "result".tr +
                                        " (" +
                                        searchController
                                            .favoriteProperties.length
                                            .toString() +
                                        ")",
                                  ),
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
                            GetBuilder<FavoriteViewModel>(
                                init: FavoriteViewModel(),
                                builder: (context) {
                                  return Stack(
                                    children: [
                                      Obx(() => GoogleMap(
                                            initialCameraPosition:
                                                _initialCameraPosition,
                                            zoomControlsEnabled: false,
                                            onTap: (tapPosition) {
                                              Get.find<FavoriteViewModel>()
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
                                              controller.getAllLikedProducts();
                                            },
                                            rotateGesturesEnabled: false,
                                            mapType: MapType.satellite,
                                            markers: Set<Marker>.of(
                                                controller.markerList),
                                          )),
                                    ],
                                  );
                                }),
                            GetBuilder<FavoriteViewModel>(
                              builder: (filterController) => Container(
                                color: Colors.grey[200],
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child:
                                      filterController
                                              .favoriteProperties.isEmpty
                                          ? const Center(
                                              child: Text("لايوجد أية عقارات"),
                                            )
                                          : SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  ListView.builder(
                                                    shrinkWrap: true,
                                                    physics:
                                                        const BouncingScrollPhysics(),
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    itemCount: filterController
                                                        .favoriteProperties
                                                        .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Container(
                                                        child: GestureDetector(
                                                          onTap: () async {
                                                            SharedPreferences
                                                                prefs =
                                                                await SharedPreferences
                                                                    .getInstance();
                                                            prefs.setInt(
                                                                "homeId",
                                                                int.parse(filterController
                                                                    .favoriteProperties[
                                                                        index]
                                                                    .propertyId));

                                                            Navigator.of(
                                                                    context)
                                                                .push(
                                                              PageRouteBuilder(
                                                                pageBuilder:
                                                                    (context,
                                                                        animation,
                                                                        _) {
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
                                                                const EdgeInsets
                                                                        .only(
                                                                    bottom:
                                                                        17.0),
                                                            // elevation: 3.0,
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
                                                            child: Column(
                                                              children: [
                                                                Card(
                                                                  margin: EdgeInsets
                                                                      .only(
                                                                          bottom:
                                                                              12.h),
                                                                  clipBehavior:
                                                                      Clip.antiAlias,
                                                                  shape:
                                                                      const RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.all(
                                                                    Radius
                                                                        .circular(
                                                                            15),
                                                                  )),
                                                                  child:
                                                                      Container(
                                                                    height:
                                                                        220.h,
                                                                    child:
                                                                        Stack(
                                                                      children: [
                                                                        Hero(
                                                                          tag:
                                                                              'image_${filterController.favoriteProperties[index].propertyId}_details',
                                                                          child:
                                                                              Image.asset(
                                                                            'assets/images/house/house1.jpeg',
                                                                            height:
                                                                                220.h,
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          ),
                                                                        ),
                                                                        Container(
                                                                          padding:
                                                                              const EdgeInsets.all(20),
                                                                          decoration: BoxDecoration(
                                                                              gradient: LinearGradient(
                                                                            colors: [
                                                                              Colors.transparent,
                                                                              Colors.black.withOpacity(0.7),
                                                                            ],
                                                                            begin:
                                                                                Alignment.topCenter,
                                                                            end:
                                                                                Alignment.bottomCenter,
                                                                            stops: [
                                                                              5.0,
                                                                              1.0
                                                                            ],
                                                                          )),
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  Container(
                                                                                    decoration: BoxDecoration(color: Colors.yellow[700], borderRadius: const BorderRadius.all(Radius.circular(5))),
                                                                                    width: 80.w,
                                                                                    padding: const EdgeInsets.symmetric(vertical: 4),
                                                                                    child: Center(
                                                                                      child: Text(
                                                                                        filterController.favoriteProperties[index].category,
                                                                                        style: const TextStyle(
                                                                                          color: Colors.white,
                                                                                          fontSize: 14,
                                                                                          fontWeight: FontWeight.bold,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
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
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          8.0),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Text(
                                                                        filterController
                                                                            .favoriteProperties[index]
                                                                            .address,
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.black,
                                                                          fontSize:
                                                                              15.sp,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                      // Row(
                                                                      //   children: [
                                                                      //     Icon(
                                                                      //       Icons.star,
                                                                      //       color:
                                                                      //           Colors.yellow[700],
                                                                      //       size:
                                                                      //           14,
                                                                      //     ),
                                                                      //     SizedBox(
                                                                      //       width:
                                                                      //           4.w,
                                                                      //     ),
                                                                      //     Text(
                                                                      //       "4.3 تقييم",
                                                                      //       style:
                                                                      //           TextStyle(
                                                                      //         color: Colors.black,
                                                                      //         fontSize: 18.sp,
                                                                      //       ),
                                                                      //     ),
                                                                      //   ],
                                                                      // )
                                                                    ],
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          8.0),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        f.format(int.parse(filterController
                                                                            .favoriteProperties[index]
                                                                            .price)),
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.black,
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
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          8.0),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      const Icon(
                                                                        Icons
                                                                            .hotel,
                                                                        color: Colors
                                                                            .black,
                                                                        size:
                                                                            18,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            4.w,
                                                                      ),
                                                                      Text(
                                                                        filterController
                                                                            .favoriteProperties[index]
                                                                            .bedRoomNum,
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.black,
                                                                          fontSize:
                                                                              18.sp,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            8.w,
                                                                      ),
                                                                      const Icon(
                                                                        Icons
                                                                            .bathtub,
                                                                        color: Colors
                                                                            .black,
                                                                        size:
                                                                            18,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            4.w,
                                                                      ),
                                                                      Text(
                                                                        filterController
                                                                            .favoriteProperties[index]
                                                                            .bathRoomNum,
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.black,
                                                                          fontSize:
                                                                              18.sp,
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            8.w,
                                                                      ),
                                                                      const Icon(
                                                                        Icons
                                                                            .zoom_out_map,
                                                                        color: Colors
                                                                            .black,
                                                                        size:
                                                                            18,
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            4.w,
                                                                      ),
                                                                      Text(
                                                                        filterController
                                                                            .favoriteProperties[index]
                                                                            .area,
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.black,
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
                  top: _getTopForPanel(favcontroller.panelState, size),
                  height: _getSizeForPanel(favcontroller.panelState, size),
                  child: GestureDetector(
                    onVerticalDragUpdate: _onVerticalGesture,
                    child: Container(
                      child: AnimatedSwitcher(
                        duration: panelTransation,
                        child: _buildPanelOption(context),
                      ),
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            );
          });
    });
  }

  Widget _buildPanelOption(BuildContext context) {
    if (Get.find<FavoriteViewModel>().panelState == PanelState.midopen) {
      return _buildPanelWidget(context);
    } else if (Get.find<FavoriteViewModel>().panelState == PanelState.open) {
      return _buildExpandedPanelWidget(context);
    } else {
      return const SizedBox.shrink();
    }
  }

  List<DataRow> buildRoomDetails() {
    List<DataRow> roomlist = [];
    for (var element in Get.find<FavoriteViewModel>().home.rooms!) {
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
                    Hero(
                      tag: 'image_${controller.home.realEstate?.id}_details',
                      child: CarouselSlider.builder(
                          itemCount: controller.home.image!.length,
                          itemBuilder: (BuildContext context, int itemIndex,
                                  int pageViewIndex) =>
                              Image.network(
                                controller.home.image![itemIndex].image!,
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
                    Positioned(
                      top: 10.h,
                      right: 10.w,
                      child: GestureDetector(
                        onTap: () {
                          Get.find<FavoriteViewModel>().changeToMidOpen();
                          Get.find<FavoriteViewModel>().changeSelectedIndex(-1);
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
                        Get.find<FavoriteViewModel>().isLoading.value
                            ? const CircularProgressIndicator()
                            : Text(
                                Get.find<FavoriteViewModel>()
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
                child: Get.find<FavoriteViewModel>().isLoading.value
                    ? const CircularProgressIndicator()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(Get.find<FavoriteViewModel>()
                                  .home
                                  .realEstate!
                                  .sleepRoomCount! +
                              'bed_room'.tr),
                          Text(Get.find<FavoriteViewModel>()
                                  .home
                                  .realEstate!
                                  .bathRoomCount! +
                              'bath_room'.tr),
                          Text(Get.find<FavoriteViewModel>()
                                  .home
                                  .realEstate!
                                  .area! +
                              'meter'.tr),
                          Text(Get.find<FavoriteViewModel>()
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
                    Column(
                      children: [const Icon(Icons.share), Text("share".tr)],
                    ),
                    Column(
                      children: [const Icon(Icons.print), Text("print".tr)],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 100.h,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                      target: LatLng(
                        double.parse(Get.find<FavoriteViewModel>()
                            .home
                            .realEstate!
                            .lat!),
                        double.parse(Get.find<FavoriteViewModel>()
                            .home
                            .realEstate!
                            .long!),
                      ),
                      zoom: 13),
                  zoomControlsEnabled: false,
                  onMapCreated: (controller) => Get.find<FavoriteViewModel>()
                      .setMiniGoolgeMapController(controller),
                  rotateGesturesEnabled: false,
                  mapType: MapType.normal,
                  markers: Get.find<FavoriteViewModel>().myMarker,
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
                          DataCell(Text(Get.find<FavoriteViewModel>()
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
                          DataCell(Text(Get.find<FavoriteViewModel>()
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
                      //     DataCell(Text(Get.find<FavoriteViewModel>()
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
                          DataCell(Text(Get.find<FavoriteViewModel>()
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
                          DataCell(Text(Get.find<FavoriteViewModel>()
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
                          DataCell(Text(Get.find<FavoriteViewModel>()
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
                          DataCell(Text(Get.find<FavoriteViewModel>()
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
                          DataCell(Text(Get.find<FavoriteViewModel>()
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
                          DataCell(Text(Get.find<FavoriteViewModel>()
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
                          DataCell(Text(Get.find<FavoriteViewModel>()
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
                          DataCell(Text(Get.find<FavoriteViewModel>()
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
              //                       // ignore: prefer_const_literals_to_create_immutables
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
        child: GetX<FavoriteViewModel>(
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
                          Hero(
                            tag:
                                'image_${controller.home.realEstate?.id}_details',
                            child: CarouselSlider.builder(
                                itemCount: controller.home.image!.length,
                                itemBuilder: (BuildContext context,
                                        int itemIndex, int pageViewIndex) =>
                                    Image.network(
                                      controller.home.image![itemIndex].image!,
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
                          Positioned(
                            top: 10.h,
                            right: 10.w,
                            child: GestureDetector(
                              onTap: () {
                                Get.find<FavoriteViewModel>().changeToHidden();
                                Get.find<FavoriteViewModel>()
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
                    PropertyPanelInfo(
                      price: controller.home.realEstate!.price!,
                      addresstitle: controller.home.realEstate!.addressTitle!,
                      area: controller.home.realEstate!.area!,
                      bednum: controller.home.realEstate!.sleepRoomCount!,
                      bathnum: controller.home.realEstate!.bathRoomCount,
                      totalarea: controller.home.realEstate!.totalArea,
                      isliked: Get.find<SearchViewModel>()
                          .favoritePropertiesId
                          .contains(controller.home.realEstate!.id!),
                      onPressed: (p0) async {
                        print(p0);
                        if (p0) {
                          Get.find<SearchViewModel>()
                              .unlikeProduct(controller.home.realEstate!.id!);
                          return false;
                        } else {
                          Get.find<SearchViewModel>()
                              .likeProductInfo(controller.home);
                          return true;
                        }
                      },
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
                              controller.isLoading.value
                                  ? const CircularProgressIndicator()
                                  : Text(
                                      controller.home.realEstate!.price!,
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
                      child: Text(controller.home.realEstate!.addressTitle!,
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
                                      controller
                                          .home.realEstate!.sleepRoomCount! +
                                      " " +
                                      'bed_room'.tr),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(Icons.bathtub),
                                  Text("  " +
                                      controller
                                          .home.realEstate!.bathRoomCount! +
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
                                      controller.home.realEstate!.area! +
                                      " " +
                                      'meter'.tr),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Icon(
                                    Icons.zoom_out_map,
                                    color: Colors.black,
                                  ),
                                  Text("  " +
                                      controller.home.realEstate!.totalArea! +
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
      ),
    );
  }
}
