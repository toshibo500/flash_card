import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flash_card/models/folder_model.dart';
import 'package:flash_card/models/book_model.dart';

class DbProvider {
  static const _dbFileName = 'flashcard.db';
  static const _dbCurrentVersion = 1;

  DbProvider._();
  static final DbProvider instance = DbProvider._();

  static Database? _database;

  Future<Database> get database async => _database ??= await _initDb();

  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), _dbFileName);
    return await openDatabase(
      path,
      version: _dbCurrentVersion,
      onCreate: _createTable,
    );
  }

  Future<void> _createTable(Database db, int version) async {
    await db.execute("CREATE TABLE ${FolderModel.tableName} ("
        "${FolderModel.colId} TEXT PRIMARY KEY,"
        "${FolderModel.colTitle} TEXT,"
        "${FolderModel.colSummary} TEXT"
        ")");
    await db.execute("CREATE TABLE ${BookModel.tableName} ("
        "${BookModel.colId} TEXT PRIMARY KEY,"
        "${BookModel.colFolderId} TEXT,"
        "${BookModel.colTitle} TEXT,"
        "${BookModel.colSummary} TEXT"
        ")");
    return;
  }
}
