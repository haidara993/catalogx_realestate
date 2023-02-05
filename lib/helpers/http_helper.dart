// ignore_for_file: constant_identifier_names

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

const DOMAIN = 'https://catalogy.me/ctlog/public/api/';
const IMAGEDOMAIN =
    'https://catalogy.me/ctlog/public/storage/real_estates/images/';
const MESSAGE_CHECK_CODE = DOMAIN + 'check';
const REGISTER_ENDPOINT = DOMAIN + 'register';
const LOGIN_ENDPOINT = DOMAIN + 'login';
const RESEND_ENDPOINT = DOMAIN + 'resend';
const CATEGORY_ENDPOINT = DOMAIN + 'getCategories';
const REGION_ENDPOINT = DOMAIN + 'getRegions';
const CITY_ENDPOINT = DOMAIN + 'getCities';
const NATURE_ENDPOINT = DOMAIN + 'getNatures';
const STATES_ENDPOINT = DOMAIN + 'getStates';
const TYPES_ENDPOINT = DOMAIN + 'getTypes';
const PRORES_ENDPOINT = DOMAIN + 'getProRes';
const LICENSE_ENDPOINT = DOMAIN + 'getLicenses';
const ADDREALESTATE_ENDPOINT = DOMAIN + 'store_real_estate';
const PROPERTIES_ENDPOINT = DOMAIN + 'getRealStates';
const PROPERTY_ENDPOINT = DOMAIN + 'getReWithId';
const BROKER_ENDPOINT = DOMAIN + 'brokers';
const OUR_SERVICES_ENDPOINT = DOMAIN + 'getAllServices';
const BROKERWITHID_ENDPOINT = DOMAIN + 'brokerWithId?id=';
const BROKERWITHREALESTATE_ENDPOINT = DOMAIN + 'ReWithBroker?broker_id=';
const DIRECTION_ENDPOINT = DOMAIN + 'getDirections';
const LINKBROKER_ENDPOINT = DOMAIN + 'link';
const CHECKCODE_ENDPOINT = DOMAIN + 'checkCode';
const FILTER_ENDPOINT = DOMAIN + 'filter';
const GET_USER_INFO_ENDPOINT = DOMAIN + 'getUser?id=';
const SEND_POINTS_ENDPOINT = DOMAIN + 'sendPoints?points=';
const CALL_ENDPOINT = DOMAIN + 'call';

class HttpHelper {
  static Future<http.Response> post(String url, Map<String, dynamic> body,
      {String? bearerToken}) async {
    return (await http.post(Uri.parse(url), body: jsonEncode(body), headers: {
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $bearerToken'
    }));
  }

  static Future<http.Response> put(String url, Map<String, dynamic> body,
      {String? bearerToken}) async {
    return (await http.put(Uri.parse(url), body: jsonEncode(body), headers: {
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      HttpHeaders.acceptHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $bearerToken'
    }));
  }

  static Future<http.Response> get(String url) async {
    return await http.get(Uri.parse(url));
  }

  static Future<http.Response> getAuth(String url,
      {String? bearerToken}) async {
    return await http.get(Uri.parse(url),
        headers: {HttpHeaders.authorizationHeader: 'Bearer $bearerToken'});
  }
}
