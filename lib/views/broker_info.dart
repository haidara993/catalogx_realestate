import 'package:carousel_slider/carousel_slider.dart';
import 'package:catalog/controllers/home_info_controller.dart';
import 'package:catalog/views/property_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BrokerInfo extends GetWidget<HomeInfoController> {
  BrokerInfo({Key? key}) : super(key: key);

  var f = NumberFormat("#,###", "en_US");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: GetBuilder<HomeInfoController>(builder: (context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: const CircleAvatar(
                  radius: 72,
                  backgroundColor: Colors.grey,
                  child: CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.blue,
                    // backgroundImage: NetworkImage(
                    //   controller.cartProductModel[index].image,
                    // ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 15.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.broker.name!,
                      style: TextStyle(
                          fontSize: 25.sp, fontWeight: FontWeight.bold),
                    ),
                    Text(controller.broker.region!),
                    Text(controller.broker.city!),
                    // Text(homeController.broker.phone!),
                  ],
                ),
              ),
              const Divider(),
              Text("العقارات المدرجة"),
              controller.properties.isEmpty
                  ? const Center(
                      child: Text("لايوجد أية عقارات"),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: controller.properties.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            var homeController = Get.put(HomeInfoController());
                            homeController.isLoading.value = true;
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setInt(
                                "homeId", controller.properties[index].id!);
                            homeController
                                .getHomeInfo(controller.properties[index].id!);
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
                            margin: const EdgeInsets.only(bottom: 17.0),
                            // elevation: 3.0,
                            clipBehavior: Clip.antiAlias,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            )),
                            child: Column(
                              children: [
                                Card(
                                  margin: EdgeInsets.only(bottom: 12.h),
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
                                              'image_${controller.properties[index].id}_details',
                                          child: CarouselSlider.builder(
                                              itemCount: controller
                                                  .properties[index]
                                                  .image!
                                                  .length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                          int itemIndex,
                                                          int pageViewIndex) =>
                                                      Image.network(
                                                        controller
                                                            .properties[index]
                                                            .image![itemIndex],
                                                        fit: BoxFit.cover,
                                                        height:
                                                            Get.height * 0.44,
                                                        loadingBuilder: (context,
                                                            child,
                                                            loadingProgress) {
                                                          if (loadingProgress ==
                                                              null) {
                                                            return child;
                                                          }
                                                          controller
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
                                                clipBehavior: Clip.hardEdge,
                                                enlargeCenterPage: true,
                                                scrollDirection:
                                                    Axis.horizontal,
                                              )),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.all(20),
                                          decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                            colors: [
                                              Colors.transparent,
                                              Colors.black.withOpacity(0.7),
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            stops: const [5.0, 1.0],
                                          )),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Colors.yellow[700],
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    5))),
                                                    width: 80.w,
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 4),
                                                    child: Center(
                                                      child: Text(
                                                        controller
                                                            .properties[index]
                                                            .getCategoryName(
                                                                controller
                                                                    .properties[
                                                                        index]
                                                                    .categoryId!),
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        controller
                                            .properties[index].addressTitle!,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "نوع العقار: ",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15.sp,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 4.w,
                                          ),
                                          Text(
                                            controller.properties[index]
                                                .getNatureName(controller
                                                    .properties[index]
                                                    .natureId!),
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.bold,
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
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        f.format(int.parse(controller
                                            .properties[index].price!)),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                        controller
                                            .properties[index].sleepRoomCount!,
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
                                        controller
                                            .properties[index].bathRoomCount!,
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
                                        controller.properties[index].area!,
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
        }),
      ),
    );
  }
}
