import 'dart:convert';

import 'package:catalog/controllers/control_viewmodel.dart';
import 'package:catalog/enums/panel_state.dart';
import 'package:catalog/helpers/http_helper.dart';
import 'package:catalog/models/favorite_property_model.dart';
import 'package:catalog/models/item_key_model.dart';
import 'package:catalog/models/property_model.dart';
import 'package:catalog/models/saved_search_model.dart';
import 'package:catalog/services/database/favoraite_database_helper.dart';
import 'package:catalog/services/property_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class SavedSearchViewModel extends GetxController
    with SingleGetTickerProviderMixin {
  var isLoading = false.obs;

  ValueNotifier<bool> _loading = ValueNotifier(false);
  ValueNotifier<bool> get loading => _loading;

  var dbHelper = FavoriteDatabaseHelper.db;
  LatLng? _currentPosition;
  LatLng? get currentPosition => _currentPosition;

  List<SavedSearch> _savedSearchs = [];
  List<SavedSearch> get savedSearchs => _savedSearchs;
  RxList<int> favoritePropertiesId = <int>[].obs;

  RxList<Marker> _markerList = <Marker>[].obs;
  RxList<Marker> get markerList => _markerList;

  var uuid = const Uuid();

  late final AnimationController _animationController;
  AnimationController get animationController => _animationController;

  late GoogleMapController _googleMapController;
  GoogleMapController get googleMapController => _googleMapController;

  List<FavoritePropertyModel> _savedProperties = [];
  List<FavoritePropertyModel> get savedProperties => _savedProperties;

  String filterMessage = "filter is true";

  List<FilteredProperty> _filteredProperties = [];
  List<FilteredProperty> get filteredProperties => _filteredProperties;

  PanelState _panelState = PanelState.hidden;
  PanelState get panelState => _panelState;

  late PropertyModel _home;
  PropertyModel get home => _home;

  var homeCarouselIndicator = 0.obs;

  final btnLoading = false.obs;

  Set<Marker> _myMarker = {};
  Set<Marker> get myMarker => _myMarker;

  int _selectedIndex = -1;
  int get selectedIndex => _selectedIndex;

  @override
  void onInit() async {
    // TODO: implement onInit
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animationController.repeat(reverse: true);
    getAllSavedSearchs();
    super.onInit();
  }

  @override
  void onClose() {
    // ignore: todo
    // TODO: implement onClose
    _googleMapController.dispose();
    _animationController.dispose();
    super.onClose();
  }

  getAllSavedSearchs() async {
    // _loading.value = true;
    _savedSearchs = await dbHelper.getAllSavedSearch();
    _markerList = <Marker>[].obs;
    for (var i = 0; i < _savedProperties.length; i++) {
      final mapItem = _savedProperties[i];
      _markerList.add(
        Marker(
          markerId: MarkerId(uuid.v1()),
          icon: BitmapDescriptor.defaultMarker,
          position:
              LatLng(double.parse(mapItem.lat), double.parse(mapItem.long)),
          onTap: () {
            Get.find<SavedSearchViewModel>().changeToMidOpen();
            Get.find<SavedSearchViewModel>()
                .getHomeInfo(int.parse(mapItem.propertyId));
            Get.find<SavedSearchViewModel>().changeSelectedIndex(i);
          },
        ),
      );
    }
    print(_savedSearchs.length);
    // _loading.value = false;
    update();
  }

  void changeSelectedIndex(int value) {
    _selectedIndex = value;
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

  Future setMiniGoolgeMapController(GoogleMapController controller) async {
    _googleMapController = controller;
    // await getProperties();
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
    update();
  }

  Future setGoolgeMapController(GoogleMapController controller) async {
    // _googleMapController = controller;
    // await getProperties();

    update();
  }

  void setCurrentPosition(CameraPosition campos) {
    _currentPosition = campos.target;
    update();
  }

  deleteSearch(String id) async {
    dbHelper.deleteSearch(id).then((value) {
      _savedSearchs = [];
      getAllSavedSearchs();
      update();
    });
  }

  filterProperty(
    String stateid,
    String typeid,
    String categoryid,
    String natureid,
    String propreid,
    String licenseid,
    String minarea,
    String maxarea,
    String minprice,
    String maxprice,
    String bedroomnum,
    String bathroomnum,
    String floorheight,
    String directionid,
    String chimney,
    String pool,
    String elevator,
    String altenergy,
    String rocks,
    String stairs,
    String well,
    String hanger,
    String lat1,
    String long1,
    String lat2,
    String long2,
  ) async {
    _loading.value = true;
    isLoading(true);
    filterMessage = "filter is true";

    // var bounds = await _googleMapController.getVisibleRegion();
    var request = http.MultipartRequest('POST', Uri.parse(FILTER_ENDPOINT));

    stateid.isEmpty
        ? request.fields['state_id'] = ""
        : request.fields['state_id'] = stateid.toString();

    typeid.isEmpty
        ? request.fields['type_id'] = ""
        : request.fields['type_id'] = typeid.toString();
    categoryid.isEmpty
        ? request.fields['category_id'] = ""
        : request.fields['category_id'] = categoryid.toString();
    // regionid == 0
    //     ? request.fields['region_id'] = ""
    //     : request.fields['region_id'] = _region.id.toString();
    // _city.id == 0
    //     ? request.fields['city_id'] = ""
    //     : request.fields['city_id'] = _city.id.toString();
    natureid.isEmpty
        ? request.fields['nature_id'] = ""
        : request.fields['nature_id'] = natureid.toString();
    propreid.isEmpty
        ? request.fields['prore_id'] = ""
        : request.fields['prore_id'] = propreid.toString();
    licenseid.isEmpty
        ? request.fields['license_id'] = ""
        : request.fields['license_id'] = licenseid.toString();
    request.fields['min_area'] = minarea.toString();
    request.fields['max_area'] = maxarea.toString();
    bedroomnum.isEmpty
        ? request.fields['sleep_room_count'] = ""
        : request.fields['sleep_room_count'] = bedroomnum.toString();
    bathroomnum.isEmpty
        ? request.fields['bath_room_count'] = ""
        : request.fields['bath_room_count'] = bathroomnum.toString();
    floorheight.isEmpty
        ? request.fields['floor_height'] = ""
        : request.fields['floor_height'] = floorheight.toString();
    directionid.isEmpty
        ? request.fields['direction_id'] = ""
        : request.fields['direction_id'] = directionid.toString();
    chimney.isEmpty
        ? request.fields['chimney'] = ""
        : request.fields['chimney'] = chimney.toString();
    pool.isEmpty
        ? request.fields['swimming_pool'] = ""
        : request.fields['swimming_pool'] = pool.toString();
    elevator.isEmpty
        ? request.fields['elevator'] = ""
        : request.fields['elevator'] = elevator.toString();
    rocks.isEmpty
        ? request.fields['with_rocks'] = ""
        : request.fields['with_rocks'] = rocks.toString();
    stairs.isEmpty
        ? request.fields['staircase'] = ""
        : request.fields['staircase'] = stairs.toString();
    altenergy.isEmpty
        ? request.fields['alternative_energy'] = ""
        : request.fields['alternative_energy'] = altenergy.toString();
    well.isEmpty
        ? request.fields['water_well'] = ""
        : request.fields['water_well'] = well.toString();
    hanger.isEmpty
        ? request.fields['hangar'] = ""
        : request.fields['hangar'] = hanger.toString();
    request.fields['min_price'] = minprice.toString();
    request.fields['max_price'] = maxprice.toString();
    request.fields['lat1'] = lat1;
    request.fields['long1'] = long1;
    request.fields['lat2'] = lat2;
    request.fields['long2'] = long2;

    var response = await request.send();

    _filteredProperties = [];
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      var res = jsonDecode(respStr);
      filterMessage = res["message"];
      for (var element in res["real_states"]) {
        _filteredProperties.add(FilteredProperty.fromJson(element));
      }
      _markerList = <Marker>[].obs;
      for (var i = 0; i < _filteredProperties.length; i++) {
        final mapItem = _filteredProperties[i];
        _markerList.add(
          Marker(
            markerId: MarkerId(uuid.v1()),
            icon: BitmapDescriptor.defaultMarker,
            position:
                LatLng(double.parse(mapItem.lat!), double.parse(mapItem.long!)),
            onTap: () {
              Get.find<SavedSearchViewModel>().changeToMidOpen();
              Get.find<SavedSearchViewModel>().getHomeInfo(mapItem.id!);
              Get.find<SavedSearchViewModel>().changeSelectedIndex(i);
            },
          ),
        );
      }
      print(_filteredProperties.length);
      _loading.value = false;
      isLoading(false);
      update();
    } else if (response.statusCode == 500) {
      _markerList = <Marker>[].obs;
      final respStr = await response.stream.bytesToString();
      // var res = jsonDecode(respStr);
      print(respStr);
      Get.snackbar(
        "خطأ",
        "يوجد خطأ بالمخدم الرجاء المحاولة مرة أخرى",
      );
      _loading.value = false;
      isLoading(false);
      update();
    }
  }
}
