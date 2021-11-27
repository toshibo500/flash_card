import 'package:sqflite/sqflite.dart';
import 'package:flash_card/models/providers/db_provider.dart';
import 'package:flash_card/models/test_model.dart';

class TestRepository {
  static DbProvider instance = DbProvider.instance;

  static Future<TestModel?> create(
      String bookId,
      DateTime startedAt,
      DateTime endedAt,
      int numberOfQuestions,
      int numberOfCorrectAnswers) async {
    final row = TestModel(DateTime.now().millisecondsSinceEpoch.toString(),
        bookId, startedAt, endedAt, numberOfQuestions, numberOfCorrectAnswers);
    final db = await instance.database;
    final int res = await db.insert(TestModel.tableName, row.toJson());
    return res > 0 ? row : null;
  }

  static Future<int> update(
      String id,
      String bookId,
      DateTime startedAt,
      DateTime endedAt,
      int numberOfQuestions,
      int numberOfCorrectAnswers) async {
    final db = await instance.database;
    return await db.rawUpdate(
        'UPDATE ${TestModel.tableName} SET '
        '${TestModel.colBookId} = ?,'
        '${TestModel.colStartedAt} = ?,'
        '${TestModel.colEndedAt} = ?,'
        '${TestModel.colNumberOfQuestions} = ?, '
        '${TestModel.colNumberOfCorrectAnswers} = ? '
        'WHERE id = ?',
        [
          bookId,
          startedAt.toUtc().toIso8601String(),
          endedAt.toUtc().toIso8601String(),
          numberOfQuestions,
          numberOfCorrectAnswers
        ]);
  }

  static Future<int> delete(String id) async {
    final db = await instance.database;
    return await db
        .rawDelete('DELETE FROM ${TestModel.tableName} WHERE id = ?', [id]);
  }

  static Future<List<TestModel>> getAll([String bookId = '']) async {
    final Database db = await instance.database;
    String where =
        bookId != '' ? "WHERE ${TestModel.colBookId} = '$bookId'" : '';
    final rows = await db.rawQuery(
        'SELECT * FROM ${TestModel.tableName} $where ORDER BY ${TestModel.colStartedAt} ASC');
    if (rows.isEmpty) return [];
    return rows.map((json) => TestModel.fromJson(json)).toList();
  }
}
