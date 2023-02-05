import 'package:catalog/controllers/auth_viewmodel.dart';
import 'package:catalog/controllers/broker_controller.dart';
import 'package:catalog/controllers/control_viewmodel.dart';
import 'package:catalog/controllers/favorite_view_model.dart';
import 'package:catalog/controllers/home_info_controller.dart';
import 'package:catalog/controllers/network_controller.dart';
import 'package:catalog/controllers/property_controller.dart';
import 'package:catalog/controllers/saved_search_viewmodel.dart';
import 'package:catalog/controllers/search_viewmodel.dart';
import 'package:get/get.dart';

class Binding extends Bindings {
  @override
  void dependencies() {
    // ignore: todo
    // TODO: implement dependencies
    Get.lazyPut(() => AuthViewModel());
    Get.lazyPut(() => ControlViewModel());
    Get.lazyPut(() => SearchViewModel());
    Get.lazyPut(() => FavoriteViewModel());
    Get.lazyPut(() => SavedSearchViewModel());
    Get.lazyPut(() => PropertyController());
    Get.lazyPut(() => NetworkController());
    Get.lazyPut(() => HomeInfoController());
    Get.lazyPut(() => BrokerController());
  }
}
