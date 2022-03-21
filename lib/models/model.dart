abstract class Model {
  List<dynamic> toList() => [];
  @override
  String toString() => '';
  factory Model.fromList(List<dynamic> list) {
    throw UnimplementedError();
  }
  Map<String, dynamic> toJson() => {};
}
