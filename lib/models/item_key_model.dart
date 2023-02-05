// ignore_for_file: non_constant_identifier_names

class Category {
  int? id;
  String? category;

  Category({this.id, this.category});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['category'] = category;
    return data;
  }
}

class States {
  int? id;
  String? states;

  States({this.id, this.states});

  States.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    states = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['state'] = states;
    return data;
  }
}

class Nature {
  int? id;
  String? nature;
  String? type_id;

  Nature({this.id, this.nature, this.type_id});

  Nature.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nature = json['nature'];
    type_id = json['type_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['nature'] = nature;
    data['type_id'] = type_id;
    return data;
  }
}

class Type {
  int? id;
  String? type;

  Type({this.id, this.type});

  Type.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    return data;
  }
}

class ProRes {
  int? id;
  String? type;

  ProRes({this.id, this.type});

  ProRes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    return data;
  }
}

class Direction {
  int? id;
  String? dir;

  Direction({this.id, this.dir});

  Direction.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    dir = json['dir'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['dir'] = dir;
    return data;
  }
}

class License {
  int? id;
  String? type;

  License({this.id, this.type});

  License.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    return data;
  }
}

class Region {
  int? id;
  String? region;

  Region({this.id, this.region});

  Region.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    region = json['region'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['region'] = region;
    return data;
  }
}

class City {
  int? id;
  String? city;

  City({this.id, this.city});

  City.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    city = json['city'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['city'] = city;
    return data;
  }
}
