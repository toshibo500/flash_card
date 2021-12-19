import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flash_card/models/folder_model.dart';
import 'package:flash_card/models/book_model.dart';
import 'package:flash_card/models/card_model.dart';
import 'package:flash_card/models/test_model.dart';

class DbProvider {
  static const _dbFileName = 'flashcard.db';
  static const _dbCurrentVersion = 2;

  DbProvider._();
  static final DbProvider instance = DbProvider._();

  static Database? _database;

  Future<Database> get database async => _database ??= await _initDb();

  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), _dbFileName);
    return await openDatabase(path,
        version: _dbCurrentVersion,
        onCreate: _createTable,
        onUpgrade: _upgradeTable);
  }

  Future<void> _createTable(Database db, int version) async {
    await db.execute("CREATE TABLE ${FolderModel.tableName} ("
        "${FolderModel.colId} TEXT PRIMARY KEY,"
        "${FolderModel.colSequence} INTEGER,"
        "${FolderModel.colTitle} TEXT,"
        "${FolderModel.colSummary} TEXT"
        ")");
    await db.execute("CREATE TABLE ${BookModel.tableName} ("
        "${BookModel.colId} TEXT PRIMARY KEY,"
        "${BookModel.colSequence} INTEGER,"
        "${BookModel.colFolderId} TEXT,"
        "${BookModel.colTitle} TEXT,"
        "${BookModel.colSummary} TEXT"
        ")");
    await db.execute("CREATE TABLE ${CardModel.tableName} ("
        "${CardModel.colId} TEXT PRIMARY KEY,"
        "${CardModel.colBookId} TEXT,"
        "${CardModel.colFront} TEXT,"
        "${CardModel.colBack} TEXT,"
        "${CardModel.colSequence} INTEGER,"
        "${CardModel.colNumberOfCorrectAnswers} INTEGER DEFAULT 0,"
        "${CardModel.colNumberOfWrongAnswers} INTEGER DEFAULT 0,"
        "${CardModel.colTestedAt} TEXT"
        ")");
    _upgradeTable(db, 1, version);
    return;
  }

  static const scripts = {
    2: [
      "CREATE TABLE ${TestModel.tableName} ("
          "${TestModel.colId} TEXT PRIMARY KEY,"
          "${TestModel.colBookId} TEXT,"
          "${TestModel.colNumberOfQuestions} INTEGER DEFAULT 0,"
          "${TestModel.colNumberOfCorrectAnswers} INTEGER DEFAULT 0,"
          "${TestModel.colStartedAt} TEXT,"
          "${TestModel.colEndedAt} TEXT"
          ");",
    ],
  };

  Future<void> _upgradeTable(
      Database db, int oldVersion, int newVersion) async {
    for (var i = oldVersion + 1; i <= newVersion; i++) {
      List? queries = scripts[i];
      for (String query in queries!) {
        await db.execute(query);
      }
    }
  }
}
