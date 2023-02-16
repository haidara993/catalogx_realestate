// ignore_for_file: prefer_final_fields, unnecessary_null_comparison, unused_field

import 'dart:async';
import 'dart:convert';

import 'package:catalog/controllers/search_viewmodel.dart';
import 'package:catalog/enums/panel_state.dart';
import 'package:catalog/helpers/http_helper.dart';
import 'package:catalog/models/broker.dart';
import 'package:catalog/models/item_key_model.dart';
import 'package:catalog/models/services_model.dart';
import 'package:catalog/services/broker_service.dart';
import 'package:catalog/services/our_services_service.dart';
import 'package:catalog/services/property_service.dart';
import 'package:catalog/views/home_view2.dart';
import 'package:catalog/views/qr_view.dart';
import 'package:catalog/views/calculator_view.dart';
import 'package:catalog/views/home_view.dart';
import 'package:catalog/views/more_view.dart';
import 'package:catalog/views/add_property/add_property.dart';
import 'package:catalog/views/search_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../models/property_model.dart';

class ControlViewModel extends GetxController
    with GetTickerProviderStateMixin, StateMixin {
  var isLoading = false.obs;
  final btnLoading = false.obs;

  late Position currentPosition;

  late TabController tabController;
  late List<Widget> tabs = [];
  // late TabController naturesTabController;
  // late List<Widget> naturesTabs = [];
  late List<String> serviceTypes = [];

  ValueNotifier<bool> _loading = ValueNotifier(false);
  ValueNotifier<bool> get loading => _loading;

  int _navigationValue = 2;
  get navigationValue => _navigationValue;

  int _navigationValue2 = 2;
  get navigationValue2 => _navigationValue2;

  Widget _currentScreen = HomeView();
  get currentScreen => _currentScreen;

  Widget _currentScreen2 = const HomeView2();
  get currentScreen2 => _currentScreen2;

  PanelState _panelState = PanelState.hidden;
  PanelState get panelState => _panelState;

  late AnimationController _animationController;

  late GoogleMapController _googleMapController;
  GoogleMapController get googleMapController => _googleMapController;

  Set<Marker> _myMarker = {};
  Set<Marker> get myMarker => _myMarker;

  late PropertyModel _home;
  PropertyModel get home => _home;

  var homeCarouselIndicator = 0.obs;

  List<ServiceModel> _selectedServices = [];
  List<ServiceModel> get selectedServices => _selectedServices;

  List<ServiceModel> _serviceModels = [];
  List<ServiceModel> get serviceModels => _serviceModels;

  late ServiceModel _serviceModel;
  ServiceModel get serviceModel => _serviceModel;

  late String _selectedservice;
  String get selectedservice => _selectedservice;

  List<Nature> _natures = [];
  List<Nature> get natures => _natures;
  late Nature _nature;
  Nature get nature => _nature;

  List<FilteredProperty> _filteredProperties = [];
  List<FilteredProperty> get filteredProperties => _filteredProperties;

  @override
  void onInit() async {
    super.onInit();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 2500,
      ),
    );
    change(null, status: RxStatus.loading());
    await getServices();
    // getCategories();
    // getRegions();
    // getCities();
    // getNatures();
    // getTypes();
    // getStates();
    // getProRes();
    // getLicenses();
    // getDirections();
    // if done, change status to success
    change(null, status: RxStatus.success());
    update();
  }

  @override
  void onClose() {
    // ignore: todo
    // TODO: implement onClose
    super.onClose();
    _googleMapController.dispose();
  }

  getCategories() async {
    _loading.value = true;

    await PropertyService().getCategories();
    _loading.value = false;
  }

  getRegions() async {
    _loading.value = true;

    await PropertyService().getRegions();
    _loading.value = false;
  }

  getCities() async {
    _loading.value = true;

    await PropertyService().getCities();
    _loading.value = false;
  }

  getDirections() async {
    _loading.value = true;

    await PropertyService().getDirections();
    _loading.value = false;
  }

  getNatures() async {
    _loading.value = true;
    await PropertyService().getNatures();
    _loading.value = false;
  }

  getStates() async {
    _loading.value = true;
    await PropertyService().getStates();
    _loading.value = false;
  }

  void getTypes() async {
    _loading.value = true;
    await PropertyService().getTypes();
    _loading.value = false;
  }

  void getProRes() async {
    _loading.value = true;
    await PropertyService().getProRes();
    _loading.value = false;
  }

  getLicenses() async {
    _loading.value = true;
    await PropertyService().getLicenses();
    _loading.value = false;
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      print('Location services are disabled.');
      // return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        _showLocationDeniedDialog();
        // return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      print(
          'Location permissions are permanently denied, we cannot request permissions.');
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  void sendPoints(String id, int points) async {
    var result = await PropertyService().sendPoints(id, points);
    if (result) {
      Get.snackbar("", "مبروك لقد تم اهدائك 10 نقاط لقاء مشاركتك هذا العقار.");
    } else {
      // Get.snackbar("", "عذرا .");;
    }
  }

  void _showLocationDeniedDialog() {
    Get.defaultDialog(
        title: "خدمة تحديد الموقع متوقفة",
        content: Text("الرجاء تفعيل خدمة تحديد الموقع"),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Geolocator.openAppSettings();
            },
            child: Text("اذهب إلى الاعدادات"),
          ),
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: Text("إلغاء"),
          ),
        ]);
  }

  Future getServices() async {
    _loading.value = true;
    isLoading.value = true;
    await OurServices().getServices().then((value) {
      if (value == null) {
        _serviceModels = [];
      } else {
        _serviceModels = value;
        _serviceModel = _serviceModels[0];
        _selectedservice = _serviceModel.type!;
        for (var cat in _serviceModels) {
          if (!serviceTypes.contains(cat.type)) {
            serviceTypes.add(cat.type!);
          }
        }
        for (var cat in serviceTypes) {
          tabs.add(SizedBox(
            width: (Get.width - 40) / 4,
            child: Tab(
              child: Text(
                cat,
              ),
              height: 40,
            ),
          ));
        }

        for (var cat in _serviceModels) {
          if (cat.type! == _selectedservice) {
            _selectedServices.add(cat);
          }
        }

        tabController = TabController(
          initialIndex: 0,
          length: serviceTypes.length,
          vsync: this,
        );

        update();
      }
      _loading.value = false;

      isLoading.value = false;
      update();
    });
  }

  updateService(int value) {
    _selectedservice = serviceTypes[value];
    _selectedServices = [];
    for (var cat in _serviceModels) {
      if (cat.type! == _selectedservice) {
        _selectedServices.add(cat);
      }
    }
    update();
  }

  void setLocation() {
    _myMarker = {};
    _myMarker.add(Marker(
        markerId: MarkerId(LatLng(
          double.parse(_home.realEstate!.lat!),
          double.parse(_home.realEstate!.long!),
        ).toString()),
        position: LatLng(
          double.parse(_home.realEstate!.lat!),
          double.parse(_home.realEstate!.long!),
        )));
  }

  void setGoolgeMapController(GoogleMapController controller) {
    _googleMapController = controller;
    update();
  }

  Future<void> getHomeInfo(int id) async {
    btnLoading.value = true;
    await PropertyService().getPropperty(id).then((value) {
      if (value == null) {
      } else {
        _home = value;
        btnLoading.value = false;
      }

      update();
    });
  }

  void changeToMidOpen() {
    _panelState = PanelState.midopen;
    update();
  }

  void changeToOpen() {
    _panelState = PanelState.open;
    update();
  }

  void changeToHidden() {
    _panelState = PanelState.hidden;
    update();
  }

  void gotoSavedSearchDetails({
    required int selectedValue,
    bool savesearch = false,
    double initlat = 0.0,
    double initlong = 0.0,
    double initzoom = 0.0,
  }) {
    _navigationValue2 = 1;
    var initLat = 35.363149;
    var initLong = 35.932120;
    double zoom = 13;
    _currentScreen2 = SearchView(
      initLat: initLat,
      initLong: initLong,
      zoom: zoom,
    );
    update();
  }

  void changeSelectedValue2({
    required int selectedValue,
    double initzoom = 0.0,
  }) async {
    _navigationValue2 = selectedValue;
    switch (selectedValue) {
      case 0:
        {
          Get.delete<SearchViewModel>();
          _currentScreen2 = QrSearchView();
          break;
        }
      case 1:
        {
          var initLat = 35.363149;
          var initLong = 35.932120;
          double zoom = 13;
          _currentScreen2 = SearchView(
            initLat: initLat,
            initLong: initLong,
            zoom: zoom,
          );

          break;
        }
      case 2:
        {
          Get.delete<SearchViewModel>();
          _currentScreen2 = const HomeView2();
          break;
        }
      case 3:
        {
          Get.delete<SearchViewModel>();
          _currentScreen2 = const OurServiceView();
          break;
        }
      case 4:
        {
          Get.delete<SearchViewModel>();
          _currentScreen2 = MoreView();
          break;
        }
    }
    update();
  }
}
