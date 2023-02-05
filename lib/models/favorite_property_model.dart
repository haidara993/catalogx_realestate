class FavoritePropertyModel {
  late String address,
      image,
      price,
      propertyId,
      bedRoomNum,
      bathRoomNum,
      category,
      review,
      area,
      lat,
      long;
  FavoritePropertyModel(
      {required this.address,
      required this.propertyId,
      required this.image,
      required this.bedRoomNum,
      required this.bathRoomNum,
      required this.category,
      required this.review,
      required this.area,
      required this.lat,
      required this.long,
      required this.price});

  FavoritePropertyModel.fromJson(dynamic map) {
    if (map == null) {
      return;
    }
    address = map['address'];
    propertyId = map['propertyId'];
    image = map['image'];
    bedRoomNum = map['bedRoomNum'];
    bathRoomNum = map['bathRoomNum'];
    category = map['category'];
    review = map['review'];
    area = map['area'];
    lat = map['lat'];
    long = map['long'];
    price = map['price'];
  }

  toJson() {
    return {
      'address': address,
      'propertyId': propertyId,
      'image': image,
      'bedRoomNum': bedRoomNum,
      'bathRoomNum': bathRoomNum,
      'category': category,
      'review': review,
      'area': area,
      'lat': lat,
      'long': long,
      'price': price,
    };
  }
}
