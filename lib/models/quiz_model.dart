import 'package:flash_card/models/model.dart';

class QuizModel implements Model {
  static const String tableName = 'quizzes';
  static const String colId = 'id';
  static const String colFolderId = 'folderId';
  static const String colStartedAt = 'startedAt';
  static const String colEndedAt = 'endedAt';
  static const String colQuizNum = 'quizNum';
  static const String colCorrectNum = 'correctNum';

  final String id;
  final String folderId;
  DateTime startedAt;
  DateTime? endedAt;
  late int quizNum;
  late int correctNum;

  QuizModel(this.id, this.folderId, this.startedAt,
      [this.endedAt, this.quizNum = 0, this.correctNum = 0]);

  factory QuizModel.fromJson(dynamic json) {
    return QuizModel(
      json[colId] as String,
      json[colFolderId] as String,
      DateTime.parse(json[colStartedAt]).toLocal(),
      json[colEndedAt] != null
          ? DateTime.parse(json[colEndedAt]).toLocal()
          : null,
      json[colQuizNum] as int,
      json[colCorrectNum] as int,
    );
  }

  @override
  factory QuizModel.fromList(List<dynamic> list) {
    return QuizModel(
        list[0] as String,
        list[1] as String,
        DateTime.parse(list[2] as String).toLocal(),
        list[3] != '' ? DateTime.parse(list[3]).toLocal() : null,
        list[4] != '' ? int.parse(list[4]) : 0,
        list[5] != '' ? int.parse(list[5]) : 0);
  }

  @override
  String toString() {
    return '{$id, $folderId, $colStartedAt, $colEndedAt, $colQuizNum, $colCorrectNum}';
  }

  @override
  List<dynamic> toList() {
    return [
      id,
      folderId,
      startedAt.toUtc().toIso8601String(),
      endedAt?.toUtc().toIso8601String() ?? '',
      quizNum,
      correctNum
    ];
  }

  @override
  Map<String, dynamic> toJson() => {
        colId: id,
        colFolderId: folderId,
        colStartedAt: startedAt.toUtc().toIso8601String(),
        colEndedAt: endedAt?.toUtc().toIso8601String(),
        colQuizNum: quizNum,
        colCorrectNum: correctNum,
      };
}
