import 'package:catalog/models/broker.dart';
import 'package:catalog/models/property_model.dart';
import 'package:catalog/services/broker_service.dart';
import 'package:get/get.dart';

class BrokerController extends GetxController {
  var isLoading = false.obs;
  var isPLoading = false.obs;

  List<Broker> _brokers = [];
  List<Broker> get brokers => _brokers;
  late Broker _broker;
  Broker get broker => _broker;

  var homeCarouselIndicator = 0.obs;

  List<Properties> _properties = [];
  List<Properties> get properties => _properties;

  @override
  void onInit() async {
    // TODO: implement onInit
    super.onInit();

    await getBrokers();
  }

  Future getProperties(String id) async {
    isPLoading.value = true;
    await BrokerService().getProperties(id).then((value) {
      if (value == null) {
        _properties = [];
      } else {
        _properties = value;

        isPLoading.value = false;
        update();
      }
    });
    isPLoading.value = false;
    update();
  }

  Future<void> getBrokerInfo(String id) async {
    await BrokerService().getBrokerwithId(id).then((value) {
      if (value == null) {
      } else {
        _broker = value;
        getProperties(id);
      }
      update();
    });
  }

  Future getBrokers() async {
    isLoading.value = true;
    await BrokerService().getBrokers().then((value) {
      if (value == null) {
        _brokers = [];
      } else {
        _brokers = value;
        _broker = _brokers[0];
        getProperties(_broker.id!.toString());
      }
      isLoading.value = false;
      update();
    });
    isLoading.value = false;
  }

  updateBroker(Broker broker) {
    _broker = broker;
    getProperties(_broker.id!.toString());
    update();
  }
}
