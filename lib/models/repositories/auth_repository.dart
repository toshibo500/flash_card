import 'package:flash_card/models/auth_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthRepository {
  Future<void> signUp(AuthModel auth) async {
    try {
      // メール/パスワードでユーザー登録
      final User? user = (await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: auth.email, password: auth.password))
          .user;
      auth.id = user!.uid;
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
}

class AuthException implements Exception {
  AuthException({this.message, required this.code});

  /// Unique error code
  final String code;

  /// Complete error message.
  dynamic message;
}
