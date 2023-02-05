// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:catalog/helpers/http_helper.dart';

class Properties {
  int? id;
  String? lat;
  String? long;
  String? qrcode;
  String? price;
  String? userId;
  String? stateId;
  String? regionId;
  String? cityId;
  String? propertyId;
  String? categoryId;
  String? periodId;
  String? brokerId;
  String? natureId;
  String? proreId;
  String? licenseId;
  String? typeId;
  String? amount;
  String? area;
  String? totalArea;
  String? sleepRoomCount;
  String? bathRoomCount;
  String? addressTitle;
  List<String>? image;

  Properties(
      {this.id,
      this.lat,
      this.long,
      this.qrcode,
      this.price,
      this.userId,
      this.stateId,
      this.regionId,
      this.cityId,
      this.propertyId,
      this.categoryId,
      this.periodId,
      this.brokerId,
      this.natureId,
      this.proreId,
      this.licenseId,
      this.typeId,
      this.amount,
      this.area,
      this.totalArea,
      this.sleepRoomCount,
      this.bathRoomCount,
      this.image,
      this.addressTitle});

  String getCategoryName(String catId) {
    String cat = "";
    switch (catId) {
      case "1":
        {
          cat = "للبيع";
          break;
        }
      case "2":
        {
          cat = "للأجار";
          break;
        }
      case "3":
        {
          cat = "للاستثمار";
          break;
        }
      case "4":
        {
          cat = "مقاولة";
          break;
        }
    }
    return cat;
  }

  String getNatureName(String catId) {
    String cat = "";
    switch (catId) {
      case "1":
        {
          cat = "شقة";
          break;
        }
      case "2":
        {
          cat = "فيلا";
          break;
        }
      case "3":
        {
          cat = "بناء للبيع";
          break;
        }
      case "4":
        {
          cat = "كراج";
          break;
        }
      case "5":
        {
          cat = "دفتر جمعية";
          break;
        }
      case "6":
        {
          cat = "شاليه";
          break;
        }
      case "7":
        {
          cat = "مكتب/عيادة/شركة";
          break;
        }
      case "8":
        {
          cat = "محل";
          break;
        }
      case "9":
        {
          cat = "مطعم";
          break;
        }
      case "10":
        {
          cat = "مستودع";
          break;
        }
      case "11":
        {
          cat = "مزرعة";
          break;
        }
      case "12":
        {
          cat = "أرض زراعية";
          break;
        }
      case "13":
        {
          cat = "أرض عمارة";
          break;
        }
    }
    return cat;
  }

  Properties.fromJson(dynamic json) {
    print("json[1]");
    print(json[1]);
    id = json[0]['id'];
    lat = json[0]['lat'];
    long = json[0]['long'];
    qrcode = json[0]['qrcode'];
    price = json[0]['price'];
    userId = json[0]['user_id'];
    stateId = json[0]['state_id'];
    regionId = json[0]['region_id'];
    cityId = json[0]['city_id'];
    propertyId = json[0]['property_id'];
    categoryId = json[0]['category_id'];
    periodId = json[0]['period_id'];
    brokerId = json[0]['broker_id'];
    natureId = json[0]['nature_id'];
    proreId = json[0]['prore_id'];
    licenseId = json[0]['license_id'];
    typeId = json[0]['type_id'];
    amount = json[0]['amount'];
    area = json[0]['area'];
    totalArea = json[0]['total_area'];
    sleepRoomCount = json[0]['sleep_room_count'];
    bathRoomCount = json[0]['bath_room_count'];
    addressTitle = json[0]['address_title'];
    image = [];
    for (var element in json[1]) {
      var img = IMAGEDOMAIN +
          element["image"]
              .toString()
              .substring(28, element["image"].toString().length);
      image?.add(img);
    }
  }
}

class PropertyModel {
  List<Rooms>? rooms;
  State? state;
  CategoryModel? category;
  Period? period;
  List<PropertyImage>? image;
  RealEstate? realEstate;

  PropertyModel(
      {this.rooms,
      this.state,
      this.category,
      this.period,
      this.image,
      this.realEstate});

  PropertyModel.fromJson(Map<String, dynamic> json) {
    if (json['rooms'] != null) {
      rooms = <Rooms>[];
      json['rooms'].forEach((v) {
        rooms!.add(Rooms.fromJson(v));
      });
    }
    state = json['state'] != null ? State.fromJson(json['state']) : null;
    category = json['category'] != null
        ? CategoryModel.fromJson(json['category'])
        : null;
    period = json['period'] != null ? Period.fromJson(json['period']) : null;
    if (json['image'] != null) {
      image = <PropertyImage>[];
      json['image'].forEach((v) {
        image!.add(PropertyImage.fromJson(v));
      });
    }
    realEstate = json['real_estate'] != null
        ? RealEstate.fromJson(json['real_estate'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (rooms != null) {
      data['rooms'] = rooms!.map((v) => v.toJson()).toList();
    }
    if (state != null) {
      data['state'] = state!.toJson();
    }
    if (category != null) {
      data['category'] = category!.toJson();
    }
    if (period != null) {
      data['period'] = period!.toJson();
    }
    if (image != null) {
      data['image'] = image!.map((v) => v.toJson()).toList();
    }
    if (realEstate != null) {
      data['real_estate'] = realEstate!.toJson();
    }
    return data;
  }
}

class Rooms {
  int? id;
  String? realEstateId;
  String? type;
  String? length;
  String? width;
  String? floor;
  String? createdAt;
  String? updatedAt;

  Rooms(
      {this.id,
      this.realEstateId,
      this.type,
      this.length,
      this.width,
      this.floor,
      this.createdAt,
      this.updatedAt});

  Rooms.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    realEstateId = json['real_estate_id'];
    type = json['type'];
    length = json['length'];
    width = json['width'];
    floor = json['floor'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['real_estate_id'] = realEstateId;
    data['type'] = type;
    data['length'] = length;
    data['width'] = width;
    data['floor'] = floor;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class State {
  String? state;

  State({this.state});

  State.fromJson(Map<String, dynamic> json) {
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['state'] = state;
    return data;
  }
}

class CategoryModel {
  String? category;

  CategoryModel({this.category});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category'] = category;
    return data;
  }
}

class Period {
  String? name;

  Period({this.name});

  Period.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    return data;
  }
}

class PropertyImage {
  int? id;
  String? realEstateId;
  String? image;
  String? createdAt;
  String? updatedAt;

  PropertyImage(
      {this.id, this.realEstateId, this.image, this.createdAt, this.updatedAt});

  PropertyImage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    realEstateId = json['real_estate_id'];
    image = IMAGEDOMAIN +
        json['image'].toString().substring(28, json['image'].toString().length);
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['real_estate_id'] = realEstateId;
    data['image'] = image;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class RealEstate {
  int? id;
  String? lat;
  String? long;
  String? qrcode;
  String? userId;
  String? stateId;
  String? propertyId;
  String? categoryId;
  String? periodId;
  String? brokerId;
  String? natureId;
  String? proreId;
  String? licenseId;
  String? typeId;
  String? active;
  String? createdAt;
  String? updatedAt;
  String? realEstateType;
  String? rentAmount;
  String? price;
  String? area;
  String? totalArea;
  String? sleepRoomCount;
  String? bathRoomCount;
  String? floorHeight;
  String? direction_id;
  String? moqaulaPerc;
  String? chaletLayoutNumber;
  String? description;
  String? vedioLinks;
  PropertyOptions? options;
  String? addressTitle;

  RealEstate(
      {this.id,
      this.lat,
      this.long,
      this.qrcode,
      this.userId,
      this.stateId,
      this.propertyId,
      this.categoryId,
      this.periodId,
      this.brokerId,
      this.proreId,
      this.natureId,
      this.licenseId,
      this.typeId,
      this.active,
      this.createdAt,
      this.updatedAt,
      this.realEstateType,
      this.rentAmount,
      this.price,
      this.area,
      this.totalArea,
      this.sleepRoomCount,
      this.bathRoomCount,
      this.floorHeight,
      this.direction_id,
      this.moqaulaPerc,
      this.chaletLayoutNumber,
      this.description,
      this.vedioLinks,
      this.options,
      this.addressTitle});

  RealEstate.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    lat = json['lat'];
    long = json['long'];
    qrcode = json['qrcode'];
    userId = json['user_id'];
    stateId = json['state_id'];
    propertyId = json['property_id'];
    categoryId = json['category_id'];
    periodId = json['period_id'];
    brokerId = json['broker_id'];
    proreId = json['prore_id'];
    natureId = json['nature_id'];
    licenseId = json['license_id'];
    typeId = json['type_id'];
    active = json['active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    realEstateType = json['real_estate_type'];
    rentAmount = json['rent_amount'];
    price = json['price'];
    area = json['area'];
    totalArea = json['total_area'];
    sleepRoomCount = json['sleep_room_count'];
    bathRoomCount = json['bath_room_count'];
    floorHeight = json['floor_height'];
    direction_id = json['direction_id'];
    moqaulaPerc = json['moqaula_perc'];
    chaletLayoutNumber = json['chalet_layout_number'];
    description = json['description'];
    vedioLinks = json['vedio_links'];
    options = PropertyOptions.fromJson(
        jsonDecode(json['options'].toString().replaceAll("\\", "")));
    addressTitle = json['address_title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['lat'] = lat;
    data['long'] = long;
    data['qrcode'] = qrcode;
    data['user_id'] = userId;
    data['state_id'] = stateId;
    data['property_id'] = propertyId;
    data['category_id'] = categoryId;
    data['period_id'] = periodId;
    data['broker_id'] = brokerId;
    data['prore_id'] = proreId;
    data['nature_id'] = natureId;
    data['license_id'] = licenseId;
    data['type_id'] = typeId;
    data['active'] = active;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['real_estate_type'] = realEstateType;
    data['rent_amount'] = rentAmount;
    data['price'] = price;
    data['area'] = area;
    data['total_area'] = totalArea;
    data['sleep_room_count'] = sleepRoomCount;
    data['bath_room_count'] = bathRoomCount;
    data['floor_height'] = floorHeight;
    data['direction_id'] = direction_id;
    data['moqaula_perc'] = moqaulaPerc;
    data['chalet_layout_number'] = chaletLayoutNumber;
    data['description'] = description;
    data['vedio_links'] = vedioLinks;
    data['options'] = options;
    data['address_title'] = addressTitle;
    return data;
  }
}

class PropertyOptions {
  String? chimney;
  String? swimmingPool;
  String? elevator;
  String? withRocks;
  String? staircase;
  String? alternativeEnergy;
  String? waterWell;
  String? hangar;
  String? lanes;
  String? workshop;

  PropertyOptions(
      {this.chimney,
      this.swimmingPool,
      this.elevator,
      this.withRocks,
      this.staircase,
      this.alternativeEnergy,
      this.waterWell,
      this.hangar,
      this.lanes,
      this.workshop});

  PropertyOptions.fromJson(Map<String, dynamic> json) {
    chimney = json['chimney'];
    swimmingPool = json['swimming_pool'];
    elevator = json['elevator'];
    withRocks = json['with_rocks'];
    staircase = json['staircase'];
    alternativeEnergy = json['alternative_energy'];
    waterWell = json['Water_well'].toString();
    hangar = json['hangar'].toString();
    lanes = json['lanes'].toString();
    workshop = json['workshop'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['chimney'] = chimney;
    data['swimming_pool'] = swimmingPool;
    data['elevator'] = elevator;
    data['with_rocks'] = withRocks;
    data['staircase'] = staircase;
    data['alternative_energy'] = alternativeEnergy;
    data['Water_well'] = waterWell;
    data['hangar'] = hangar;
    data['lanes'] = lanes;
    data['workshop'] = workshop;
    return data;
  }
}

class FilteredProperty {
  int? id;
  String? lat;
  String? long;
  String? qrcode;
  String? price;
  String? userId;
  String? stateId;
  String? propertyId;
  String? categoryId;
  String? category;
  String? periodId;
  String? brokerId;
  String? natureId;
  String? proreId;
  String? licenseId;
  String? typeId;
  String? directionId;
  String? active;
  String? createdAt;
  String? updatedAt;
  String? realEstateType;
  String? rentAmount;
  String? amount;
  String? area;
  String? totalArea;
  String? sleepRoomCount;
  String? bathRoomCount;
  String? floorHeight;
  String? moqaulaPerc;
  String? chaletLayoutNumber;
  String? description;
  String? vedioLinks;
  List<PropertyImage>? image;
  String? addressTitle;

  FilteredProperty(
      {this.id,
      this.lat,
      this.long,
      this.qrcode,
      this.price,
      this.userId,
      this.stateId,
      this.propertyId,
      this.categoryId,
      this.category,
      this.periodId,
      this.brokerId,
      this.natureId,
      this.proreId,
      this.licenseId,
      this.typeId,
      this.directionId,
      this.active,
      this.createdAt,
      this.updatedAt,
      this.realEstateType,
      this.rentAmount,
      this.amount,
      this.area,
      this.totalArea,
      this.sleepRoomCount,
      this.bathRoomCount,
      this.floorHeight,
      this.moqaulaPerc,
      this.chaletLayoutNumber,
      this.description,
      this.vedioLinks,
      this.image,
      this.addressTitle});

  String getCategoryName(String catId) {
    String cat = "";
    switch (catId) {
      case "1":
        {
          cat = "للبيع";
          break;
        }
      case "2":
        {
          cat = "للأجار";
          break;
        }
      case "3":
        {
          cat = "للاستثمار";
          break;
        }
      case "4":
        {
          cat = "مقاولة";
          break;
        }
    }
    return cat;
  }

  String getNatureName(String catId) {
    String cat = "";
    switch (catId) {
      case "1":
        {
          cat = "شقة";
          break;
        }
      case "2":
        {
          cat = "فيلا";
          break;
        }
      case "3":
        {
          cat = "بناء للبيع";
          break;
        }
      case "4":
        {
          cat = "كراج";
          break;
        }
      case "5":
        {
          cat = "دفتر جمعية";
          break;
        }
      case "6":
        {
          cat = "شاليه";
          break;
        }
      case "7":
        {
          cat = "مكتب/عيادة/شركة";
          break;
        }
      case "8":
        {
          cat = "محل";
          break;
        }
      case "9":
        {
          cat = "مطعم";
          break;
        }
      case "10":
        {
          cat = "مستودع";
          break;
        }
      case "11":
        {
          cat = "مزرعة";
          break;
        }
      case "12":
        {
          cat = "أرض زراعية";
          break;
        }
      case "13":
        {
          cat = "أرض عمارة";
          break;
        }
    }
    return cat;
  }

  FilteredProperty.fromJson(List<dynamic> json) {
    id = json[0]['id'];
    lat = json[0]['lat'];
    long = json[0]['long'];
    qrcode = json[0]['qrcode'];
    price = json[0]['price'];
    userId = json[0]['user_id'];
    stateId = json[0]['state_id'];
    propertyId = json[0]['property_id'];
    category = getCategoryName(json[0]['category_id']);
    categoryId = json[0]['category_id'];
    periodId = json[0]['period_id'];
    brokerId = json[0]['broker_id'];
    natureId = json[0]['nature_id'];
    proreId = json[0]['prore_id'];
    licenseId = json[0]['license_id'];
    typeId = json[0]['type_id'];
    directionId = json[0]['direction_id'];
    active = json[0]['active'];
    createdAt = json[0]['created_at'];
    updatedAt = json[0]['updated_at'];
    realEstateType = json[0]['real_estate_type'];
    rentAmount = json[0]['rent_amount'];
    amount = json[0]['amount'];
    area = json[0]['area'];
    totalArea = json[0]['total_area'];
    sleepRoomCount = json[0]['sleep_room_count'];
    bathRoomCount = json[0]['bath_room_count'];
    floorHeight = json[0]['floor_height'];
    moqaulaPerc = json[0]['moqaula_perc'];
    chaletLayoutNumber = json[0]['chalet_layout_number'];
    description = json[0]['description'];
    vedioLinks = json[0]['vedio_links'];
    addressTitle = json[0]['address_title'];
    image = <PropertyImage>[];
    json[1].forEach((v) {
      image!.add(PropertyImage.fromJson(v));
    });
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['lat'] = lat;
    data['long'] = long;
    data['qrcode'] = qrcode;
    data['price'] = price;
    data['user_id'] = userId;
    data['state_id'] = stateId;
    data['property_id'] = propertyId;
    data['category_id'] = categoryId;
    data['period_id'] = periodId;
    data['broker_id'] = brokerId;
    data['nature_id'] = natureId;
    data['prore_id'] = proreId;
    data['license_id'] = licenseId;
    data['type_id'] = typeId;
    data['direction_id'] = directionId;
    data['active'] = active;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['real_estate_type'] = realEstateType;
    data['rent_amount'] = rentAmount;
    data['amount'] = amount;
    data['area'] = area;
    data['total_area'] = totalArea;
    data['sleep_room_count'] = sleepRoomCount;
    data['bath_room_count'] = bathRoomCount;
    data['floor_height'] = floorHeight;
    data['moqaula_perc'] = moqaulaPerc;
    data['chalet_layout_number'] = chaletLayoutNumber;
    data['description'] = description;
    data['vedio_links'] = vedioLinks;
    data['address_title'] = addressTitle;
    return data;
  }
}
