import 'package:sqflite/sqflite.dart';
import 'package:flash_card/models/providers/db_provider.dart';
import 'package:flash_card/models/book_model.dart';

class BookRepository {
  static DbProvider instance = DbProvider.instance;

  static Future<BookModel?> create(
      String folderId, String title, String summary, int sequence) async {
    final row = BookModel(DateTime.now().millisecondsSinceEpoch.toString(),
        folderId, title, summary, sequence);
    final db = await instance.database;
    final int res = await db.insert(BookModel.tableName, row.toJson());
    return res > 0 ? row : null;
  }

  static Future<int> update(String id, String folderId, String title,
      String summary, int sequence) async {
    final db = await instance.database;
    return await db.rawUpdate(
        'UPDATE ${BookModel.tableName} SET '
        '${BookModel.colFolderId} = ?,'
        '${BookModel.colTitle} = ?,'
        '${BookModel.colSummary} = ?,'
        '${BookModel.colSequence} = ? '
        'WHERE id = ?',
        [folderId, title, summary, sequence, id]);
  }

  static Future<int> updateWithModel(BookModel row) async {
    final db = await instance.database;
    return await db.update(BookModel.tableName, row.toJson(),
        where: "id = ?", whereArgs: [row.id]);
  }

  static Future<int> bulkUpdate(List<BookModel> rows) async {
    final db = await instance.database;
    int cnt = 0;
    db.transaction((txn) async {
      for (BookModel row in rows) {
        cnt += await txn.rawUpdate(
            'UPDATE ${BookModel.tableName} SET '
            '${BookModel.colFolderId} = ?,'
            '${BookModel.colTitle} = ?,'
            '${BookModel.colSummary} = ?,'
            '${BookModel.colSequence} = ? '
            'WHERE id = ?',
            [row.folderId, row.title, row.summary, row.sequence, row.id]);
      }
    });
    return cnt;
  }

  static Future<int> delete(String id) async {
    final db = await instance.database;
    return await db
        .rawDelete('DELETE FROM ${BookModel.tableName} WHERE id = ?', [id]);
  }

  static Future<int> deleteByFolderId(String folderId) async {
    final db = await instance.database;
    return await db.rawDelete(
        'DELETE FROM ${BookModel.tableName} WHERE ${BookModel.colFolderId} = ?',
        [folderId]);
  }

  static Future<BookModel?> get([String id = '']) async {
    final Database db = await instance.database;
    String where = "WHERE ${BookModel.colId} = '$id'";
    final rows =
        await db.rawQuery('SELECT * FROM ${BookModel.tableName} $where');
    if (rows.isEmpty) return null;
    List<BookModel> list =
        rows.map((json) => BookModel.fromJson(json)).toList();
    return list[0];
  }

  static Future<List<BookModel>> getAll([String foldeId = '']) async {
    final Database db = await instance.database;
    String where =
        foldeId != '' ? "WHERE ${BookModel.colFolderId} = '$foldeId'" : '';
    final rows = await db.rawQuery(
        'SELECT * FROM ${BookModel.tableName} $where ORDER BY ${BookModel.colSequence} ASC');
    if (rows.isEmpty) return [];
    return rows.map((json) => BookModel.fromJson(json)).toList();
  }
}
