import 'dart:io';
import 'package:flash_card/models/card_model.dart';
import 'package:flash_card/models/model.dart';
import 'package:flutter/foundation.dart';
import 'package:flash_card/models/folder_model.dart';
import 'package:csv/csv.dart';
import 'package:flash_card/models/repositories/folder_repository.dart';
import 'package:flash_card/models/repositories/card_repository.dart';
import 'package:flash_card/utilities/file_util.dart';
import 'package:flutter/services.dart';
import 'package:flash_card/globals.dart';
import 'package:share_extend/share_extend.dart';

class ShareViewModel extends ChangeNotifier {
  final String _dumpDirName = 'backups';
  final String _folderCsvName = 'folders.csv';
  final String _cardsCsvName = 'cards.csv';
  // final String _quizCsvName = 'quizzes.csv';
  final String _dumpZipName = Globals.backupFileName;
  final String _dumpAesName = Globals.backupCryptFileName;
  final String _key = Globals.encryptionKey;

  final FileUtil fileUtil = FileUtil();

  DateTime? lastBackuptime;

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
    List<List> listlist = const CsvToListConverter().convert(csv);
    listlist = listlist
        .map((e) => e.map((e) => e == 'null' ? null : e).toList())
        .toList();
    return listlist;
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

  Future<void> share({String? folderId}) async {
    // まずdump用のフォルダをクリア
    await deleteDumpFiles();
    try {
      // csv保存用ディレクトリ
      Directory dir = await createDumpDir();
      // _ls(dir.parent);

      // フォルダオブジェクト
      List<FolderModel> folders;
      if (folderId == null) {
        folders = await FolderRepository()
            .getByParentIdRecursively(Globals.rootFolderId);
      } else {
        folders = await FolderRepository().getByIdRecursively(folderId);
      }
      // フォルダがないと押せないのでありえないはず
      if (folders.isEmpty) {
        throw PlatformException(
            code: 'folder-not-foound', message: 'Folder not found');
      }
      // ignore: avoid_print
      // print('created folders');
      await createCsv('${dir.path}/$_folderCsvName', folders);
      // ignore: avoid_print
      // print('created folder csv');
      // カードオブジェクト
      List<CardModel> cards = await CardRepository()
          .getAllByFolderIds(folders.map((e) => e.id).toList());
      await createCsv('${dir.path}/$_cardsCsvName', cards);
      // 圧縮
      File zipFile =
          await fileUtil.zipDir(dir, '${dir.parent.path}/$_dumpZipName');
      // ignore: avoid_print
      // print('ziped folder');
      // ファイルを確認
      // _ls(dir.parent);

      // 暗号化
      File aesFile = await fileUtil.encryptFile(
          key: _key,
          workingDir: dir.path,
          inputFile: zipFile.path,
          outputFile: _dumpAesName);
      // Share
      await ShareExtend.share(aesFile.path, "file");
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

  Future<void> import({String? path}) async {
    // まずdump用のフォルダをクリア
    await deleteDumpFiles();

    final String _path = await fileUtil.localPath;
    // _ls(Directory(_path));
    try {
      // 解凍先ディレクトリ
      Directory dir = await createDumpDir();
      // _ls(dir.parent);

      // 復号化
      File zipFile = await fileUtil.decryptFile(
          key: _key,
          workingDir: dir.path,
          inputFile: path!,
          outputFile: _dumpZipName);

      // 解凍
      await fileUtil.unzipDir(zipFile, dir);
      // _ls(zipFile.parent);

      // フォルダオブジェクト
      List<dynamic> _lsit =
          await readCsv('$_path/$_dumpDirName/$_folderCsvName');
      List<FolderModel> folders =
          _lsit.map((e) => FolderModel.fromList(e)).toList();
      await FolderRepository().import(folders);
      // カードオブジェクト
      _lsit = await readCsv('$_path/$_dumpDirName/$_cardsCsvName');
      List<CardModel> cards = _lsit.map((e) => CardModel.fromList(e)).toList();
      await CardRepository().import(cards);
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

}
