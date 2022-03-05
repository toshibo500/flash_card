import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flash_card/models/folder_model.dart';
import 'package:flash_card/models/card_model.dart';
import 'package:flash_card/models/quiz_model.dart';

class DbProvider {
  static const _dbFileName = 'flashcard.db';
  static const _dbCurrentVersion = 3;

  DbProvider._();
  static final DbProvider instance = DbProvider._();

  static Database? _database;

  Future<Database> get database async => _database ??= await _initDb();

  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), _dbFileName);
    return await openDatabase(path,
        version: _dbCurrentVersion,
        onCreate: _createTable,
        onUpgrade: _upgradeTable,
        onOpen: _onOpen);
  }

  Future<void> _onOpen(Database db) async {
    // ignore: avoid_print
    // db.rawQuery("select * from sqlite_master;").then((value) => print(value));
    // db.rawQuery("select * from cards order by sequence desc;").then((value) => print(value));
  }

  Future<void> _createTable(Database db, int version) async {
    await db.execute("CREATE TABLE ${FolderModel.tableName} ("
        "${FolderModel.colId} TEXT PRIMARY KEY,"
        "${FolderModel.colSequence} INTEGER,"
        "${FolderModel.colParentId} TEXT,"
        "${FolderModel.colTitle} TEXT,"
        "${FolderModel.colSummary} TEXT,"
        "${FolderModel.colQuizedAt} TEXT"
        ")");
    await db.execute("CREATE TABLE ${CardModel.tableName} ("
        "${CardModel.colId} TEXT PRIMARY KEY,"
        "${CardModel.colFolderId} TEXT,"
        "${CardModel.colFront} TEXT,"
        "${CardModel.colBack} TEXT,"
        "${CardModel.colSequence} INTEGER,"
        "${CardModel.colCorrectNum} INTEGER DEFAULT 0,"
        "${CardModel.colWrongNum} INTEGER DEFAULT 0,"
        "${CardModel.colQuizedAt} TEXT"
        ")");
    await db.execute("CREATE TABLE ${QuizModel.tableName} ("
        "${QuizModel.colId} TEXT PRIMARY KEY,"
        "${QuizModel.colFolderId} TEXT,"
        "${QuizModel.colQuizNum} INTEGER DEFAULT 0,"
        "${QuizModel.colCorrectNum} INTEGER DEFAULT 0,"
        "${QuizModel.colStartedAt} TEXT,"
        "${QuizModel.colEndedAt} TEXT"
        ")");
    await _upgradeTable(db, 1, version);
    return;
  }

  static const scripts = {
    2: [
      "INSERT INTO ${FolderModel.tableName} ("
          "${FolderModel.colId},"
          "${FolderModel.colSequence},"
          "${FolderModel.colTitle},"
          "${FolderModel.colSummary}"
          ") VALUES("
          "'00000000000000000',"
          "0,"
          "'root',"
          "''"
          ");",
      "INSERT INTO ${FolderModel.tableName} ("
          "${FolderModel.colId},"
          "${FolderModel.colSequence},"
          "${FolderModel.colParentId},"
          "${FolderModel.colTitle},"
          "${FolderModel.colSummary}"
          ") VALUES("
          "'00000000000000001',"
          "0,"
          "'00000000000000000',"
          "'Food',"
          "''"
          ");",
      "INSERT INTO ${CardModel.tableName} ("
          "${CardModel.colId},"
          "${CardModel.colFolderId},"
          "${CardModel.colFront},"
          "${CardModel.colBack},"
          "${CardModel.colSequence}"
          ") VALUES("
          "'00000000000000000',"
          "'00000000000000001',"
          "'Chocolate',"
          "'チョコレート',"
          "0"
          ");",
      "INSERT INTO ${CardModel.tableName} ("
          "${CardModel.colId},"
          "${CardModel.colFolderId},"
          "${CardModel.colFront},"
          "${CardModel.colBack},"
          "${CardModel.colSequence}"
          ") VALUES("
          "'00000000000000001',"
          "'00000000000000001',"
          "'Banana',"
          "'バナナ',"
          "1"
          ");",
      "INSERT INTO ${CardModel.tableName} ("
          "${CardModel.colId},"
          "${CardModel.colFolderId},"
          "${CardModel.colFront},"
          "${CardModel.colBack},"
          "${CardModel.colSequence}"
          ") VALUES("
          "'00000000000000002',"
          "'00000000000000001',"
          "'Mackerel',"
          "'鯖',"
          "2"
          ");",
      "INSERT INTO ${CardModel.tableName} ("
          "${CardModel.colId},"
          "${CardModel.colFolderId},"
          "${CardModel.colFront},"
          "${CardModel.colBack},"
          "${CardModel.colSequence}"
          ") VALUES("
          "'00000000000000003',"
          "'00000000000000001',"
          "'Sardine',"
          "'いわし',"
          "3"
          ");",
      "INSERT INTO ${CardModel.tableName} ("
          "${CardModel.colId},"
          "${CardModel.colFolderId},"
          "${CardModel.colFront},"
          "${CardModel.colBack},"
          "${CardModel.colSequence}"
          ") VALUES("
          "'00000000000000004',"
          "'00000000000000001',"
          "'Clam',"
          "'しじみ',"
          "4"
          ");",
      "INSERT INTO ${CardModel.tableName} ("
          "${CardModel.colId},"
          "${CardModel.colFolderId},"
          "${CardModel.colFront},"
          "${CardModel.colBack},"
          "${CardModel.colSequence}"
          ") VALUES("
          "'00000000000000005',"
          "'00000000000000001',"
          "'Pork',"
          "'豚肉',"
          "5"
          ");",
      "INSERT INTO ${CardModel.tableName} ("
          "${CardModel.colId},"
          "${CardModel.colFolderId},"
          "${CardModel.colFront},"
          "${CardModel.colBack},"
          "${CardModel.colSequence}"
          ") VALUES("
          "'00000000000000006',"
          "'00000000000000001',"
          "'Soy',"
          "'大豆',"
          "6"
          ");",
    ],
    3: [
      "ALTER TABLE ${CardModel.tableName} "
          "ADD ${CardModel.colFrontLang} TEXT;",
      "ALTER TABLE ${CardModel.tableName} "
          "ADD ${CardModel.colBackLang} TEXT;"
    ]
  };

  Future<void> _upgradeTable(
      Database db, int oldVersion, int newVersion) async {
    for (var i = oldVersion + 1; i <= newVersion; i++) {
      List? queries = scripts[i];
      for (String query in queries!) {
        await db.rawQuery(query);
      }
    }
  }
}
