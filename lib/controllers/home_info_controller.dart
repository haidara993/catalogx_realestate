import 'package:catalog/helpers/http_helper.dart';
import 'package:catalog/models/broker.dart';
import 'package:catalog/models/property_model.dart';
import 'package:catalog/services/broker_service.dart';
import 'package:catalog/services/property_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomeInfoController extends GetxController {
  var isLoading = false.obs;

  late GoogleMapController _googleMapController;
  GoogleMapController get googleMapController => _googleMapController;

  Set<Marker> _myMarker = {};
  Set<Marker> get myMarker => _myMarker;

  ValueNotifier<bool> _maploading = ValueNotifier(false);
  ValueNotifier<bool> get maploading => _maploading;

  List<Properties> _properties = [];
  List<Properties> get properties => _properties;

  late PropertyModel _home;
  PropertyModel get home => _home;

  late Broker _broker;
  Broker get broker => _broker;

  var homeCarouselIndicator = 0.obs;

  late SharedPreferences prefs;

  late int homeId;

  @override
  void onInit() async {
    // ignore: todo
    // TODO: implement onInit
    super.onInit();
    isLoading.value = true;
    prefs = await SharedPreferences.getInstance();
    homeId = prefs.getInt("homeId")!;

    await PropertyService().getPropperty(homeId).then((value) {
      if (value == null) {
      } else {
        _home = value;
        getBrokerInfo((_home.realEstate?.brokerId)!);
      }
      update();
    });
  }

  Future getProperties(String id) async {
    isLoading(true);
    await BrokerService().getProperties(id).then((value) {
      if (value == null) {
        _properties = [];
      } else {
        _properties = value;

        return _properties;
      }
      isLoading.value = false;
      update();
    });
  }

  Future<void> getHomeInfo(int id) async {
    await PropertyService().getPropperty(id).then((value) {
      if (value == null) {
      } else {
        _home = value;
        getBrokerInfo((_home.realEstate?.brokerId)!);
      }
      update();
    });
  }

  String getNatureName(String catId) {
    String cat = "";
    switch (catId) {
      case "1":
        {
          cat = "شقة";
          break;
        }
      case "2":
        {
          cat = "فيلا";
          break;
        }
      case "3":
        {
          cat = "بناء للبيع";
          break;
        }
      case "4":
        {
          cat = "كراج";
          break;
        }
      case "5":
        {
          cat = "دفتر جمعية";
          break;
        }
      case "6":
        {
          cat = "شاليه";
          break;
        }
      case "7":
        {
          cat = "مكتب/عيادة/شركة";
          break;
        }
      case "8":
        {
          cat = "محل";
          break;
        }
      case "9":
        {
          cat = "مطعم";
          break;
        }
      case "10":
        {
          cat = "مستودع";
          break;
        }
      case "11":
        {
          cat = "مزرعة";
          break;
        }
      case "12":
        {
          cat = "أرض زراعية";
          break;
        }
      case "13":
        {
          cat = "أرض عمارة";
          break;
        }
    }
    return cat;
  }

  Future<void> getBrokerInfo(String id) async {
    await BrokerService().getBrokerwithId(id).then((value) {
      if (value == null) {
      } else {
        _broker = value;
        print(_broker.city);
        print(_broker.name);
        print(id);
        getProperties(id);
        isLoading.value = false;
      }
      update();
    });
  }

  void callBroker() async {
    prefs = await SharedPreferences.getInstance();
    var userid = prefs.getString("userId");
    var request = http.MultipartRequest('POST', Uri.parse(CALL_ENDPOINT));

    request.fields['sender_id'] = userid!;
    request.fields['recieved_id'] = _broker.id!.toString();
    request.send();
  }

  void sendPoints(String id, int points) async {
    var result = await PropertyService().sendPoints(id, points);
    if (result) {
      Get.snackbar("", "مبروك لقد تم اهدائك 10 نقاط لقاء مشاركتك هذا العقار.");
    } else {
      // Get.snackbar("", "عذرا .");;
    }
  }

  void setGoolgeMapController(GoogleMapController controller) {
    _googleMapController = controller;
    _maploading = ValueNotifier(false);
    _myMarker = {};
    _myMarker.add(Marker(
        markerId: MarkerId(LatLng(
          double.parse((_home.realEstate?.lat)!),
          double.parse((_home.realEstate?.long)!),
        ).toString()),
        position: LatLng(
          double.parse((_home.realEstate?.lat)!),
          double.parse((_home.realEstate?.long)!),
        )));
    update();
  }
}
