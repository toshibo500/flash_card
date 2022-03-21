import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_archive/flutter_archive.dart' as fa;
import 'package:path_provider/path_provider.dart';
import 'package:file_cryptor/file_cryptor.dart';

class FileUtil {
  Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // ディレクトリを圧縮
  Future<File> zipDir(Directory srcDir, String dstPath) async {
    // 圧縮ファイルが既存ならまず削除
    await deleteFile(dstPath);
    // 圧縮ファイルを作成
    final zipFile = File(dstPath);
    // 圧縮する
    await fa.ZipFile.createFromDirectory(
        sourceDir: srcDir, zipFile: zipFile, recurseSubDirs: true);
    return zipFile;
  }

  // ZIPを解凍
  Future<void> unzipDir(File srcFile, Directory dstDir) async {
    // 既存なら一旦削除して
    // await deleteDir(dstDir.path);
    // 解凍
    await fa.ZipFile.extractToDirectory(
        zipFile: srcFile, destinationDir: dstDir);
  }

  // bytesデータを保存
  Future<File> saveBytes(Uint8List bytes, String dstPath) async {
    // すでにファイルがあったら一旦削除
    await deleteFile(dstPath);
    // 保存
    File zipFile = File(dstPath);
    // 保存
    zipFile.writeAsBytes(bytes);
    return zipFile;
  }

  // ファイル削除
  Future<void> deleteFile(String path) async {
    // オブジェクト作成
    File file = File(path);
    // ファイルがあったら一旦削除
    if (await file.exists()) await file.delete();
  }

  // ディレクトリ削除
  Future<void> deleteDir(String path) async {
    // オブジェクト作成
    Directory dir = Directory(path);
    // ファイルがあったら一旦削除
    if (await dir.exists()) await dir.delete(recursive: true);
  }

  // ファイルを暗号化
  Future<File> encryptFile(
      {required String key,
      required String workingDir,
      required String inputFile,
      required String outputFile}) async {
    FileCryptor fileCryptor = FileCryptor(
      key: key,
      iv: 16,
      dir: workingDir,
    );
    return await fileCryptor.encrypt(
        inputFile: inputFile, outputFile: outputFile);
  }

  // ファイルを復号化
  Future<File> decryptFile(
      {required String key,
      required String workingDir,
      required String inputFile,
      required String outputFile}) async {
    FileCryptor fileCryptor = FileCryptor(
      key: key,
      iv: 16,
      dir: workingDir,
    );
    try {
      return await fileCryptor.decrypt(
          inputFile: inputFile, outputFile: outputFile);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw PlatformException(code: 'wrong-file', message: e.toString());
    }
  }
}
