import 'package:catalog/controllers/property_controller.dart';
import 'package:catalog/models/broker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../utils/app_color.dart';

class AssignBroker extends StatelessWidget {
  int propertyId;
  AssignBroker({Key? key, required this.propertyId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("assign_broker".tr),
      ),
      body: GetBuilder<PropertyController>(builder: (controller) {
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          color: Colors.white,
          padding: EdgeInsets.symmetric(
              vertical: 5.h,
              horizontal: MediaQuery.of(context).size.width * .05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 60.h,
              ),
              Text("اختر مكتب عقاري"),
              SizedBox(
                height: 8.h,
              ),
              Text("الرجاء  اختيار مكتب عقاري لربط العقار معه"),
              SizedBox(
                height: 10.h,
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: DropdownButton<Broker>(
                      isExpanded: true,
                      value: controller.broker,
                      icon: const Icon(Icons.arrow_drop_down_outlined),
                      elevation: 16,
                      style: const TextStyle(color: Colors.blue),
                      underline: Container(
                        height: 2,
                        color: Colors.blueAccent,
                      ),
                      onChanged: (Broker? newValue) {
                        controller.updateBroker(newValue!);
                        // setState(() {
                        //   dropdownValue = newValue!;
                        // });
                      },
                      items: controller.brokers
                          .map<DropdownMenuItem<Broker>>((Broker value) {
                        return DropdownMenuItem<Broker>(
                          value: value,
                          child: Center(child: Text(value.name!)),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20.h,
              ),
              Center(
                child: Obx(() => ElevatedButton.icon(
                      icon: controller.btnLoading.value
                          ? const CircularProgressIndicator()
                          : const Icon(Icons.arrow_circle_right),
                      label: Text(
                        controller.btnLoading.value
                            ? 'جاري التحميل...'
                            : 'next'.tr,
                      ),
                      onPressed: controller.btnLoading.value
                          ? null
                          : () async {
                              controller.postBroker(propertyId);
                            },
                      style: ElevatedButton.styleFrom(
                          textStyle:
                              TextStyle(fontSize: 15.sp, color: Colors.white),
                          padding: EdgeInsets.symmetric(
                              vertical: 8.h, horizontal: 60.w)),
                    )),
              ),
            ],
          ),
        );
      }),
    );
  }
}
