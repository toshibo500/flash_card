import 'package:flash_card/globals.dart';
import 'package:flash_card/models/folder_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flash_card/views/folder_page.dart';
import 'package:flash_card/viewmodels/folder_viewmodel.dart';
import 'folder_page_test.mocks.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flash_card/models/card_model.dart';

Widget createFolderPage(FolderViewModel model) =>
    ChangeNotifierProvider<FolderViewModel>(
      create: (context) => model,
      child: MaterialApp(
        localizationsDelegates: L10n.localizationsDelegates,
        supportedLocales: L10n.supportedLocales,
        locale: const Locale('en'),
        home: Scaffold(
          body: Builder(builder: (context) {
            Globals().initGlobals(context); // Global変数初期化
            return const FolderPageBody(pageTitle: 'TOEIC600');
          }),
        ),
      ),
    );

@GenerateMocks([FolderViewModel])
void main() {
  Widget? app;
  MockFolderViewModel? model = MockFolderViewModel();

  FolderModel _folder1 = FolderModel('00002', '00001', 'Day1', '', 2,
      DateTime(2021, 12, 28, 13, 00, 00), false);
  FolderModel _folder2 = FolderModel('00003', '00001', 'Day2', '', 3,
      DateTime(2021, 12, 31, 13, 00, 00), false);
  CardModel _card1 = CardModel('00001', '00001', 'hello', 'こんにちわ', 0, 0, 0,
      DateTime.now(), 'en-US', 'jp-JP');
  CardModel _card2 = CardModel('00002', '00001', 'see ya', 'じゃ', 0, 0, 0,
      DateTime.now(), 'en-US', 'jp-JP');

  void setUpPage({bool folderMode = true, bool editMode = false}) {
    when(model.hasCard).thenReturn(!folderMode);
    when(model.hasSubFolders).thenReturn(folderMode);
    when(model.editMode).thenReturn(editMode);

    _folder1.cards = [_card1, _card2];
    _folder2.cards = [_card1];
    List<FolderModel> folderList = [_folder1, _folder2];
    when(model.folderItems).thenReturn(folderList);
    when(model.isEmptyFolder).thenReturn(false);

    app = createFolderPage(model);
  }

  testWidgets('FolderPage initializing', (WidgetTester tester) async {
    // act
    setUpPage();
    await tester.pumpWidget(app!);
    // assert
    expect(find.text('TOEIC600'), findsOneWidget);
    expect(find.text('Day1'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('2021-12-28 13:00'), findsOneWidget);
    expect(find.text('Day2'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
    expect(find.text('2021-12-31 13:00'), findsOneWidget);
    // dump
    debugDumpApp();
  });
  testWidgets('FolderPage edit mode', (WidgetTester tester) async {
    // act
    setUpPage(editMode: true);
    await tester.pumpWidget(app!);
    // assert
    expect(find.text('TOEIC600'), findsOneWidget);
    expect(find.text('Day1'), findsOneWidget);
    expect(find.text('2'), findsNothing);
    expect(find.text('2021-12-28 13:00'), findsNothing);
    expect(find.text('Day2'), findsOneWidget);
    expect(find.text('1'), findsNothing);
    expect(find.text('2021-12-31 13:00'), findsNothing);

    expect(find.byIcon(Icons.done), findsOneWidget);
    expect(find.byIcon(Icons.edit), findsWidgets);
    expect(find.byIcon(Icons.delete), findsWidgets);
    expect(find.byIcon(Icons.drag_handle_rounded), findsWidgets);

    // dump
    debugDumpApp();
  });

  testWidgets('FolderPage add folder', (WidgetTester tester) async {
    // act
    setUpPage(editMode: false);
    await tester.pumpWidget(app!);
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    // assert
    expect(find.text('Folder'), findsOneWidget);
    // act
    await tester.tap(find.text('Folder'));
    await tester.pump();
    // assert
//    expect(find.text('Folder Name'), findsOneWidget);
//    expect(find.text('OK'), findsOneWidget);
//    expect(find.text('Cancel'), findsOneWidget);

    // dump
    debugDumpApp();
  });
}
