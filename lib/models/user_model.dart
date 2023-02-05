class UserModel {
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
  String? points;
  String? role;
  String? createdAt;
  String? updatedAt;

  UserModel(
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
      this.points,
      this.role,
      this.createdAt,
      this.updatedAt});

  UserModel.fromJson(Map<String, dynamic> json) {
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
    points = json['points'];
    role = json['role'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['image'] = this.image;
    data['code'] = this.code;
    data['city'] = this.city;
    data['region'] = this.region;
    data['lat'] = this.lat;
    data['long'] = this.long;
    data['points'] = this.points;
    data['role'] = this.role;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
