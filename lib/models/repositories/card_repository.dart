import 'package:sqflite/sqflite.dart';
import 'package:flash_card/models/providers/db_provider.dart';
import 'package:flash_card/models/card_model.dart';

class CardRepository {
  static DbProvider instance = DbProvider.instance;

  static Future<CardModel?> create(
      String bookId, String front, String back, int sequence,
      [int? numberOfQuestions,
      int? numberOfCorrectAnswers,
      DateTime? testedAt]) async {
    final row = CardModel(
        DateTime.now().millisecondsSinceEpoch.toString(),
        bookId,
        front,
        back,
        sequence,
        numberOfQuestions ?? 0,
        numberOfCorrectAnswers ?? 0,
        testedAt);
    final db = await instance.database;
    final int res = await db.insert(CardModel.tableName, row.toJson());
    return res > 0 ? row : null;
  }

  static Future<int> update(CardModel row) async {
    final db = await instance.database;
    return await db.update(CardModel.tableName, row.toJson(),
        where: "id = ?", whereArgs: [row.id]);
  }

  static Future<int> bulkUpdate(List<CardModel> rows) async {
    final db = await instance.database;
    int cnt = 0;
    db.transaction((txn) async {
      for (CardModel row in rows) {
        cnt += await txn.rawUpdate(
            'UPDATE ${CardModel.tableName} SET '
            '${CardModel.colBookId} = ?,'
            '${CardModel.colFront} = ?,'
            '${CardModel.colBack} = ?,'
            '${CardModel.colSequence} = ? '
            'WHERE id = ?',
            [row.bookId, row.front, row.back, row.sequence, row.id]);
      }
    });
    return cnt;
  }

  static Future<int> delete(String id) async {
    final db = await instance.database;
    return await db
        .rawDelete('DELETE FROM ${CardModel.tableName} WHERE id = ?', [id]);
  }

  static Future<List<CardModel>> getAll([String bookId = '']) async {
    final Database db = await instance.database;
    String where =
        bookId != '' ? "WHERE ${CardModel.colBookId} = '$bookId'" : '';
    final rows = await db.rawQuery(
        'SELECT * FROM ${CardModel.tableName} $where ORDER BY ${CardModel.colSequence} ASC');
    if (rows.isEmpty) return [];
    return rows.map((json) => CardModel.fromJson(json)).toList();
  }

  static Future<List<CardModel>> getListRandom(
      [String bookId = '', int limit = 50]) async {
    final Database db = await instance.database;
    String where =
        bookId != '' ? "WHERE ${CardModel.colBookId} = '$bookId'" : '';
    final rows = await db.rawQuery(
        'SELECT * FROM ${CardModel.tableName} $where ORDER BY RANDOM() LIMIT $limit');
    if (rows.isEmpty) return [];
    return rows.map((json) => CardModel.fromJson(json)).toList();
  }
}
