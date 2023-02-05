import 'package:carousel_slider/carousel_slider.dart';
import 'package:catalog/controllers/control_viewmodel.dart';
import 'package:catalog/controllers/home_info_controller.dart';
import 'package:catalog/controllers/search_viewmodel.dart';
import 'package:catalog/views/property_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class FilterResult extends StatelessWidget {
  FilterResult({Key? key}) : super(key: key);

  var f = NumberFormat("#,###", "en_US");
  @override
  Widget build(BuildContext context) {
    return GetX<SearchViewModel>(builder: (filterController) {
      return filterController.btnLoading.value
          ? Scaffold(
              appBar: AppBar(),
              body: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                      child: Shimmer.fromColors(
                        baseColor: (Colors.grey[300])!,
                        highlightColor: (Colors.grey[100])!,
                        enabled: true,
                        child: ListView.builder(
                          itemBuilder: (_, __) => Column(
                            children: [
                              Card(
                                margin: EdgeInsets.only(bottom: 12.h),
                                clipBehavior: Clip.antiAlias,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                )),
                                child: Container(
                                  height: 220.h,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                      ),
                                      height: 20,
                                      width: 200,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                          ),
                                          height: 20,
                                          width: 70,
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 6.h,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                      ),
                                      height: 20,
                                      width: 120,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 6.h,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                      ),
                                      height: 20,
                                      width: 150,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 15.h,
                              )
                            ],
                          ),
                          itemCount: 3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Scaffold(
              appBar: AppBar(),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: filterController.filteredProperties.isEmpty
                      ? const Center(
                          child: Text("لايوجد أية عقارات"),
                        )
                      : Column(
                          children: [
                            filterController.filterMessage == "filter is true"
                                ? SizedBox(
                                    height: 5.h,
                                  )
                                : const Text(
                                    "لم يتم العثور على عقارات موافقة للفلاتر المدخلة, قد يهمك/تهمك هذه العقارات."),
                            const SizedBox(height: 15),
                            LiquidPullToRefresh(
                              onRefresh: () => Get.find<SearchViewModel>()
                                  .filterWithoutmapProperty(),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemCount:
                                    filterController.filteredProperties.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () async {
                                      var homeController =
                                          Get.put(HomeInfoController());
                                      homeController.isLoading.value = true;
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      prefs.setInt(
                                          "homeId",
                                          filterController
                                              .filteredProperties[index].id!);
                                      homeController.getHomeInfo(
                                          filterController
                                              .filteredProperties[index].id!);
                                      Navigator.of(context).push(
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation, _) {
                                            return FadeTransition(
                                              opacity: animation,
                                              child: PropertyInfo(),
                                            );
                                          },
                                          transitionDuration:
                                              const Duration(milliseconds: 900),
                                        ),
                                      );
                                    },
                                    child: Card(
                                      margin:
                                          const EdgeInsets.only(bottom: 17.0),
                                      // elevation: 3.0,
                                      clipBehavior: Clip.antiAlias,
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                        Radius.circular(15),
                                      )),
                                      child: Column(
                                        children: [
                                          Card(
                                            margin:
                                                EdgeInsets.only(bottom: 12.h),
                                            clipBehavior: Clip.antiAlias,
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                              Radius.circular(15),
                                            )),
                                            child: SizedBox(
                                              height: 220.h,
                                              child: Stack(
                                                children: [
                                                  Hero(
                                                    tag:
                                                        'image_${filterController.filteredProperties[index].id}_details',
                                                    child: CarouselSlider
                                                        .builder(
                                                            itemCount:
                                                                filterController
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
                                                                Image.network(
                                                                  filterController
                                                                      .filteredProperties[
                                                                          index]
                                                                      .image![
                                                                          itemIndex]
                                                                      .image!,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  height:
                                                                      Get.height *
                                                                          0.44,
                                                                  loadingBuilder:
                                                                      (context,
                                                                          child,
                                                                          loadingProgress) {
                                                                    if (loadingProgress ==
                                                                        null) {
                                                                      return child;
                                                                    }
                                                                    filterController
                                                                            .homeCarouselIndicator
                                                                            .value =
                                                                        itemIndex;
                                                                    return Center(
                                                                      child:
                                                                          CircularProgressIndicator(
                                                                        value: loadingProgress.expectedTotalBytes !=
                                                                                null
                                                                            ? loadingProgress.cumulativeBytesLoaded /
                                                                                loadingProgress.expectedTotalBytes!
                                                                            : null,
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                            options:
                                                                CarouselOptions(
                                                              height:
                                                                  Get.height *
                                                                      0.44,
                                                              viewportFraction:
                                                                  1,
                                                              initialPage: 0,
                                                              enableInfiniteScroll:
                                                                  false,
                                                              clipBehavior:
                                                                  Clip.hardEdge,
                                                              enlargeCenterPage:
                                                                  true,
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                            )),
                                                  ),
                                                  Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    decoration: BoxDecoration(
                                                        gradient:
                                                            LinearGradient(
                                                      colors: [
                                                        Colors.transparent,
                                                        Colors.black
                                                            .withOpacity(0.7),
                                                      ],
                                                      begin:
                                                          Alignment.topCenter,
                                                      end: Alignment
                                                          .bottomCenter,
                                                      stops: const [5.0, 1.0],
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
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                          .yellow[
                                                                      700],
                                                                  borderRadius: const BorderRadius
                                                                          .all(
                                                                      Radius.circular(
                                                                          5))),
                                                              width: 80.w,
                                                              padding:
                                                                  const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          4),
                                                              child: Center(
                                                                child: Text(
                                                                  filterController
                                                                      .filteredProperties[
                                                                          index]
                                                                      .category!,
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            AbsorbPointer(
                                                              absorbing: false,
                                                              child: Container(
                                                                height: 40,
                                                                width: 40,
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .grey
                                                                      .withOpacity(
                                                                          .7),
                                                                  shape: BoxShape
                                                                      .circle,
                                                                ),
                                                                child: Center(
                                                                  child: Obx(() =>
                                                                      LikeButton(
                                                                        size:
                                                                            35,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        onTap:
                                                                            (isLiked) async {
                                                                          if (isLiked) {
                                                                            filterController.unlikeProduct(filterController.filteredProperties[index].id!);
                                                                            return false;
                                                                          } else {
                                                                            filterController.likeProduct(filterController.filteredProperties[index]);
                                                                            return true;
                                                                          }
                                                                        },
                                                                        isLiked: filterController
                                                                            .favoritePropertiesId
                                                                            .contains(filterController.filteredProperties[index].id!),
                                                                        likeBuilder:
                                                                            (bool
                                                                                isLiked) {
                                                                          return Icon(
                                                                              isLiked ? Icons.star : Icons.star_border_outlined,
                                                                              color: isLiked ? Colors.yellow[700] : Colors.black,
                                                                              size: 35);
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
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  filterController
                                                      .filteredProperties[index]
                                                      .addressTitle!,
                                                  style: TextStyle(
                                                    fontSize: 15.sp,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "نوع العقار: ",
                                                      style: TextStyle(
                                                        fontSize: 15.sp,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 4.w,
                                                    ),
                                                    Text(
                                                      filterController
                                                          .filteredProperties[
                                                              index]
                                                          .getNatureName(
                                                              filterController
                                                                  .filteredProperties[
                                                                      index]
                                                                  .natureId!),
                                                      style: TextStyle(
                                                        fontSize: 15.sp,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  f.format(int.parse(
                                                      filterController
                                                          .filteredProperties[
                                                              index]
                                                          .price!)),
                                                  style: TextStyle(
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
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Visibility(
                                                  visible: (filterController
                                                              .filteredProperties[
                                                                  index]
                                                              .natureId! ==
                                                          "1" ||
                                                      filterController
                                                              .filteredProperties[
                                                                  index]
                                                              .natureId! ==
                                                          "2" ||
                                                      filterController
                                                              .filteredProperties[
                                                                  index]
                                                              .natureId! ==
                                                          "6"),
                                                  child: const Icon(
                                                    Icons.hotel,
                                                    size: 18,
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: (filterController
                                                              .filteredProperties[
                                                                  index]
                                                              .natureId! ==
                                                          "1" ||
                                                      filterController
                                                              .filteredProperties[
                                                                  index]
                                                              .natureId! ==
                                                          "2" ||
                                                      filterController
                                                              .filteredProperties[
                                                                  index]
                                                              .natureId! ==
                                                          "6"),
                                                  child: SizedBox(
                                                    width: 4.w,
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: (filterController
                                                              .filteredProperties[
                                                                  index]
                                                              .natureId! ==
                                                          "1" ||
                                                      filterController
                                                              .filteredProperties[
                                                                  index]
                                                              .natureId! ==
                                                          "2" ||
                                                      filterController
                                                              .filteredProperties[
                                                                  index]
                                                              .natureId! ==
                                                          "6"),
                                                  child: Text(
                                                    filterController
                                                        .filteredProperties[
                                                            index]
                                                        .sleepRoomCount!,
                                                    style: TextStyle(
                                                      fontSize: 18.sp,
                                                    ),
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: (filterController
                                                              .filteredProperties[
                                                                  index]
                                                              .natureId! ==
                                                          "1" ||
                                                      filterController
                                                              .filteredProperties[
                                                                  index]
                                                              .natureId! ==
                                                          "2" ||
                                                      filterController
                                                              .filteredProperties[
                                                                  index]
                                                              .natureId! ==
                                                          "6"),
                                                  child: SizedBox(
                                                    width: 8.w,
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: (filterController
                                                              .filteredProperties[
                                                                  index]
                                                              .natureId! ==
                                                          "1" ||
                                                      filterController
                                                              .filteredProperties[
                                                                  index]
                                                              .natureId! ==
                                                          "2" ||
                                                      filterController
                                                              .filteredProperties[
                                                                  index]
                                                              .natureId! ==
                                                          "6"),
                                                  child: const Icon(
                                                    Icons.bathtub,
                                                    size: 18,
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: (filterController
                                                              .filteredProperties[
                                                                  index]
                                                              .natureId! ==
                                                          "1" ||
                                                      filterController
                                                              .filteredProperties[
                                                                  index]
                                                              .natureId! ==
                                                          "2" ||
                                                      filterController
                                                              .filteredProperties[
                                                                  index]
                                                              .natureId! ==
                                                          "6"),
                                                  child: SizedBox(
                                                    width: 4.w,
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: (filterController
                                                              .filteredProperties[
                                                                  index]
                                                              .natureId! ==
                                                          "1" ||
                                                      filterController
                                                              .filteredProperties[
                                                                  index]
                                                              .natureId! ==
                                                          "2" ||
                                                      filterController
                                                              .filteredProperties[
                                                                  index]
                                                              .natureId! ==
                                                          "6"),
                                                  child: Text(
                                                    filterController
                                                        .filteredProperties[
                                                            index]
                                                        .bathRoomCount!,
                                                    style: TextStyle(
                                                      fontSize: 18.sp,
                                                    ),
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: (filterController
                                                              .filteredProperties[
                                                                  index]
                                                              .natureId! ==
                                                          "1" ||
                                                      filterController
                                                              .filteredProperties[
                                                                  index]
                                                              .natureId! ==
                                                          "2" ||
                                                      filterController
                                                              .filteredProperties[
                                                                  index]
                                                              .natureId! ==
                                                          "6"),
                                                  child: SizedBox(
                                                    width: 8.w,
                                                  ),
                                                ),
                                                const Icon(
                                                  Icons.zoom_out_map,
                                                  size: 18,
                                                ),
                                                SizedBox(
                                                  width: 4.w,
                                                ),
                                                Text(
                                                  filterController
                                                      .filteredProperties[index]
                                                      .totalArea!,
                                                  style: TextStyle(
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
                              ),
                            )
                          ],
                        ),
                ),
              ),
            );
    });
  }
}
