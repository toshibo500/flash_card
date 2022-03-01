import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flash_card/globals.dart';
import 'package:flash_card/models/backup_meta_model.dart';
import 'package:flash_card/models/cache_model.dart';
import 'package:flash_card/models/card_model.dart';
import 'package:flash_card/models/model.dart';
import 'package:flash_card/models/quiz_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flash_card/models/folder_model.dart';
import 'package:csv/csv.dart';
import 'package:flash_card/models/repositories/folder_repository.dart';
import 'package:flash_card/models/repositories/card_repository.dart';
import 'package:flash_card/models/repositories/quiz_repository.dart';
import 'package:flash_card/models/repositories/firestore_repository.dart';
import 'package:flash_card/utilities/file_util.dart';
import 'package:flutter/services.dart';
import 'package:flash_card/models/repositories/cache_repository.dart';

class BackupViewModel extends ChangeNotifier {
  final String _dumpDirName = 'backups';
  final String _storeDirName = 'backups';
  final String _folderCsvName = 'folders.csv';
  final String _cardsCsvName = 'cards.csv';
  final String _quizCsvName = 'quizzes.csv';
  final String _dumpZipName = 'dump.zip';
  final FileUtil fileUtil = FileUtil();

  DateTime? lastBackuptime;

  BackupViewModel() {
    lastBackuptime = null;
    _getLastBackupTime().then((value) {
      lastBackuptime = value;
      notifyListeners();
    });
  }

  Future<Directory> createDumpDir() async {
    final String _path = await fileUtil.localPath;
    String _dirPath = '$_path/$_dumpDirName';
    // 既存ならまず一旦削除
    await fileUtil.deleteDir(_dirPath);
    // オブジェクト作成
    Directory localDirectory = Directory(_dirPath);
    // _ls(localDirectory.parent);
    // 新しくディレクトリをつくる
    return await localDirectory.create(recursive: false);
  }

  // CSV作成
  Future<File> createCsv(String path, List<Model> data) async {
    File csvFile = File(path);
    List<List<dynamic>> _lsit = data.map((e) => e.toList()).toList();
    String csv = const ListToCsvConverter().convert(_lsit,
        textDelimiter: '"', textEndDelimiter: '"', delimitAllFields: true);
    await csvFile.writeAsString(csv);
    return csvFile;
  }

  // CSV読み込み
  Future<List<List>> readCsv(String path) async {
    File csvFile = File(path);
    // ファイルを読み込む
    String csv = await csvFile.readAsString();
    // CSV to List
    return const CsvToListConverter().convert(csv);
  }

  // deleteDumpFiles
  Future<void> deleteDumpFiles() async {
    final String _path = await fileUtil.localPath;
    // _ls(Directory(_path));
    // ディレクトリ削除
    await fileUtil.deleteDir('$_path/$_dumpDirName');
    // _ls(Directory(_path));

    // zipファイル削除
    await fileUtil.deleteFile('$_path/$_dumpZipName');
    //_ls(Directory(_path));
  }

  Future<void> backup() async {
    // ログインしてなかったら終了
    String uid = Globals().userInfo?.id ?? '';
    if (uid.isEmpty) {
      return;
    }
    // まずdump用のフォルダをクリア
    await deleteDumpFiles();

    try {
      // csv保存用ディレクトリ
      Directory dir = await createDumpDir();
      // _ls(dir.parent);

      // フォルダオブジェクト
      List<FolderModel> folders = await FolderRepository.getAll();
      // ignore: avoid_print
      // print('created folders');
      await createCsv('${dir.path}/$_folderCsvName', folders);
      // ignore: avoid_print
      // print('created folder csv');
      // カードオブジェクト
      List<CardModel> cards = await CardRepository.getAll();
      await createCsv('${dir.path}/$_cardsCsvName', cards);
      // ignore: avoid_print
      // print('created card csv');
      // クイズオブジェクト
      List<QuizModel> quizzes = await QuizRepository.getAll();
      await createCsv('${dir.path}/$_quizCsvName', quizzes);
      // ignore: avoid_print
      // print('created quiz csv');
      // 圧縮
      File zipFile =
          await fileUtil.zipDir(dir, '${dir.parent.path}/$_dumpZipName');
      // ignore: avoid_print
      // print('ziped folder');
      // アップロード
      await FireStoreRepository()
          .uploadFile(zipFile, '$_storeDirName/$uid/$_dumpZipName');
      // ignore: avoid_print
      // print('uploaded zipfile');

      // meta情報を保存
      await _saveLastBackupTime(DateTime.now());

      // ファイルを確認
      // _ls(dir.parent);
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print(e.message);
      }
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw PlatformException(code: '', message: e.toString());
    }
  }

  Future<void> restore() async {
    // ログインしてなかったら終了
    String uid = Globals().userInfo?.id ?? '';
    if (uid.isEmpty) {
      return;
    }
    // まずdump用のフォルダをクリア
    await deleteDumpFiles();

    final String _path = await fileUtil.localPath;
    // _ls(Directory(_path));
    try {
      // dumpファイルをダウンロード
      final Uint8List? bytes = await FireStoreRepository()
          .downloadFile('$_storeDirName/$uid/$_dumpZipName');
      // 保存
      File zipFile = await fileUtil.saveBytes(bytes!, '$_path/$_dumpZipName');
      // 解凍先ディレクトリ
      Directory dir = await createDumpDir();
      // _ls(dir.parent);
      // 解凍
      await fileUtil.unzipDir(zipFile, dir);
      // _ls(zipFile.parent);
      // フォルダオブジェクト
      List<dynamic> _lsit =
          await readCsv('$_path/$_dumpDirName/$_folderCsvName');
      List<FolderModel> folders =
          _lsit.map((e) => FolderModel.fromList(e)).toList();
      await FolderRepository.restore(folders);
      // カードオブジェクト
      _lsit = await readCsv('$_path/$_dumpDirName/$_cardsCsvName');
      List<CardModel> cards = _lsit.map((e) => CardModel.fromList(e)).toList();
      await CardRepository.restore(cards);
      // クイズオブジェクト
      _lsit = await readCsv('$_path/$_dumpDirName/$_quizCsvName');
      List<QuizModel> quizzes =
          _lsit.map((e) => QuizModel.fromList(e)).toList();
      await QuizRepository.restore(quizzes);
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print(e.message);
      }
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw PlatformException(code: '', message: e.toString());
    }
  }

/*   void _ls(Directory dir) {
    List<FileSystemEntity> files;
    files = dir.listSync(recursive: true, followLinks: false);
    for (var file in files) {
      if (kDebugMode) {
        print(file);
      }
      if (file.path.indexOf('.csv') > 0) {
        // file.delete();
      }
    }
  } */

  Future<DateTime?> _getLastBackupTime() async {
    BackupMetaModel? meta;
    CacheModel? cache;
    String uid = Globals().userInfo?.id ?? '';
    // ログインしてなかったら終了
    if (uid.isEmpty) {
      return null;
    }
    try {
      // キャッシュにあれば返す
      cache = await CacheRepository.get('BackupMeta', 86400);
      if (cache != null) {
        dynamic json = jsonDecode(cache.value);
        meta = BackupMetaModel.fromJson(json);
        return meta.updatedAt;
      }
      // serverから取得
      meta = await FireStoreRepository().getBackupMeta(uid);
      // キャッシュに保存
      cache = CacheModel('BackupMeta', jsonEncode(meta?.toJson()));
      await CacheRepository.deleteInsert(cache);
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print(e.message);
      }
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw PlatformException(code: '', message: e.toString());
    }
    return cache.createdAt;
  }

  Future<void> _saveLastBackupTime(DateTime updatedAt) async {
    BackupMetaModel meta = BackupMetaModel(updatedAt);
    String uid = Globals().userInfo?.id ?? '';
    // ログインしてなかったら終了
    if (uid.isEmpty) {
      return;
    }
    try {
      // serverに保存
      await FireStoreRepository().setBackupMeta(uid, meta);
      // キャッシュに保存
      CacheModel cache = CacheModel('BackupMeta', jsonEncode(meta.toJson()));
      await CacheRepository.deleteInsert(cache);
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print(e.message);
      }
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw PlatformException(code: '', message: e.toString());
    }
  }
}
