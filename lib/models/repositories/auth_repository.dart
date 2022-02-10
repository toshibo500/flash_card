import 'package:flash_card/models/auth_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  Future<dynamic> signUp(AuthModel auth) async {
    try {
      // メール/パスワードでユーザー登録
      final User? user = (await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: auth.email, password: auth.password))
          .user;
      auth.id = user!.uid;
      return user;
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

  Future<dynamic> signIn(AuthModel auth) async {
    try {
      // メール/パスワードでユーザー認証
      final User? user = (await FirebaseAuth.instance
              .signInWithEmailAndPassword(
                  email: auth.email, password: auth.password))
          .user;
      auth.id = user!.uid;
      return user;
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
      {required AuthModel auth, required String newPassword}) async {
    // ユーザー認証
    User user = await signIn(auth);
    // パスワード変更
    try {
      await user.updatePassword(newPassword);
      auth.password = newPassword;
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

  Future<dynamic> googleSignIn(AuthModel authModel) async {
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
    authModel.id = user!.uid;
    authModel.email = user.email ?? '';

    return user;
  }
}

class AuthException implements Exception {
  AuthException({this.message, required this.code});

  /// Unique error code
  final String code;

  /// Complete error message.
  dynamic message;
}
