// ignore_for_file: prefer_final_fields, non_constant_identifier_names, unused_field, unnecessary_null_comparison

import 'dart:convert';
import 'dart:io';

import 'package:catalog/helpers/http_helper.dart';
import 'package:catalog/models/broker.dart';
import 'package:catalog/models/item_key_model.dart';
import 'package:catalog/models/pinned_estate.dart';
import 'package:catalog/models/property_model.dart';
import 'package:catalog/services/broker_service.dart';
import 'package:catalog/services/database/favoraite_database_helper.dart';
import 'package:catalog/services/property_service.dart';
import 'package:catalog/views/add_property/assign_broker.dart';
import 'package:catalog/views/add_property/property_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PropertyController extends GetxController {
  late GoogleMapController _googleMapController;
  GoogleMapController get googleMapController => _googleMapController;

  Set<Marker> _myMarker = {};
  Set<Marker> get myMarker => _myMarker;

  FavoriteDatabaseHelper? dbHelper;

  ValueNotifier<bool> _maploading = ValueNotifier(false);
  ValueNotifier<bool> get maploading => _maploading;

  ValueNotifier<bool> _loading = ValueNotifier(true);
  ValueNotifier<bool> get loading => _loading;

  // ValueNotifier<bool> get btnLoading => _btnLoading;

  var homeCarouselIndicator = 0.obs;

  final isLoading = false.obs;
  final btnLoading = false.obs;
  final locationValid = true.obs;
  final directionValid = true.obs;
  final directionmultiValid = true.obs;

  ValueNotifier<bool> _regionloading = ValueNotifier(false);
  ValueNotifier<bool> get regionloading => _regionloading;
  ValueNotifier<bool> _cityloading = ValueNotifier(false);
  ValueNotifier<bool> get cityloading => _cityloading;

  late PropertyModel _property;
  PropertyModel get property => _property;

  List<Category> _categories = [];
  List<Category> get categories => _categories;
  late Category _category;
  Category get category => _category;

  List<Region> _regions = [];
  List<Region> get regions => _regions;
  late Region _region = Region(id: 0, region: "All".tr);
  Region get region => _region;

  List<City> _cities = [];
  List<City> get cities => _cities;
  late City _city = City(id: 0, city: "All".tr);
  City get city => _city;

  List<Nature> _natures = [];
  List<Nature> get natures => _natures;
  Nature _nature = Nature(id: 0, nature: "All".tr, type_id: "0");
  Nature get nature => _nature;

  List<States> _states = [];
  List<States> get states => _states;
  late States _state;
  States get state => _state;

  List<Type> _types = [];
  List<Type> get types => _types;
  late Type _typeValue;
  Type get typeValue => _typeValue;

  List<ProRes> _prores = [];
  List<ProRes> get prores => _prores;
  late ProRes _prore;
  ProRes get prore => _prore;

  List<DataRow> _rowList = [];
  List<DataRow> get rowList => _rowList;

  List<License> _licenses = [];
  List<License> get licenses => _licenses;
  late License _license;
  License get license => _license;

  List<Broker> _brokers = [];
  List<Broker> get brokers => _brokers;
  late Broker _broker;
  Broker get broker => _broker;

  List<Direction> _directions = [];
  List<Direction> get directions => _directions;
  late Direction _direction;
  Direction get direction => _direction;

  late PropertyModel _home;
  PropertyModel get home => _home;

  List<int> percentageList = [1, 2, 3, 4, 5];
  int _percentageValue = 1;
  int get percentageValue => _percentageValue;

  List<String> roomTypes = [];
  List<String> roomLengths = [];
  List<String> roomWidths = [];
  List<String> roomFloors = [];

  int _regionindex = 0;
  int get regionindex => _regionindex;

  int _cityindex = 0;
  int get cityindex => _cityindex;

  int _categoryindex = 0;
  int get categoryindex => _categoryindex;

  int _natureindex = 0;
  int get natureindex => _natureindex;

  int _typeindex = 0;
  int get typeindex => _typeindex;

  int _statusindex = 0;
  int get statusindex => _statusindex;

  int _propreindex = 0;
  int get propreindex => _propreindex;

  int _licenseindex = 0;
  int get licenseindex => _licenseindex;

  int _percentageindex = 0;
  int get percentageindex => _percentageindex;

  List<String> _roomTypesList = [
    'غرفة نوم',
    'حمام',
    'مطبخ',
    'صالون',
    'غرفة معيشة'
  ];
  List<String> get roomTypesList => _roomTypesList;
  late String _selectedRoomType;
  String get selectedRoomType => _selectedRoomType;

  List<int> _selectedDirectionIndex = [];
  List<int> get selectedDirectionIndex => _selectedDirectionIndex;
  // var directions = ['شرقي', 'غربي', 'شمالي', 'جنوبي'];

  bool ischimney = false;
  bool isSwiming = false;
  bool iselevator = false;
  bool isrockcover = false;
  bool isstaircover = false;
  bool isaltenergy = false;
  bool iswell = false;
  bool ishanger = false;

  bool isRentOptionsVisibile = false;
  bool isChaletNumVisible = false;
  bool isBedAndBathroomNumVisible = false;
  bool isLevelNumVisible = false;
  bool isAreaVisible = false;
  bool isStatusVisible = false;
  bool isTotalAreaVisible = false;
  bool isCheminyVisible = true;
  bool isPoolVisible = true;
  bool isElevatorVisible = true;
  bool isRockCoverVisible = true;
  bool isStairCoverVisible = true;
  bool isAltEnergyVisible = true;
  bool isWaterWellVisible = true;
  bool isGreenHouseVisible = true;

  String roomType = '';
  String roomLength = '';
  String roomWidth = '';
  String roomFloor = '';

  XFile? _file;
  XFile? get file => _file;
  List<XFile>? _imageFileList = [];
  List<XFile>? get imageFileList => _imageFileList;
  late File image;
  final ImagePicker _picker = ImagePicker();

  dynamic _pickImageError;

  String? id,
      address_latitude,
      address_longitude,
      address_title,
      user_id,
      real_estate_type,
      rent_amount,
      moquala_perc,
      descrition,
      video_links,
      address_address,
      real_estate_images;

  String? chalet_layout_number = "0";
  String? floor_height = "0";
  String? bath_room_count = "0";
  String? sleep_room_count = "0";
  String? area = "0";
  String? total_area = "0";
  String? amount = "0";
  String? period = "1";

  PropertyService _propertyServices = PropertyService();
  @override
  void onInit() {
    // ignore: todo
    // TODO: implement onInit
    super.onInit();
    isLoading.value = true;
    getCategories();
    getRegions();
    getCities();
    getDirections();
    getStates();
    getTypes();
    getProRes();
    getBrokers();
    updateRowList();
    dbHelper = FavoriteDatabaseHelper.db;
    _selectedRoomType = _roomTypesList[0];
    roomType = _selectedRoomType;
    update();
  }

  @override
  void onClose() {
    // ignore: todo
    // TODO: implement onClose
    _googleMapController.dispose();
    super.onClose();
  }

  addDirection(int index) {
    print("object");
    _selectedDirectionIndex.add(index);
    directionValid.value = true;
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
    print(_selectedDirectionIndex.length);
    update();
  }

  void setGoolgeMapController(GoogleMapController controller) {
    _googleMapController = controller;
    _maploading = ValueNotifier(false);
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
    }
    update();
  }

  // ignore: unused_element
  void _setImageFileListFromFile(XFile? value) {
    _imageFileList = value == null ? null : <XFile>[value];
  }

  // ignore: unused_element
  Future<void> _displayPickImageDialog(
      BuildContext context, OnPickImageCallback onPick) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add optional parameters'),
            content: Column(
              children: const <Widget>[],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                  child: const Text('PICK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  setLocation(double lat, double long) {
    address_latitude = lat.toString();
    address_longitude = long.toString();
    var newPosition = CameraPosition(
        target: LatLng(
          double.parse(address_latitude!),
          double.parse(address_longitude!),
        ),
        zoom: 13);
    CameraUpdate cameraUpdate = CameraUpdate.newCameraPosition(newPosition);
    _googleMapController.moveCamera(cameraUpdate);
    _myMarker = {};
    _myMarker.add(Marker(
        markerId: MarkerId(LatLng(
          double.parse(address_latitude!),
          double.parse(address_longitude!),
        ).toString()),
        position: LatLng(
          double.parse(address_latitude!),
          double.parse(address_longitude!),
        )));
    locationValid.value = true;
    _maploading = ValueNotifier(true);
    update();
  }

  updateRowList() {
    _rowList = [];
    for (var i = 0; i < roomTypes.length; i++) {
      // ignore: unnecessary_new
      var cell = new DataRow(
        cells: <DataCell>[
          DataCell(
            Text(roomTypes[i]),
          ),
          DataCell(
            Text(roomLengths[i].toString()),
          ),
          DataCell(
            Text(roomWidths[i].toString()),
          ),
          DataCell(
            Text(roomFloors[i].toString()),
          ),
        ],
      );
      rowList.add(cell);
    }
    update();
  }

  imageButtonPressed(ImageSource source,
      {BuildContext? context, bool isMultiImage = false}) async {
    if (isMultiImage) {
      try {
        final List<XFile>? pickedFileList = await _picker.pickMultiImage();
        _imageFileList = pickedFileList;
        update();
      } catch (e) {
        _pickImageError = e;
      }
    }
  }

  addRoom() {
    roomTypes.add(roomType);
    _selectedRoomType = _roomTypesList[0];
    roomType = _selectedRoomType;
    roomLengths.add(roomLength.toString());
    roomLength = '';
    roomWidths.add(roomWidth.toString());
    roomWidth = '';
    roomFloors.add(roomFloor.toString());
    roomFloor = '';
    updateRowList();
  }

  insertPinnedProperty(PinnedPropertyModel pinnedproperty) {
    dbHelper!.insertPinnedProperty(pinnedproperty);
  }

  updateBroker(Broker broker) {
    _broker = broker;
    update();
  }

  updateCategory(Category cat, int index) {
    if (_categoryindex == index) {
      _categoryindex = 0;
    } else {
      _categoryindex = index;
      _category = cat;
      if (_category.id == 2) {
        isRentOptionsVisibile = true;
      } else {
        isRentOptionsVisibile = false;
      }
    }

    update();
  }

  updateRegion(int state) {
    _region = _regions[state];
    update();
  }

  updateRegionIdex(int state) {
    _regionindex = state;
    update();
  }

  updateCity(int state) {
    _city = _cities[state];
    update();
  }

  updateCityIdex(int state) {
    _cityindex = state;
    update();
  }

  // updateRegion(Region cat, int index) {
  //   if (_regionindex == index) {
  //     _regionindex = 0;
  //   } else {
  //     _regionindex = index;
  //     _region = cat;
  //   }
  //   update();
  // }

  // updateCity(City cat, int index) {
  //   if (_cityindex == index) {
  //     _cityindex = 0;
  //   } else {
  //     _cityindex = index;
  //     _city = cat;
  //   }
  //   update();
  // }

  updateSelectedRoomType(String roomType) {
    _selectedRoomType = roomType;
    update();
  }

  updatePeriod(String value) {
    period = value;
    update();
  }

  updateState(States state, int index) {
    if (_statusindex == index) {
      _statusindex = 0;
    } else {
      _statusindex = index;
      _state = state;
    }
    update();
  }

  updateNature(Nature state, int index) {
    _natureindex = index;
    _nature = state;
    if (_typeValue.id == 1 || _typeValue.id == 2) {
      isBedAndBathroomNumVisible = true;
      isLevelNumVisible = true;
    } else {
      isBedAndBathroomNumVisible = false;
      isLevelNumVisible = false;
    }
    if (_typeValue.id == 3) {
      if (_nature.id == 7) {
        isLevelNumVisible = true;
      } else {
        isLevelNumVisible = false;
      }
    }

    switch (_nature.id!) {
      case 1:
        {
          isCheminyVisible = true; //12
          isPoolVisible = false; //13
          isElevatorVisible = true; //14
          isRockCoverVisible = true; //15
          isStairCoverVisible = true; //16
          isAltEnergyVisible = true; //17
          isWaterWellVisible = false; //18
          isGreenHouseVisible = false; //19
        }
        break;
      case 2:
        {
          isCheminyVisible = false; //12
          isPoolVisible = true; //13
          isElevatorVisible = false; //14
          isRockCoverVisible = false; //15
          isStairCoverVisible = false; //16
          isAltEnergyVisible = true; //17
          isWaterWellVisible = true; //18
          isGreenHouseVisible = false; //19
        }
        break;
      case 3:
        {
          isCheminyVisible = false; //12
          isPoolVisible = false; //13
          isElevatorVisible = true; //14
          isRockCoverVisible = true; //15
          isStairCoverVisible = true; //16
          isAltEnergyVisible = true; //17
          isWaterWellVisible = true; //18
          isGreenHouseVisible = false; //19
        }
        break;
      case 4:
        {
          isCheminyVisible = false; //12
          isPoolVisible = false; //13
          isElevatorVisible = false; //14
          isRockCoverVisible = false; //15
          isStairCoverVisible = false; //16
          isAltEnergyVisible = false; //17
          isWaterWellVisible = false; //18
          isGreenHouseVisible = false; //19
        }
        break;
      case 5:
        {
          isCheminyVisible = false; //12
          isPoolVisible = false; //13
          isElevatorVisible = false; //14
          isRockCoverVisible = false; //15
          isStairCoverVisible = false; //16
          isAltEnergyVisible = false; //17
          isWaterWellVisible = false; //18
          isGreenHouseVisible = false; //19
        }
        break;
      case 6:
        {
          isCheminyVisible = false; //12
          isPoolVisible = false; //13
          isElevatorVisible = false; //14
          isRockCoverVisible = false; //15
          isStairCoverVisible = false; //16
          isAltEnergyVisible = true; //17
          isWaterWellVisible = false; //18
          isGreenHouseVisible = false; //19
        }
        break;
      case 7:
        {
          isCheminyVisible = false; //12
          isPoolVisible = false; //13
          isElevatorVisible = false; //14
          isRockCoverVisible = false; //15
          isStairCoverVisible = false; //16
          isAltEnergyVisible = false; //17
          isWaterWellVisible = false; //18
          isGreenHouseVisible = false; //19
        }
        break;
      case 8:
        {
          isCheminyVisible = false; //12
          isPoolVisible = false; //13
          isElevatorVisible = false; //14
          isRockCoverVisible = false; //15
          isStairCoverVisible = false; //16
          isAltEnergyVisible = false; //17
          isWaterWellVisible = false; //18
          isGreenHouseVisible = false; //19
        }
        break;
      case 9:
        {
          isCheminyVisible = false; //12
          isPoolVisible = false; //13
          isElevatorVisible = false; //14
          isRockCoverVisible = false; //15
          isStairCoverVisible = false; //16
          isAltEnergyVisible = true; //17
          isWaterWellVisible = false; //18
          isGreenHouseVisible = false; //19
        }
        break;
      case 10:
        {
          isCheminyVisible = false; //12
          isPoolVisible = false; //13
          isElevatorVisible = false; //14
          isRockCoverVisible = false; //15
          isStairCoverVisible = false; //16
          isAltEnergyVisible = false; //17
          isWaterWellVisible = false; //18
          isGreenHouseVisible = false; //19
        }
        break;
      case 11:
        {
          isCheminyVisible = false; //12
          isPoolVisible = false; //13
          isElevatorVisible = true; //14
          isRockCoverVisible = true; //15
          isStairCoverVisible = true; //16
          isAltEnergyVisible = false; //17
          isWaterWellVisible = false; //18
          isGreenHouseVisible = false; //19

        }
        break;
      case 12:
        {
          isCheminyVisible = false; //12
          isPoolVisible = false; //13
          isElevatorVisible = false; //14
          isRockCoverVisible = false; //15
          isStairCoverVisible = false; //16
          isAltEnergyVisible = false; //17
          isWaterWellVisible = false; //18
          isGreenHouseVisible = false; //19
        }
        break;
      case 13:
        {
          isCheminyVisible = false; //12
          isPoolVisible = false; //13
          isElevatorVisible = false; //14
          isRockCoverVisible = false; //15
          isStairCoverVisible = false; //16
          isAltEnergyVisible = false; //17
          isWaterWellVisible = false; //18
          isGreenHouseVisible = false; //19
        }
        break;
    }

    update();
  }

  updateType(Type type, int index) {
    _typeindex = index;
    _typeValue = type;
    if (_typeValue.id == 2) {
      isChaletNumVisible = true;
    } else {
      isChaletNumVisible = false;
    }

    if (_typeValue.id == 1) {
      isStatusVisible = true;
    } else {
      isStatusVisible = false;
    }

    if (_typeValue.id == 1 || _typeValue.id == 2) {
      isBedAndBathroomNumVisible = true;
      isLevelNumVisible = true;
    } else {
      isBedAndBathroomNumVisible = false;
      isLevelNumVisible = false;
    }

    if (_typeValue.id == 3) {
      if (_nature.id == 7) {
        isLevelNumVisible = true;
      } else {
        isLevelNumVisible = false;
      }
    }

    getNatures();
    print(_typeValue.type!);
    print(_typeindex);
    update();
  }

  updateOwnership(ProRes ownership, int index) {
    if (_propreindex == index) {
      _propreindex = 0;
    } else {
      _propreindex = index;
      _prore = ownership;
      _licenses = [];
      getLicenses();
    }

    update();
  }

  updateLicense(License license, int index) {
    if (_licenseindex == index) {
      _licenseindex = 0;
    } else {
      _licenseindex = index;
      _license = license;
    }
    update();
  }

  updatePercentage(int cat, int index) {
    if (_percentageindex == index) {
      _percentageindex = 0;
    } else {
      _percentageindex = index;
      _percentageValue = cat;
    }
    update();
  }

  updateDirection(Direction dir) {
    _direction = dir;
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
      case "ishangar":
        {
          ishanger = newValue;
          break;
        }
    }
    update();
  }

  // Future<File?> testCompressAndGetFile(File file, String targetPath) async {
  //   var result = await FlutterImageCompress.compressAndGetFile(
  //       file.absolute.path, targetPath,
  //       quality: 88,
  //       rotate: 180,
  //     );

  //   print(file.lengthSync());
  //   print(result?.lengthSync());

  //   return result;
  // }

  postProperty() async {
    btnLoading.value = true;
    List<http.MultipartFile> newList = [];
    var request =
        http.MultipartRequest('POST', Uri.parse(ADDREALESTATE_ENDPOINT));
    for (var img in _imageFileList!) {
      var result = await FlutterImageCompress.compressAndGetFile(
        img.path,
        img.path + "temp.jpg",
        quality: 85,
      );
      var multipartFile = await http.MultipartFile.fromPath(
        'real_estate_images[]',
        result!.path,
        filename: img.path.split('/').last,
      );
      newList.add(multipartFile);
    }
    request.files.addAll(newList);

    request.fields['chimney'] = ischimney.toString();
    request.fields['swimming_pool'] = isSwiming.toString();
    request.fields['elevator'] = iselevator.toString();
    request.fields['with_rocks'] = isrockcover.toString();
    request.fields['staircase'] = isstaircover.toString();
    request.fields['alternative_energy'] = isaltenergy.toString();
    request.fields['water_well'] = iswell.toString();
    request.fields['hanger'] = ishanger.toString();
    request.fields['address_latitude'] = address_latitude.toString();
    request.fields['address_longitude'] = address_longitude.toString();
    request.fields['user_id'] = 1.toString();
    request.fields['state_id'] = _state.id.toString();
    request.fields['type_id'] = _typeValue.id.toString();
    request.fields['prore_id'] = _prore.id.toString();
    request.fields['nature_id'] = _nature.id.toString();
    request.fields['license_id'] = _license.id.toString();
    request.fields['category_id'] = _category.id.toString();
    request.fields['region_id'] = _region.id.toString();
    request.fields['city_id'] = _city.id.toString();
    request.fields['moqaula_perc'] = _percentageValue.toString();
    request.fields['period'] = period!;
    request.fields['chalet_layout_number'] = chalet_layout_number!;
    request.fields['real_estate_type'] = _typeValue.id.toString();
    request.fields['rent_amount'] = 1.toString();
    request.fields['price'] = amount.toString();
    request.fields['area'] = area.toString();
    request.fields['total_area'] = total_area.toString();
    request.fields['sleep_room_count'] = sleep_room_count.toString();
    request.fields['bath_room_count'] = bath_room_count.toString();
    request.fields['floor_heigh'] = floor_height.toString();
    request.fields['description'] = descrition.toString();
    request.fields['direction_id'] = direction.id.toString();
    request.fields['address_title'] = address_address!;

    for (var i = 0; i < roomTypes.length; i++) {
      request.fields['type[$i]'] = roomTypes[i].toString();
      request.fields['length[$i]'] = roomLengths[i].toString();
      request.fields['width[$i]'] = roomWidths[i].toString();
      request.fields['floor[$i]'] = roomFloors[i].toString();
    }

    var response = await request.send();

    if (response.statusCode == 200) {
      Get.snackbar(
        "تمت الإضافة",
        "تم اضافة العقار بنجاح. بانتظار موافقة الأدمن",
      );
      final respStr = await response.stream.bytesToString();
      var res = jsonDecode(respStr);
      int id = res["id"];
      btnLoading.value = false;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt("homepId", id);
      Get.to(AssignBroker(
        propertyId: id,
      ));
    } else if (response.statusCode == 500) {
      final respStr = await response.stream.bytesToString();
      print(respStr);
      Get.snackbar(
        "خطأ",
        "يوجد خطأ بالمخدم الرجاء المحاولة مرة أخرى",
      );
      btnLoading.value = false;
      // update();
    } else {
      Get.snackbar(
        "خطأ",
        "يوجد خطأ بالمخدم الرجاء المحاولة مرة أخرى",
      );
      btnLoading.value = false;
    }

    // response.stream.transform(utf8.decoder).listen((value) {
    //   print(value);
    // });
  }

  Future<String> postCode(int propertyId, int code) async {
    btnLoading.value = true;

    var result = await PropertyService().linkPropertyWithCode(propertyId, code);

    btnLoading.value = false;
    return result;
  }

  postBroker(int propertyId) async {
    btnLoading.value = true;
    var request = http.MultipartRequest('POST', Uri.parse(LINKBROKER_ENDPOINT));
    request.fields['id'] = propertyId.toString();
    request.fields['broker_id'] = _broker.id.toString();
    var response = await request.send();

    if (response.statusCode == 200) {
      Get.snackbar(
        "تم الربط",
        "تم ربط العقار بنجاح مع المكتب العقاري.",
      );
      // final respStr = await response.stream.bytesToString();
      // var res = jsonDecode(respStr);
      // int id = res["id"];
      getHomeInfo(propertyId);
    } else {
      Get.snackbar(
        "يوجد خطأ",
        "يوجد مشكلة في المخدم الرجاء المحاولة مرة أخرى.",
      );
    }
  }

  void getHomeInfo(int id) async {
    await PropertyService().getPropperty(id).then((value) {
      if (value == null) {
      } else {
        _home = value;
        Get.to(PropertyDetails(home: _home));
      }
      btnLoading.value = false;
    });
  }

  getBrokers() async {
    _loading.value = true;

    await BrokerService().getBrokers().then((value) {
      if (value == null) {
        _brokers = [];
      } else {
        _brokers = value;
        _broker = _brokers[0];
      }
      _loading.value = false;
      update();
    });
  }

  getCategories() async {
    _loading.value = true;

    await PropertyService().getCategories().then((value) {
      if (value == null) {
        _categories = [];
      } else {
        _categories = value;
        _category = _categories[0];
      }
      if (_nature != null) {
        _loading.value = false;
      }
      update();
    });
  }

  getRegions() async {
    _loading.value = true;

    await PropertyService().getRegions().then((value) {
      if (value == null) {
        _regions = [];
      } else {
        _regions = value;
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
        _cities = value;
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

  getStates() async {
    _loading.value = true;
    await PropertyService().getStates().then((value) {
      if (value == null) {
        _states = [];
      } else {
        _states = value;
        _state = _states[0];
      }
      if (_nature != null) {
        _loading.value = false;
      }
      update();
    });
  }

  void getTypes() async {
    _loading.value = true;
    await PropertyService().getTypes().then((value) {
      if (value == null) {
        _types = [];
      } else {
        _types = value;
        _typeValue = _types[0];
        if (_typeValue.id == 1 || _typeValue.id == 2) {
          isBedAndBathroomNumVisible = true;
          isLevelNumVisible = true;
          isAreaVisible = true;
        } else {
          isBedAndBathroomNumVisible = false;
          isLevelNumVisible = false;

          isAreaVisible = false;
        }
        if (_typeValue.id == 1) {
          isStatusVisible = true;
        } else {
          isStatusVisible = false;
        }
        if (_typeValue.id == 3) {
          if (_nature.id == 7) {
            isLevelNumVisible = true;
          } else {
            isLevelNumVisible = false;
          }
        }
        isTotalAreaVisible = true;
      }
      getNatures();
      if (_nature != null) {
        _loading.value = false;
      }
      update();
    });
  }

  getNatures() async {
    _loading.value = true;
    await PropertyService().getNatures().then((value) {
      if (value == null) {
        _natures = [];
      } else {
        _natures = [];
        for (var element in value) {
          if (int.parse(element.type_id!) == _typeValue.id) {
            _natures.add(element);
          }
        }
        _nature = _natures[0];
        if (_nature.id == 2) {
          isAreaVisible = true;
        } else {
          isAreaVisible = false;
        }
      }
      _loading.value = false;
      update();
    });
  }

  void getProRes() async {
    _loading.value = true;
    await PropertyService().getProRes().then((value) {
      if (value == null) {
        _prores = [];
      } else {
        _prores = value;
        _prore = _prores[0];
      }
      getLicenses();
      if (_nature != null) {
        _loading.value = false;
      }
      update();
    });
  }

  void getLicenses() async {
    _loading.value = true;
    await PropertyService().getLicenses().then((value) {
      if (value == null) {
        _licenses = [];
      } else {
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
        _license = _licenses[0];
      }
      if (_nature != null) {
        _loading.value = false;
      }
      isLoading.value = false;
      update();
    });
  }
}

typedef OnPickImageCallback = void Function(
    double? maxWidth, double? maxHeight, int? quality);
