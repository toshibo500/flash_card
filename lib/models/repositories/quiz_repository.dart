import 'package:sqflite/sqflite.dart';
import 'package:flash_card/models/providers/db_provider.dart';
import 'package:flash_card/models/quiz_model.dart';

class QuizRepository {
  static DbProvider instance = DbProvider.instance;

  Future<QuizModel?> create(String folderId, DateTime startedAt,
      [DateTime? endedAt, int? quizNum, int? correctNum]) async {
    final row = QuizModel(DateTime.now().millisecondsSinceEpoch.toString(),
        folderId, startedAt, endedAt, quizNum ?? 0, correctNum ?? 0);
    final db = await instance.database;
    final int res = await db.insert(QuizModel.tableName, row.toJson());
    return res > 0 ? row : null;
  }

  Future<int> update(QuizModel row) async {
    final db = await instance.database;
    return await db.update(QuizModel.tableName, row.toJson(),
        where: "id = ?", whereArgs: [row.id]);
  }

  Future<int> delete(String id) async {
    final db = await instance.database;
    return await db
        .rawDelete('DELETE FROM ${QuizModel.tableName} WHERE id = ?', [id]);
  }

  Future<int> deleteByFolderId(String folderId) async {
    final db = await instance.database;
    return await db.rawDelete(
        'DELETE FROM ${QuizModel.tableName} WHERE ${QuizModel.colFolderId} = ?',
        [folderId]);
  }

  Future<QuizModel?> get(String id) async {
    final Database db = await instance.database;
    String where = "WHERE ${QuizModel.colId} = '$id'";
    final rows =
        await db.rawQuery('SELECT * FROM ${QuizModel.tableName} $where');
    if (rows.isEmpty) return null;
    List<QuizModel> list =
        rows.map((json) => QuizModel.fromJson(json)).toList();
    return list[0];
  }

  Future<List<QuizModel>> getAll([String folderId = '']) async {
    return await getList(folderId);
  }

  Future<List<QuizModel>> getList(
      [String folderId = '', int rowCount = -1, String orderBy = 'ASC']) async {
    final Database db = await instance.database;
    String where = "WHERE ${QuizModel.colQuizNum} != 0";
    where +=
        folderId != '' ? " AND ${QuizModel.colFolderId} = '$folderId'" : '';

    String limit = rowCount >= 0 ? "LIMIT $rowCount" : '';

    final rows = await db.rawQuery(
        'SELECT * FROM ${QuizModel.tableName} $where ORDER BY ${QuizModel.colStartedAt} $orderBy $limit');
    if (rows.isEmpty) return [];
    return rows.map((json) => QuizModel.fromJson(json)).toList();
  }

  Future<int> restore(List<QuizModel> rows) async {
    final db = await instance.database;
    int cnt = 0;
    await db.transaction((txn) async {
      await txn.rawDelete('DELETE FROM ${QuizModel.tableName}');
      for (QuizModel row in rows) {
        cnt += await txn.insert(QuizModel.tableName, row.toJson());
      }
    });
    return cnt;
  }
}
