import 'package:flash_card/models/model.dart';

class CacheModel implements Model {
  static const String tableName = 'cache';
  static const String colKey = 'key';
  static const String colValue = 'value';
  static const String colCreatedAt = 'createdAt';

  final String key;
  final String value;
  late DateTime? createdAt;

  CacheModel(this.key, this.value, [this.createdAt]);

  factory CacheModel.fromJson(dynamic json) {
    return CacheModel(
      json[colKey] as String,
      json[colValue] as String,
      json[colCreatedAt] != null
          ? DateTime.parse(json[colCreatedAt]).toLocal()
          : null,
    );
  }

  @override
  factory CacheModel.fromList(List<dynamic> list) {
    return CacheModel(
      list[0] as String,
      list[1] as String,
      list[2] != '' ? DateTime.parse(list[2]).toLocal() : null,
    );
  }

  @override
  String toString() {
    return '{$key, $value, $createdAt}';
  }

  @override
  List<dynamic> toList() {
    return [
      key,
      value,
      createdAt?.toUtc().toIso8601String() ?? '',
    ];
  }

  @override
  Map<String, dynamic> toJson() => {
        colKey: key,
        colValue: value,
        colCreatedAt: createdAt?.toUtc().toIso8601String(),
      };
}
