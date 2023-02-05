import 'package:catalog/controllers/control_viewmodel.dart';
import 'package:catalog/enums/panel_state.dart';
import 'package:catalog/models/favorite_property_model.dart';
import 'package:catalog/models/property_model.dart';
import 'package:catalog/services/database/favoraite_database_helper.dart';
import 'package:catalog/services/property_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

class FavoriteViewModel extends GetxController
    with SingleGetTickerProviderMixin {
  ValueNotifier<bool> _loading = ValueNotifier(false);
  ValueNotifier<bool> get loading => _loading;

  late final AnimationController _animationController;
  AnimationController get animationController => _animationController;

  late GoogleMapController _googleMapController;
  GoogleMapController get googleMapController => _googleMapController;

  var dbHelper = FavoriteDatabaseHelper.db;
  LatLng? _currentPosition;
  LatLng? get currentPosition => _currentPosition;

  List<FavoritePropertyModel> _favoriteProperties = [];
  List<FavoritePropertyModel> get favoriteProperties => _favoriteProperties;
  RxList<int> favoritePropertiesId = <int>[].obs;

  RxList<Marker> _markerList = <Marker>[].obs;
  RxList<Marker> get markerList => _markerList;

  var uuid = const Uuid();

  PanelState _panelState = PanelState.hidden;
  PanelState get panelState => _panelState;

  late PropertyModel _home;
  PropertyModel get home => _home;

  final btnLoading = false.obs;
  var isLoading = false.obs;

  Set<Marker> _myMarker = {};
  Set<Marker> get myMarker => _myMarker;

  int _selectedIndex = -1;
  int get selectedIndex => _selectedIndex;

  var homeCarouselIndicator = 0.obs;

  @override
  void onInit() async {
    // TODO: implement onInit
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animationController.repeat(reverse: true);

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

  void changeSelectedIndex(int value) {
    _selectedIndex = value;
    update();
  }

  Future<void> getHomeInfo(int id) async {
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

    _markerList = <Marker>[].obs;
    for (var i = 0; i < _favoriteProperties.length; i++) {
      final mapItem = _favoriteProperties[i];
      _markerList.add(
        Marker(
          markerId: MarkerId(uuid.v1()),
          icon: BitmapDescriptor.defaultMarker,
          position:
              LatLng(double.parse(mapItem.lat), double.parse(mapItem.long)),
          onTap: () {
            btnLoading.value = true;
            Get.find<FavoriteViewModel>().changeToMidOpen();
            Get.find<FavoriteViewModel>()
                .getHomeInfo(int.parse(mapItem.propertyId));
            Get.find<FavoriteViewModel>().changeSelectedIndex(i);
          },
        ),
      );
    }
    print(_favoriteProperties.length);
    print(favoritePropertiesId.length);
    // _loading.value = false;
    update();
  }

  Future setGoolgeMapController(GoogleMapController controller) async {
    _googleMapController = controller;
    // await getProperties();
    await getAllLikedProducts();
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

  void setCurrentPosition(CameraPosition campos) {
    _currentPosition = campos.target;
    update();
  }
}
