// ignore_for_file: prefer_final_fields, unnecessary_null_comparison

import 'dart:convert';

import 'package:catalog/controllers/saved_search_viewmodel.dart';
import 'package:catalog/helpers/http_helper.dart';
import 'package:catalog/models/favorite_property_model.dart';
import 'package:catalog/models/item_key_model.dart';
import 'package:catalog/models/place.dart';
import 'package:catalog/models/property_model.dart';
import 'package:catalog/models/saved_search_model.dart';
import 'package:catalog/models/search_item.dart';
import 'package:catalog/services/database/favoraite_database_helper.dart';
import 'package:catalog/services/location_services.dart';
import 'package:catalog/services/place_services.dart';
import 'package:catalog/services/property_service.dart';
import 'package:catalog/views/filter_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlong2/latlong.dart' as latLng;
import 'package:google_maps_webservice/src/places.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import 'control_viewmodel.dart';

class SearchViewModel extends GetxController with SingleGetTickerProviderMixin {
  SearchViewModel();
  ValueNotifier<bool> _loading = ValueNotifier(false);
  ValueNotifier<bool> get loading => _loading;
  ValueNotifier<bool> _typeloading = ValueNotifier(false);
  ValueNotifier<bool> get typeloading => _typeloading;
  ValueNotifier<bool> _natureloading = ValueNotifier(false);
  ValueNotifier<bool> get natureloading => _natureloading;
  ValueNotifier<bool> _licenseloading = ValueNotifier(false);
  ValueNotifier<bool> get licenseloading => _licenseloading;
  ValueNotifier<bool> _statusloading = ValueNotifier(false);
  ValueNotifier<bool> get statusloading => _statusloading;
  ValueNotifier<bool> _regionloading = ValueNotifier(false);
  ValueNotifier<bool> get regionloading => _regionloading;
  ValueNotifier<bool> _cityloading = ValueNotifier(false);
  ValueNotifier<bool> get cityloading => _cityloading;

  var isLoading = false.obs;
  final btnLoading = false.obs;
  var isHomeLoading = false.obs;
  var homeCarouselIndicator = 0.obs;

  MapType currentMapType = MapType.normal;
  var dbHelper = FavoriteDatabaseHelper.db;

  GlobalKey iconKey = GlobalKey();

  bool ismapview = true;

  int _selectedIndex = -1;
  int get selectedIndex => _selectedIndex;

  late Position _currentPos;
  Position get currentPos => _currentPos;

  late final AnimationController _animationController;
  AnimationController get animationController => _animationController;

  late GoogleMapController _googleMapController;
  GoogleMapController get googleMapController => _googleMapController;

  final _placeService = PlacesService();

  LatLng? _currentPosition;
  LatLng? get currentPosition => _currentPosition;

  Placemark _pickPlaceMark = Placemark();
  Placemark get pickPlaceMark => _pickPlaceMark;

  List<PlaceSearch> _searchResults = [];
  List<PlaceSearch> get searchResults => _searchResults;

  List<Properties> _properties = [];
  List<Properties> get properties => _properties;

  List<FilteredProperty> _filteredProperties = [];
  List<FilteredProperty> get filteredProperties => _filteredProperties;

  List<FavoritePropertyModel> _favoriteProperties = [];
  List<FavoritePropertyModel> get favoriteProperties => _favoriteProperties;
  RxList<int> favoritePropertiesId = <int>[].obs;

  RxList<Marker> _markerList = <Marker>[].obs;
  RxList<Marker> get markerList => _markerList;

  List<Category> _categories = [];
  List<Category> get categories => _categories;
  Category _category = Category(id: 0, category: "All".tr);
  Category get category => _category;
  int categoryindex = 0;

  List<Region> _regions = [];
  List<Region> get regions => _regions;
  late Region _region = Region(id: 0, region: "All".tr);
  Region get region => _region;
  int regionindex = 0;

  List<City> _cities = [];
  List<City> get cities => _cities;
  late City _city = City(id: 0, city: "All".tr);
  City get city => _city;
  int cityindex = 0;

  List<Nature> _natures = [];
  List<Nature> get natures => _natures;
  Nature _nature = Nature(id: 0, nature: "All".tr, type_id: "0");
  Nature get nature => _nature;
  int natureindex = 0;

  List<States> _states = [];
  List<States> get states => _states;
  States _state = States(id: 0, states: "All".tr);
  States get state => _state;
  int stateindex = 0;

  List<Type> _types = [];
  List<Type> get types => _types;
  Type _typeValue = Type(id: 0, type: "All".tr);
  Type get typeValue => _typeValue;
  int typeindex = 0;

  List<ProRes> _prores = [];
  List<ProRes> get prores => _prores;
  ProRes _prore = ProRes(id: 0, type: "All".tr);
  ProRes get prore => _prore;
  int propreindex = 0;

  List<DataRow> _rowList = [];
  List<DataRow> get rowList => _rowList;

  List<License> _licenses = [];
  List<License> get licenses => _licenses;
  License _license = License(id: 0, type: "All".tr);
  License get license => _license;
  int licenseindex = 0;

  List<int> percentageList = [0, 1, 2, 3, 4, 5];
  int _percentageValue = 1;
  int get percentageValue => _percentageValue;

  int minPrice = 0;
  int minPriceIndex = 0;

  int maxPrice = 2000000000;
  int maxPriceIndex = 0;

  String searchName = "";
  String initLat = "";
  String initLong = "";
  String zoom = "";

  String filterMessage = "filter is true";

  List<int> _selectedDirectionIndex = [];
  List<int> get selectedDirectionIndex => _selectedDirectionIndex;

  List<Direction> _directions = [];
  List<Direction> get directions => _directions;
  late Direction _direction;
  Direction get direction => _direction;

  final directionmultiValid = true.obs;

  FixedExtentScrollController minPriceSchroolController =
      FixedExtentScrollController();
  FixedExtentScrollController maxPriceSchroolController =
      FixedExtentScrollController();

  int minArea = 0;
  int minAreaIndex = 0;

  int maxArea = 10000;
  int maxAreaIndex = 0;

  late FixedExtentScrollController minAreaSchroolController =
      FixedExtentScrollController();
  late FixedExtentScrollController maxAreaSchroolController =
      FixedExtentScrollController();

  List<String> houseSizeRange = [
    "0",
    "50m",
    "60m",
    "70m",
    "80m",
    "90m",
    "100m",
    "110m",
    "120m",
    "130m",
    "150m",
    "180m",
    "200m",
    "250m",
    "غير محدود"
  ];

  List<String> salePriceRange = [
    "0",
    "50m",
    "60m",
    "70m",
    "80m",
    "90m",
    "100m",
    "110m",
    "120m",
    "130m",
    "150m",
    "180m",
    "200m",
    "250m",
    "غير محدود"
  ];
  List<String> rentPriceRange = [
    "0",
    "50000",
    "75000",
    "100000",
    "150000",
    "200000",
    "400000",
    "600000",
    "800000",
    "1000000",
    "غير محدود"
  ];

  var uuid = const Uuid();

  List<Prediction> _predictionList = [];

  Rxn<Place> _selectedLocation = Rxn(null);
  Rxn<Place> get selectedLocation => _selectedLocation;

  LatLngBounds? _bounds;
  LatLngBounds? get bounds => _bounds;

  Rxn<Place> _selectedLocationStatic = Rxn(null);
  Rxn<Place> get selectedLocationStatic => _selectedLocationStatic;

  Rxn<String> _placeType = Rxn(null);
  Rxn<String> get placeType => _placeType;

  int _bedroomindex = 0;
  int get bedroomindex => _bedroomindex;

  int _bathroomindex = 0;
  int get bathroomindex => _bathroomindex;

  int _levelheightindex = 0;
  int get levelheightindex => _levelheightindex;

  String? period = "1";
  String? chalet_layout_number = "0";

  bool ischimney = false;
  bool isSwiming = false;
  bool iselevator = false;
  bool isrockcover = false;
  bool isstaircover = false;
  bool isaltenergy = false;
  bool iswell = false;
  bool ishanger = false;

  bool isCheminyVisible = true;
  bool isPoolVisible = true;
  bool isElevatorVisible = true;
  bool isRockCoverVisible = true;
  bool isStairCoverVisible = true;
  bool isAltEnergyVisible = true;
  bool isWaterWellVisible = true;
  bool isGreenHouseVisible = true;
  bool isTypeVisible = true;
  bool isNatureVisible = true;
  bool isCategoryVisible = true;
  bool isPriceVisible = true;
  bool isAreaVisible = true;
  bool isBedroomVisible = true;
  bool isBathroomVisible = true;
  bool isLevelVisible = true;
  bool isDirectionVisible = true;
  bool isLotAreaVisible = false;
  bool isStatesVisible = true;
  bool isOwnershipVisible = true;
  bool isLicenseVisible = true;
  bool isRentOptionsVisibile = false;
  @override
  void onInit() async {
    // ignore: todo
    // TODO: implement onInit
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animationController.repeat(reverse: true);

    super.onInit();
    selectedLocation.listen((p0) {
      if (p0 != null) {
        _goToPlace(p0);
      }
    });

    getCategories();
    getRegions();
    getCities();
    getDirections();
    getStates();
    getTypes();
    getProRes();
    // getProperties();
    _favoriteProperties = await dbHelper.getAllProduct();
    for (var element in _favoriteProperties) {
      favoritePropertiesId.add(int.parse(element.propertyId));
    }
    print(_favoriteProperties.length);
    print(favoritePropertiesId.length);

    update();
  }

  @override
  void onClose() {
    // ignore: todo
    // TODO: implement onClose
    _googleMapController.dispose();
    _animationController.dispose();
    super.onClose();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
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
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  likeProduct(FilteredProperty filteredModel) async {
    FavoritePropertyModel fpModel = FavoritePropertyModel(
        address: filteredModel.addressTitle!,
        propertyId: filteredModel.id!.toString(),
        image: "",
        bedRoomNum: filteredModel.bathRoomCount.toString(),
        bathRoomNum: filteredModel.bathRoomCount.toString(),
        review: "4.3",
        category: filteredModel.category!,
        lat: filteredModel.lat!,
        long: filteredModel.long!,
        area: filteredModel.area.toString(),
        price: filteredModel.price.toString());

    await dbHelper.insert(fpModel);
    favoritePropertiesId.add(filteredModel.id!);

    // Get.snackbar(
    //     "Item added", "${cartProductModel.name} was added to your cart");
    getAllLikedProducts();

    update();
  }

  likeProductInfo(PropertyModel filteredModel) async {
    FavoritePropertyModel fpModel = FavoritePropertyModel(
        address: filteredModel.realEstate!.addressTitle!,
        propertyId: filteredModel.realEstate!.id!.toString(),
        image: "",
        bedRoomNum: filteredModel.realEstate!.bathRoomCount.toString(),
        bathRoomNum: filteredModel.realEstate!.bathRoomCount.toString(),
        review: "4.3",
        category: filteredModel.category!.category!,
        lat: filteredModel.realEstate!.lat!,
        long: filteredModel.realEstate!.long!,
        area: filteredModel.realEstate!.area.toString(),
        price: filteredModel.realEstate!.price.toString());

    await dbHelper.insert(fpModel);
    favoritePropertiesId.add(filteredModel.realEstate!.id!);

    // Get.snackbar(
    //     "Item added", "${cartProductModel.name} was added to your cart");
    getAllLikedProducts();

    update();
  }

  unlikeProduct(int productId) async {
    await dbHelper.deleteProduct(productId.toString());
    favoritePropertiesId.remove(productId);
    getAllLikedProducts();
  }

  getAllLikedProducts() async {
    // _loading.value = true;
    _favoriteProperties = await dbHelper.getAllProduct();
    favoritePropertiesId = <int>[].obs;
    for (var element in _favoriteProperties) {
      favoritePropertiesId.add(int.parse(element.propertyId));
    }
    print(_favoriteProperties.length);
    print(favoritePropertiesId.length);
    // _loading.value = false;
    update();
  }

  updatePeriod(String value) {
    period = value;
    update();
  }

  updateRoomNum(int index) {
    _bedroomindex = index;
    update();
  }

  updatebathNum(int index) {
    _bathroomindex = index;
    update();
  }

  updatelevelHeight(int index) {
    _levelheightindex = index;
    update();
  }

  updateCategory(int cat) {
    _category = _categories[cat];
    updateNature(_nature.id!);
    _states = [];
    getStates();
    update();
  }

  updateCategoryIdex(int state) {
    categoryindex = state;
    update();
  }

  initMinScrollController(int init) {
    minPriceSchroolController = FixedExtentScrollController(initialItem: init);
    SchedulerBinding.instance.addPostFrameCallback(
        (_) => minPriceSchroolController.jumpToItem(init));
  }

  initMaxScrollController(int init) {
    maxPriceSchroolController = FixedExtentScrollController(initialItem: init);
    SchedulerBinding.instance.addPostFrameCallback(
        (_) => maxPriceSchroolController.jumpToItem(init));
  }

  initMinAreaScrollController(int init) {
    minAreaSchroolController = FixedExtentScrollController(initialItem: init);
    SchedulerBinding.instance
        .addPostFrameCallback((_) => minAreaSchroolController.jumpToItem(init));
  }

  initMaxAreaScrollController(int init) {
    maxAreaSchroolController = FixedExtentScrollController(initialItem: init);
    SchedulerBinding.instance
        .addPostFrameCallback((_) => maxAreaSchroolController.jumpToItem(init));
  }

  void initPriceController() {
    minPriceSchroolController =
        FixedExtentScrollController(initialItem: minPriceIndex);
    maxPriceSchroolController =
        FixedExtentScrollController(initialItem: maxPriceIndex);
  }

  updateMinPrice(int min) {
    minPriceIndex = min;
    minPrice = int.parse(salePriceRange[min].replaceAll("m", "000000"));
    print(minPriceIndex);
    print(minPrice);
    update();
  }

  updateMaxPrice(int max) {
    maxPriceIndex = max;
    if (max == (salePriceRange.length - 1)) {
      maxPrice = 2000000000;
    } else {
      maxPrice = int.parse(salePriceRange[(salePriceRange.length - 1) - max]
          .replaceAll("m", "000000"));
    }

    update();
  }

  updateMinArea(int min) {
    minAreaIndex = min;
    minArea = int.parse(houseSizeRange[min].replaceAll("m", ""));
    update();
  }

  updateMaxArea(int max) {
    maxAreaIndex = max;
    if (max == (houseSizeRange.length - 1)) {
      maxPrice = 10000;
    } else {
      maxPrice = int.parse(houseSizeRange[(houseSizeRange.length - 1) - max]
          .replaceAll("m", ""));
    }
    update();
  }

  // updateSelectedRoomType(String roomType) {
  //   _selectedRoomType = roomType;
  //   update();
  // }

  updateState(int state) {
    _state = _states[state];
    update();
  }

  updateStateIdex(int state) {
    stateindex = state;
    update();
  }

  updateRegion(int state) {
    _region = _regions[state];
    update();
  }

  updateRegionIdex(int state) {
    regionindex = state;
    update();
  }

  updateCity(int state) {
    _city = _cities[state];
    update();
  }

  updateCityIdex(int state) {
    cityindex = state;
    update();
  }

  updateType(int type) {
    _typeValue = _types[type];
    getNatures(_typeValue.id!);
    update();
  }

  updateTypeIdex(int state) {
    typeindex = state;
    update();
  }

  updateNature(int nature) {
    _nature = _natures[nature];
    switch (_nature.id!) {
      case 0:
        {
          if (_category.id! == 1) {
            isPriceVisible = true; //1
            isAreaVisible = true; //2
            isBedroomVisible = true; //3
            isBathroomVisible = true; //4
            isLevelVisible = true; //5
            isDirectionVisible = false; //6
            isStatesVisible = true; //7
            isOwnershipVisible = true; //8
            isLicenseVisible = true; //9
            isCheminyVisible = true; //12
            isPoolVisible = true; //13
            isElevatorVisible = true; //14
            isRockCoverVisible = true; //15
            isStairCoverVisible = true; //16
            isAltEnergyVisible = true; //17
            isWaterWellVisible = true; //18
            isGreenHouseVisible = true; //19
          } else if (_category.id! == 2) {
            isPriceVisible = true; //1
            isAreaVisible = true; //2
            isBedroomVisible = true; //3
            isBathroomVisible = true; //4
            isLevelVisible = true; //5
            isDirectionVisible = false; //6
            isStatesVisible = true; //7
            isOwnershipVisible = true; //8
            isLicenseVisible = true; //9
            isCheminyVisible = true; //12
            isPoolVisible = true; //13
            isElevatorVisible = true; //14
            isRockCoverVisible = true; //15
            isStairCoverVisible = true; //16
            isAltEnergyVisible = true; //17
            isWaterWellVisible = true; //18
            isGreenHouseVisible = true; //19
          } else if (_category.id! == 3) {
            isPriceVisible = true; //1
            isAreaVisible = true; //2
            isBedroomVisible = true; //3
            isBathroomVisible = true; //4
            isLevelVisible = true; //5
            isDirectionVisible = false; //6
            isStatesVisible = true; //7
            isOwnershipVisible = true; //8
            isLicenseVisible = true; //9
            isCheminyVisible = true; //12
            isPoolVisible = true; //13
            isElevatorVisible = true; //14
            isRockCoverVisible = true; //15
            isStairCoverVisible = true; //16
            isAltEnergyVisible = true; //17
            isWaterWellVisible = true; //18
            isGreenHouseVisible = true; //19
          } else if (_category.id! == 4) {
            isPriceVisible = true; //1
            isAreaVisible = true; //2
            isBedroomVisible = true; //3
            isBathroomVisible = true; //4
            isLevelVisible = true; //5
            isDirectionVisible = false; //6
            isStatesVisible = true; //7
            isOwnershipVisible = true; //8
            isLicenseVisible = true; //9
            isCheminyVisible = true; //12
            isPoolVisible = true; //13
            isElevatorVisible = true; //14
            isRockCoverVisible = true; //15
            isStairCoverVisible = true; //16
            isAltEnergyVisible = true; //17
            isWaterWellVisible = true; //18
            isGreenHouseVisible = true; //19
          } else if (_category.id! == 0) {
            isPriceVisible = true; //1
            isAreaVisible = true; //2
            isBedroomVisible = true; //3
            isBathroomVisible = true; //4
            isLevelVisible = true; //5
            isDirectionVisible = false; //6
            isStatesVisible = true; //7
            isOwnershipVisible = true; //8
            isLicenseVisible = true; //9
            isCheminyVisible = true; //12
            isPoolVisible = true; //13
            isElevatorVisible = true; //14
            isRockCoverVisible = true; //15
            isStairCoverVisible = true; //16
            isAltEnergyVisible = true; //17
            isWaterWellVisible = true; //18
            isGreenHouseVisible = true; //19
          }
        }
        break;
      case 1:
        {
          if (_category.id! == 1) {
            isPriceVisible = true; //1
            isAreaVisible = true; //2
            isBedroomVisible = true; //3
            isBathroomVisible = true; //4
            isLevelVisible = true; //5
            isDirectionVisible = false; //6
            isStatesVisible = true; //7
            isOwnershipVisible = true; //8
            isLicenseVisible = true; //9
            isCheminyVisible = true; //12
            isPoolVisible = false; //13
            isElevatorVisible = true; //14
            isRockCoverVisible = true; //15
            isStairCoverVisible = true; //16
            isAltEnergyVisible = true; //17
            isWaterWellVisible = false; //18
            isGreenHouseVisible = false; //19
          } else if (_category.id! == 2) {
            isPriceVisible = true; //1
            isAreaVisible = true; //2
            isBedroomVisible = true; //3
            isBathroomVisible = true; //4
            isLevelVisible = true; //5
            isDirectionVisible = false; //6
            isStatesVisible = true; //7
            isOwnershipVisible = false; //8
            isLicenseVisible = false; //9
            isCheminyVisible = false; //12
            isPoolVisible = false; //13
            isElevatorVisible = true; //14
            isRockCoverVisible = true; //15
            isStairCoverVisible = true; //16
            isAltEnergyVisible = true; //17
            isWaterWellVisible = false; //18
            isGreenHouseVisible = false; //19
          } else if (_category.id! == 3) {
            isPriceVisible = true; //1
            isAreaVisible = true; //2
            isBedroomVisible = true; //3
            isBathroomVisible = false; //4
            isLevelVisible = true; //5
            isDirectionVisible = false; //6
            isStatesVisible = true; //7
            isOwnershipVisible = false; //8
            isLicenseVisible = false; //9
            isCheminyVisible = false; //12
            isPoolVisible = false; //13
            isElevatorVisible = true; //14
            isRockCoverVisible = true; //15
            isStairCoverVisible = true; //16
            isAltEnergyVisible = true; //17
            isWaterWellVisible = false; //18
            isGreenHouseVisible = false; //19
          } else if (_category.id! == 4) {
            isPriceVisible = false; //1
            isAreaVisible = false; //2
            isBedroomVisible = false; //3
            isBathroomVisible = false; //4
            isLevelVisible = false; //5
            isDirectionVisible = false; //6
            isStatesVisible = false; //7
            isOwnershipVisible = false; //8
            isLicenseVisible = false; //9
            isCheminyVisible = false; //12
            isPoolVisible = false; //13
            isElevatorVisible = false; //14
            isRockCoverVisible = false; //15
            isStairCoverVisible = false; //16
            isAltEnergyVisible = false; //17
            isWaterWellVisible = false; //18
            isGreenHouseVisible = false; //19
          } else if (_category.id! == 0) {
            isPriceVisible = true; //1
            isAreaVisible = true; //2
            isBedroomVisible = true; //3
            isBathroomVisible = true; //4
            isLevelVisible = true; //5
            isDirectionVisible = false; //6
            isStatesVisible = true; //7
            isOwnershipVisible = true; //8
            isLicenseVisible = true; //9
            isCheminyVisible = true; //12
            isPoolVisible = false; //13
            isElevatorVisible = true; //14
            isRockCoverVisible = true; //15
            isStairCoverVisible = true; //16
            isAltEnergyVisible = true; //17
            isWaterWellVisible = false; //18
            isGreenHouseVisible = false; //19
          }
        }
        break;
      case 2:
        {
          if (_category.id! == 0) {
            isPriceVisible = true; //1
            isAreaVisible = true; //2
            isBedroomVisible = true; //3
            isBathroomVisible = true; //4
            isLevelVisible = true; //5
            isDirectionVisible = false; //6
            isStatesVisible = true; //7
            isOwnershipVisible = true; //8
            isLicenseVisible = true; //9
            isCheminyVisible = false; //12
            isPoolVisible = true; //13
            isElevatorVisible = false; //14
            isRockCoverVisible = false; //15
            isStairCoverVisible = false; //16
            isAltEnergyVisible = true; //17
            isWaterWellVisible = true; //18
            isGreenHouseVisible = false; //19
          } else if (_category.id! == 1) {
            isPriceVisible = true; //1
            isAreaVisible = true; //2
            isBedroomVisible = true; //3
            isBathroomVisible = true; //4
            isLevelVisible = true; //5
            isDirectionVisible = false; //6
            isStatesVisible = true; //7
            isOwnershipVisible = true; //8
            isLicenseVisible = true; //9
            isCheminyVisible = false; //12
            isPoolVisible = true; //13
            isElevatorVisible = false; //14
            isRockCoverVisible = false; //15
            isStairCoverVisible = false; //16
            isAltEnergyVisible = true; //17
            isWaterWellVisible = true; //18
            isGreenHouseVisible = false; //19
          } else if (_category.id! == 2) {
            isPriceVisible = true; //1
            isAreaVisible = true; //2
            isBedroomVisible = true; //3
            isBathroomVisible = true; //4
            isLevelVisible = true; //5
            isDirectionVisible = false; //6
            isStatesVisible = true; //7
            isOwnershipVisible = false; //8
            isLicenseVisible = false; //9
            isCheminyVisible = false; //12
            isPoolVisible = true; //13
            isElevatorVisible = false; //14
            isRockCoverVisible = false; //15
            isStairCoverVisible = false; //16
            isAltEnergyVisible = true; //17
            isWaterWellVisible = false; //18
            isGreenHouseVisible = false; //19
          } else if (_category.id! == 3) {
            isPriceVisible = true; //1
            isAreaVisible = true; //2
            isBedroomVisible = true; //3
            isBathroomVisible = true; //4
            isLevelVisible = false; //5
            isDirectionVisible = false; //6
            isStatesVisible = true; //7
            isOwnershipVisible = false; //8
            isLicenseVisible = false; //9
            isCheminyVisible = false; //12
            isPoolVisible = true; //13
            isElevatorVisible = false; //14
            isRockCoverVisible = false; //15
            isStairCoverVisible = false; //16
            isAltEnergyVisible = true; //17
            isWaterWellVisible = false; //18
            isGreenHouseVisible = false; //19
          } else if (_category.id! == 4) {
            isPriceVisible = false; //1
            isAreaVisible = false; //2
            isBedroomVisible = false; //3
            isBathroomVisible = false; //4
            isLevelVisible = false; //5
            isDirectionVisible = false; //6
            isStatesVisible = false; //7
            isOwnershipVisible = false; //8
            isLicenseVisible = false; //9
            isCheminyVisible = false; //12
            isPoolVisible = false; //13
            isElevatorVisible = false; //14
            isRockCoverVisible = false; //15
            isStairCoverVisible = false; //16
            isAltEnergyVisible = false; //17
            isWaterWellVisible = false; //18
            isGreenHouseVisible = false; //19
          }
        }
        break;
      case 3:
        {
          if (_category.id! == 1) {
            isPriceVisible = true; //1
            isAreaVisible = true; //2
            isBedroomVisible = false; //3
            isBathroomVisible = false; //4
            isLevelVisible = false; //5
            isDirectionVisible = false; //6
            isStatesVisible = true; //7
            isOwnershipVisible = true; //8
            isLicenseVisible = true; //9
            isCheminyVisible = false; //12
            isPoolVisible = false; //13
            isElevatorVisible = true; //14
            isRockCoverVisible = true; //15
            isStairCoverVisible = true; //16
            isAltEnergyVisible = true; //17
            isWaterWellVisible = true; //18
            isGreenHouseVisible = false; //19
          } else if (_category.id! == 2) {
            isPriceVisible = false; //1
            isAreaVisible = false; //2
            isBedroomVisible = false; //3
            isBathroomVisible = false; //4
            isLevelVisible = false; //5
            isDirectionVisible = false; //6
            isStatesVisible = false; //7
            isOwnershipVisible = false; //8
            isLicenseVisible = false; //9
            isCheminyVisible = false; //12
            isPoolVisible = false; //13
            isElevatorVisible = false; //14
            isRockCoverVisible = false; //15
            isStairCoverVisible = false; //16
            isAltEnergyVisible = false; //17
            isWaterWellVisible = false; //18
            isGreenHouseVisible = false; //19
          } else if (_category.id! == 3) {
            isPriceVisible = false; //1
            isAreaVisible = false; //2
            isBedroomVisible = false; //3
            isBathroomVisible = false; //4
            isLevelVisible = false; //5
            isDirectionVisible = false; //6
            isStatesVisible = false; //7
            isOwnershipVisible = false; //8
            isLicenseVisible = false; //9
            isCheminyVisible = false; //12
            isPoolVisible = false; //13
            isElevatorVisible = false; //14
            isRockCoverVisible = false; //15
            isStairCoverVisible = false; //16
            isAltEnergyVisible = false; //17
            isWaterWellVisible = false; //18
            isGreenHouseVisible = false; //19
          } else if (_category.id! == 4) {
            isPriceVisible = false; //1
            isAreaVisible = true; //2
            isBedroomVisible = false; //3
            isBathroomVisible = false; //4
            isLevelVisible = true; //5
            isDirectionVisible = false; //6
            isStatesVisible = false; //7
            isOwnershipVisible = true; //8
            isLicenseVisible = true; //9
            isCheminyVisible = false; //12
            isPoolVisible = false; //13
            isElevatorVisible = true; //14
            isRockCoverVisible = true; //15
            isStairCoverVisible = true; //16
            isAltEnergyVisible = false; //17
            isWaterWellVisible = false; //18
            isGreenHouseVisible = false; //19
          } else if (_category.id! == 0) {
            isPriceVisible = true; //1
            isAreaVisible = true; //2
            isBedroomVisible = false; //3
            isBathroomVisible = false; //4
            isLevelVisible = false; //5
            isDirectionVisible = false; //6
            isStatesVisible = true; //7
            isOwnershipVisible = true; //8
            isLicenseVisible = true; //9
            isCheminyVisible = false; //12
            isPoolVisible = false; //13
            isElevatorVisible = true; //14
            isRockCoverVisible = true; //15
            isStairCoverVisible = true; //16
            isAltEnergyVisible = true; //17
            isWaterWellVisible = true; //18
            isGreenHouseVisible = false; //19
          }
        }
        break;
      case 4:
        {
          if (_category.id! == 1 || _category.id! == 0) {
            isPriceVisible = true; //1
            isAreaVisible = true; //2
            isBedroomVisible = false; //3
            isBathroomVisible = false; //4
            isLevelVisible = false; //5
            isDirectionVisible = false; //6
            isStatesVisible = false; //7
            isOwnershipVisible = true; //8
            isLicenseVisible = false; //9
            isCheminyVisible = false; //12
            isPoolVisible = false; //13
            isElevatorVisible = false; //14
            isRockCoverVisible = false; //15
            isStairCoverVisible = false; //16
            isAltEnergyVisible = false; //17
            isWaterWellVisible = false; //18
            isGreenHouseVisible = false; //19
          } else if (_category.id! == 2) {
            isPriceVisible = false; //1
            isAreaVisible = false; //2
            isBedroomVisible = false; //3
            isBathroomVisible = false; //4
            isLevelVisible = false; //5
            isDirectionVisible = false; //6
            isStatesVisible = false; //7
            isOwnershipVisible = false; //8
            isLicenseVisible = false; //9
            isCheminyVisible = false; //12
            isPoolVisible = false; //13
            isElevatorVisible = false; //14
            isRockCoverVisible = false; //15
            isStairCoverVisible = false; //16
            isAltEnergyVisible = false; //17
            isWaterWellVisible = false; //18
            isGreenHouseVisible = false; //19
          } else if (_category.id! == 3) {
            isPriceVisible = false; //1
            isAreaVisible = false; //2
            isBedroomVisible = false; //3
            isBathroomVisible = false; //4
            isLevelVisible = false; //5
            isDirectionVisible = false; //6
            isStatesVisible = false; //7
            isOwnershipVisible = false; //8
            isLicenseVisible = false; //9
            isCheminyVisible = false; //12
            isPoolVisible = false; //13
            isElevatorVisible = false; //14
            isRockCoverVisible = false; //15
            isStairCoverVisible = false; //16
            isAltEnergyVisible = false; //17
            isWaterWellVisible = false; //18
            isGreenHouseVisible = false; //19
          } else if (_category.id! == 4) {
            isPriceVisible = false; //1
            isAreaVisible = false; //2
            isBedroomVisible = false; //3
            isBathroomVisible = false; //4
            isLevelVisible = false; //5
            isDirectionVisible = false; //6
            isStatesVisible = false; //7
            isOwnershipVisible = false; //8
            isLicenseVisible = false; //9
            isCheminyVisible = false; //12
            isPoolVisible = false; //13
            isElevatorVisible = false; //14
            isRockCoverVisible = false; //15
            isStairCoverVisible = false; //16
            isAltEnergyVisible = false; //17
            isWaterWellVisible = false; //18
            isGreenHouseVisible = false; //19
          }
        }
        break;
      case 5:
        {
          if (_category.id! == 1 || _category.id! == 0) {
            isPriceVisible = true; //1
            isAreaVisible = false; //2
            isBedroomVisible = false; //3
            isBathroomVisible = false; //4
            isLevelVisible = true; //5
            isDirectionVisible = false; //6
            isStatesVisible = false; //7
            isOwnershipVisible = false; //8
            isLicenseVisible = false; //9
            isCheminyVisible = false; //12
            isPoolVisible = false; //13
            isElevatorVisible = false; //14
            isRockCoverVisible = false; //15
            isStairCoverVisible = false; //16
            isAltEnergyVisible = false; //17
            isWaterWellVisible = false; //18
            isGreenHouseVisible = false; //19
          } else if (_category.id! == 2) {
            isPriceVisible = false; //1
            isAreaVisible = false; //2
            isBedroomVisible = false; //3
            isBathroomVisible = false; //4
            isLevelVisible = false; //5
            isDirectionVisible = false; //6
            isStatesVisible = false; //7
            isOwnershipVisible = false; //8
            isLicenseVisible = false; //9
            isCheminyVisible = false; //12
            isPoolVisible = false; //13
            isElevatorVisible = false; //14
            isRockCoverVisible = false; //15
            isStairCoverVisible = false; //16
            isAltEnergyVisible = false; //17
            isWaterWellVisible = false; //18
            isGreenHouseVisible = false; //19
          } else if (_category.id! == 3) {
            isPriceVisible = false; //1
            isAreaVisible = false; //2
            isBedroomVisible = false; //3
            isBathroomVisible = false; //4
            isLevelVisible = false; //5
            isDirectionVisible = false; //6
            isStatesVisible = false; //7
            isOwnershipVisible = false; //8
            isLicenseVisible = false; //9
            isCheminyVisible = false; //12
            isPoolVisible = false; //13
            isElevatorVisible = false; //14
            isRockCoverVisible = false; //15
            isStairCoverVisible = false; //16
            isAltEnergyVisible = false; //17
            isWaterWellVisible = false; //18
            isGreenHouseVisible = false; //19
          } else if (_category.id! == 4) {
            isPriceVisible = false; //1
            isAreaVisible = false; //2
            isBedroomVisible = false; //3
            isBathroomVisible = false; //4
            isLevelVisible = false; //5
            isDirectionVisible = false; //6
            isStatesVisible = false; //7
            isOwnershipVisible = false; //8
            isLicenseVisible = false; //9
            isCheminyVisible = false; //12
            isPoolVisible = false; //13
            isElevatorVisible = false; //14
            isRockCoverVisible = false; //15
            isStairCoverVisible = false; //16
            isAltEnergyVisible = false; //17
            isWaterWellVisible = false; //18
            isGreenHouseVisible = false; //19
          }
        }
        break;
      case 6:
        {
          if (_category.id! == 1) {
            isPriceVisible = true; //1
            isAreaVisible = true; //2
            isBedroomVisible = true; //3
            isBathroomVisible = true; //4
            isLevelVisible = false; //5
            isDirectionVisible = false; //6
            isStatesVisible = true; //7
            isOwnershipVisible = true; //8
            isLicenseVisible = false; //9
            isCheminyVisible = false; //12
            isPoolVisible = false; //13
            isElevatorVisible = false; //14
            isRockCoverVisible = false; //15
            isStairCoverVisible = false; //16
            isAltEnergyVisible = true; //17
            isWaterWellVisible = false; //18
            isGreenHouseVisible = false; //19
          } else if (_category.id! == 2) {
            isPriceVisible = true; //1
            isAreaVisible = false; //2
            isBedroomVisible = true; //3
            isBathroomVisible = true; //4
            isLevelVisible = false; //5
            isDirectionVisible = false; //6
            isStatesVisible = false; //7
            isOwnershipVisible = false; //8
            isLicenseVisible = false; //9
            isCheminyVisible = false; //12
            isPoolVisible = false; //13
            isElevatorVisible = false; //14
            isRockCoverVisible = false; //15
            isStairCoverVisible = false; //16
            isAltEnergyVisible = true; //17
            isWaterWellVisible = false; //18
            isGreenHouseVisible = false; //19
          } else if (_category.id! == 3) {
            isPriceVisible = true; //1
            isAreaVisible = true; //2
            isBedroomVisible = true; //3
            isBathroomVisible = true; //4
            isLevelVisible = false; //5
            isDirectionVisible = false; //6
            isStatesVisible = false; //7
            isOwnershipVisible = false; //8
            isLicenseVisible = false; //9
            isCheminyVisible = false; //12
            isPoolVisible = false; //13
            isElevatorVisible = false; //14
            isRockCoverVisible = false; //15
            isStairCoverVisible = false; //16
            isAltEnergyVisible = true; //17
            isWaterWellVisible = false; //18
            isGreenHouseVisible = false; //19
          } else if (_category.id! == 4) {
            isPriceVisible = false; //1
            isAreaVisible = false; //2
            isBedroomVisible = false; //3
            isBathroomVisible = false; //4
            isLevelVisible = false; //5
            isDirectionVisible = false; //6
            isStatesVisible = false; //7
            isOwnershipVisible = false; //8
            isLicenseVisible = false; //9
            isCheminyVisible = false; //12
            isPoolVisible = false; //13
            isElevatorVisible = false; //14
            isRockCoverVisible = false; //15
            isStairCoverVisible = false; //16
            isAltEnergyVisible = false; //17
            isWaterWellVisible = false; //18
            isGreenHouseVisible = false; //19
          } else if (_category.id! == 0) {
            isPriceVisible = true; //1
            isAreaVisible = true; //2
            isBedroomVisible = true; //3
            isBathroomVisible = true; //4
            isLevelVisible = false; //5
            isDirectionVisible = false; //6
            isStatesVisible = true; //7
            isOwnershipVisible = true; //8
            isLicenseVisible = false; //9
            isCheminyVisible = false; //12
            isPoolVisible = false; //13
            isElevatorVisible = false; //14
            isRockCoverVisible = false; //15
            isStairCoverVisible = false; //16
            isAltEnergyVisible = true; //17
            isWaterWellVisible = false; //18
            isGreenHouseVisible = false; //19
          }
        }
        break;
      case 7:
        {
          if (_category.id! == 1 || _category.id! == 0) {
            isPriceVisible = true; //1
            isAreaVisible = true; //2
            isBedroomVisible = false; //3
            isBathroomVisible = false; //4
            isLevelVisible = true; //5
            isDirectionVisible = true; //6
            isStatesVisible = true; //7
            isOwnershipVisible = true; //8
            isLicenseVisible = true; //9
            isCheminyVisible = false; //12
            isPoolVisible = false; //13
            isElevatorVisible = true; //14
            isRockCoverVisible = false; //15
            isStairCoverVisible = false; //16
            isAltEnergyVisible = true; //17
            isWaterWellVisible = false; //18
            isGreenHouseVisible = false; //19
          } else if (_category.id! == 2) {
            isPriceVisible = true; //1
            isAreaVisible = true; //2
            isBedroomVisible = false; //3
            isBathroomVisible = false; //4
            isLevelVisible = true; //5
            isDirectionVisible = false; //6
            isStatesVisible = true; //7
            isOwnershipVisible = false; //8
            isLicenseVisible = false; //9
            isCheminyVisible = false; //12
            isPoolVisible = false; //13
            isElevatorVisible = true; //14
            isRockCoverVisible = false; //15
            isStairCoverVisible = false; //16
            isAltEnergyVisible = true; //17
            isWaterWellVisible = false; //18
            isGreenHouseVisible = false; //19
          } else if (_category.id! == 3) {
            isPriceVisible = false; //1
            isAreaVisible = false; //2
            isBedroomVisible = false; //3
            isBathroomVisible = false; //4
            isLevelVisible = false; //5
            isDirectionVisible = false; //6
            isStatesVisible = false; //7
            isOwnershipVisible = false; //8
            isLicenseVisible = false; //9
            isCheminyVisible = false; //12
            isPoolVisible = false; //13
            isElevatorVisible = false; //14
            isRockCoverVisible = false; //15
            isStairCoverVisible = false; //16
            isAltEnergyVisible = false; //17
            isWaterWellVisible = false; //18
            isGreenHouseVisible = false; //19
          } else if (_category.id! == 4) {
            isPriceVisible = false; //1
            isAreaVisible = false; //2
            isBedroomVisible = false; //3
            isBathroomVisible = false; //4
            isLevelVisible = false; //5
            isDirectionVisible = false; //6
            isStatesVisible = false; //7
            isOwnershipVisible = false; //8
            isLicenseVisible = false; //9
            isCheminyVisible = false; //12
            isPoolVisible = false; //13
            isElevatorVisible = false; //14
            isRockCoverVisible = false; //15
            isStairCoverVisible = false; //16
            isAltEnergyVisible = false; //17
            isWaterWellVisible = false; //18
            isGreenHouseVisible = false; //19
          }
        }
        break;
      case 8:
        {
          if (_category.id! == 1 || _category.id! == 0) {
            isPriceVisible = true; //1
            isAreaVisible = true; //2
            isBedroomVisible = false; //3
            isBathroomVisible = false; //4
            isLevelVisible = false; //5
            isDirectionVisible = false; //6
            isStatesVisible = true; //7
            isOwnershipVisible = true; //8
            isLicenseVisible = true; //9
            isCheminyVisible = true; //12
            isPoolVisible = false; //13
            isElevatorVisible = false; //14
            isRockCoverVisible = false; //15
            isStairCoverVisible = false; //16
            isAltEnergyVisible = true; //17
            isWaterWellVisible = false; //18
            isGreenHouseVisible = false; //19
          } else if (_category.id! == 2) {
            isPriceVisible = true; //1
            isAreaVisible = true; //2
            isBedroomVisible = false; //3
            isBathroomVisible = false; //4
            isLevelVisible = false; //5
            isDirectionVisible = false; //6
            isStatesVisible = true; //7
            isOwnershipVisible = false; //8
            isLicenseVisible = false; //9
            isCheminyVisible = true; //12
            isPoolVisible = false; //13
            isElevatorVisible = false; //14
            isRockCoverVisible = false; //15
            isStairCoverVisible = false; //16
            isAltEnergyVisible = true; //17
            isWaterWellVisible = false; //18
            isGreenHouseVisible = false; //19
          } else if (_category.id! == 3) {
            isPriceVisible = false; //1
            isAreaVisible = false; //2
            isBedroomVisible = false; //3
            isBathroomVisible = false; //4
            isLevelVisible = false; //5
            isDirectionVisible = false; //6
            isStatesVisible = false; //7
            isOwnershipVisible = false; //8
            isLicenseVisible = false; //9
            isCheminyVisible = false; //12
            isPoolVisible = false; //13
            isElevatorVisible = false; //14
            isRockCoverVisible = false; //15
            isStairCoverVisible = false; //16
            isAltEnergyVisible = false; //17
            isWaterWellVisible = false; //18
            isGreenHouseVisible = false; //19
          } else if (_category.id! == 4) {
            isPriceVisible = false; //1
            isAreaVisible = false; //2
            isBedroomVisible = false; //3
            isBathroomVisible = false; //4
            isLevelVisible = false; //5
            isDirectionVisible = false; //6
            isStatesVisible = false; //7
            isOwnershipVisible = false; //8
            isLicenseVisible = false; //9
            isCheminyVisible = false; //12
            isPoolVisible = false; //13
            isElevatorVisible = false; //14
            isRockCoverVisible = false; //15
            isStairCoverVisible = false; //16
            isAltEnergyVisible = false; //17
            isWaterWellVisible = false; //18
            isGreenHouseVisible = false; //19
          }
        }
        break;
      case 9:
        {
          if (_category.id! == 1 || _category.id! == 0) {
            isPriceVisible = true; //1
            isAreaVisible = true; //2
            isBedroomVisible = false; //3
            isBathroomVisible = false; //4
            isLevelVisible = false; //5
            isDirectionVisible = false; //6
            isStatesVisible = true; //7
            isOwnershipVisible = true; //8
            isLicenseVisible = true; //9
            isCheminyVisible = false; //12
            isPoolVisible = false; //13
            isElevatorVisible = false; //14
            isRockCoverVisible = false; //15
            isStairCoverVisible = false; //16
            isAltEnergyVisible = true; //17
            isWaterWellVisible = false; //18
            isGreenHouseVisible = false; //19
          } else if (_category.id! == 2) {
            isPriceVisible = false; //1
            isAreaVisible = false; //2
            isBedroomVisible = false; //3
            isBathroomVisible = false; //4
            isLevelVisible = false; //5
            isDirectionVisible = false; //6
            isStatesVisible = false; //7
            isOwnershipVisible = false; //8
            isLicenseVisible = false; //9
            isCheminyVisible = false; //12
            isPoolVisible = false; //13
            isElevatorVisible = false; //14
            isRockCoverVisible = false; //15
            isStairCoverVisible = false; //16
            isAltEnergyVisible = false; //17
            isWaterWellVisible = false; //18
            isGreenHouseVisible = false; //19
          } else if (_category.id! == 3) {
            isPriceVisible = true; //1
            isAreaVisible = true; //2
            isBedroomVisible = false; //3
            isBathroomVisible = false; //4
            isLevelVisible = false; //5
            isDirectionVisible = false; //6
            isStatesVisible = false; //7
            isOwnershipVisible = false; //8
            isLicenseVisible = false; //9
            isCheminyVisible = false; //12
            isPoolVisible = false; //13
            isElevatorVisible = false; //14
            isRockCoverVisible = false; //15
            isStairCoverVisible = false; //16
            isAltEnergyVisible = true; //17
            isWaterWellVisible = false; //18
            isGreenHouseVisible = false; //19
          } else if (_category.id! == 4) {
            isPriceVisible = false; //1
            isAreaVisible = false; //2
            isBedroomVisible = false; //3
            isBathroomVisible = false; //4
            isLevelVisible = false; //5
            isDirectionVisible = false; //6
            isStatesVisible = false; //7
            isOwnershipVisible = false; //8
            isLicenseVisible = false; //9
            isCheminyVisible = false; //12
            isPoolVisible = false; //13
            isElevatorVisible = false; //14
            isRockCoverVisible = false; //15
            isStairCoverVisible = false; //16
            isAltEnergyVisible = false; //17
            isWaterWellVisible = false; //18
            isGreenHouseVisible = false; //19
          }
        }
        break;
      case 10:
        {
          if (_category.id! == 1 || _category.id! == 0) {
            isPriceVisible = true; //1
            isAreaVisible = true; //2
            isBedroomVisible = false; //3
            isBathroomVisible = false; //4
            isLevelVisible = true; //5
            isDirectionVisible = false; //6
            isStatesVisible = true; //7
            isOwnershipVisible = true; //8
            isLicenseVisible = true; //9
            isCheminyVisible = false; //12
            isPoolVisible = false; //13
            isElevatorVisible = false; //14
            isRockCoverVisible = false; //15
            isStairCoverVisible = false; //16
            isAltEnergyVisible = true; //17
            isWaterWellVisible = false; //18
            isGreenHouseVisible = false; //19
          } else if (_category.id! == 2) {
            isPriceVisible = true; //1
            isAreaVisible = true; //2
            isBedroomVisible = false; //3
            isBathroomVisible = false; //4
            isLevelVisible = true; //5
            isDirectionVisible = false; //6
            isStatesVisible = false; //7
            isOwnershipVisible = false; //8
            isLicenseVisible = false; //9
            isCheminyVisible = false; //12
            isPoolVisible = false; //13
            isElevatorVisible = false; //14
            isRockCoverVisible = false; //15
            isStairCoverVisible = false; //16
            isAltEnergyVisible = true; //17
            isWaterWellVisible = false; //18
            isGreenHouseVisible = false; //19
          } else if (_category.id! == 3) {
            isPriceVisible = false; //1
            isAreaVisible = false; //2
            isBedroomVisible = false; //3
            isBathroomVisible = false; //4
            isLevelVisible = false; //5
            isDirectionVisible = false; //6
            isStatesVisible = false; //7
            isOwnershipVisible = false; //8
            isLicenseVisible = false; //9
            isCheminyVisible = false; //12
            isPoolVisible = false; //13
            isElevatorVisible = false; //14
            isRockCoverVisible = false; //15
            isStairCoverVisible = false; //16
            isAltEnergyVisible = false; //17
            isWaterWellVisible = false; //18
            isGreenHouseVisible = false; //19
          } else if (_category.id! == 4) {
            isPriceVisible = false; //1
            isAreaVisible = false; //2
            isBedroomVisible = false; //3
            isBathroomVisible = false; //4
            isLevelVisible = false; //5
            isDirectionVisible = false; //6
            isStatesVisible = false; //7
            isOwnershipVisible = false; //8
            isLicenseVisible = false; //9
            isCheminyVisible = false; //12
            isPoolVisible = false; //13
            isElevatorVisible = false; //14
            isRockCoverVisible = false; //15
            isStairCoverVisible = false; //16
            isAltEnergyVisible = false; //17
            isWaterWellVisible = false; //18
            isGreenHouseVisible = false; //19
          }
        }
        break;
      case 11:
        {
          if (_category.id! == 1 || _category.id! == 0) {
            isPriceVisible = true; //1
            isAreaVisible = true; //2
            isBedroomVisible = true; //3
            isBathroomVisible = true; //4
            isLevelVisible = false; //5
            isDirectionVisible = false; //6
            isStatesVisible = true; //7
            isOwnershipVisible = true; //8
            isLicenseVisible = false; //9
            isCheminyVisible = false; //12
            isPoolVisible = true; //13
            isElevatorVisible = false; //14
            isRockCoverVisible = false; //15
            isStairCoverVisible = false; //16
            isAltEnergyVisible = true; //17
            isWaterWellVisible = true; //18
            isGreenHouseVisible = true; //19
          } else if (_category.id! == 2) {
            isPriceVisible = true; //1
            isAreaVisible = true; //2
            isBedroomVisible = true; //3
            isBathroomVisible = true; //4
            isLevelVisible = false; //5
            isDirectionVisible = false; //6
            isStatesVisible = false; //7
            isOwnershipVisible = false; //8
            isLicenseVisible = false; //9
            isCheminyVisible = false; //12
            isPoolVisible = true; //13
            isElevatorVisible = false; //14
            isRockCoverVisible = false; //15
            isStairCoverVisible = false; //16
            isAltEnergyVisible = true; //17
            isWaterWellVisible = false; //18
            isGreenHouseVisible = false; //19
          } else if (_category.id! == 3) {
            isPriceVisible = false; //1
            isAreaVisible = false; //2
            isBedroomVisible = false; //3
            isBathroomVisible = false; //4
            isLevelVisible = false; //5
            isDirectionVisible = false; //6
            isStatesVisible = false; //7
            isOwnershipVisible = false; //8
            isLicenseVisible = false; //9
            isCheminyVisible = false; //12
            isPoolVisible = false; //13
            isElevatorVisible = false; //14
            isRockCoverVisible = false; //15
            isStairCoverVisible = false; //16
            isAltEnergyVisible = false; //17
            isWaterWellVisible = false; //18
            isGreenHouseVisible = false; //19
          } else if (_category.id! == 4) {
            isPriceVisible = false; //1
            isAreaVisible = false; //2
            isBedroomVisible = false; //3
            isBathroomVisible = false; //4
            isLevelVisible = false; //5
            isDirectionVisible = false; //6
            isStatesVisible = false; //7
            isOwnershipVisible = false; //8
            isLicenseVisible = false; //9
            isCheminyVisible = false; //12
            isPoolVisible = false; //13
            isElevatorVisible = false; //14
            isRockCoverVisible = false; //15
            isStairCoverVisible = false; //16
            isAltEnergyVisible = false; //17
            isWaterWellVisible = false; //18
            isGreenHouseVisible = false; //19
          }
        }
        break;
      case 12:
        {
          if (_category.id! == 1 || _category.id! == 0) {
            isPriceVisible = true; //1
            isAreaVisible = true; //2
            isBedroomVisible = false; //3
            isBathroomVisible = false; //4
            isLevelVisible = false; //5
            isDirectionVisible = false; //6
            isStatesVisible = false; //7
            isOwnershipVisible = true; //8
            isLicenseVisible = false; //9
            isCheminyVisible = false; //12
            isPoolVisible = false; //13
            isElevatorVisible = false; //14
            isRockCoverVisible = false; //15
            isStairCoverVisible = false; //16
            isAltEnergyVisible = false; //17
            isWaterWellVisible = true; //18
            isGreenHouseVisible = true; //19
          } else if (_category.id! == 2) {
            isPriceVisible = true; //1
            isAreaVisible = true; //2
            isBedroomVisible = false; //3
            isBathroomVisible = false; //4
            isLevelVisible = false; //5
            isDirectionVisible = false; //6
            isStatesVisible = false; //7
            isOwnershipVisible = false; //8
            isLicenseVisible = false; //9
            isCheminyVisible = false; //12
            isPoolVisible = false; //13
            isElevatorVisible = false; //14
            isRockCoverVisible = false; //15
            isStairCoverVisible = false; //16
            isAltEnergyVisible = true; //17
            isWaterWellVisible = true; //18
            isGreenHouseVisible = true; //19
          } else if (_category.id! == 3) {
            isPriceVisible = true; //1
            isAreaVisible = true; //2
            isBedroomVisible = false; //3
            isBathroomVisible = false; //4
            isLevelVisible = false; //5
            isDirectionVisible = false; //6
            isStatesVisible = false; //7
            isOwnershipVisible = false; //8
            isLicenseVisible = false; //9
            isCheminyVisible = false; //12
            isPoolVisible = false; //13
            isElevatorVisible = false; //14
            isRockCoverVisible = false; //15
            isStairCoverVisible = false; //16
            isAltEnergyVisible = false; //17
            isWaterWellVisible = true; //18
            isGreenHouseVisible = true; //19
          } else if (_category.id! == 4) {
            isPriceVisible = false; //1
            isAreaVisible = false; //2
            isBedroomVisible = false; //3
            isBathroomVisible = false; //4
            isLevelVisible = false; //5
            isDirectionVisible = false; //6
            isStatesVisible = false; //7
            isOwnershipVisible = false; //8
            isLicenseVisible = false; //9
            isCheminyVisible = false; //12
            isPoolVisible = false; //13
            isElevatorVisible = false; //14
            isRockCoverVisible = false; //15
            isStairCoverVisible = false; //16
            isAltEnergyVisible = false; //17
            isWaterWellVisible = false; //18
            isGreenHouseVisible = false; //19
          }
        }
        break;
      case 13:
        {
          if (_category.id! == 1 || _category.id! == 0) {
            isPriceVisible = true; //1
            isAreaVisible = true; //2
            isBedroomVisible = false; //3
            isBathroomVisible = false; //4
            isLevelVisible = false; //5
            isDirectionVisible = false; //6
            isStatesVisible = false; //7
            isOwnershipVisible = true; //8
            isLicenseVisible = false; //9
            isCheminyVisible = false; //12
            isPoolVisible = false; //13
            isElevatorVisible = false; //14
            isRockCoverVisible = false; //15
            isStairCoverVisible = false; //16
            isAltEnergyVisible = false; //17
            isWaterWellVisible = false; //18
            isGreenHouseVisible = false; //19
          } else if (_category.id! == 2) {
            isPriceVisible = false; //1
            isAreaVisible = false; //2
            isBedroomVisible = false; //3
            isBathroomVisible = false; //4
            isLevelVisible = false; //5
            isDirectionVisible = false; //6
            isStatesVisible = false; //7
            isOwnershipVisible = false; //8
            isLicenseVisible = false; //9
            isCheminyVisible = false; //12
            isPoolVisible = false; //13
            isElevatorVisible = false; //14
            isRockCoverVisible = false; //15
            isStairCoverVisible = false; //16
            isAltEnergyVisible = false; //17
            isWaterWellVisible = false; //18
            isGreenHouseVisible = false; //19
          } else if (_category.id! == 3) {
            isPriceVisible = false; //1
            isAreaVisible = false; //2
            isBedroomVisible = false; //3
            isBathroomVisible = false; //4
            isLevelVisible = false; //5
            isDirectionVisible = false; //6
            isStatesVisible = false; //7
            isOwnershipVisible = false; //8
            isLicenseVisible = false; //9
            isCheminyVisible = false; //12
            isPoolVisible = false; //13
            isElevatorVisible = false; //14
            isRockCoverVisible = false; //15
            isStairCoverVisible = false; //16
            isAltEnergyVisible = false; //17
            isWaterWellVisible = false; //18
            isGreenHouseVisible = false; //19
          } else if (_category.id! == 4) {
            isPriceVisible = false; //1
            isAreaVisible = true; //2
            isBedroomVisible = false; //3
            isBathroomVisible = false; //4
            isLevelVisible = false; //5
            isDirectionVisible = false; //6
            isStatesVisible = false; //7
            isOwnershipVisible = true; //8
            isLicenseVisible = true; //9
            isCheminyVisible = false; //12
            isPoolVisible = false; //13
            isElevatorVisible = true; //14
            isRockCoverVisible = true; //15
            isStairCoverVisible = true; //16
            isAltEnergyVisible = false; //17
            isWaterWellVisible = false; //18
            isGreenHouseVisible = false; //19
          }
        }
        break;
    }

    update();
  }

  updateNatureIdex(int state) {
    natureindex = state;
    update();
  }

  updateOwnership(int ownership) {
    _prore = _prores[ownership];
    _licenses = [];
    getLicenses();
    update();
  }

  updatePropreIdex(int state) {
    propreindex = state;
    update();
  }

  updateLicense(int license) {
    _license = _licenses[license];
    update();
  }

  updateLicenseIdex(int state) {
    licenseindex = state;
    update();
  }

  updateValue(bool newValue, String prop) {
    switch (prop) {
      case "ischimney":
        {
          ischimney = newValue;
          break;
        }
      case "isSwiming":
        {
          isSwiming = newValue;
          break;
        }
      case "iselevator":
        {
          iselevator = newValue;
          break;
        }
      case "isrockcover":
        {
          isrockcover = newValue;
          break;
        }
      case "isstaircover":
        {
          isstaircover = newValue;
          break;
        }
      case "isaltenergy":
        {
          isaltenergy = newValue;
          break;
        }
      case "iswell":
        {
          iswell = newValue;
          break;
        }
      case "isGreenhouse":
        {
          ishanger = newValue;
          break;
        }
    }
    update();
  }

  updatePercentage(int cat) {
    _percentageValue = cat;
    update();
  }

  addDirection(int index) {
    _selectedDirectionIndex.add(index);
    // directionValid.value = true;
    directionmultiValid.value = true;
    if (_selectedDirectionIndex.length == 1) {
      directionmultiValid.value = true;
      if (_selectedDirectionIndex.contains(0)) {
        _direction = _directions[0];
      } else if (_selectedDirectionIndex.contains(1)) {
        _direction = _directions[1];
      } else if (_selectedDirectionIndex.contains(2)) {
        _direction = _directions[2];
      } else if (_selectedDirectionIndex.contains(3)) {
        _direction = _directions[3];
      }
    } else if (_selectedDirectionIndex.length == 2) {
      if (_selectedDirectionIndex.contains(0) &&
          _selectedDirectionIndex.contains(2)) {
        _direction = _directions[4];
      } else if (_selectedDirectionIndex.contains(0) &&
          _selectedDirectionIndex.contains(3)) {
        _direction = _directions[5];
      } else if (_selectedDirectionIndex.contains(1) &&
          _selectedDirectionIndex.contains(2)) {
        _direction = _directions[6];
      } else if (_selectedDirectionIndex.contains(1) &&
          _selectedDirectionIndex.contains(3)) {
        _direction = _directions[7];
      } else if (_selectedDirectionIndex.contains(0) &&
          _selectedDirectionIndex.contains(1)) {
        directionmultiValid.value = false;
      } else if (_selectedDirectionIndex.contains(2) &&
          _selectedDirectionIndex.contains(3)) {
        directionmultiValid.value = false;
      }
    } else if (_selectedDirectionIndex.length == 3) {
      directionmultiValid.value = true;
      if (_selectedDirectionIndex.contains(0) &&
          _selectedDirectionIndex.contains(1) &&
          _selectedDirectionIndex.contains(2)) {
        _direction = _directions[9];
      } else if (_selectedDirectionIndex.contains(0) &&
          _selectedDirectionIndex.contains(1) &&
          _selectedDirectionIndex.contains(3)) {
        _direction = _directions[10];
      } else if (_selectedDirectionIndex.contains(0) &&
          _selectedDirectionIndex.contains(2) &&
          _selectedDirectionIndex.contains(3)) {
        _direction = _directions[11];
      } else if (_selectedDirectionIndex.contains(1) &&
          _selectedDirectionIndex.contains(2) &&
          _selectedDirectionIndex.contains(3)) {
        _direction = _directions[12];
      }
    } else if (_selectedDirectionIndex.length == 4) {
      directionmultiValid.value = true;
      _direction = _directions[8];
    }
    print(_direction.id);
    print(_direction.dir);
    update();
  }

  removeDirection(int index) {
    _selectedDirectionIndex.remove(index);
    directionmultiValid.value = true;
    if (_selectedDirectionIndex.length == 1) {
      if (_selectedDirectionIndex.contains(0)) {
        _direction = _directions[0];
      } else if (_selectedDirectionIndex.contains(1)) {
        _direction = _directions[1];
      } else if (_selectedDirectionIndex.contains(2)) {
        _direction = _directions[2];
      } else if (_selectedDirectionIndex.contains(3)) {
        _direction = _directions[3];
      }
    } else if (_selectedDirectionIndex.length == 2) {
      if (_selectedDirectionIndex.contains(0) &&
          _selectedDirectionIndex.contains(2)) {
        _direction = _directions[4];
      } else if (_selectedDirectionIndex.contains(0) &&
          _selectedDirectionIndex.contains(3)) {
        _direction = _directions[5];
      } else if (_selectedDirectionIndex.contains(1) &&
          _selectedDirectionIndex.contains(2)) {
        _direction = _directions[6];
      } else if (_selectedDirectionIndex.contains(1) &&
          _selectedDirectionIndex.contains(3)) {
        _direction = _directions[7];
      } else if (_selectedDirectionIndex.contains(0) &&
          _selectedDirectionIndex.contains(1)) {
        directionmultiValid.value = false;
      } else if (_selectedDirectionIndex.contains(2) &&
          _selectedDirectionIndex.contains(3)) {
        directionmultiValid.value = false;
      }
    } else if (_selectedDirectionIndex.length == 3) {
      if (_selectedDirectionIndex.contains(0) &&
          _selectedDirectionIndex.contains(1) &&
          _selectedDirectionIndex.contains(2)) {
        _direction = _directions[9];
      } else if (_selectedDirectionIndex.contains(0) &&
          _selectedDirectionIndex.contains(1) &&
          _selectedDirectionIndex.contains(3)) {
        _direction = _directions[10];
      } else if (_selectedDirectionIndex.contains(0) &&
          _selectedDirectionIndex.contains(2) &&
          _selectedDirectionIndex.contains(3)) {
        _direction = _directions[11];
      } else if (_selectedDirectionIndex.contains(1) &&
          _selectedDirectionIndex.contains(2) &&
          _selectedDirectionIndex.contains(3)) {
        _direction = _directions[12];
      }
    } else if (_selectedDirectionIndex.length == 4) {
      _direction = _directions[8];
    } else if (_selectedDirectionIndex.length == 0) {
      _direction = _directions.last;
    }
    print(_direction.id);
    print(_direction.dir);
    update();
  }

  getCategories() async {
    _loading.value = true;

    await PropertyService().getCategories().then((value) {
      if (value == null) {
        _categories = [];
      } else {
        var defualtCat = Category(id: 0, category: "All".tr);
        _categories = value;
        _categories.insert(0, defualtCat);
        _category = _categories[0];
      }
      _loading.value = false;
      update();
    });
  }

  getRegions() async {
    _loading.value = true;

    await PropertyService().getRegions().then((value) {
      if (value == null) {
        _regions = [];
      } else {
        var defualtCat = Region(id: 0, region: "All".tr);
        _regions = value;
        _regions.insert(0, defualtCat);
        _region = _regions[0];
      }
      if (_nature != null) {
        _loading.value = false;
      }
      update();
    });
  }

  getCities() async {
    _loading.value = true;

    await PropertyService().getCities().then((value) {
      if (value == null) {
        _cities = [];
      } else {
        var defualtCat = City(id: 0, city: "All".tr);
        _cities = value;
        _cities.insert(0, defualtCat);
        _city = _cities[0];
      }
      if (_nature != null) {
        _loading.value = false;
      }
      update();
    });
  }

  getDirections() async {
    _loading.value = true;

    await PropertyService().getDirections().then((value) {
      if (value == null) {
        _directions = [];
      } else {
        _directions = value;
        _direction = _directions[0];
      }
      if (_nature != null) {
        _loading.value = false;
      }
      update();
    });
  }

  getNatures(int type) async {
    _natureloading.value = true;
    natureindex = 0;
    await PropertyService().getNatures().then((value) {
      if (value == null) {
        _natures = [];
      } else {
        _natures = [];
        if (type == 0) {
          var defualtCat = Nature(id: 0, nature: "All".tr);
          _natures = value;
          _natures.insert(0, defualtCat);
          _nature = _natures[0];
        } else {
          for (var element in value) {
            if (element.type_id == type.toString()) {
              _natures.add(element);
            }
          }
          _nature = _natures[0];
        }
      }
      _natureloading.value = false;
      update();
    });
  }

  getStates() async {
    statusloading.value = true;
    stateindex = 0;
    await PropertyService().getStates().then((value) {
      if (value == null) {
        _states = [];
      } else {
        var defualtState = States(id: 0, states: "All".tr);
        _states.add(defualtState);
        for (var element in value) {
          if (element.id == 1 && category.id == 2) {
            continue;
          }
          _states.add(element);
        }
        _state = _states[0];
      }
      statusloading.value = false;
      update();
    });
  }

  void getTypes() async {
    _typeloading.value = true;
    typeindex = 0;
    await PropertyService().getTypes().then((value) {
      if (value == null) {
        _types = [];
      } else {
        var defualtType = Type(id: 0, type: "All".tr);
        _types = value;
        _types.insert(0, defualtType);
        _typeValue = _types[0];
      }
      getNatures(0);
      _typeloading.value = false;
      update();
    });
  }

  void getProRes() async {
    _loading.value = true;
    propreindex = 0;
    await PropertyService().getProRes().then((value) {
      if (value == null) {
        _prores = [];
      } else {
        var defualtProre = ProRes(id: 0, type: "All".tr);
        _prores = value;
        _prores.insert(0, defualtProre);
        _prore = _prores[0];
      }
      getLicenses();
      _loading.value = false;
      update();
    });
  }

  getLicenses() async {
    _licenseloading.value = true;
    licenseindex = 0;
    await PropertyService().getLicenses().then((value) {
      if (value == null) {
        _licenses = [];
      } else {
        var defualtLicense = License(id: 0, type: "All".tr);
        for (var element in value) {
          if (_prore.id == 1) {
            if (element.id == 1) {
              _licenses.add(element);
              break;
            }
          } else if (_prore.id == 2) {
            if (element.id == 2 || element.id == 3) {
              _licenses.add(element);
            }
          } else {
            _licenses = value;
          }
        }
        _licenses.insert(0, defualtLicense);
        _license = _licenses[0];
      }
      _licenseloading.value = false;
      update();
    });
  }

  void setCurrentPosition(CameraPosition campos) {
    _currentPosition = campos.target;
    initLat = (_currentPosition?.latitude.toString())!;
    initLong = (_currentPosition?.longitude.toString())!;
    zoom = campos.zoom.toString();
    update();
  }

  Future<List<Prediction>> searchLocation(
      BuildContext context, String text) async {
    if (text != null && text.isNotEmpty) {
      http.Response response = await getLocationData(text);
      var data = jsonDecode(response.body.toString());
      if (data['status'] == 'OK') {
        _predictionList = [];
        data['predictions'].forEach((prediction) =>
            _predictionList.add(Prediction.fromJson(prediction)));
      } else {
        // ApiChecker.checkApi(response);
      }
    }
    return _predictionList;
  }

  void searchPlaces(String searchTerm) async {
    _searchResults = await _placeService.getAutocomplete(searchTerm);
    update();
  }

  void setSelectedLocation(String placeId) async {
    var sLocation = await _placeService.getPlace(placeId);
    _selectedLocation = Rxn(sLocation);
    _selectedLocationStatic = Rxn(sLocation);
    if (selectedLocation.value != null) {
      _goToPlace(selectedLocation.value!);
    }
    _searchResults = [];
    update();
  }

  clearSelectedLocation() {
    _selectedLocation = Rxn(null);
    _selectedLocationStatic = Rxn(null);
    _searchResults = [];
    _placeType = Rxn(null);
    update();
  }

  Future<void> _goToPlace(Place place) async {
    _googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(
                place.geometry.location.lat, place.geometry.location.lng),
            zoom: 14.0),
      ),
    );
  }

  setGoolgeMapController(
      {required GoogleMapController controller, bool saveSearch = false}) {
    _googleMapController = controller;
    // await getProperties();
    initLat = 35.363149.toString();
    initLong = 35.932120.toString();
    zoom = 13.toString();
    filterProperty();
    Get.find<ControlViewModel>().determinePosition().then((value) {
      var initLat = value.latitude;
      var initLong = value.longitude;
      double zoom = 13;
      _googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(initLat, initLong), zoom: 13.0),
        ),
      );
    });
    update();
  }

  void gotolocation() {
    Get.find<ControlViewModel>().determinePosition().then((value) {
      var initLat = value.latitude;
      var initLong = value.longitude;
      double zoom = 13;
      _googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(initLat, initLong), zoom: 13.0),
        ),
      );
    });
    update();
  }

  changeMapType() {
    currentMapType =
        currentMapType == MapType.normal ? MapType.satellite : MapType.normal;
    update();
  }

  void changeSelectedIndex(int value) {
    _selectedIndex = value;
    update();
  }

  saveSearch() async {
    String sstateid,
        scategoryid,
        stypeid,
        snatureid,
        spropreid,
        slicenseid,
        sminarea,
        smaxarea,
        sbedroomnum,
        sbathroomnum,
        sfloorheight,
        schimney,
        spool,
        selevator,
        srocks,
        sstairs,
        saltenergy,
        swaterwell,
        shanger,
        sminprice,
        smaxprice,
        slat1,
        slong1,
        slat2,
        slong2 = "";

    var bounds = await _googleMapController.getVisibleRegion();

    _state.id == 0 ? sstateid = "" : sstateid = _state.id.toString();
    _typeValue.id == 0 ? stypeid = "" : stypeid = _typeValue.id.toString();
    _category.id == 0
        ? scategoryid = ""
        : scategoryid = _category.id.toString();
    _nature.id == 0 ? snatureid = "" : snatureid = _nature.id.toString();
    _prore.id == 0 ? spropreid = "" : spropreid = _prore.id.toString();
    _license.id == 0 ? slicenseid = "" : slicenseid = _license.id.toString();
    sminarea = minArea.toString();
    smaxarea = maxArea.toString();
    bedroomindex == 0
        ? sbedroomnum = ""
        : sbedroomnum = bedroomindex.toString();
    bathroomindex == 0
        ? sbathroomnum = ""
        : sbathroomnum = bathroomindex.toString();
    levelheightindex == 0
        ? sfloorheight = ""
        : sfloorheight = levelheightindex.toString();
    ischimney == false ? schimney = "" : schimney = ischimney.toString();
    isSwiming == false ? spool = "" : spool = isSwiming.toString();
    iselevator == false ? selevator = "" : selevator = iselevator.toString();
    isrockcover == false ? srocks = "" : srocks = isrockcover.toString();
    isstaircover == false ? sstairs = "" : sstairs = isstaircover.toString();
    isaltenergy == false
        ? saltenergy = ""
        : saltenergy = isaltenergy.toString();
    iswell == false ? swaterwell = "" : swaterwell = iswell.toString();
    ishanger == false ? shanger = "" : shanger = ishanger.toString();
    sminprice = minPrice.toString();
    smaxprice = maxPrice.toString();
    slat1 = bounds.northeast.latitude.toString();
    slong1 = bounds.northeast.longitude.toString();
    slat2 = bounds.southwest.latitude.toString();
    slong2 = bounds.southwest.longitude.toString();

    SavedSearch sSearch = SavedSearch(
        saveid: uuid.v1(),
        searchName: searchName,
        stateId: sstateid,
        propertyId: sstateid,
        typeId: stypeid,
        categoryId: scategoryid,
        natureId: snatureid,
        propreId: spropreid,
        licenseId: slicenseid,
        minarea: sminarea,
        maxarea: smaxarea,
        bedroomNum: sbedroomnum,
        bathroomNum: sbathroomnum,
        floorHeight: sfloorheight,
        chimney: schimney,
        elevator: selevator,
        pool: spool,
        rocks: srocks,
        stairs: sstairs,
        altenergy: saltenergy,
        waterwell: swaterwell,
        hanger: shanger,
        minprice: sminprice,
        maxprice: smaxprice,
        lat1: slat1,
        long1: slong1,
        lat2: slat2,
        long2: slong2,
        initlat: initLat,
        initlong: initLong,
        zoom: zoom);

    var decodedjson = json.encode(sSearch.toJson());
    print(decodedjson);
    await dbHelper.insertSearch(sSearch);

    // List<SavedSearch> asd = await dbHelper.getAllSavedSearch();
    // print(asd.length);
    Get.find<SavedSearchViewModel>().getAllSavedSearchs();
    update();
  }

  filterProperty() async {
    _loading.value = true;
    isLoading(true);
    filterMessage = "filter is true";
    var bounds = await _googleMapController.getVisibleRegion();
    var request = http.MultipartRequest('POST', Uri.parse(FILTER_ENDPOINT));

    _state.id == 0
        ? request.fields['state_id'] = ""
        : request.fields['state_id'] = _state.id.toString();
    request.fields['region_id'] = "";
    request.fields['city_id'] = "";
    _typeValue.id == 0
        ? request.fields['type_id'] = ""
        : request.fields['type_id'] = _typeValue.id.toString();
    _category.id == 0
        ? request.fields['category_id'] = ""
        : request.fields['category_id'] = _category.id.toString();
    _nature.id == 0
        ? request.fields['nature_id'] = ""
        : request.fields['nature_id'] = _nature.id.toString();
    _prore.id == 0
        ? request.fields['prore_id'] = ""
        : request.fields['prore_id'] = _prore.id.toString();
    _license.id == 0
        ? request.fields['license_id'] = ""
        : request.fields['license_id'] = _license.id.toString();
    // request.fields['min_area'] = minArea.toString();
    // request.fields['max_area'] = maxArea.toString();
    bedroomindex == 0
        ? request.fields['sleep_room_count'] = ""
        : request.fields['sleep_room_count'] = bedroomindex.toString();
    bathroomindex == 0
        ? request.fields['bath_room_count'] = ""
        : request.fields['bath_room_count'] = bathroomindex.toString();
    levelheightindex == 0
        ? request.fields['floor_height'] = ""
        : request.fields['floor_height'] = levelheightindex.toString();
    selectedDirectionIndex.isEmpty
        ? request.fields['direction_id'] = ""
        : request.fields['direction_id'] = _direction.id.toString();
    ischimney == false
        ? request.fields['chimney'] = ""
        : request.fields['chimney'] = ischimney.toString();
    isSwiming == false
        ? request.fields['swimming_pool'] = ""
        : request.fields['swimming_pool'] = isSwiming.toString();
    iselevator == false
        ? request.fields['elevator'] = ""
        : request.fields['elevator'] = iselevator.toString();
    isrockcover == false
        ? request.fields['with_rocks'] = ""
        : request.fields['with_rocks'] = isrockcover.toString();
    isstaircover == false
        ? request.fields['staircase'] = ""
        : request.fields['staircase'] = isstaircover.toString();
    isaltenergy == false
        ? request.fields['alternative_energy'] = ""
        : request.fields['alternative_energy'] = isaltenergy.toString();
    iswell == false
        ? request.fields['water_well'] = ""
        : request.fields['water_well'] = iswell.toString();
    ishanger == false
        ? request.fields['hangar'] = ""
        : request.fields['hangar'] = ishanger.toString();
    request.fields['min_price'] = minPrice.toString();
    request.fields['max_price'] = maxPrice.toString();
    request.fields['lat1'] = bounds.northeast.latitude.toString();
    request.fields['long1'] = bounds.northeast.longitude.toString();
    request.fields['lat2'] = bounds.southwest.latitude.toString();
    request.fields['long2'] = bounds.southwest.longitude.toString();
    var response = await request.send();

    _filteredProperties = [];
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      var res = jsonDecode(respStr);
      filterMessage = res["message"];
      // print(res["real_states"][0][0]);
      for (var element in res["real_states"]) {
        _filteredProperties.add(FilteredProperty.fromJson(element));
        // print(_filteredProperties[0].image![0].image!);
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
            onTap: () async {
              // List<Placemark> placemarks = await placemarkFromCoordinates(
              //     double.parse(mapItem.lat!), double.parse(mapItem.long!),
              //     localeIdentifier: "en");
              // print(placemarks);
              Get.find<ControlViewModel>().changeToMidOpen();
              Get.find<ControlViewModel>().getHomeInfo(mapItem.id!);
              Get.find<SearchViewModel>().changeSelectedIndex(i);
            },
          ),
        );
      }

      _loading.value = false;
      isLoading(false);
      update();
    } else if (response.statusCode == 500) {
      // Get.snackbar(
      //   "خطأ",
      //   "يوجد خطأ بالمخدم الرجاء المحاولة مرة أخرى",
      // );
      _filteredProperties = [];
      _loading.value = false;
      isLoading(false);
      update();
    }
  }

  Future filterWithoutmapProperty() async {
    _loading.value = true;
    isLoading(true);
    btnLoading.value = true;
    var request = http.MultipartRequest('POST', Uri.parse(FILTER_ENDPOINT));

    _state.id == 0
        ? request.fields['state_id'] = ""
        : request.fields['state_id'] = _state.id.toString();

    _typeValue.id == 0
        ? request.fields['type_id'] = ""
        : request.fields['type_id'] = _typeValue.id.toString();
    _category.id == 0
        ? request.fields['category_id'] = ""
        : request.fields['category_id'] = _category.id.toString();
    _region.id == 0
        ? request.fields['region_id'] = ""
        : request.fields['region_id'] = _region.id.toString();
    _city.id == 0
        ? request.fields['city_id'] = ""
        : request.fields['city_id'] = _city.id.toString();
    _nature.id == 0
        ? request.fields['nature_id'] = ""
        : request.fields['nature_id'] = _nature.id.toString();
    _prore.id == 0
        ? request.fields['prore_id'] = ""
        : request.fields['prore_id'] = _prore.id.toString();
    _license.id == 0
        ? request.fields['license_id'] = ""
        : request.fields['license_id'] = _license.id.toString();
    // request.fields['min_area'] = minArea.toString();
    // request.fields['max_area'] = maxArea.toString();
    bedroomindex == 0
        ? request.fields['sleep_room_count'] = ""
        : request.fields['sleep_room_count'] = bedroomindex.toString();
    bathroomindex == 0
        ? request.fields['bath_room_count'] = ""
        : request.fields['bath_room_count'] = bathroomindex.toString();
    levelheightindex == 0
        ? request.fields['floor_height'] = ""
        : request.fields['floor_height'] = levelheightindex.toString();
    selectedDirectionIndex.isEmpty
        ? request.fields['direction_id'] = ""
        : request.fields['direction_id'] = _direction.id.toString();
    ischimney == false
        ? request.fields['chimney'] = ""
        : request.fields['chimney'] = ischimney.toString();
    isSwiming == false
        ? request.fields['swimming_pool'] = ""
        : request.fields['swimming_pool'] = isSwiming.toString();
    iselevator == false
        ? request.fields['elevator'] = ""
        : request.fields['elevator'] = iselevator.toString();
    isrockcover == false
        ? request.fields['with_rocks'] = ""
        : request.fields['with_rocks'] = isrockcover.toString();
    isstaircover == false
        ? request.fields['staircase'] = ""
        : request.fields['staircase'] = isstaircover.toString();
    isaltenergy == false
        ? request.fields['alternative_energy'] = ""
        : request.fields['alternative_energy'] = isaltenergy.toString();
    iswell == false
        ? request.fields['water_well'] = ""
        : request.fields['water_well'] = iswell.toString();
    ishanger == false
        ? request.fields['hangar'] = ""
        : request.fields['hangar'] = ishanger.toString();
    request.fields['min_price'] = minPrice.toString();
    request.fields['max_price'] = maxPrice.toString();
    request.fields['lat1'] = "";
    request.fields['long1'] = "";
    request.fields['lat2'] = "";
    request.fields['long2'] = "";
    Get.to(FilterResult());
    var response = await request.send();

    _filteredProperties = [];
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      var res = jsonDecode(respStr);
      filterMessage = res["message"];
      for (var element in res["real_states"]) {
        _filteredProperties.add(FilteredProperty.fromJson(element));
        // print(_filteredProperties[0].image![0].image!);
      }
      btnLoading.value = false;
      _loading.value = false;
      isLoading(false);
      update();
    } else if (response.statusCode == 500) {
      // Get.snackbar(
      //   "خطأ",
      //   "يوجد خطأ بالمخدم الرجاء المحاولة مرة أخرى",
      // );
      _filteredProperties = [];
      btnLoading.value = false;
      _loading.value = false;
      isLoading(false);
      update();
    }
  }
}
