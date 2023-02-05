class SavedSearch {
  late String searchName,
      saveid,
      stateId,
      propertyId,
      typeId,
      categoryId,
      natureId,
      propreId,
      licenseId,
      minarea,
      maxarea,
      bedroomNum,
      bathroomNum,
      floorHeight,
      chimney,
      elevator,
      pool,
      rocks,
      stairs,
      altenergy,
      waterwell,
      hanger,
      minprice,
      maxprice,
      lat1,
      long1,
      lat2,
      long2,
      initlat,
      initlong,
      zoom;
  SavedSearch(
      {required this.searchName,
      required this.saveid,
      required this.stateId,
      required this.propertyId,
      required this.typeId,
      required this.categoryId,
      required this.natureId,
      required this.propreId,
      required this.licenseId,
      required this.minarea,
      required this.maxarea,
      required this.bedroomNum,
      required this.bathroomNum,
      required this.floorHeight,
      required this.chimney,
      required this.elevator,
      required this.pool,
      required this.rocks,
      required this.stairs,
      required this.altenergy,
      required this.waterwell,
      required this.hanger,
      required this.minprice,
      required this.maxprice,
      required this.lat1,
      required this.long1,
      required this.lat2,
      required this.long2,
      required this.initlat,
      required this.initlong,
      required this.zoom});

  SavedSearch.fromJson(dynamic map) {
    if (map == null) {
      return;
    }
    saveid = map['saveid'];
    searchName = map['searchname'];
    stateId = map['stateid'];
    propertyId = map['propertyId'];
    typeId = map['typeid'];
    categoryId = map['categoryid'];
    natureId = map['natureid'];
    propreId = map['propreid'];
    licenseId = map['licenseid'];
    minarea = map['minarea'];
    maxarea = map['maxarea'];
    bedroomNum = map['sleeproomcount'];
    bathroomNum = map['bathroomcount'];
    floorHeight = map['floorHeight'];
    chimney = map['chimney'];
    pool = map['swimmingpool'];
    elevator = map['elevator'];
    rocks = map['rocks'];
    stairs = map['stairs'];
    altenergy = map['altenergy'];
    waterwell = map['waterwell'];
    hanger = map['hanger'];
    minprice = map['minprice'];
    maxprice = map['maxprice'];
    lat1 = map['lat1'];
    long1 = map['long1'];
    lat2 = map['lat2'];
    long2 = map['long2'];
    initlat = map['initlat'];
    initlong = map['initlong'];
    zoom = map['zoom'];
  }

  toJson() {
    return {
      'saveid': saveid,
      'searchname': searchName,
      'stateid': stateId,
      'propertyId': propertyId,
      'typeid': typeId,
      'categoryid': categoryId,
      'natureid': natureId,
      'propreid': propreId,
      'licenseid': licenseId,
      'minarea': minarea,
      'maxarea': maxarea,
      'sleeproomcount': bedroomNum,
      'bathroomcount': bathroomNum,
      'floorHeight': floorHeight,
      'chimney': chimney,
      'swimmingpool': pool,
      'rocks': rocks,
      'elevator': elevator,
      'stairs': stairs,
      'altenergy': altenergy,
      'waterwell': waterwell,
      'hanger': hanger,
      'minprice': minprice,
      'maxprice': maxprice,
      'lat1': lat1,
      'long1': long1,
      'lat2': lat2,
      'long2': long2,
      'initlat': initlat,
      'initlong': initlong,
      'zoom': zoom,
    };
  }
}
