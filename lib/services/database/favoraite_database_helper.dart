import 'package:catalog/helpers/constants.dart';
import 'package:catalog/models/favorite_property_model.dart';
import 'package:catalog/models/pinned_estate.dart';
import 'package:catalog/models/saved_search_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class FavoriteDatabaseHelper {
  FavoriteDatabaseHelper._();

  static final FavoriteDatabaseHelper db = FavoriteDatabaseHelper._();

  static Database? _dbase;

  Future<Database> get dbase async {
    if (_dbase != null) {
      return _dbase!;
    }
    _dbase = await initDb();
    return _dbase!;
  }

  initDb() async {
    String path = join(await getDatabasesPath(), 'FavoriteDB.db');
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(''' 
      CREATE TABLE $tableFavorite (
        $columnAddress TEXT NOT NULL,
        $columnImage TEXT NOT NULL,
        $columnBedRoomNum TEXT NOT NULL,
        $columnBathRoomNum TEXT NOT NULL,
        $columnCategory TEXT NOT NULL,
        $columnArea TEXT NOT NULL,
        $columnLat TEXT NOT NULL,
        $columnLong TEXT NOT NULL,
        $columnReview TEXT NOT NULL,
        $columnPrice TEXT NOT NULL,
        $columnPropertyId TEXT NOT NULL
      )
      ''');

      await db.execute(''' 
      CREATE TABLE $tableSavedSearch (
        $columnSaveId TEXT NOT NULL,
        $columnPropertyId TEXT NOT NULL,
        $columnSearchName TEXT NOT NULL,
        $columnStateId TEXT NOT NULL,
        $columnTypeId TEXT NOT NULL,
        $columnCategoryId TEXT NOT NULL,
        $columnNatureId TEXT NOT NULL,
        $columnPropreId TEXT NOT NULL,
        $columnLicenseId TEXT NOT NULL,
        $columnMinArea TEXT NOT NULL,
        $columnMaxArea TEXT NOT NULL,
        $columnSleepRoomCount TEXT NOT NULL,
        $columnBathRoomCount TEXT NOT NULL,
        $columnFloorHeight TEXT NOT NULL,
        $columnChimney TEXT NOT NULL,
        $columnSwimmingPool TEXT NOT NULL,
        $columnElevator TEXT NOT NULL,
        $columnRocks TEXT NOT NULL,
        $columnStairs TEXT NOT NULL,
        $columnAltEnergy TEXT NOT NULL,
        $columnWaterWell TEXT NOT NULL,
        $columnHangar TEXT NOT NULL,
        $columnMinPrice TEXT NOT NULL,
        $columnMaxPrice TEXT NOT NULL,
        $columnLat1 TEXT NOT NULL,
        $columnLong1 TEXT NOT NULL,
        $columnLat2 TEXT NOT NULL,
        $columnLong2 TEXT NOT NULL,
        $columnInitLat TEXT NOT NULL,
        $columnInitLong TEXT NOT NULL,
        $columnZoom TEXT NOT NULL
      )
      ''');

      await db.execute(''' 
      CREATE TABLE $tablePinned (
        $columnUserId TEXT NOT NULL,
        $columnPinnedPropertyId TEXT NOT NULL,
        $columnAddress TEXT NOT NULL,
        $columnBrokerName TEXT NOT NULL,
        $columnBrokerId TEXT NOT NULL
      )
      ''');
    });
  }

  Future<List<PinnedPropertyModel>> getAllPinnedProperties() async {
    var dbClient = await dbase;
    List<Map> maps = await dbClient.query(tablePinned);

    List<PinnedPropertyModel> list = maps.isNotEmpty
        ? maps.map((e) => PinnedPropertyModel.fromJson(e)).toList()
        : [];
    return list;
  }

  Future<List<FavoritePropertyModel>> getAllProduct() async {
    var dbClient = await dbase;
    List<Map> maps = await dbClient.query(tableFavorite);

    List<FavoritePropertyModel> list = maps.isNotEmpty
        ? maps.map((e) => FavoritePropertyModel.fromJson(e)).toList()
        : [];
    return list;
  }

  Future<List<SavedSearch>> getAllSavedSearch() async {
    var dbClient = await dbase;
    List<Map> maps = await dbClient.query(tableSavedSearch);

    List<SavedSearch> list = maps.isNotEmpty
        ? maps.map((e) => SavedSearch.fromJson(e)).toList()
        : [];
    if (maps.isNotEmpty) {
      // print(maps[1]);
      // print(maps[1]);
    }
    return list;
  }

  Future<SavedSearch> getSavedSearch(String id) async {
    var dbClient = await dbase;
    var savedResult = await dbClient.query(tableSavedSearch,
        where: '$columnSaveId = ?', whereArgs: [id], limit: 1);
    return SavedSearch.fromJson(savedResult);
  }

  insert(FavoritePropertyModel model) async {
    var dbClient = await dbase;
    await dbClient.insert(
      tableFavorite,
      model.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  insertPinnedProperty(PinnedPropertyModel model) async {
    var dbClient = await dbase;
    await dbClient.insert(
      tablePinned,
      model.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  insertSearch(SavedSearch model) async {
    var dbClient = await dbase;
    await dbClient
        .insert(
          tableSavedSearch,
          model.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        )
        .then((value) => print(value));
  }

  Future<int> deleteSearch(String id) async {
    var dbClient = await dbase;
    var did = dbClient
        .delete(tableSavedSearch, where: '$columnSaveId = ?', whereArgs: [id]);
    return did;
  }

  updateProduct(FavoritePropertyModel model) async {
    var dbClient = await dbase;
    return await dbClient.update(tableFavorite, model.toJson(),
        where: '$columnPropertyId = ?', whereArgs: [model.propertyId]);
  }

  deleteProduct(String productId) async {
    Database _db = await dbase;
    _db.delete(
      tableFavorite,
      where: '$columnPropertyId = ?',
      whereArgs: [productId],
    );
  }

  deletePinnedProperty(String productId) async {
    Database _db = await dbase;
    await _db.delete(
      tablePinned,
      where: '$columnPinnedPropertyId = ?',
      whereArgs: [productId],
    );
  }

  deleteAllProducts() async {
    Database _db = await dbase;
    await _db.delete(tableFavorite);
  }
}
