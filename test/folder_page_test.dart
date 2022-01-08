import 'package:flash_card/models/folder_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flash_card/views/folder_page.dart';
import 'package:flash_card/viewmodels/folder_viewmodel.dart';
import 'folder_page_test.mocks.dart';

@GenerateMocks([FolderViewModel])
class ModelContainer with ChangeNotifier {
  final MockFolderViewModel model;

  ModelContainer({required this.model});

  static Widget builder(BuildContext context, Widget child) {
    return ChangeNotifierProvider<MockFolderViewModel>.value(
      value: context.watch<ModelContainer>().model,
      child: child,
    );
  }
}

@GenerateMocks([FolderViewModel])
void main() {
  MaterialApp? app;
  MockFolderViewModel? model = MockFolderViewModel();

  setUp(() async {
    app = MaterialApp(
      home: ChangeNotifierProvider(
        create: (_) => ModelContainer(model: model),
        child: FolderPage(
          folder: FolderModel('00001', '00000', 'TOEIC600', '', 0),
        ),
      ),
    );
  });

  testWidgets('FolderPage', (WidgetTester tester) async {
    // arrange
    FolderModel folder1 = FolderModel(
        '00001', '00001', 'Food', '', 0, DateTime(2021, 12, 28, 13, 00, 00));
    folder1.cards = [];

    List<FolderModel> folderList = [folder1];

    when(model.folderItems).thenAnswer((_) => folderList);

    // act
    await tester.pumpWidget(app!);

    // assert
    expect(find.text('TOEIC600'), findsOneWidget);
    expect(find.text('Food'), findsOneWidget);

    // dump
    debugDumpApp();
  });
}
