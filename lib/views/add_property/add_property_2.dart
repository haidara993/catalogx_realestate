// ignore_for_file: use_key_in_widget_constructors

import 'package:catalog/controllers/property_controller.dart';
import 'package:catalog/utils/app_color.dart';
import 'package:catalog/views/add_property/add_property_3.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class AddPropertyTwo extends GetWidget<PropertyController> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("add_property".tr),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: 25.h,
              horizontal: MediaQuery.of(context).size.width * .05),
          child: GetBuilder<PropertyController>(
              builder: (controller) => controller.loading.value
                  ? Container(
                      color: Colors.white,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "مميزات إضافية".tr,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Visibility(
                            visible: controller.isCheminyVisible,
                            child: SizedBox(
                              height: 15.h,
                            ),
                          ),
                          Visibility(
                            visible: controller.isCheminyVisible,
                            child: Card(
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .60,
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: Text("is_there_chimeny".tr)),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .25,
                                    child: CheckboxListTile(
                                      contentPadding: EdgeInsets.zero,
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      value: controller.ischimney,
                                      onChanged: (bool? value) {
                                        controller.updateValue(
                                            value!, "ischimney");
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Visibility(
                            visible: controller.isPoolVisible,
                            child: SizedBox(
                              height: 5.h,
                            ),
                          ),
                          Visibility(
                            visible: controller.isPoolVisible,
                            child: Card(
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .60,
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: Text("is_there_pool".tr)),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .25,
                                    child: CheckboxListTile(
                                      contentPadding: EdgeInsets.zero,
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      value: controller.isSwiming,
                                      onChanged: (bool? value) {
                                        controller.updateValue(
                                            value!, "isSwiming");
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Visibility(
                            visible: controller.isElevatorVisible,
                            child: SizedBox(
                              height: 5.h,
                            ),
                          ),
                          Visibility(
                            visible: controller.isElevatorVisible,
                            child: Card(
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .60,
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: Text("is_there_elevator".tr)),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .25,
                                    child: CheckboxListTile(
                                      contentPadding: EdgeInsets.zero,
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      value: controller.iselevator,
                                      onChanged: (bool? value) {
                                        controller.updateValue(
                                            value!, "iselevator");
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Visibility(
                            visible: controller.isRockCoverVisible,
                            child: SizedBox(
                              height: 5.h,
                            ),
                          ),
                          Visibility(
                            visible: controller.isRockCoverVisible,
                            child: Card(
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .60,
                                    child: Align(
                                        alignment: Alignment.center,
                                        child:
                                            Text("is_thee_building_cover".tr)),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .25,
                                    child: CheckboxListTile(
                                      contentPadding: EdgeInsets.zero,
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      value: controller.isrockcover,
                                      onChanged: (bool? value) {
                                        controller.updateValue(
                                            value!, "isrockcover");
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Visibility(
                            visible: controller.isStairCoverVisible,
                            child: SizedBox(
                              height: 5.h,
                            ),
                          ),
                          Visibility(
                            visible: controller.isStairCoverVisible,
                            child: Card(
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .60,
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: Text("is_the_stairs_cover".tr)),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .25,
                                    child: CheckboxListTile(
                                      contentPadding: EdgeInsets.zero,
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      value: controller.isstaircover,
                                      onChanged: (bool? value) {
                                        controller.updateValue(
                                            value!, "isstaircover");
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Visibility(
                            visible: controller.isAltEnergyVisible,
                            child: SizedBox(
                              height: 5.h,
                            ),
                          ),
                          Visibility(
                            visible: controller.isAltEnergyVisible,
                            child: Card(
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .60,
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                            "is_equipped_with_solar_power".tr)),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .25,
                                    child: CheckboxListTile(
                                      contentPadding: EdgeInsets.zero,
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      value: controller.isaltenergy,
                                      onChanged: (bool? value) {
                                        controller.updateValue(
                                            value!, "isaltenergy");
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Visibility(
                            visible: controller.isWaterWellVisible,
                            child: SizedBox(
                              height: 5.h,
                            ),
                          ),
                          Visibility(
                            visible: controller.isWaterWellVisible,
                            child: Card(
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .60,
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: Text("is_there_well".tr)),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .25,
                                    child: CheckboxListTile(
                                      contentPadding: EdgeInsets.zero,
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      value: controller.iswell,
                                      onChanged: (bool? value) {
                                        controller.updateValue(
                                            value!, "iswell");
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Visibility(
                            visible: controller.isGreenHouseVisible,
                            child: SizedBox(
                              height: 5.h,
                            ),
                          ),
                          Visibility(
                            visible: controller.isGreenHouseVisible,
                            child: Card(
                              color: Colors.white,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .60,
                                    child: Align(
                                        alignment: Alignment.center,
                                        child: Text("is_there_hanger".tr)),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * .25,
                                    child: CheckboxListTile(
                                      contentPadding: EdgeInsets.zero,
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      value: controller.ishanger,
                                      onChanged: (bool? value) {
                                        controller.updateValue(
                                            value!, "ishangar");
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 25.h,
                          ),
                          Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(Get.width * .9, 50),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  Get.to(AddPropertyThree());
                                }
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                child: Text(
                                  'next'.tr,
                                  style: TextStyle(
                                      fontSize: 17.sp, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
        ),
      ),
    );
  }
}
