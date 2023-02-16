// ignore_for_file: unnecessary_null_comparison

import 'dart:io';

import 'package:catalog/helpers/http_helper.dart';
import 'package:catalog/models/pinned_estate.dart';
import 'package:catalog/models/user_model.dart';
import 'package:catalog/services/database/favoraite_database_helper.dart';
import 'package:catalog/views/control_view.dart';
import 'package:catalog/views/sms_screen.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sms_receiver/sms_receiver.dart';

class AuthViewModel extends GetxController {
  // ignore: prefer_final_fields
  ValueNotifier<bool> _loading = ValueNotifier(false);
  ValueNotifier<bool> get loading => _loading;
  ValueNotifier<bool> _userloading = ValueNotifier(false);
  ValueNotifier<bool> get userloading => _userloading;

  UserModel? _userModel;
  UserModel? get userModel => _userModel;

  List<PinnedPropertyModel>? _pinnedProperties;
  List<PinnedPropertyModel>? get pinnedProperties => _pinnedProperties;

  SmsReceiver? _smsReceiver;

  bool obscurePassword = true;

  final TextEditingController smsCodeController = TextEditingController();

  String? password, name, phone, city, code, firebase_token;

  final isLogged = false.obs;
  final isActive = false.obs;
  final isRegistered = false.obs;

  late SharedPreferences prefs;

  bool _checkedValue = false;
  bool get checkedValue => _checkedValue;

  @override
  void onInit() async {
    // ignore: todo
    // TODO: implement onInit
    prefs = await SharedPreferences.getInstance();
    var token = await jwtOrEmpty;

    if (token != "") {
      var str = token;
      var jwt = str.split(".");

      if (jwt.length != 3) {
        isLogged.value = false;
      } else {
        var payload =
            json.decode(ascii.decode(base64.decode(base64.normalize(jwt[1]))));
        if (DateTime.fromMillisecondsSinceEpoch(
                (payload["exp"].toInt()) * 1000000)
            .isAfter(DateTime.now())) {
          isLogged.value = true;
          var userId = prefs.getString("userId");
          var isactive = false;
          if (prefs.getBool("active") == null) {
            isactive = false;
          } else {
            isactive = prefs.getBool("active")!;
          }
          isActive.value = isactive ? true : false;
          getUserInfo(userId!);
        } else {
          isLogged.value = false;
        }
      }
    } else {
      isLogged.value = false;
    }

    FirebaseMessaging messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value) {
      print(value);
      firebase_token = value;
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage event) async {
      FavoriteDatabaseHelper? dbHelper = FavoriteDatabaseHelper.db;
      dbHelper.deletePinnedProperty(event.data["id"].toString());
      _pinnedProperties = await dbHelper.getAllPinnedProperties();
      update();
      // print("message recieved");
      // print(event.notification!.body);
      // print(event.notification!.bodyLocArgs);
      // print(event.data);
      // print(event.data["id"]);
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message clicked!');
    });

    _smsReceiver = SmsReceiver(onSmsReceived, onTimeout: onTimeout);
    if (!isLogged.value) {
      _startListening();
    }
    super.onInit();
  }

  void showPassword() {
    obscurePassword = !obscurePassword;
    update();
  }

  void getUserInfo(String id) async {
    _userloading.value = true;
    update();
    var dbHelper = FavoriteDatabaseHelper.db;

    var rs = await HttpHelper.get(GET_USER_INFO_ENDPOINT + id);
    if (rs.statusCode == 200) {
      var res = jsonDecode(rs.body);
      _userModel = UserModel.fromJson(res["user"]);
      _pinnedProperties = await dbHelper.getAllPinnedProperties();
      _userloading.value = false;
      update();
    }
  }

  Future<String> get jwtOrEmpty async {
    // sharedPreferencesHelper.getUserDataModel().then((userDataModel) {
    //   final jsonData = json.decode(userDataModel);
    //   user = User.fromJson(jsonData);
    // });
    var jwt = await prefs.getString("token");
    if (jwt == null) return "";
    return jwt;
  }

  void onSmsReceived(String? message) {
    RegExp regExp = RegExp(r'\d{5}');
    code = regExp.stringMatch(message!);
    smsCodeController.text = code!;
    update();
    checkMessageCode();
    _stopListening();
    update();
  }

  void onTimeout() {}

  void _startListening() async {
    if (_smsReceiver == null) return;
    await _smsReceiver?.startListening();
  }

  void _stopListening() async {
    if (_smsReceiver == null) return;
    await _smsReceiver?.stopListening();
  }

  void oncheckedValueChanged(bool newValue) {
    _checkedValue = newValue;
    update();
  }

  void register() async {
    _loading.value = true;
    update();
    prefs = await SharedPreferences.getInstance();
    var request = http.MultipartRequest('POST', Uri.parse(REGISTER_ENDPOINT));

    request.fields['name'] = name!;
    request.fields['password'] = password!;
    request.fields['phone'] = phone!;
    request.fields['city'] = city!;
    request.fields['firebase_token'] = firebase_token!;

    var response = await request.send();

    if (response.statusCode == 200) {
      String respStr = await response.stream.bytesToString();
      var result = respStr.substring(12);
      var res = jsonDecode(result);
      prefs.setString("token", res["success"]["token"]);
      prefs.setString("userId", res["success"]["id"].toString());
      prefs.setString("phone", phone!);
      getUserInfo(res["success"]["id"].toString());
      Get.off(SmsScreen());
      isLogged.value = true;
      _loading.value = false;
      update();
    } else if (response.statusCode == 400) {
      isRegistered.value = true;
      _loading.value = false;
      update();
    } else {
      _loading.value = false;
      update();
    }
    // isLogged.value = true;
  }

  void login() async {
    _loading.value = true;
    update();
    prefs = await SharedPreferences.getInstance();
    var request = http.MultipartRequest('POST', Uri.parse(LOGIN_ENDPOINT));

    request.fields['password'] = password!;
    request.fields['phone'] = phone!;
    request.fields['firebase_token'] = firebase_token!;

    var response = await request.send();

    if (response.statusCode == 200) {
      String respStr = await response.stream.bytesToString();
      var res = jsonDecode(respStr);
      if (res["message"] == "success") {
        prefs.setString("token", res["0"]["token"]);
        prefs.setString("userId", res["0"]["id"].toString());
        prefs.setString("phone", phone!);
        getUserInfo(res["0"]["id"].toString());
        isLogged.value = true;
        Get.back();
        _loading.value = false;
        update();
      } else if (res["message"] == "user is not active") {
        prefs.setString("token", res["0"]["token"]);
        prefs.setString("userId", res["0"]["id"].toString());
        prefs.setString("phone", phone!);
        getUserInfo(res["0"]["id"].toString());
        isLogged.value = true;
        var request = http.MultipartRequest('POST', Uri.parse(RESEND_ENDPOINT));
        request.fields['phone'] = phone!;
        var response = await request.send();
        Get.off(SmsScreen());
        _loading.value = false;
        update();
      }
    } else {
      _loading.value = false;
      update();
    }
    // isLogged.value = true;
  }

  void resendcode() async {
    prefs = await SharedPreferences.getInstance();
    String phone = prefs.getString('phone')!;
    String jwt = prefs.getString('token')!;
    var request = http.MultipartRequest('POST', Uri.parse(RESEND_ENDPOINT));
    // request.headers.addAll({
    //   HttpHeaders.authorizationHeader: "Bearer $jwt",
    //   HttpHeaders.contentTypeHeader: "multipart/form-data"
    // });
    request.fields['phone'] = phone;
    var response = await request.send();
  }

  void checkMessageCode() async {
    _loading.value = true;
    update();
    prefs = await SharedPreferences.getInstance();
    String jwt = prefs.getString('token')!;
    var request = http.MultipartRequest('POST', Uri.parse(MESSAGE_CHECK_CODE));
    request.headers.addAll({
      HttpHeaders.authorizationHeader: "Bearer $jwt",
      HttpHeaders.contentTypeHeader: "multipart/form-data"
    });
    request.fields['code'] = code!;
    var response = await request.send();

    if (response.statusCode == 200) {
      prefs.setBool("active", true);
      isActive.value = true;
      Get.off(ControlView());
      _loading.value = false;
      update();
    } else {
      _loading.value = false;
      update();
    }
  }
}
