// ignore_for_file: use_key_in_widget_constructors

import 'package:catalog/controllers/auth_viewmodel.dart';
import 'package:catalog/controllers/control_viewmodel.dart';
import 'package:catalog/controllers/network_controller.dart';
import 'package:catalog/controllers/search_viewmodel.dart';
import 'package:catalog/enums/panel_state.dart';
import 'package:catalog/views/phone_screen.dart';
import 'package:catalog/views/widgets/no_internet_connection.dart';
import 'package:catalog/views/widgets/property_panel_info.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ControlView extends GetWidget<ControlViewModel> {
  final panelTransation = const Duration(milliseconds: 500);
  final loremIpsum =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.";

  void _onVerticalGesture(DragUpdateDetails details) {
    if (details.primaryDelta! < -7 &&
        Get.find<ControlViewModel>().panelState == PanelState.hidden) {
      Get.find<ControlViewModel>().changeToMidOpen();
    } else if (details.primaryDelta! < -7 &&
        Get.find<ControlViewModel>().panelState == PanelState.midopen) {
      Get.find<ControlViewModel>().changeToOpen();
    } else if (details.primaryDelta! > 7 &&
        Get.find<ControlViewModel>().panelState == PanelState.open) {
      Get.find<ControlViewModel>().changeToMidOpen();
    } else if (details.primaryDelta! > 7 &&
        Get.find<ControlViewModel>().panelState == PanelState.midopen) {
      Get.find<ControlViewModel>().changeToHidden();
      Get.find<SearchViewModel>().changeSelectedIndex(-1);
    }
  }

  double? _getTopForPanel(PanelState state, Size size) {
    if (state == PanelState.open) {
      return 0;
    } else if (state == PanelState.midopen) {
      return (size.height * 0.5);
    } else if (state == PanelState.hidden) {
      return (size.height);
    }
  }

  double? _getSizeForPanel(PanelState state, Size size) {
    if (state == PanelState.open) {
      return size.height;
    } else if (state == PanelState.midopen) {
      return (size.height * 0.5);
    } else if (state == PanelState.hidden) {
      return (size.height * 0.5);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        if (Get.find<ControlViewModel>().navigationValue2 != 2) {
          Get.find<ControlViewModel>().changeSelectedValue2(selectedValue: 2);
          return Future.value(false);
        } else {
          final shouldPop = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('هل أنت متأكد أنك تريد الخروج?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                    )),
                actionsAlignment: MainAxisAlignment.spaceAround,
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    child: const Text('نعم'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, false);
                    },
                    child: const Text('لا'),
                  ),
                ],
              );
            },
          );
          return shouldPop!;
        }
      },
      child: Directionality(
        textDirection: Get.locale?.languageCode == 'ar'
            ? TextDirection.rtl
            : TextDirection.ltr,
        child: Obx(() {
          return !(Get.find<AuthViewModel>().isLogged.value)
              ? PhoneScreen()
              : !(Get.find<NetworkController>().connectionStatus.value == 1 ||
                      Get.find<NetworkController>().connectionStatus.value == 2)
                  ? NoInternetConnection()
                  : GetBuilder<ControlViewModel>(
                      // init: Get.put(ControlViewModel()),
                      builder: (controller) {
                      return AnimatedBuilder(
                          animation: ControlViewModel(),
                          builder: (context, _) {
                            return Stack(
                              children: [
                                Scaffold(
                                  body: controller.currentScreen2,
                                  bottomNavigationBar: _bottomNavigationBar2(),
                                ),
                                AnimatedPositioned(
                                  duration: panelTransation,
                                  curve: Curves.decelerate,
                                  left: 0,
                                  right: 0,
                                  top: _getTopForPanel(
                                      controller.panelState, size),
                                  height: _getSizeForPanel(
                                      controller.panelState, size),
                                  child: GestureDetector(
                                    onVerticalDragUpdate: _onVerticalGesture,
                                    child: Container(
                                      child: AnimatedSwitcher(
                                        duration: panelTransation,
                                        child: _buildPanelOption(context),
                                      ),
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          });
                    });
        }),
      ),
    );
  }

  Widget _bottomNavigationBar2() {
    return GetBuilder<ControlViewModel>(
      builder: (controller) {
        return BottomNavigationBar(
          iconSize: 30,
          showSelectedLabels: true,
          type: BottomNavigationBarType.fixed,
          currentIndex: controller.navigationValue2,
          onTap: (value) {
            if (value == 1) {
              var favoriteController = Get.put(SearchViewModel());

              controller.changeSelectedValue2(selectedValue: value);
            } else {
              controller.changeSelectedValue2(selectedValue: value);
            }
          },
          items: [
            const BottomNavigationBarItem(
                icon: Icon(Icons.qr_code), label: "QR"),
            BottomNavigationBarItem(
                icon: const Icon(Icons.search), label: 'search'.tr),
            BottomNavigationBarItem(
                icon: const Icon(Icons.home), label: 'home'.tr),
            BottomNavigationBarItem(
                icon: const Icon(Icons.home_repair_service_outlined),
                label: 'services'.tr),
            BottomNavigationBarItem(
                icon: const Icon(Icons.list), label: 'more'.tr),
          ],
        );
      },
    );
  }

  Widget _buildPanelOption(BuildContext context) {
    if (Get.find<ControlViewModel>().panelState == PanelState.midopen) {
      return _buildPanelWidget(context);
    } else if (Get.find<ControlViewModel>().panelState == PanelState.open) {
      return _buildExpandedPanelWidget(context);
    } else {
      return const SizedBox.shrink();
    }
  }

  List<DataRow> buildRoomDetails() {
    List<DataRow> roomlist = [];
    for (var element in Get.find<ControlViewModel>().home.rooms!) {
      var roomcell = new DataRow(cells: [
        DataCell(Text('الأرضي'.tr)),
        DataCell(Text(element.type!)),
        DataCell(Text(element.length! + ' * ' + element.width! + 'meter'.tr)),
      ]);
      roomlist.add(roomcell);
    }
    return roomlist;
  }

  Widget _buildExpandedPanelWidget(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.44,
                child: Stack(
                  children: [
                    CarouselSlider.builder(
                        itemCount:
                            Get.find<ControlViewModel>().home.image!.length,
                        itemBuilder: (BuildContext context, int itemIndex,
                                int pageViewIndex) =>
                            Image.network(
                              Get.find<ControlViewModel>()
                                  .home
                                  .image![itemIndex]
                                  .image!,
                              fit: BoxFit.fill,
                              height: Get.height * 0.44,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                }
                                Get.find<ControlViewModel>()
                                    .homeCarouselIndicator
                                    .value = itemIndex;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
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
                          enlargeCenterPage: true,
                          scrollDirection: Axis.horizontal,
                        )),
                    Positioned(
                      top: 10.h,
                      right: 10.w,
                      child: GestureDetector(
                        onTap: () {
                          Get.find<ControlViewModel>().changeToMidOpen();
                          // Get.find<SearchViewModel>().changeSelectedIndex(-1);
                        },
                        child: Container(
                          height: 40.h,
                          width: 40.w,
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(45),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              PropertyPanelInfo(
                price: Get.find<ControlViewModel>().home.realEstate!.price!,
                addresstitle:
                    Get.find<ControlViewModel>().home.realEstate!.addressTitle!,
                area: Get.find<ControlViewModel>().home.realEstate!.area!,
                bednum: Get.find<ControlViewModel>()
                    .home
                    .realEstate!
                    .sleepRoomCount!,
                bathnum:
                    Get.find<ControlViewModel>().home.realEstate!.bathRoomCount,
                totalarea:
                    Get.find<ControlViewModel>().home.realEstate!.totalArea,
                isliked: Get.find<SearchViewModel>()
                    .favoritePropertiesId
                    .contains(
                        Get.find<ControlViewModel>().home.realEstate!.id!),
                onPressed: (p0) async {
                  print(p0);
                  if (p0) {
                    Get.find<SearchViewModel>().unlikeProduct(
                        Get.find<ControlViewModel>().home.realEstate!.id!);
                    return false;
                  } else {
                    Get.find<SearchViewModel>()
                        .likeProductInfo(Get.find<ControlViewModel>().home);
                    return true;
                  }
                },
              ),
              Container(
                height: 60.h,
                padding: EdgeInsets.symmetric(vertical: 5.h),
                decoration: const BoxDecoration(
                    border: Border(
                  top: BorderSide(width: 1.0, color: Colors.black12),
                )),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [const Icon(Icons.share), Text("share".tr)],
                    ),
                    Column(
                      children: [const Icon(Icons.print), Text("print".tr)],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 100.h,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                      target: LatLng(
                        double.parse(
                            Get.find<ControlViewModel>().home.realEstate!.lat!),
                        double.parse(Get.find<ControlViewModel>()
                            .home
                            .realEstate!
                            .long!),
                      ),
                      zoom: 13),
                  zoomControlsEnabled: false,
                  onMapCreated: (controller) => Get.find<ControlViewModel>()
                      .setGoolgeMapController(controller),
                  rotateGesturesEnabled: false,
                  mapType: MapType.normal,
                  markers: Get.find<ControlViewModel>().myMarker,
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              Container(
                decoration: const BoxDecoration(
                    border: Border(
                  top: BorderSide(color: Colors.black12, width: 1.0),
                  bottom: BorderSide(color: Colors.black12, width: 1.0),
                )),
                child: ExpandablePanel(
                  theme: const ExpandableThemeData(
                    headerAlignment: ExpandablePanelHeaderAlignment.center,
                    tapBodyToCollapse: true,
                  ),
                  header: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "room_details".tr,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )),
                  collapsed: const SizedBox.shrink(),
                  expanded: Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(10.h),
                    child: DataTable(columns: <DataColumn>[
                      DataColumn(
                        label: Text(
                          'level'.tr,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'room'.tr,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'dimensions'.tr,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ], rows: buildRoomDetails()),
                  ),
                  builder: (_, collapsed, expanded) {
                    return Padding(
                      padding: EdgeInsets.only(
                          left: 10.w, right: 10.w, bottom: 10.h),
                      child: Expandable(
                        collapsed: collapsed,
                        expanded: expanded,
                        theme: const ExpandableThemeData(crossFadePoint: 0),
                      ),
                    );
                  },
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.black12, width: 1.0),
                  ),
                ),
                child: ExpandablePanel(
                  theme: const ExpandableThemeData(
                    headerAlignment: ExpandablePanelHeaderAlignment.center,
                    tapBodyToCollapse: true,
                  ),
                  header: Padding(
                      padding: EdgeInsets.all(10.h),
                      child: Text(
                        "features".tr,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      )),
                  collapsed: const SizedBox.shrink(),
                  expanded: DataTable(
                    columnSpacing: 100,
                    columns: const <DataColumn>[
                      DataColumn(
                        label: Text(
                          '',
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          '',
                        ),
                      ),
                    ],
                    rows: <DataRow>[
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text(
                            'category'.tr,
                            style: const TextStyle(color: Colors.grey),
                          )),
                          DataCell(Text(
                              Get.find<ControlViewModel>().home.state!.state!)),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text(
                            'area'.tr,
                            style: const TextStyle(color: Colors.grey),
                          )),
                          DataCell(Text(Get.find<ControlViewModel>()
                                  .home
                                  .realEstate!
                                  .area! +
                              'meter'.tr)),
                        ],
                      ),
                      // DataRow(
                      //   cells: <DataCell>[
                      //     DataCell(Text(
                      //       'direction'.tr,
                      //       style: TextStyle(color: Colors.grey),
                      //     )),
                      //     DataCell(Text(Get.find<ControlViewModel>()
                      //         .home
                      //         .realEstate!
                      //         .direction!)),
                      //   ],
                      // ),
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text(
                            'is_there_chimeny'.tr,
                            style: const TextStyle(color: Colors.grey),
                          )),
                          DataCell(Text(Get.find<ControlViewModel>()
                                      .home
                                      .realEstate!
                                      .options!
                                      .chimney! ==
                                  "true"
                              ? "true".tr
                              : "false".tr)),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text(
                            'is_there_pool'.tr,
                            style: const TextStyle(color: Colors.grey),
                          )),
                          DataCell(Text(Get.find<ControlViewModel>()
                                      .home
                                      .realEstate!
                                      .options!
                                      .swimmingPool! ==
                                  "true"
                              ? "true".tr
                              : "false".tr)),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text(
                            'is_there_elevator'.tr,
                            style: const TextStyle(color: Colors.grey),
                          )),
                          DataCell(Text(Get.find<ControlViewModel>()
                                      .home
                                      .realEstate!
                                      .options!
                                      .elevator! ==
                                  "true"
                              ? "true".tr
                              : "false".tr)),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text(
                            'is_thee_building_cover'.tr,
                            style: const TextStyle(color: Colors.grey),
                          )),
                          DataCell(Text(Get.find<ControlViewModel>()
                                      .home
                                      .realEstate!
                                      .options!
                                      .withRocks! ==
                                  "true"
                              ? "true".tr
                              : "false".tr)),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text(
                            'is_the_stairs_cover'.tr,
                            style: const TextStyle(color: Colors.grey),
                          )),
                          DataCell(Text(Get.find<ControlViewModel>()
                                      .home
                                      .realEstate!
                                      .options!
                                      .staircase! ==
                                  "true"
                              ? "true".tr
                              : "false".tr)),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text(
                            'is_equipped_with_solar_power'.tr,
                            style: const TextStyle(color: Colors.grey),
                          )),
                          DataCell(Text(Get.find<ControlViewModel>()
                                      .home
                                      .realEstate!
                                      .options!
                                      .alternativeEnergy! ==
                                  "true"
                              ? "true".tr
                              : "false".tr)),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text(
                            'is_there_well'.tr,
                            style: const TextStyle(color: Colors.grey),
                          )),
                          DataCell(Text(Get.find<ControlViewModel>()
                                      .home
                                      .realEstate!
                                      .options!
                                      .waterWell! ==
                                  "1"
                              ? "true".tr
                              : "false".tr)),
                        ],
                      ),
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text(
                            'is_there_hanger'.tr,
                            style: const TextStyle(color: Colors.grey),
                          )),
                          DataCell(Text(Get.find<ControlViewModel>()
                                      .home
                                      .realEstate!
                                      .options!
                                      .hangar! ==
                                  "1"
                              ? "true".tr
                              : "false".tr)),
                        ],
                      ),
                    ],
                  ),
                  builder: (_, collapsed, expanded) {
                    return Padding(
                      padding: EdgeInsets.only(
                          left: 10.w, right: 10.w, bottom: 10.h),
                      child: Expandable(
                        collapsed: collapsed,
                        expanded: expanded,
                        theme: const ExpandableThemeData(crossFadePoint: 0),
                      ),
                    );
                  },
                ),
              ),
              // Container(
              //   decoration: const BoxDecoration(
              //     border: Border(
              //       bottom: BorderSide(color: Colors.black12, width: 1.0),
              //     ),
              //   ),
              //   child: ExpandablePanel(
              //     theme: const ExpandableThemeData(
              //       headerAlignment: ExpandablePanelHeaderAlignment.center,
              //       tapBodyToCollapse: true,
              //     ),
              //     header: Padding(
              //         padding: EdgeInsets.all(10.h),
              //         child: Text(
              //           "listed_brokers".tr,
              //           style: const TextStyle(fontWeight: FontWeight.bold),
              //         )),
              //     collapsed: const SizedBox.shrink(),
              //     expanded: ListView.separated(
              //         shrinkWrap: true,
              //         padding: EdgeInsets.zero,
              //         itemBuilder: (context, index) {
              //           return Column(
              //             children: [
              //               Padding(
              //                 padding: EdgeInsets.only(bottom: 10.h),
              //                 child: Row(
              //                   mainAxisAlignment: MainAxisAlignment.start,
              //                   children: [
              //                     Padding(
              //                       padding:
              //                           EdgeInsets.symmetric(horizontal: 10.h),
              //                       child: const CircleAvatar(
              //                         radius: 30,
              //                         backgroundColor: Colors.blue,
              //                         // backgroundImage: NetworkImage(
              //                         //   controller.cartProductModel[index].image,
              //                         // ),
              //                       ),
              //                     ),
              //                     Padding(
              //                       padding:
              //                           EdgeInsets.symmetric(horizontal: 15.w),
              //                       child: Column(
              //                         crossAxisAlignment:
              //                             CrossAxisAlignment.start,
              //                         children: [
              //                           Text(
              //                             DataConstants.brokers[index].name!,
              //                             style: TextStyle(
              //                                 fontSize: 20.sp,
              //                                 fontWeight: FontWeight.bold),
              //                           ),
              //                           Text(DataConstants
              //                               .brokers[index].address!),
              //                           Text(DataConstants
              //                               .brokers[index].phonenumber!),
              //                         ],
              //                       ),
              //                     )
              //                   ],
              //                 ),
              //               ),
              //               Padding(
              //                 padding: EdgeInsets.symmetric(horizontal: 10.w),
              //                 child: Row(
              //                   mainAxisAlignment:
              //                       MainAxisAlignment.spaceBetween,
              //                   children: [
              //                     Column(
              //                       children: [
              //                         const Icon(Icons.home),
              //                         const Text("معلومات"),
              //                       ],
              //                     ),
              //                     Column(
              //                       // ignore: prefer_const_literals_to_create_immutables
              //                       children: [
              //                         const Icon(Icons.phone),
              //                         const Text("اتصل بنا"),
              //                       ],
              //                     ),
              //                     Column(
              //                       children: [
              //                         const Icon(Icons.email),
              //                         const Text("أرسل ايميل"),
              //                       ],
              //                     ),
              //                     Column(
              //                       children: [
              //                         const Icon(Icons.insert_drive_file),
              //                         const Text("موقع الويب"),
              //                       ],
              //                     ),
              //                   ],
              //                 ),
              //               )
              //             ],
              //           );
              //         },
              //         separatorBuilder: (context, index) =>
              //             const Divider(color: Colors.grey),
              //         itemCount: DataConstants.brokers.length),
              //     builder: (_, collapsed, expanded) {
              //       return Padding(
              //         padding: EdgeInsets.only(
              //             left: 10.w, right: 10.w, bottom: 10.h),
              //         child: Expandable(
              //           collapsed: collapsed,
              //           expanded: expanded,
              //           theme: const ExpandableThemeData(crossFadePoint: 0),
              //         ),
              //       );
              //     },
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPanelWidget(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: GetX<ControlViewModel>(
          builder: (controller) => controller.btnLoading.value
              ? Shimmer.fromColors(
                  baseColor: (Colors.grey[300])!,
                  highlightColor: (Colors.grey[100])!,
                  enabled: true,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.3,
                        color: Colors.white,
                      ),
                      Padding(
                        padding:
                            EdgeInsets.only(top: 7.h, left: 20.w, right: 20.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 30.h,
                              width: 175.w,
                              color: Colors.white,
                            ),
                            Container(
                              height: 30,
                              width: 30,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Container(
                          height: 50.h,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ))
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.33,
                      child: Stack(
                        children: [
                          CarouselSlider.builder(
                              itemCount: Get.find<ControlViewModel>()
                                  .home
                                  .image!
                                  .length,
                              itemBuilder: (BuildContext context, int itemIndex,
                                      int pageViewIndex) =>
                                  Image.network(
                                    Get.find<ControlViewModel>()
                                        .home
                                        .image![itemIndex]
                                        .image!,
                                    fit: BoxFit.fill,
                                    height: Get.height * 0.44,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      }
                                      Get.find<ControlViewModel>()
                                          .homeCarouselIndicator
                                          .value = itemIndex;
                                      return Center(
                                        child: CircularProgressIndicator(
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
                                enlargeCenterPage: true,
                                scrollDirection: Axis.horizontal,
                              )),
                          Positioned(
                            top: 10.h,
                            right: 10.w,
                            child: GestureDetector(
                              onTap: () {
                                Get.find<ControlViewModel>().changeToHidden();
                                Get.find<SearchViewModel>()
                                    .changeSelectedIndex(-1);
                              },
                              child: Container(
                                height: 40.h,
                                width: 40.w,
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(45),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    PropertyPanelInfo(
                      price:
                          Get.find<ControlViewModel>().home.realEstate!.price!,
                      addresstitle: Get.find<ControlViewModel>()
                          .home
                          .realEstate!
                          .addressTitle!,
                      area: Get.find<ControlViewModel>().home.realEstate!.area!,
                      bednum: Get.find<ControlViewModel>()
                          .home
                          .realEstate!
                          .sleepRoomCount!,
                      bathnum: Get.find<ControlViewModel>()
                          .home
                          .realEstate!
                          .bathRoomCount,
                      totalarea: Get.find<ControlViewModel>()
                          .home
                          .realEstate!
                          .totalArea,
                      isliked: Get.find<SearchViewModel>()
                          .favoritePropertiesId
                          .contains(Get.find<ControlViewModel>()
                              .home
                              .realEstate!
                              .id!),
                      onPressed: (p0) async {
                        print(p0);
                        if (p0) {
                          Get.find<SearchViewModel>().unlikeProduct(
                              Get.find<ControlViewModel>()
                                  .home
                                  .realEstate!
                                  .id!);
                          return false;
                        } else {
                          Get.find<SearchViewModel>().likeProductInfo(
                              Get.find<ControlViewModel>().home);
                          return true;
                        }
                      },
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
