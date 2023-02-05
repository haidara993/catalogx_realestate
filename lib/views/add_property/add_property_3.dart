// ignore_for_file: use_key_in_widget_constructors, unused_local_variable

import 'dart:io';

import 'package:catalog/controllers/property_controller.dart';
import 'package:catalog/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';

class AddPropertyThree extends GetWidget<PropertyController> {
  final _formKey = GlobalKey<FormState>();
  final _dialogformKey = GlobalKey<FormState>();
  List<Widget> _buildimagelist() {
    List<Widget> list = [];
    int i = 0;
    for (var element in controller.imageFileList!) {
      var elem = Container(
        padding: const EdgeInsets.all(7),
        height: 100.h,
        width: 100.w,
        child: Image.file(File(controller.imageFileList![i].path)),
      );
      i++;
      list.add(elem);
    }
    return list;
  }

  Widget _previewImages() {
    // final Text? retrieveError = _getRetrieveErrorWidget();
    // if (retrieveError != null) {
    //   return retrieveError;
    // }
    if (controller.imageFileList != null) {
      return Wrap(
        children: _buildimagelist(),
      );
    } else {
      return const Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text("add_property".tr),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Visibility(
                visible: (controller.nature.id! == 1 ||
                    controller.nature.id! == 2 ||
                    controller.nature.id! == 6),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(
                      vertical: 5.h,
                      horizontal: MediaQuery.of(context).size.width * .05),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 8.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "add_room".tr,
                            style: TextStyle(
                                fontSize: 18.sp, fontWeight: FontWeight.bold),
                          ),
                          ButtonTheme(
                            minWidth: 100,
                            child: ElevatedButton(
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      child: GetBuilder<PropertyController>(
                                        builder: (controller) => Container(
                                          padding: const EdgeInsets.all(8.0),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .6,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                height: 15.h,
                                              ),
                                              Text("add_room".tr),
                                              SizedBox(
                                                height: 7.h,
                                              ),
                                              Form(
                                                  key: _dialogformKey,
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text("room".tr),
                                                          SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                .3,
                                                            child:
                                                                DropdownButton<
                                                                    String>(
                                                              isExpanded: true,
                                                              value: controller
                                                                  .selectedRoomType,
                                                              icon: const Icon(Icons
                                                                  .arrow_drop_down_outlined),
                                                              elevation: 16,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .blue),
                                                              underline:
                                                                  Container(
                                                                height: 2,
                                                                color: Colors
                                                                    .blueAccent,
                                                              ),
                                                              onChanged: (String?
                                                                  newValue) {
                                                                controller
                                                                        .roomType =
                                                                    newValue!;
                                                                controller
                                                                    .updateSelectedRoomType(
                                                                        newValue);
                                                              },
                                                              items: controller
                                                                  .roomTypesList
                                                                  .map<
                                                                      DropdownMenuItem<
                                                                          String>>((String
                                                                      value) {
                                                                return DropdownMenuItem<
                                                                    String>(
                                                                  value: value,
                                                                  child: Center(
                                                                      child: Text(
                                                                          value)),
                                                                );
                                                              }).toList(),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 7.h,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text("length".tr),
                                                          SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  .3,
                                                              child:
                                                                  TextFormField(
                                                                keyboardType:
                                                                    TextInputType
                                                                        .number,
                                                                // decoration:
                                                                //     InputDecoration(),
                                                                onSaved:
                                                                    (length) {
                                                                  controller
                                                                          .roomLength =
                                                                      length!;
                                                                },
                                                                validator:
                                                                    (text) {
                                                                  if (text ==
                                                                          null ||
                                                                      text.isEmpty) {
                                                                    return 'Can\'t be empty';
                                                                  }
                                                                  return null;
                                                                },
                                                              ))
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 7.h,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text("width".tr),
                                                          SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  .3,
                                                              child:
                                                                  TextFormField(
                                                                keyboardType:
                                                                    TextInputType
                                                                        .number,
                                                                decoration:
                                                                    const InputDecoration(),
                                                                onSaved:
                                                                    (width) {
                                                                  controller
                                                                          .roomWidth =
                                                                      width!;
                                                                },
                                                                onChanged:
                                                                    (value) {},
                                                                validator:
                                                                    (text) {
                                                                  if (text ==
                                                                          null ||
                                                                      text.isEmpty) {
                                                                    return 'Can\'t be empty';
                                                                  }
                                                                  return null;
                                                                },
                                                              ))
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 7.h,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text("الطابق".tr),
                                                          SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  .3,
                                                              child:
                                                                  TextFormField(
                                                                keyboardType:
                                                                    TextInputType
                                                                        .number,
                                                                decoration:
                                                                    const InputDecoration(),
                                                                onSaved:
                                                                    (width) {
                                                                  controller
                                                                          .roomFloor =
                                                                      width!;
                                                                },
                                                                onChanged:
                                                                    (value) {},
                                                                validator:
                                                                    (text) {
                                                                  if (text ==
                                                                          null ||
                                                                      text.isEmpty) {
                                                                    return 'Can\'t be empty';
                                                                  }
                                                                  return null;
                                                                },
                                                              ))
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 15.h,
                                                      ),
                                                      ElevatedButton(
                                                        style: ButtonStyle(
                                                          minimumSize: MaterialStateProperty
                                                              .all<Size>(Size(
                                                                  MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      .25,
                                                                  0)),
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .resolveWith<
                                                                          Color>(
                                                                      (states) {
                                                            if (states.contains(
                                                                MaterialState
                                                                    .disabled)) {
                                                              return AppColor
                                                                  .BlueBtn;
                                                            }
                                                            return AppColor
                                                                .BlueBtn;
                                                          }),
                                                          shape: MaterialStateProperty.all<
                                                                  OutlinedBorder>(
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                          )),
                                                          padding: MaterialStateProperty.all<
                                                                  EdgeInsets>(
                                                              EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          5.h,
                                                                      horizontal:
                                                                          5.w)),
                                                          elevation:
                                                              MaterialStateProperty
                                                                  .all<double>(
                                                                      0.5),
                                                        ),
                                                        onPressed: () async {
                                                          if (_dialogformKey
                                                              .currentState!
                                                              .validate()) {
                                                            _dialogformKey
                                                                .currentState!
                                                                .save();
                                                            controller
                                                                .addRoom();
                                                            Get.back();
                                                          }
                                                        },
                                                        child: Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical:
                                                                      5.h),
                                                          child: Text(
                                                            'add_room'.tr,
                                                            style: TextStyle(
                                                                fontSize: 15.sp,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 7.h,
                                                      ),
                                                      ElevatedButton(
                                                        style: ButtonStyle(
                                                          minimumSize: MaterialStateProperty
                                                              .all<Size>(Size(
                                                                  MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width *
                                                                      .25,
                                                                  0)),
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .resolveWith<
                                                                          Color>(
                                                                      (states) {
                                                            if (states.contains(
                                                                MaterialState
                                                                    .disabled)) {
                                                              return AppColor
                                                                  .GreyIcons;
                                                            }
                                                            return AppColor
                                                                .GreyIcons;
                                                          }),
                                                          shape: MaterialStateProperty.all<
                                                                  OutlinedBorder>(
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                          )),
                                                          padding: MaterialStateProperty.all<
                                                                  EdgeInsets>(
                                                              EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          5.h,
                                                                      horizontal:
                                                                          5.w)),
                                                          elevation:
                                                              MaterialStateProperty
                                                                  .all<double>(
                                                                      0.5),
                                                        ),
                                                        onPressed: () async {
                                                          Get.back();
                                                        },
                                                        child: Padding(
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical:
                                                                      5.h),
                                                          child: Text(
                                                            'cancel'.tr,
                                                            style: TextStyle(
                                                                fontSize: 15.sp,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ),
                                      elevation: 1.0,
                                    );
                                  },
                                );
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 5.h),
                                child: Text(
                                  'add_room'.tr,
                                  style: TextStyle(
                                      fontSize: 15.sp, color: Colors.white),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      Container(
                        color: Colors.white,
                        padding: EdgeInsets.all(10.h),
                        child: controller.roomLengths.isEmpty
                            ? const Text("أضف غرفة لاظهار التفاصيل.")
                            : DataTable(
                                columns: <DataColumn>[
                                  DataColumn(
                                    label: Text(
                                      'room'.tr,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'length'.tr,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'width'.tr,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const DataColumn(
                                    label: Text(
                                      "الطابق",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                                rows: controller.rowList,
                              ),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                color: Colors.white,
                padding: EdgeInsets.symmetric(
                    vertical: 5.h,
                    horizontal: MediaQuery.of(context).size.width * .05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 15.h,
                    ),
                    Text("additional_info".tr),
                    // Text("additional_info_specification".tr),
                    TextFormField(
                      maxLines: 4,
                      onSaved: (description) {
                        controller.descrition = description;
                      },
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                color: Colors.white,
                padding: EdgeInsets.symmetric(
                    vertical: 5.h,
                    horizontal: MediaQuery.of(context).size.width * .05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 6.h,
                    ),
                    Text("add_photo".tr),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("الرجاء اختيار صور للعقار...."),
                        const Spacer(),
                        IconButton(
                            onPressed: () async {
                              await controller.imageButtonPressed(
                                  ImageSource.gallery,
                                  isMultiImage: true);
                            },
                            icon: const Icon(Icons.camera_alt)),
                      ],
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    GetBuilder<PropertyController>(
                      builder: (controller) => _previewImages(),
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 10),
                color: Colors.white,
                padding: EdgeInsets.symmetric(
                    vertical: 5.h,
                    horizontal: MediaQuery.of(context).size.width * .05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 15.h,
                    ),
                    Text("add_video".tr),
                    // Text("add_video_specification"),
                    TextFormField(),
                    SizedBox(
                      height: 15.h,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15.h,
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
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                controller.postProperty();
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(Get.width * .9, 50),
                        // textStyle:
                        //     TextStyle(fontSize: 20.sp, color: Colors.white),
                        // padding: const EdgeInsets.symmetric(
                        //     vertical: 8.0, horizontal: 25.0),
                      ),
                    )),
              ),
              SizedBox(
                height: 15.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
