import 'dart:convert';

import 'package:catalog/helpers/http_helper.dart';
import 'package:catalog/models/services_model.dart';

class OurServices {
  List<ServiceModel> ourservices = [];

  Future<List<ServiceModel>> getServices() async {
    // ignore: todo
    // TODO: implement getAll
    var rs = await HttpHelper.get(OUR_SERVICES_ENDPOINT);
    if (rs.statusCode == 200) {
      var res = jsonDecode(rs.body);

      // print(jsonList.toList());
      for (var element in res["services"]) {
        ourservices.add(ServiceModel.fromJson(element));
      }
      return ourservices;
    }
    return [];
  }
}
