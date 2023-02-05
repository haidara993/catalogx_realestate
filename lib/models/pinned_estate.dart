class PinnedPropertyModel {
  late String userId, propertyId, brokerId, address, brokername;
  PinnedPropertyModel(
      {required this.userId,
      required this.propertyId,
      required this.brokerId,
      required this.brokername,
      required this.address});

  PinnedPropertyModel.fromJson(dynamic map) {
    if (map == null) {
      return;
    }
    userId = map['userId'];
    propertyId = map['propertyId'];
    brokerId = map['brokerId'];
    brokername = map['brokerName'];
    address = map['address'];
  }

  toJson() {
    return {
      'userId': userId,
      'propertyId': propertyId,
      'address': address,
      'brokerName': brokername,
      'brokerId': brokerId,
    };
  }
}
