import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:flutter_wish_lists/src/model/wish_item_model.dart';

class WishItemsDatabase {
  // privateなコンストラクタ
  static final WishItemsDatabase instance = WishItemsDatabase._init();

  static Database? _database;

  WishItemsDatabase._init();

  Future<Database> get database async {
    if (_database != null)
      return _database!;

    // DBがなかったら作成する
    _database = await initDB("WishItemsDB.db");
    return _database!;
  }

  Future<Database> initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createTable);
  }

  Future _createTable(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final wishItemNameType = 'TEXT NOT NULL';
    final moneyType = 'TEXT NOT NULL';

    await db.execute('''
      CREATE TABLE $tableWishItems (
        ${WishItemFields.id} $idType,
        ${WishItemFields.wishItemName} $wishItemNameType,
        ${WishItemFields.money} $moneyType
      )
    ''');
  }

  // CRUD関数
  Future<WishItem> createWishItem(WishItem wishItem) async {
    final db = await instance.database;
    final id = await db.insert(tableWishItems, wishItem.toJson());
    return wishItem.copy(id: id);
  }

  Future<List<WishItem>> getAllWishItems() async {
    final db = await instance.database;
    final result = await db.query(tableWishItems);
    return result.map((json) => WishItem.fromJson(json)).toList();
  }

  Future<WishItem> getWishItem(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableWishItems,
      columns: WishItemFields.values,
      where: '${WishItemFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return WishItem.fromJson(maps.first);
    } else {
      throw Exception('ID $id not fount');
    }
  }

  Future<int> updateWishItem(WishItem wishItem) async {
    final db = await instance.database;

    return db.update(
      tableWishItems,
      wishItem.toJson(),
      where: '${WishItemFields.id} = ?',
      whereArgs: [wishItem.id],
    );
  }

  Future<int> deleteWishItem(int id) async {
    final db = await instance.database;

    return await db.delete(
        tableWishItems,
        where: '${WishItemFields.id} = ?',
        whereArgs: [id]
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}