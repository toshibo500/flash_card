import 'package:sqflite/sqflite.dart';
import 'package:flash_card/models/providers/db_provider.dart';
import 'package:flash_card/models/quiz_model.dart';

class QuizRepository {
  static DbProvider instance = DbProvider.instance;

  static Future<QuizModel?> create(String bookId, DateTime startedAt,
      [DateTime? endedAt,
      int? numberOfQuestions,
      int? numberOfCorrectAnswers]) async {
    final row = QuizModel(
        DateTime.now().millisecondsSinceEpoch.toString(),
        bookId,
        startedAt,
        endedAt,
        numberOfQuestions ?? 0,
        numberOfCorrectAnswers ?? 0);
    final db = await instance.database;
    final int res = await db.insert(QuizModel.tableName, row.toJson());
    return res > 0 ? row : null;
  }

  static Future<int> update(QuizModel row) async {
    final db = await instance.database;
    return await db.update(QuizModel.tableName, row.toJson(),
        where: "id = ?", whereArgs: [row.id]);
  }

  static Future<int> delete(String id) async {
    final db = await instance.database;
    return await db
        .rawDelete('DELETE FROM ${QuizModel.tableName} WHERE id = ?', [id]);
  }

  static Future<int> deleteByBook(String bookId) async {
    final db = await instance.database;
    return await db.rawDelete(
        'DELETE FROM ${QuizModel.tableName} WHERE ${QuizModel.colBookId} = ?',
        [bookId]);
  }

  static Future<QuizModel?> get(String id) async {
    final Database db = await instance.database;
    String where = "WHERE ${QuizModel.colId} = '$id'";
    final rows =
        await db.rawQuery('SELECT * FROM ${QuizModel.tableName} $where');
    if (rows.isEmpty) return null;
    List<QuizModel> list =
        rows.map((json) => QuizModel.fromJson(json)).toList();
    return list[0];
  }

  static Future<List<QuizModel>> getAll([String bookId = '']) async {
    return await getList(bookId);
  }

  static Future<List<QuizModel>> getList(
      [String bookId = '', int rowCount = -1, String orderBy = 'ASC']) async {
    final Database db = await instance.database;
    String where = "WHERE ${QuizModel.colNumberOfQuestions} != 0";
    where += bookId != '' ? " AND ${QuizModel.colBookId} = '$bookId'" : '';

    String limit = rowCount >= 0 ? "LIMIT $rowCount" : '';

    final rows = await db.rawQuery(
        'SELECT * FROM ${QuizModel.tableName} $where ORDER BY ${QuizModel.colStartedAt} $orderBy $limit');
    if (rows.isEmpty) return [];
    return rows.map((json) => QuizModel.fromJson(json)).toList();
  }
}
