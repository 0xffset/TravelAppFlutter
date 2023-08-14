import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DataBaseHelper {
  static Future<Database> database() async {
    final datapath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(datapath, 'travel_app.db'),
        onCreate: (db, version) {
      return db.execute(''
          'CREATE TABLE places (id TEXT PRIMARY KEY,'
          'uid TEXT,'
          'latitude TEXT, longitude TEXT,'
          'title TEXT, description TEXT,'
          'image TEXT, time TEXT)');
    }, version: 1);
  }

  // Insert a new moment into the database
  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DataBaseHelper.database();
    db.insert(table, data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  // Get all moments stored in database
  static Future<List<Map<String, dynamic>>> getData(String table, String uid) async {
    final db = await DataBaseHelper.database();
    return db.query(table, where: 'uid = ?', whereArgs: [uid]);
  }

  // Get by id
  static Future<List<Map<String, dynamic>>> getDataById(String table, String id) async {
    final db = await DataBaseHelper.database();
    return db.query(table, where: 'id = ?', whereArgs: [id]);
  }
  // Remove a moment form database giving their id
  static Future<int> remove_moment(String id) async {
    final db = await DataBaseHelper.database();
    return await db.database
        .delete('places', where: 'id = ?', whereArgs: [id]);
  }

  // Clean all data from database
  static Future<void> clean_database() async {
    final db = await DataBaseHelper.database();
    await db.execute("DELETE FROM places");
  }
}
