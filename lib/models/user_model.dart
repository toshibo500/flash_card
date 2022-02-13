import 'package:flash_card/utilities/crypt.dart';

enum LoginMethod { email, google }

class UserModel {
  static const String tableName = 'user';
  static const String colId = 'id';
  static const String colDisplayName = 'displayName';
  static const String colEmail = 'email';
  static const String colPassword = 'password';
  static const String colLoginMethod = 'loginMethod';
  static const String colToken = 'token';
  static const String colSignedInAt = 'signedInAt';

  String id;
  String displayName;
  String email;
  String password;
  String token;
  LoginMethod loginMethod;
  late DateTime? signedInAt;

  UserModel({
    this.id = '',
    this.displayName = '',
    this.email = '',
    this.password = '',
    this.token = '',
    this.loginMethod = LoginMethod.email,
    this.signedInAt,
  });
  // localに保存する項目のみjson化する
  factory UserModel.fromJson(dynamic json) {
    return UserModel(
        id: Crypt().decrypt64(json[colId] as String),
        email: Crypt().decrypt64(json[colEmail] as String),
        password: Crypt().decrypt64(json[colPassword] as String),
        displayName: Crypt().decrypt64(json[colDisplayName] as String),
        token: json[colToken] as String,
        loginMethod: LoginMethod.values[json[colLoginMethod] as int],
        signedInAt: json[colSignedInAt] != null
            ? DateTime.parse(json[colSignedInAt]).toLocal()
            : null);
  }
  // localに保存する項目のみ
  @override
  String toString() {
    return '{$id, '
        '$email, '
        '$password, '
        '$displayName, '
        '$token, '
        '${loginMethod.index}, '
        '$signedInAt}';
  }

  // localに保存する項目のみ
  Map<String, dynamic> toJson() => {
        colId: Crypt().encrypt64(id),
        colEmail: Crypt().encrypt64(email),
        colPassword: Crypt().encrypt64(password),
        colDisplayName: Crypt().encrypt64(displayName),
        colToken: token,
        colLoginMethod: loginMethod.index,
        colSignedInAt: signedInAt?.toUtc().toIso8601String(),
      };
}
