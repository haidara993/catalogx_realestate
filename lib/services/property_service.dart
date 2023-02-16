import 'dart:convert';
import 'dart:io';

import 'package:catalog/models/item_key_model.dart';
import 'package:catalog/models/property_model.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/http_helper.dart';

class PropertyService {
  List<Category> categories = [];
  List<Nature> natures = [];
  List<States> states = [];
  List<Type> types = [];
  List<ProRes> prores = [];
  List<License> licenses = [];
  List<Properties> properties = [];
  List<Direction> directions = [];
  List<Region> regions = [];
  List<City> cities = [];
  late PropertyModel prop;
  late SharedPreferences prefs;

  Future<PropertyModel?> getPropperty(int id) async {
    var rs = await HttpHelper.get(PROPERTY_ENDPOINT + "?id=" + id.toString());
    if (rs.statusCode == 200) {
      var res = jsonDecode(rs.body);

      var property = res;
      prop = PropertyModel.fromJson(property);
      return prop;
    }
    return null;
  }

  Future<List<Properties>> getProperties(
      double nwlat, double nwlong, double selat, double selong) async {
    var request = http.MultipartRequest('POST', Uri.parse(PROPERTIES_ENDPOINT));

    if (nwlat != 0.0) {
      request.fields['lat1'] = nwlat.toString();
      request.fields['long1'] = nwlong.toString();
      request.fields['lat2'] = selat.toString();
      request.fields['long2'] = selong.toString();
    }
    var response = await request.send();
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      var res = jsonDecode(respStr);

      for (var element in res["res"]) {
        properties.add(Properties.fromJson(element));
      }
      return properties;
    }
    return [];
  }

  Future<List<Region>> getRegions() async {
    // ignore: todo
    // TODO: implement getAll
    String fileName = "regionsData";

    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString(fileName) != null &&
        prefs.getString(fileName)!.isNotEmpty) {
      var jsonData = prefs.getString(fileName)!;
      var res = jsonDecode(jsonData);

      // print(jsonList.toList());
      for (var element in res["regions"]) {
        regions.add(Region.fromJson(element));
      }
      return regions;
    } else {
      var rs = await HttpHelper.get(REGION_ENDPOINT);
      if (rs.statusCode == 200) {
        var res = jsonDecode(rs.body);

        // print(jsonList.toList());
        for (var element in res["regions"]) {
          regions.add(Region.fromJson(element));
        }

        prefs.setString(fileName, rs.body);
        return regions;
      }
    }

    return [];
  }

  Future<List<City>> getCities() async {
    // ignore: todo
    // TODO: implement getAll
    String fileName = "citiesData";

    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString(fileName) != null &&
        prefs.getString(fileName)!.isNotEmpty) {
      var jsonData = prefs.getString(fileName)!;
      var res = jsonDecode(jsonData);

      // print(jsonList.toList());
      for (var element in res["cities"]) {
        cities.add(City.fromJson(element));
      }
      return cities;
    } else {
      var rs = await HttpHelper.get(CITY_ENDPOINT);
      if (rs.statusCode == 200) {
        var res = jsonDecode(rs.body);

        // print(jsonList.toList());
        for (var element in res["cities"]) {
          cities.add(City.fromJson(element));
        }
        prefs.setString(fileName, rs.body);
        return cities;
      }
    }

    return [];
  }

  Future<List<Category>> getCategories() async {
    // ignore: todo
    // TODO: implement getAll
    String fileName = "categoriesData";

    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString(fileName) != null &&
        prefs.getString(fileName)!.isNotEmpty) {
      var jsonData = prefs.getString(fileName)!;
      var res = jsonDecode(jsonData);

      // print(jsonList.toList());
      for (var element in res["categories"]) {
        categories.add(Category.fromJson(element));
      }
      return categories;
    } else {
      var rs = await HttpHelper.get(CATEGORY_ENDPOINT);
      if (rs.statusCode == 200) {
        var res = jsonDecode(rs.body);

        // print(jsonList.toList());
        for (var element in res["categories"]) {
          categories.add(Category.fromJson(element));
        }
        prefs.setString(fileName, rs.body);
        return categories;
      }
    }

    return [];
  }

  Future<String> linkPropertyWithCode(int propertyId, int code) async {
    // ignore: todo
    // TODO: implement getAll
    var rs = await HttpHelper.get(CHECKCODE_ENDPOINT +
        "?re_id=" +
        propertyId.toString() +
        "&code=" +
        code.toString());
    if (rs.statusCode == 200) {
      var res = jsonDecode(rs.body);

      return res["message"];
    }
    return "";
  }

  Future<bool> sendPoints(String propertyId, int points) async {
    prefs = await SharedPreferences.getInstance();
    String jwt = prefs.getString('token')!;
    var request =
        http.MultipartRequest('POST', Uri.parse(SEND_POINTS_ENDPOINT));
    request.headers.addAll({
      HttpHeaders.authorizationHeader: "Bearer $jwt",
      HttpHeaders.contentTypeHeader: "multipart/form-data"
    });
    request.fields['re_id'] = propertyId;
    request.fields['points'] = points.toString();
    var response = await request.send();

    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 400) {
      return false;
    }
    return false;
  }

  Future<List<Direction>> getDirections() async {
    // ignore: todo
    // TODO: implement getAll
    String fileName = "directionsData";

    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString(fileName) != null &&
        prefs.getString(fileName)!.isNotEmpty) {
      var jsonData = prefs.getString(fileName)!;
      var res = jsonDecode(jsonData);

      // print(jsonList.toList());
      for (var element in res["directions"]) {
        directions.add(Direction.fromJson(element));
      }
      return directions;
    } else {
      var rs = await HttpHelper.get(DIRECTION_ENDPOINT);
      if (rs.statusCode == 200) {
        var res = jsonDecode(rs.body);

        // print(jsonList.toList());
        for (var element in res["directions"]) {
          directions.add(Direction.fromJson(element));
        }
        prefs.setString(fileName, rs.body);
        return directions;
      }
    }

    return [];
  }

  Future<List<Nature>> getNatures() async {
    // ignore: todo
    // TODO: implement getAll
    String fileName = "naturesData";

    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString(fileName) != null &&
        prefs.getString(fileName)!.isNotEmpty) {
      var jsonData = prefs.getString(fileName)!;
      var res = jsonDecode(jsonData);

      // print(jsonList.toList());
      for (var element in res["natures"]) {
        natures.add(Nature.fromJson(element));
      }
      return natures;
    } else {
      var rs = await HttpHelper.get(NATURE_ENDPOINT);
      if (rs.statusCode == 200) {
        var res = jsonDecode(rs.body);

        // print(jsonList.toList());
        for (var element in res["natures"]) {
          natures.add(Nature.fromJson(element));
        }
        prefs.setString(fileName, rs.body);
        return natures;
      }
    }

    return [];
  }

  Future<List<States>> getStates() async {
    // ignore: todo
    // TODO: implement getAll
    String fileName = "statuesData";

    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString(fileName) != null &&
        prefs.getString(fileName)!.isNotEmpty) {
      var jsonData = prefs.getString(fileName)!;
      var res = jsonDecode(jsonData);
      // print(jsonList.toList());
      for (var element in res["states"]) {
        states.add(States.fromJson(element));
      }
      return states;
    } else {
      var rs = await HttpHelper.get(STATES_ENDPOINT);
      if (rs.statusCode == 200) {
        var res = jsonDecode(rs.body);
        // print(jsonList.toList());
        for (var element in res["states"]) {
          states.add(States.fromJson(element));
        }
        prefs.setString(fileName, rs.body);
        return states;
      }
    }

    return [];
  }

  Future<List<Type>> getTypes() async {
    // ignore: todo
    // TODO: implement getAll
    String fileName = "typesData";

    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString(fileName) != null);
    if (prefs.getString(fileName) != null &&
        prefs.getString(fileName)!.isNotEmpty) {
      var jsonData = prefs.getString(fileName)!;
      var res = jsonDecode(jsonData);
      for (var element in res["types"]) {
        types.add(Type.fromJson(element));
      }
      return types;
    } else {
      var rs = await HttpHelper.get(TYPES_ENDPOINT);
      if (rs.statusCode == 200) {
        var res = jsonDecode(rs.body);
        for (var element in res["types"]) {
          types.add(Type.fromJson(element));
        }
        prefs.setString(fileName, rs.body);
        return types;
      }
    }

    return [];
  }

  Future<List<ProRes>> getProRes() async {
    // ignore: todo
    // TODO: implement getAll
    String fileName = "propresData";

    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString(fileName) != null &&
        prefs.getString(fileName)!.isNotEmpty) {
      var jsonData = prefs.getString(fileName)!;
      var res = jsonDecode(jsonData);
      for (var element in res["prores"]) {
        prores.add(ProRes.fromJson(element));
      }
      return prores;
    } else {
      var rs = await HttpHelper.get(PRORES_ENDPOINT);
      if (rs.statusCode == 200) {
        var res = jsonDecode(rs.body);
        for (var element in res["prores"]) {
          prores.add(ProRes.fromJson(element));
        }
        prefs.setString(fileName, rs.body);
        return prores;
      }
    }

    return [];
  }

  Future<List<License>> getLicenses() async {
    // ignore: todo
    // TODO: implement getAll
    String fileName = "licensesData";

    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString(fileName) != null &&
        prefs.getString(fileName)!.isNotEmpty) {
      var jsonData = prefs.getString(fileName)!;
      var res = jsonDecode(jsonData);
      for (var element in res["licenses"]) {
        licenses.add(License.fromJson(element));
      }
      return licenses;
    } else {
      var rs = await HttpHelper.get(LICENSE_ENDPOINT);
      if (rs.statusCode == 200) {
        var res = jsonDecode(rs.body);
        for (var element in res["licenses"]) {
          licenses.add(License.fromJson(element));
        }
        prefs.setString(fileName, rs.body);
        return licenses;
      }
    }

    return [];
  }
}
