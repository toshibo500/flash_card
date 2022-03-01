import 'package:sqflite/sqflite.dart';
import 'package:flash_card/models/providers/db_provider.dart';
import 'package:flash_card/models/cache_model.dart';

class CacheRepository {
  static DbProvider instance = DbProvider.instance;

  static Future<CacheModel?> create(CacheModel row) async {
    final db = await instance.database;
    row.createdAt = DateTime.now();
    //print(row.toJson());
    final int res = await db.insert(CacheModel.tableName, row.toJson());
    return res > 0 ? row : null;
  }

  static Future<CacheModel?> deleteInsert(CacheModel row) async {
    await delete(row.key);
    return await create(row);
  }

  static Future<int> delete(String key) async {
    final db = await instance.database;
    return await db
        .rawDelete('DELETE FROM ${CacheModel.tableName} WHERE key = ?', [key]);
  }

  static Future<CacheModel?> get(String key, int expireSeconds) async {
    final Database db = await instance.database;
    final rows = await db
        .rawQuery('SELECT * FROM ${CacheModel.tableName} WHERE key = ?', [key]);
    if (rows.isEmpty) return null;
    List<CacheModel> list =
        rows.map((json) => CacheModel.fromJson(json)).toList();

    // 期限切れかどうか
    final DateTime expireDateTime =
        DateTime.now().add(Duration(seconds: expireSeconds) * -1);
    if (list[0].createdAt == null ||
        expireDateTime.isAfter(list[0].createdAt as DateTime)) {
      // 期限切れなので削除
      await delete(key);
      return null;
    }
    return list[0];
  }
}
