class Broker {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? emailVerifiedAt;
  String? image;
  String? code;
  String? city;
  String? region;
  String? lat;
  String? long;
  String? role;
  String? createdAt;
  String? updatedAt;

  Broker(
      {this.id,
      this.name,
      this.email,
      this.phone,
      this.emailVerifiedAt,
      this.image,
      this.code,
      this.city,
      this.region,
      this.lat,
      this.long,
      this.role,
      this.createdAt,
      this.updatedAt});

  Broker.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    emailVerifiedAt = json['email_verified_at'];
    image = json['image'];
    code = json['code'];
    city = json['city'];
    region = json['region'];
    lat = json['lat'];
    long = json['long'];
    role = json['role'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['email_verified_at'] = emailVerifiedAt;
    data['image'] = image;
    data['code'] = code;
    data['city'] = city;
    data['region'] = region;
    data['lat'] = lat;
    data['long'] = long;
    data['role'] = role;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
