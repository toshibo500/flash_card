import 'package:flash_card/models/model.dart';

class BackupMetaModel implements Model {
  static const String colCreatedAt = 'updatedAt';

  DateTime updatedAt;

  BackupMetaModel(this.updatedAt);

  factory BackupMetaModel.fromJson(dynamic json) {
    return BackupMetaModel(DateTime.parse(json[colCreatedAt]).toLocal());
  }

  @override
  factory BackupMetaModel.fromList(List<dynamic> list) {
    return BackupMetaModel(
      DateTime.parse(list[0]).toLocal(),
    );
  }

  @override
  String toString() {
    return '{$updatedAt}';
  }

  @override
  List<dynamic> toList() {
    return [
      updatedAt.toUtc().toIso8601String(),
    ];
  }

  @override
  Map<String, dynamic> toJson() => {
        colCreatedAt: updatedAt.toUtc().toIso8601String(),
      };
}
