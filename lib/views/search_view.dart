// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:catalog/controllers/control_viewmodel.dart';
import 'package:catalog/controllers/home_info_controller.dart';
import 'package:catalog/controllers/search_viewmodel.dart';
import 'package:catalog/models/map_marker.dart';
import 'package:catalog/models/saved_search_model.dart';
import 'package:catalog/views/property_info.dart';
import 'package:catalog/views/search_filter_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:http/http.dart' as http;
import 'package:like_button/like_button.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

const MARKER_COLOR = Color(0xFF3DC5A7);
const MARKER_SIZE_BIG = 100.0;
const MARKER_SIZE_SMALL = 80.0;

// ignore: must_be_immutable
class SearchView extends GetWidget<SearchViewModel> {
  double initLat, initLong, zoom;
  bool savesearch;
  SearchView(
      {Key? key,
      required this.initLat,
      required this.initLong,
      required this.zoom,
      this.savesearch = false})
      : super(key: key);

  ScrollController? scrollController;

  var uuid = const Uuid();

  var f = NumberFormat("#,###", "en_US");
  final _searchFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Get.find<ControlViewModel>().changeSelectedValue2(selectedValue: 2);
        return Future.value(true);
      },
      child: DefaultTabController(
        length: 2,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: AppBar(
              title: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  height: 45,
                  width: MediaQuery.of(context).size.width - 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: TextFormField(
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              enabledBorder: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                              border: InputBorder.none,
                              hintText: "jumpLocation".tr,
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  Get.to(SearchFilterView());
                                },
                                child: Container(
                                    margin: const EdgeInsets.all(7),
                                    width: 15.0,
                                    height: 15.0,
                                    // decoration: new BoxDecoration(
                                    //   borderRadius: BorderRadius.circular(10),
                                    //   border: Border.all(
                                    //       color: Colors.black87, width: 1),
                                    // ),
                                    child: const Icon(
                                      Icons.filter_list,
                                      size: 25,
                                    )),
                              ),
                            ),
                            onChanged: (value) =>
                                controller.searchPlaces(value),
                            onTap: () => controller.clearSelectedLocation(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: Expanded(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TabBar(
                          labelColor:
                              Get.isDarkMode ? Colors.white : Colors.black,
                          isScrollable: true,
                          tabs: [
                            Tab(
                              text: "map".tr,
                            ),
                            Tab(
                              text: "list".tr,
                            ),
                          ]),
                      GetBuilder<SearchViewModel>(builder: (searchController) {
                        return Container(
                          width: MediaQuery.of(context).size.width / 2,
                          alignment: Get.locale?.languageCode == 'ar'
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                          child: Obx(() => searchController.isLoading.value
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "يجري البحث ",
                                    ),
                                    JumpingDotsProgressIndicator(
                                      fontSize: 25.0,
                                    ),
                                  ],
                                )
                              : Text(
                                  "result".tr +
                                      " (" +
                                      searchController.filteredProperties.length
                                          .toString() +
                                      ")",
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
                    GetBuilder<SearchViewModel>(
                        init: SearchViewModel(),
                        builder: (context) {
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              Obx(() => GoogleMap(
                                    initialCameraPosition: CameraPosition(
                                      target: LatLng(initLat, initLong),
                                      zoom: zoom,
                                    ),
                                    zoomControlsEnabled: false,
                                    onTap: (tapPosition) {
                                      Get.find<ControlViewModel>()
                                          .changeToHidden();
                                      print(tapPosition);
                                    },
                                    onMapCreated: (controller) {
                                      this.controller.setGoolgeMapController(
                                          controller: controller);
                                      // this.controller.getProperties();
                                    },
                                    compassEnabled: true,
                                    onCameraMove: (position) {
                                      this
                                          .controller
                                          .setCurrentPosition(position);
                                    },
                                    onCameraIdle: () {
                                      controller.filterProperty();
                                    },
                                    rotateGesturesEnabled: false,
                                    mapType: controller.currentMapType,
                                    markers:
                                        Set<Marker>.of(controller.markerList),
                                  )),
                              if (controller.searchResults != null &&
                                  controller.searchResults.isNotEmpty)
                                Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(.6),
                                    backgroundBlendMode: BlendMode.darken,
                                  ),
                                ),
                              if (controller.searchResults != null &&
                                  controller.searchResults.isNotEmpty)
                                SizedBox(
                                  width: double.infinity,
                                  child: ListView.builder(
                                    itemCount: controller.searchResults.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: Text(
                                          controller
                                              .searchResults[index].description,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        onTap: () {
                                          print(controller
                                              .searchResults[index].placeId);
                                          controller.setSelectedLocation(
                                              controller.searchResults[index]
                                                  .placeId);
                                        },
                                      );
                                    },
                                  ),
                                ),
                              Positioned(
                                bottom: 25.h,
                                child: InkWell(
                                  onTap: () {
                                    Get.defaultDialog(
                                      title: 'أدخل اسم ',
                                      content: Form(
                                        key: _searchFormKey,
                                        child: Column(
                                          children: [
                                            TextFormField(
                                              onSaved: (name) {
                                                controller.searchName = name!;
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
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              // ignore: prefer_const_literals_to_create_immutables
                                              children: [
                                                InkWell(
                                                    onTap: () {
                                                      print("asd1");
                                                      if (_searchFormKey
                                                          .currentState!
                                                          .validate()) {
                                                        _searchFormKey
                                                            .currentState!
                                                            .save();
                                                        controller.saveSearch();
                                                        print("asd2");
                                                        Get.back();
                                                      }
                                                    },
                                                    child: const Text("موافق")),
                                                InkWell(
                                                    onTap: () {
                                                      Get.back();
                                                    },
                                                    child: const Text("إلغاء")),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 50.h,
                                    width: 150.w,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: Center(
                                      child: Text(
                                        "حفظ البحث",
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 25.h,
                                left: 20.w,
                                child: GetBuilder<SearchViewModel>(
                                    builder: (context) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      FloatingActionButton(
                                        foregroundColor: Colors.black,
                                        onPressed: () {
                                          controller.gotolocation();
                                        },
                                        child: const Icon(
                                            Icons.center_focus_strong),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      FloatingActionButton(
                                        tooltip: "تغيير نمط الخريطة",
                                        foregroundColor: Colors.black,
                                        onPressed: () =>
                                            controller.changeMapType(),
                                        child: controller.currentMapType ==
                                                MapType.normal
                                            ? Image.asset(
                                                "assets/icons/sattalite_map.png")
                                            : Image.asset(
                                                "assets/icons/normal_map.png"),
                                      ),
                                    ],
                                  );
                                }),
                              ),
                            ],
                          );
                        }),
                    GetBuilder<SearchViewModel>(
                      builder: (filterController) => Container(
                        color: Colors.grey[200],
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: filterController.filteredProperties.isEmpty
                              ? const Center(
                                  child: Text("لايوجد أية عقارات"),
                                )
                              : SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics: const BouncingScrollPhysics(),
                                        scrollDirection: Axis.vertical,
                                        itemCount: filterController
                                            .filteredProperties.length,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () async {
                                              var homeController =
                                                  Get.put(HomeInfoController());
                                              homeController.isLoading.value =
                                                  true;
                                              SharedPreferences prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              prefs.setInt(
                                                  "homeId",
                                                  filterController
                                                      .filteredProperties[index]
                                                      .id!);
                                              homeController.getHomeInfo(
                                                  filterController
                                                      .filteredProperties[index]
                                                      .id!);
                                              Navigator.of(context).push(
                                                PageRouteBuilder(
                                                  pageBuilder:
                                                      (context, animation, _) {
                                                    return FadeTransition(
                                                      opacity: animation,
                                                      child: PropertyInfo(),
                                                    );
                                                  },
                                                  transitionDuration:
                                                      const Duration(
                                                          milliseconds: 900),
                                                ),
                                              );
                                            },
                                            child: Card(
                                              margin: const EdgeInsets.only(
                                                  bottom: 17.0),
                                              // elevation: 3.0,
                                              clipBehavior: Clip.antiAlias,
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                Radius.circular(15),
                                              )),
                                              child: Column(
                                                children: [
                                                  Card(
                                                    margin: EdgeInsets.only(
                                                        bottom: 12.h),
                                                    clipBehavior:
                                                        Clip.antiAlias,
                                                    shape:
                                                        const RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(
                                                      Radius.circular(15),
                                                    )),
                                                    child: Container(
                                                      height: 220.h,
                                                      child: Stack(
                                                        children: [
                                                          Hero(
                                                            tag:
                                                                'image_${filterController.filteredProperties[index].id}_details',
                                                            child: CarouselSlider
                                                                .builder(
                                                                    itemCount: filterController
                                                                        .filteredProperties[
                                                                            index]
                                                                        .image!
                                                                        .length,
                                                                    itemBuilder: (BuildContext
                                                                                context,
                                                                            int
                                                                                itemIndex,
                                                                            int
                                                                                pageViewIndex) =>
                                                                        Image
                                                                            .network(
                                                                          filterController
                                                                              .filteredProperties[index]
                                                                              .image![itemIndex]
                                                                              .image!,
                                                                          fit: BoxFit
                                                                              .cover,
                                                                          height:
                                                                              Get.height * 0.44,
                                                                          loadingBuilder: (context,
                                                                              child,
                                                                              loadingProgress) {
                                                                            if (loadingProgress ==
                                                                                null) {
                                                                              return child;
                                                                            }
                                                                            filterController.homeCarouselIndicator.value =
                                                                                itemIndex;
                                                                            return Center(
                                                                              child: CircularProgressIndicator(
                                                                                value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
                                                                              ),
                                                                            );
                                                                          },
                                                                        ),
                                                                    options:
                                                                        CarouselOptions(
                                                                      height: Get
                                                                              .height *
                                                                          0.44,
                                                                      viewportFraction:
                                                                          1,
                                                                      initialPage:
                                                                          0,
                                                                      enableInfiniteScroll:
                                                                          false,
                                                                      enlargeCenterPage:
                                                                          true,
                                                                      scrollDirection:
                                                                          Axis.horizontal,
                                                                    )),
                                                          ),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10),
                                                            decoration:
                                                                BoxDecoration(
                                                                    gradient:
                                                                        LinearGradient(
                                                              colors: [
                                                                Colors
                                                                    .transparent,
                                                                Colors.black
                                                                    .withOpacity(
                                                                        0.7),
                                                              ],
                                                              begin: Alignment
                                                                  .topCenter,
                                                              end: Alignment
                                                                  .bottomCenter,
                                                              stops: [5.0, 1.0],
                                                            )),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Container(
                                                                      decoration: BoxDecoration(
                                                                          color: Colors.yellow[
                                                                              700],
                                                                          borderRadius:
                                                                              const BorderRadius.all(Radius.circular(5))),
                                                                      width:
                                                                          80.w,
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          vertical:
                                                                              4),
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Text(
                                                                          filterController
                                                                              .filteredProperties[index]
                                                                              .category!,
                                                                          style:
                                                                              const TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    AbsorbPointer(
                                                                      absorbing:
                                                                          false,
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            40,
                                                                        width:
                                                                            40,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color: Colors
                                                                              .grey
                                                                              .withOpacity(.7),
                                                                          shape:
                                                                              BoxShape.circle,
                                                                        ),
                                                                        child:
                                                                            Center(
                                                                          child: Obx(() =>
                                                                              LikeButton(
                                                                                size: 35,
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                onTap: (isLiked) async {
                                                                                  if (isLiked) {
                                                                                    filterController.unlikeProduct(filterController.filteredProperties[index].id!);
                                                                                    return false;
                                                                                  } else {
                                                                                    filterController.likeProduct(filterController.filteredProperties[index]);
                                                                                    return true;
                                                                                  }
                                                                                },
                                                                                isLiked: filterController.favoritePropertiesId.contains(filterController.filteredProperties[index].id!),
                                                                                likeBuilder: (bool isLiked) {
                                                                                  return Icon(isLiked ? Icons.star : Icons.star_border_outlined, color: isLiked ? Colors.yellow[700] : Colors.black, size: 30);
                                                                                },
                                                                              )),
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
                                                        horizontal: 8.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          filterController
                                                              .filteredProperties[
                                                                  index]
                                                              .addressTitle!,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 15.sp,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            Icon(
                                                              Icons.star,
                                                              color: Colors
                                                                  .yellow[700],
                                                              size: 14,
                                                            ),
                                                            SizedBox(
                                                              width: 4.w,
                                                            ),
                                                            Text(
                                                              "4.3 تقييم",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 18.sp,
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 8.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          f.format(int.parse(
                                                              filterController
                                                                  .filteredProperties[
                                                                      index]
                                                                  .price!)),
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 18.sp,
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
                                                        horizontal: 8.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Icon(
                                                          Icons.hotel,
                                                          color: Colors.black,
                                                          size: 18,
                                                        ),
                                                        SizedBox(
                                                          width: 4.w,
                                                        ),
                                                        Text(
                                                          filterController
                                                              .filteredProperties[
                                                                  index]
                                                              .sleepRoomCount!,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 18.sp,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 8.w,
                                                        ),
                                                        const Icon(
                                                          Icons.bathtub,
                                                          color: Colors.black,
                                                          size: 18,
                                                        ),
                                                        SizedBox(
                                                          width: 4.w,
                                                        ),
                                                        Text(
                                                          filterController
                                                              .filteredProperties[
                                                                  index]
                                                              .bathRoomCount!,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 18.sp,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 8.w,
                                                        ),
                                                        const Icon(
                                                          Icons.zoom_out_map,
                                                          color: Colors.black,
                                                          size: 18,
                                                        ),
                                                        SizedBox(
                                                          width: 4.w,
                                                        ),
                                                        Text(
                                                          filterController
                                                              .filteredProperties[
                                                                  index]
                                                              .area!,
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 18.sp,
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
          ),
        ),
      ),
    );
  }
}

class _LocationMarker extends StatelessWidget {
  final bool selected;
  const _LocationMarker({Key? key, this.selected = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = selected ? MARKER_SIZE_BIG : MARKER_SIZE_SMALL;
    final toppadding = selected ? 7.0 : 5.0;
    return Center(
      child: AnimatedContainer(
        height: size / 2,
        width: size,
        duration: const Duration(
          milliseconds: 200,
        ),
        child: Container(
          padding: EdgeInsets.only(
            top: toppadding,
            right: 25,
            left: selected ? 10.0 : 8.0,
          ),
          decoration: const BoxDecoration(
            // color: Colors.white,
            image: DecorationImage(
                image: AssetImage('assets/icons/marker.png'),
                fit: BoxFit.cover),
          ),
          child: Text(
            "12.7m",
            style: TextStyle(
                fontSize: selected ? 16.0 : 14.0, color: Colors.white),
            textAlign: TextAlign.left,
          ),
        ),
      ),
    );
  }
}

class _MyLocationMarker extends AnimatedWidget {
  const _MyLocationMarker(Animation<double> animation, {Key? key})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final value = (listenable as Animation<double>).value;
    final newValue = lerpDouble(0.5, 1.0, value)!;
    final size = 40.0;

    return Center(
      child: Stack(
        children: [
          Center(
            child: Container(
              height: size * newValue,
              width: size * newValue,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: MARKER_COLOR.withOpacity(.5),
              ),
            ),
          ),
          Center(
            child: Container(
              width: 17,
              height: 17,
              decoration: const BoxDecoration(
                color: MARKER_COLOR,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
