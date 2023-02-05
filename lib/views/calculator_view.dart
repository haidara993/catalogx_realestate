import 'package:catalog/controllers/control_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class OurServiceView extends StatelessWidget {
  const OurServiceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("our_service".tr),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: GetBuilder<ControlViewModel>(
            builder: (controller) => controller.obx(
                  (state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TabBar(
                          indicatorColor: Get.theme.indicatorColor,
                          controller: controller.tabController,
                          labelColor: Get.theme.indicatorColor,
                          unselectedLabelColor: Colors.grey,
                          tabs: controller.tabs,
                          isScrollable: true,
                          // indicator: BoxDecoration(
                          //   color: Color.fromARGB(255, 205, 227, 245),
                          // ),
                          onTap: (value) {
                            controller.updateService(value);
                            // controller.filterProperty();
                          },
                        ),
                        SizedBox(
                          height: 15.h,
                        ),
                        controller.btnLoading.value
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  itemCount: controller.selectedServices.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () async {},
                                      child: Card(
                                        margin:
                                            const EdgeInsets.only(bottom: 17.0),
                                        elevation: 1.0,
                                        clipBehavior: Clip.antiAlias,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                          Radius.circular(15),
                                        )),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0,
                                                      horizontal: 15.0),
                                              child: Text(
                                                controller
                                                    .selectedServices[index]
                                                    .name!,
                                                style: TextStyle(
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    controller
                                                        .selectedServices[index]
                                                        .phone!,
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
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Icon(
                                                    Icons.location_city,
                                                    size: 18,
                                                  ),
                                                  SizedBox(
                                                    width: 4.w,
                                                  ),
                                                  Text(
                                                    controller
                                                        .selectedServices[index]
                                                        .region!,
                                                    style: TextStyle(
                                                      fontSize: 18.sp,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 8.w,
                                                  ),
                                                  Text(
                                                    "-",
                                                    style: TextStyle(
                                                      fontSize: 18.sp,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 4.w,
                                                  ),
                                                  Text(
                                                    controller
                                                        .selectedServices[index]
                                                        .city!,
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
                          height: 40,
                          color: Colors.white,
                        ),
                        SizedBox(
                          height: 15.h,
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
    );
  }
}
