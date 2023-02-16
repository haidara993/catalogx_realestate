import 'dart:convert';

import 'package:catalog/models/property_model.dart';

import '../helpers/http_helper.dart';
import '../models/broker.dart';

class BrokerService {
  List<Broker> brokers = [];
  late Broker broker;
  List<Properties> properties = [];

  Future<List<Broker>> getBrokers() async {
    // ignore: todo
    // TODO: implement getAll
    var rs = await HttpHelper.get(BROKER_ENDPOINT);
    if (rs.statusCode == 200) {
      var res = jsonDecode(rs.body);

      // print(jsonList.toList());
      for (var element in res["brokers"]["data"]) {
        brokers.add(Broker.fromJson(element));
      }
      return brokers;
    }
    return [];
  }

  Future<Broker?> getBrokerwithId(String id) async {
    var rs = await HttpHelper.get(BROKERWITHID_ENDPOINT + id);

    if (rs.statusCode == 200) {
      var res = jsonDecode(rs.body);

      broker = Broker.fromJson(res["broker"]);

      return broker;
    }
    return null;
  }

  Future<List<Properties>> getProperties(String id) async {
    var rs =
        await HttpHelper.get(BROKERWITHREALESTATE_ENDPOINT + id.toString());
    if (rs.statusCode == 200) {
      final respStr = jsonDecode(rs.body);
      properties = [];
      if (respStr["message"] == false) {
        return properties;
      }
      for (var element in respStr["real_states"]) {
        properties.add(Properties.fromJson(element));
      }
      return properties;
    }
    return [];
  }
}
