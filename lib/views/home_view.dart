// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:catalog/controllers/control_viewmodel.dart';
import 'package:catalog/views/filter_vew.dart';
import 'package:catalog/views/property_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:http/http.dart' as http;
import 'package:like_button/like_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  // buildTabs() {
  //   List<Widget> list = [];
  //   for (var cat in Get.find<ControlViewModel>().categories) {
  //     list.add(Tab(
  //       text: cat.category!,
  //       icon: Icon(Icons.sell),
  //     ));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.h),
          child: GetBuilder<ControlViewModel>(
              builder: (controller) => controller.obx(
                    (state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 20.h,
                          ),
                          Container(
                            height: 50.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(45.0),
                              ),
                              boxShadow: const <BoxShadow>[
                                BoxShadow(
                                  color: Colors.black45,
                                  blurRadius: 3.0,
                                ),
                              ],
                            ),
                            margin: EdgeInsets.all(5.0),
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            child: TextFormField(
                              style: TextStyle(
                                  fontSize: 28,
                                  height: 1,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              decoration: InputDecoration(
                                hintText: "search".tr,
                                hintStyle: TextStyle(
                                  fontSize: 28,
                                  color: Colors.grey,
                                ),
                                border: InputBorder.none,
                                prefixIcon: Padding(
                                  padding: EdgeInsets.only(left: 16),
                                  child: Icon(Icons.search),
                                ),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    Get.to(FilterView());
                                  },
                                  child: Container(
                                      margin: EdgeInsets.all(7),
                                      width: 15.0,
                                      height: 15.0,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.black87, width: 1),
                                      ),
                                      child: Icon(Icons.filter_list_rounded)),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 7.h,
                          ),
                          SizedBox(
                            height: 40,
                            child: TabBar(
                              indicatorColor: Colors.blue,
                              controller: controller.tabController,
                              labelColor: Colors.black,
                              unselectedLabelColor: Colors.grey,
                              tabs: controller.tabs,
                              isScrollable: true,
                              indicator: BoxDecoration(
                                color: Colors.blue[100],
                              ),
                              onTap: (value) {
                                // controller.updateCategory(value);
                                // controller.filterProperty();
                              },
                            ),
                          ),
                          Divider(),
                          SizedBox(
                            height: 15.h,
                          ),
                          // SizedBox(
                          //   height: 70,
                          //   child: TabBar(
                          //     indicator: BoxDecoration(
                          //       color: Colors.blue[100],
                          //     ),
                          //     indicatorColor: Colors.blue,
                          //     controller: controller.naturesTabController,
                          //     labelColor: Colors.black,
                          //     unselectedLabelColor: Colors.grey,
                          //     tabs: controller.naturesTabs,
                          //     indicatorPadding:
                          //         EdgeInsets.symmetric(vertical: 0),
                          //     isScrollable: true,
                          //     onTap: (value) {
                          //       // controller.updateNature(value);

                          //       // controller.filterProperty();
                          //     },
                          //   ),
                          // ),
                          Divider(),
                          Text(
                            "الأحدث",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          controller.btnLoading.value
                              ? SizedBox(
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Shimmer.fromColors(
                                        baseColor: (Colors.grey[300])!,
                                        highlightColor: (Colors.grey[100])!,
                                        enabled: true,
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemBuilder: (_, __) => Card(
                                            margin:
                                                EdgeInsets.only(bottom: 17.0),
                                            elevation: 3.0,
                                            clipBehavior: Clip.antiAlias,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                              Radius.circular(15),
                                            )),
                                            child: Column(
                                              children: [
                                                Card(
                                                  margin: EdgeInsets.only(
                                                      bottom: 12.h),
                                                  clipBehavior: Clip.antiAlias,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                    Radius.circular(15),
                                                  )),
                                                  child: Container(
                                                    height: 300.h,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          itemCount: 3,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : controller.filteredProperties.isEmpty
                                  ? Center(
                                      child: Text("لايوجد أية عقارات"),
                                    )
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      physics: BouncingScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      itemCount:
                                          controller.filteredProperties.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                          onTap: () async {
                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            prefs.setInt(
                                                "homeId",
                                                controller
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
                                                    Duration(milliseconds: 900),
                                              ),
                                            );
                                          },
                                          child: Card(
                                            margin:
                                                EdgeInsets.only(bottom: 17.0),
                                            elevation: 3.0,
                                            clipBehavior: Clip.antiAlias,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                              Radius.circular(15),
                                            )),
                                            child: Column(
                                              children: [
                                                Card(
                                                  margin: EdgeInsets.only(
                                                      bottom: 12.h),
                                                  clipBehavior: Clip.antiAlias,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                    Radius.circular(15),
                                                  )),
                                                  child: SizedBox(
                                                    height: 220.h,
                                                    child: Stack(
                                                      children: [
                                                        // Hero(
                                                        //   tag:
                                                        //       'image_${controller.filteredProperties[index].id}_details',
                                                        //   child: Image.asset(
                                                        //     'assets/images/house/house1.jpeg',
                                                        //     height: 220.h,
                                                        //     fit: BoxFit.cover,
                                                        //   ),
                                                        // ),
                                                        Image.asset(
                                                          'assets/images/house/house1.jpeg',
                                                          height: 220.h,
                                                          fit: BoxFit.cover,
                                                        ),
                                                        Container(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  20),
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
                                                            stops: const [
                                                              5.0,
                                                              1.0
                                                            ],
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
                                                                            BorderRadius.all(Radius.circular(5))),
                                                                    width: 80.w,
                                                                    padding: EdgeInsets
                                                                        .symmetric(
                                                                            vertical:
                                                                                4),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        controller
                                                                            .filteredProperties[index]
                                                                            .category!,
                                                                        style:
                                                                            TextStyle(
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
                                                                          35,
                                                                      width: 35,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Colors
                                                                            .grey
                                                                            .withOpacity(.7),
                                                                        shape: BoxShape
                                                                            .circle,
                                                                      ),
                                                                      padding: EdgeInsets.symmetric(
                                                                          vertical:
                                                                              4),
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            LikeButton(
                                                                          likeBuilder:
                                                                              (bool isLiked) {
                                                                            return Icon(
                                                                              isLiked ? Icons.favorite : Icons.favorite_border,
                                                                              color: isLiked ? Colors.deepPurpleAccent : Colors.black,
                                                                              size: 30,
                                                                            );
                                                                          },
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
                                                      horizontal: 8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        controller
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
                                                              color:
                                                                  Colors.black,
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
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        controller
                                                            .filteredProperties[
                                                                index]
                                                            .price!,
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
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .bedroom_parent_outlined,
                                                        color: Colors.black,
                                                        size: 18,
                                                      ),
                                                      SizedBox(
                                                        width: 4.w,
                                                      ),
                                                      Text(
                                                        controller
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
                                                      Icon(
                                                        Icons.bathroom_outlined,
                                                        color: Colors.black,
                                                        size: 18,
                                                      ),
                                                      SizedBox(
                                                        width: 4.w,
                                                      ),
                                                      Text(
                                                        controller
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
                                                      Icon(
                                                        Icons.zoom_out_map,
                                                        color: Colors.black,
                                                        size: 18,
                                                      ),
                                                      SizedBox(
                                                        width: 4.w,
                                                      ),
                                                      Text(
                                                        controller
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
                                    ),
                        ],
                      );
                    },
                    onLoading: Shimmer.fromColors(
                      baseColor: (Colors.grey[300])!,
                      highlightColor: (Colors.grey[100])!,
                      enabled: true,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 20.h,
                          ),
                          Container(
                            height: 50.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(45.0),
                              ),
                              boxShadow: const <BoxShadow>[
                                BoxShadow(
                                  color: Colors.black45,
                                  blurRadius: 3.0,
                                ),
                              ],
                            ),
                            margin: EdgeInsets.all(5.0),
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            child: TextFormField(
                              style: TextStyle(
                                  fontSize: 28,
                                  height: 1,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              decoration: InputDecoration(
                                hintText: "search".tr,
                                hintStyle: TextStyle(
                                  fontSize: 28,
                                  color: Colors.grey,
                                ),
                                border: InputBorder.none,
                                prefixIcon: Padding(
                                  padding: EdgeInsets.only(left: 16),
                                  child: Icon(Icons.search),
                                ),
                                suffixIcon: Container(
                                    margin: EdgeInsets.all(7),
                                    width: 15.0,
                                    height: 15.0,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: Colors.black87, width: 1),
                                    ),
                                    child: Icon(Icons.filter_list_rounded)),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 7.h,
                          ),
                          Container(
                            height: 40,
                            color: Colors.white,
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          Container(
                            height: 70,
                            color: Colors.white,
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemBuilder: (_, __) => Card(
                                    margin: EdgeInsets.only(bottom: 17.0),
                                    elevation: 3.0,
                                    clipBehavior: Clip.antiAlias,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                      Radius.circular(15),
                                    )),
                                    child: Column(
                                      children: [
                                        Card(
                                          margin: EdgeInsets.only(bottom: 12.h),
                                          clipBehavior: Clip.antiAlias,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                            Radius.circular(15),
                                          )),
                                          child: Container(
                                            height: 300.h,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  itemCount: 3,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )),
        ),
      ),
    );
  }
}
