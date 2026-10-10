// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:myapp_files/firebase_options.dart';
import 'package:myapp_files/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  });

  testWidgets('Student form loads correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Student Form'), findsOneWidget);
    expect(find.text('Name'), findsOneWidget);
    expect(find.text('Course'), findsOneWidget);
    expect(find.text('Section'), findsOneWidget);
    expect(find.text('Save to Firebase'), findsOneWidget);
  });
}
