import 'dart:io';
import 'dart:typed_data';
import 'package:flash_card/models/providers/db_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flash_card/models/backup_meta_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreRepository {
  final FirebaseStorage storage = FirebaseStorage.instance;
  static DbProvider instance = DbProvider.instance;

  // アップロード
  Future<void> uploadFile(File srcFile, String dstPath,
      {String contentType = 'application/zip'}) async {
    // アップロード
    await storage
        .ref(dstPath)
        .putFile(srcFile, SettableMetadata(contentType: contentType));
  }

  // ダウンロード
  Future<Uint8List?> downloadFile(String srcPath) async {
    // ダウンロード
    return await storage.ref(srcPath).getData();
  }

  // getBackupMet
  Future<BackupMetaModel?> getBackupMeta(String uid) async {
    final doc =
        await FirebaseFirestore.instance.collection('backups').doc(uid).get();
    return BackupMetaModel(DateTime.parse(doc['updatedAt']));
  }

  // setBackupMet
  Future<void> setBackupMeta(String uid, BackupMetaModel model) async {
    await FirebaseFirestore.instance
        .collection('backups')
        .doc(uid)
        .set(model.toJson());
  }
}
