import 'package:sqflite/sqflite.dart';
import 'package:flash_card/models/providers/db_provider.dart';
import 'package:flash_card/models/folder_model.dart';

class FolderRepository {
  static DbProvider instance = DbProvider.instance;

  static Future<FolderModel?> create(
      String parentId, String title, String summary, int sequence) async {
    final row = FolderModel(DateTime.now().millisecondsSinceEpoch.toString(),
        parentId, title, summary, sequence);
    final db = await instance.database;
    final int res = await db.insert(FolderModel.tableName, row.toJson());
    return res > 0 ? row : null;
  }

  static Future<int> update(String id, String parentId, String title,
      String summary, int sequence) async {
    final db = await instance.database;
    return await db.rawUpdate(
        'UPDATE ${FolderModel.tableName} SET '
        '${FolderModel.colParentId} = ?,'
        '${FolderModel.colTitle} = ?,'
        '${FolderModel.colSummary} = ?,'
        '${FolderModel.colSequence} = ? '
        'WHERE id = ?',
        [parentId, title, summary, sequence, id]);
  }

  static Future<int> updateWithModel(FolderModel row) async {
    final db = await instance.database;
    return await db.update(FolderModel.tableName, row.toJson(),
        where: "id = ?", whereArgs: [row.id]);
  }

  static Future<int> bulkUpdate(List<FolderModel> rows) async {
    final db = await instance.database;
    int cnt = 0;
    db.transaction((txn) async {
      for (FolderModel row in rows) {
        cnt += await txn.rawUpdate(
            'UPDATE ${FolderModel.tableName} SET '
            '${FolderModel.colParentId} = ?,'
            '${FolderModel.colTitle} = ?,'
            '${FolderModel.colSummary} = ?,'
            '${FolderModel.colSequence} = ? '
            'WHERE id = ?',
            [row.parentId, row.title, row.summary, row.sequence, row.id]);
      }
    });
    return cnt;
  }

  static Future<int> delete(String id) async {
    final db = await instance.database;
    return await db
        .rawDelete('DELETE FROM ${FolderModel.tableName} WHERE id = ?', [id]);
  }

  static Future<List<FolderModel>> get(
      {String id = '', String parentId = ''}) async {
    final Database db = await instance.database;
    String where = "WHERE 1=1";
    if (id.isNotEmpty) where += " AND ${FolderModel.colId} = '$id'";
    if (parentId.isNotEmpty) {
      where += " AND ${FolderModel.colParentId} = '$parentId'";
    }
    final rows =
        await db.rawQuery('SELECT * FROM ${FolderModel.tableName} $where');
    if (rows.isEmpty) return [];
    List<FolderModel> list =
        rows.map((json) => FolderModel.fromJson(json)).toList();
    return list;
  }

  static Future<FolderModel?> getById(String id) async {
    List<FolderModel> list = await get(id: id);
    return list.isEmpty ? null : list[0];
  }

  static Future<List<FolderModel>> getByParentId(String parentId) async {
    return await get(parentId: parentId);
  }

  static Future<List<FolderModel>> getByIdRecursively(String id) async {
    List<FolderModel> list = await get(id: id);
    if (list.isEmpty) {
      return [];
    }
    List<FolderModel> children = await getByParentIdRecursively(list[0].id);
    if (children.isNotEmpty) {
      list += children;
    }
    return list;
  }

  static Future<List<FolderModel>> getByParentIdRecursively(
      String parentId) async {
    List<FolderModel> children = await get(parentId: parentId);
    List<FolderModel> grandchildren;
    for (var child in children) {
      grandchildren = await get(parentId: child.id);
      if (grandchildren.isNotEmpty) {
        children += grandchildren;
      }
    }
    return children;
  }

  static Future<List<FolderModel>> getAll() async {
    return await get();
  }

  static Future<int> restore(List<FolderModel> rows) async {
    final db = await instance.database;
    int cnt = 0;
    await db.transaction((txn) async {
      await txn.rawDelete('DELETE FROM ${FolderModel.tableName}');
      for (FolderModel row in rows) {
        cnt += await txn.insert(FolderModel.tableName, row.toJson());
      }
    });
    return cnt;
  }

  static Future<int> import(List<FolderModel> rows) async {
    final db = await instance.database;
    int cnt = 0;
    await db.transaction((txn) async {
      for (FolderModel row in rows) {
        await txn.delete(FolderModel.tableName,
            where: '${FolderModel.colId} = ?', whereArgs: [row.id]);
        cnt += await txn.insert(FolderModel.tableName, row.toJson());
      }
    });
    return cnt;
  }
}
