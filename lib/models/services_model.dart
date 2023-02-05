class ServiceModel {
  int? id;
  String? name, phone, city, region, type;
  ServiceModel(
      {this.id, this.name, this.phone, this.city, this.region, this.type});

  ServiceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    city = json['city'];
    region = json['region'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['phone'] = phone;
    data['city'] = city;
    data['region'] = region;
    data['type'] = type;
    return data;
  }
}
