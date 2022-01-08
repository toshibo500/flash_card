import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flash_card/models/preference_model.dart';

class PreferenceRepository {
  static Future<bool> update(PreferenceModel row) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var json = jsonEncode(row.toJson());
    return await prefs.setString(PreferenceModel.tableName, json);
  }

  static Future<PreferenceModel> get() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(PreferenceModel.tableName)) {
      // デフォルト値を返す
      return PreferenceModel.fromJson({});
    }
    String? jsonStr = prefs.getString(PreferenceModel.tableName);
    var jsonObj = jsonDecode(jsonStr!);
/*
     List rows =
        jsonObjs.map((jsonObj) => PreferenceModel.fromJson(jsonObj)).toList();
    return rows[0];
 */
    return PreferenceModel.fromJson(jsonObj);
  }
}
