import 'package:flash_card/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flash_card/models/providers/db_provider.dart';

class UserRepository {
  static DbProvider instance = DbProvider.instance;

  Future<void> signUp(UserModel userModel) async {
    try {
      // メール/パスワードでユーザー登録
      final User? user = (await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: userModel.email, password: userModel.password))
          .user;
      userModel = await updateUserInfo(userModel, user!);
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print(e.code);
      }
      throw AuthException(code: e.code, message: e.message);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw AuthException(code: 'undefind', message: e.toString());
    }
  }

  Future<void> signIn(UserModel userModel) async {
    try {
      // メール/パスワードでユーザー認証
      final User? user = (await FirebaseAuth.instance
              .signInWithEmailAndPassword(
                  email: userModel.email, password: userModel.password))
          .user;
      userModel = await updateUserInfo(userModel, user!);
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print(e.code);
      }
      throw AuthException(code: e.code, message: e.message);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw AuthException(code: 'undefind', message: e.toString());
    }
  }

  Future<void> updatePassword(
      {required UserModel userModel, required String newPassword}) async {
    // パスワード変更
    try {
      // tokenでログイン
      final User? user =
          (await FirebaseAuth.instance.signInWithCustomToken(userModel.token))
              .user;
      // メール取得
      String email = user!.email ?? '';
      // メール/パスワードでユーザー認証だけする。
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, password: userModel.password);
      // パスワード変更
      await user.updatePassword(newPassword);
      userModel.password = newPassword;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print(e.code);
      }
      throw AuthException(code: e.code, message: e.message);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw AuthException(code: 'undefind', message: e.toString());
    }
  }

  Future<void> restPassword({required String email}) async {
    // パスワードリセット
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print(e.code);
      }
      throw AuthException(code: e.code, message: e.message);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      throw AuthException(code: 'undefind', message: e.toString());
    }
  }

  static final googleLogin = GoogleSignIn(scopes: [
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ]);

  Future<void> googleSignIn(UserModel userModel) async {
    // Google認証
    GoogleSignInAccount? signinAccount = await googleLogin.signIn();
    if (signinAccount == null) {
      throw AuthException(code: 'signinCanceled', message: '');
    }
    GoogleSignInAuthentication auth = await signinAccount.authentication;
    final OAuthCredential credential = GoogleAuthProvider.credential(
      idToken: auth.idToken,
      accessToken: auth.accessToken,
    );
    User? user =
        (await FirebaseAuth.instance.signInWithCredential(credential)).user;
    userModel = await updateUserInfo(userModel, user!);
  }

  Future<UserModel> updateUserInfo(UserModel userModel, User user) async {
    String token = await user.getIdToken();
    userModel.id = user.uid;
    userModel.displayName =
        user.displayName ?? user.email!.substring(0, 3) + "*******";
    userModel.token = token;
    userModel.signedInAt = DateTime.now();
    await delete();
    await create(userModel);
    return userModel;
  }

  Future<void> signOut() async {
    await delete();
  }

  static Future<UserModel?> create(UserModel auth) async {
    final db = await instance.database;
    final int res = await db.insert(UserModel.tableName, auth.toJson());
    return res > 0 ? auth : null;
  }

  static Future<int> delete() async {
    final db = await instance.database;
    return await db.rawDelete('DELETE FROM ${UserModel.tableName}');
  }

  static Future<UserModel?> get() async {
    final db = await instance.database;
    final rows = await db.rawQuery(
        'SELECT * FROM ${UserModel.tableName} ORDER BY ${UserModel.colSignedInAt} DESC');
    if (rows.isEmpty) return null;
    List<UserModel> list =
        rows.map((json) => UserModel.fromJson(json)).toList();
    return list[0];
  }
}

class AuthException implements Exception {
  AuthException({this.message, required this.code});

  /// Unique error code
  final String code;

  /// Complete error message.
  dynamic message;
}
