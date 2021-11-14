import 'package:sqflite/sqflite.dart';
import 'package:flash_card/models/providers/db_provider.dart';
import 'package:flash_card/models/folder_model.dart';

class FolderRepository {
  static DbProvider instance = DbProvider.instance;

  static Future<FolderModel?> create(
      String title, String summary, int sequence) async {
    final row = FolderModel(DateTime.now().millisecondsSinceEpoch.toString(),
        title, summary, sequence);
    final db = await instance.database;
    final int res = await db.insert(FolderModel.tableName, row.toJson());
    return res > 0 ? row : null;
  }

  static Future<int> update(
      String id, String title, String summary, int sequence) async {
    final db = await instance.database;
    return await db.rawUpdate(
        'UPDATE ${FolderModel.tableName} SET '
        '${FolderModel.colTitle} = ?,'
        '${FolderModel.colSummary} = ?,'
        '${FolderModel.colSequence} = ? '
        'WHERE id = ?',
        [title, summary, sequence, id]);
  }

  static Future<int> bulkUpdate(List<FolderModel> rows) async {
    final db = await instance.database;
    int cnt = 0;
    db.transaction((txn) async {
      for (FolderModel row in rows) {
        cnt += await txn.rawUpdate(
            'UPDATE ${FolderModel.tableName} SET '
            '${FolderModel.colTitle} = ?,'
            '${FolderModel.colSummary} = ?,'
            '${FolderModel.colSequence} = ? '
            'WHERE id = ?',
            [row.title, row.summary, row.sequence, row.id]);
      }
    });
    return cnt;
  }

  static Future<int> delete(String id) async {
    final db = await instance.database;
    return await db
        .rawDelete('DELETE FROM ${FolderModel.tableName} WHERE id = ?', [id]);
  }

  static Future<List<FolderModel>> getAll() async {
    final Database db = await instance.database;

    final rows = await db.rawQuery(
        'SELECT * FROM ${FolderModel.tableName} ORDER BY ${FolderModel.colSequence} ASC');
    if (rows.isEmpty) return [];
    return rows.map((json) => FolderModel.fromJson(json)).toList();
  }
}
