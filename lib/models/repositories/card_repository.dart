import 'package:sqflite/sqflite.dart';
import 'package:flash_card/models/providers/db_provider.dart';
import 'package:flash_card/models/card_model.dart';

class CardRepository {
  static DbProvider instance = DbProvider.instance;

  Future<CardModel?> create(
      String folderId, String front, String back, int sequence,
      {int? quizNum,
      int? correctNum,
      DateTime? quizedAt,
      String? frontLang,
      String? backLang}) async {
    final row = CardModel(
        DateTime.now().millisecondsSinceEpoch.toString(),
        folderId,
        front,
        back,
        sequence,
        quizNum ?? 0,
        correctNum ?? 0,
        quizedAt,
        frontLang,
        backLang);
    final db = await instance.database;
    //print(row.toJson());
    final int res = await db.insert(CardModel.tableName, row.toJson());
    return res > 0 ? row : null;
  }

  Future<int> update(CardModel row) async {
    final db = await instance.database;
    return await db.update(CardModel.tableName, row.toJson(),
        where: "id = ?", whereArgs: [row.id]);
  }

  Future<int> bulkUpdate(List<CardModel> rows) async {
    final db = await instance.database;
    int cnt = 0;
    db.transaction((txn) async {
      for (CardModel row in rows) {
        cnt += await txn.rawUpdate(
            'UPDATE ${CardModel.tableName} SET '
            '${CardModel.colFolderId} = ?,'
            '${CardModel.colFront} = ?,'
            '${CardModel.colBack} = ?,'
            '${CardModel.colSequence} = ? '
            'WHERE id = ?',
            [row.folderId, row.front, row.back, row.sequence, row.id]);
      }
    });
    return cnt;
  }

  Future<int> delete(String id) async {
    final db = await instance.database;
    return await db
        .rawDelete('DELETE FROM ${CardModel.tableName} WHERE id = ?', [id]);
  }

  Future<int> deleteByFolderId(String folderId) async {
    final db = await instance.database;
    return await db.rawDelete(
        'DELETE FROM ${CardModel.tableName} WHERE ${CardModel.colFolderId} = ?',
        [folderId]);
  }

  Future<List<CardModel>> getAll([String folderId = '']) async {
    final Database db = await instance.database;
    String where = folderId.isNotEmpty
        ? "WHERE ${CardModel.colFolderId} = '$folderId'"
        : '';
    final rows = await db.rawQuery(
        'SELECT * FROM ${CardModel.tableName} $where ORDER BY ${CardModel.colSequence} ASC');
    if (rows.isEmpty) return [];
    return rows.map((json) => CardModel.fromJson(json)).toList();
  }

  Future<List<CardModel>> getAllByFolderIds(List<String> folderIds) async {
    final Database db = await instance.database;
    final rows = await db.query(CardModel.tableName,
        where: '${CardModel.colFolderId} IN ("${folderIds.join('","')}")');
    if (rows.isEmpty) return [];
    return rows.map((json) => CardModel.fromJson(json)).toList();
  }

  Future<List<CardModel>> getList(
      {String folderId = '',
      String orderBy = 'RANDOM()',
      String orderMethod = 'ASC',
      int limit = 50}) async {
    final Database db = await instance.database;
    String where =
        folderId != '' ? "WHERE ${CardModel.colFolderId} = '$folderId'" : '';

    final rows = await db.rawQuery(
        'SELECT * FROM ${CardModel.tableName} $where ORDER BY $orderBy $orderMethod LIMIT $limit');
    if (rows.isEmpty) return [];
    return rows.map((json) => CardModel.fromJson(json)).toList();
  }

  Future<List<CardModel>> getListRandom(
      [String folderId = '', int limit = 50]) async {
    final Database db = await instance.database;
    String where =
        folderId != '' ? "WHERE ${CardModel.colFolderId} = '$folderId'" : '';
    final rows = await db.rawQuery(
        'SELECT * FROM ${CardModel.tableName} $where ORDER BY RANDOM() LIMIT $limit');
    if (rows.isEmpty) return [];
    return rows.map((json) => CardModel.fromJson(json)).toList();
  }

  Future<int> restore(List<CardModel> rows) async {
    final db = await instance.database;
    int cnt = 0;
    await db.transaction((txn) async {
      await txn.rawDelete('DELETE FROM ${CardModel.tableName}');
      for (CardModel row in rows) {
        cnt += await txn.insert(CardModel.tableName, row.toJson());
      }
    });
    return cnt;
  }

  Future<int> import(List<CardModel> rows) async {
    final db = await instance.database;
    int cnt = 0;
    await db.transaction((txn) async {
      for (CardModel row in rows) {
        await txn.delete(CardModel.tableName,
            where: '${CardModel.colId} = ?', whereArgs: [row.id]);
        cnt += await txn.insert(CardModel.tableName, row.toJson());
      }
    });
    return cnt;
  }
}
