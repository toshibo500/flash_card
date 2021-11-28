import 'package:sqflite/sqflite.dart';
import 'package:flash_card/models/providers/db_provider.dart';
import 'package:flash_card/models/test_model.dart';

class TestRepository {
  static DbProvider instance = DbProvider.instance;

  static Future<TestModel?> create(String bookId, DateTime startedAt,
      [DateTime? endedAt,
      int? numberOfQuestions,
      int? numberOfCorrectAnswers]) async {
    final row = TestModel(
        DateTime.now().millisecondsSinceEpoch.toString(),
        bookId,
        startedAt,
        endedAt,
        numberOfQuestions ?? 0,
        numberOfCorrectAnswers ?? 0);
    final db = await instance.database;
    final int res = await db.insert(TestModel.tableName, row.toJson());
    return res > 0 ? row : null;
  }

  static Future<int> update(TestModel row) async {
    final db = await instance.database;
    return await db.update(TestModel.tableName, row.toJson(),
        where: "id = ?", whereArgs: [row.id]);
  }

  static Future<int> delete(String id) async {
    final db = await instance.database;
    return await db
        .rawDelete('DELETE FROM ${TestModel.tableName} WHERE id = ?', [id]);
  }

  static Future<TestModel?> get(String id) async {
    final Database db = await instance.database;
    String where = "WHERE ${TestModel.colId} = '$id'";
    final row =
        await db.rawQuery('SELECT * FROM ${TestModel.tableName} $where');
    if (row.isEmpty) return null;
    return TestModel.fromJson(row);
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
