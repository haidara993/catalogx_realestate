import 'package:carousel_slider/carousel_slider.dart';
import 'package:catalog/controllers/auth_viewmodel.dart';
import 'package:catalog/views/add_property/pinned_payment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class UserInfo extends StatelessWidget {
  UserInfo({Key? key}) : super(key: key);

  var f = NumberFormat("#,###", "en_US");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: GetBuilder<AuthViewModel>(builder: (controller) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: LimitedBox(
                  maxHeight: 400.0,
                  maxWidth: 400.0,
                  child: Lottie.asset(
                    'assets/lottiefiles/avatar-man.json',
                    fit: BoxFit.cover,
                  ),
                ),
                // child: const CircleAvatar(
                //   radius: 72,
                //   backgroundColor: Colors.grey,
                //   child: CircleAvatar(
                //     radius: 70,
                //     backgroundColor: Colors.blue,
                //     // backgroundImage: NetworkImage(
                //     //   controller.cartProductModel[index].image,
                //     // ),
                //   ),
                // ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    controller.userModel!.name!,
                    style:
                        TextStyle(fontSize: 25.sp, fontWeight: FontWeight.bold),
                  ),
                  // Text(controller.userModel!.region!),
                  Text(controller.userModel!.city!),
                  Text(controller.userModel!.phone!),
                ],
              ),
              const Divider(),
              Text("العقارات المضافة من قبلك وتنتظر موافقة الأدمن"),
              controller.pinnedProperties!.isEmpty
                  ? const Center(
                      child: Text("لايوجد أية عقارات تحتاج موافقة الأدمن"),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: controller.pinnedProperties!.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            Get.to(PinnedPaymentPage(
                                propertyId: controller
                                    .pinnedProperties![index].propertyId));
                          },
                          child: Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 17.0, vertical: 7),
                            // elevation: 3.0,
                            clipBehavior: Clip.antiAlias,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            )),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    controller.pinnedProperties![index].address,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    controller
                                        .pinnedProperties![index].brokername,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
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
