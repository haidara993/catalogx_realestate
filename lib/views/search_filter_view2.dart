import 'package:catalog/controllers/search_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SearchFilterView2 extends StatelessWidget {
  const SearchFilterView2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
        ),
        body: SingleChildScrollView(
            child: GetBuilder<SearchViewModel>(
          builder: (controller) => Container(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Visibility(
                    visible: controller.isCheminyVisible,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .65,
                          child: Align(
                              alignment: Alignment.center,
                              child: Text("is_there_chimeny".tr)),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .25,
                          child: Center(
                            child: CheckboxListTile(
                              contentPadding: EdgeInsets.zero,
                              controlAffinity: ListTileControlAffinity.leading,
                              value: controller.ischimney,
                              onChanged: (bool? value) {
                                controller.updateValue(value!, "ischimney");
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: controller.isPoolVisible,
                    child: SizedBox(
                      height: 15.h,
                    ),
                  ),
                  Visibility(
                    visible: controller.isPoolVisible,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .65,
                          child: Align(
                              alignment: Alignment.center,
                              child: Text("is_there_pool".tr)),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .25,
                          child: CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            controlAffinity: ListTileControlAffinity.leading,
                            value: controller.isSwiming,
                            onChanged: (bool? value) {
                              controller.updateValue(value!, "isSwiming");
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: controller.isElevatorVisible,
                    child: SizedBox(
                      height: 15.h,
                    ),
                  ),
                  Visibility(
                    visible: controller.isElevatorVisible,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .65,
                          child: Align(
                              alignment: Alignment.center,
                              child: Text("is_there_elevator".tr)),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .25,
                          child: CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            controlAffinity: ListTileControlAffinity.leading,
                            value: controller.iselevator,
                            onChanged: (bool? value) {
                              controller.updateValue(value!, "iselevator");
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: controller.isRockCoverVisible,
                    child: SizedBox(
                      height: 15.h,
                    ),
                  ),
                  Visibility(
                    visible: controller.isRockCoverVisible,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .65,
                          child: Align(
                              alignment: Alignment.center,
                              child: Text("is_thee_building_cover".tr)),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .25,
                          child: CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            controlAffinity: ListTileControlAffinity.leading,
                            value: controller.isrockcover,
                            onChanged: (bool? value) {
                              controller.updateValue(value!, "isrockcover");
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: controller.isStairCoverVisible,
                    child: SizedBox(
                      height: 15.h,
                    ),
                  ),
                  Visibility(
                    visible: controller.isStairCoverVisible,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .65,
                          child: Align(
                              alignment: Alignment.center,
                              child: Text("is_the_stairs_cover".tr)),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .25,
                          child: CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            controlAffinity: ListTileControlAffinity.leading,
                            value: controller.isstaircover,
                            onChanged: (bool? value) {
                              controller.updateValue(value!, "isstaircover");
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: controller.isAltEnergyVisible,
                    child: SizedBox(
                      height: 15.h,
                    ),
                  ),
                  Visibility(
                    visible: controller.isAltEnergyVisible,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .65,
                          child: Align(
                              alignment: Alignment.center,
                              child: Text("is_equipped_with_solar_power".tr)),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .25,
                          child: CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            controlAffinity: ListTileControlAffinity.leading,
                            value: controller.isaltenergy,
                            onChanged: (bool? value) {
                              controller.updateValue(value!, "isaltenergy");
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: controller.isWaterWellVisible,
                    child: SizedBox(
                      height: 15.h,
                    ),
                  ),
                  Visibility(
                    visible: controller.isWaterWellVisible,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .65,
                          child: Align(
                              alignment: Alignment.center,
                              child: Text("is_there_well".tr)),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .25,
                          child: CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            controlAffinity: ListTileControlAffinity.leading,
                            value: controller.iswell,
                            onChanged: (bool? value) {
                              controller.updateValue(value!, "iswell");
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: controller.isGreenHouseVisible,
                    child: SizedBox(
                      height: 15.h,
                    ),
                  ),
                  Visibility(
                    visible: controller.isGreenHouseVisible,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .65,
                          child: Align(
                              alignment: Alignment.center,
                              child: Text("is_there_hanger".tr)),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .25,
                          child: CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            controlAffinity: ListTileControlAffinity.leading,
                            value: controller.ishanger,
                            onChanged: (bool? value) {
                              controller.updateValue(value!, "isGreenhouse");
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(Get.width * .9, 50),
                    ),
                    onPressed: () {
                      controller.filterProperty();
                    },
                    child: Center(
                      child: Text(
                        "search".tr,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                ]),
          ),
        )));
  }
}
