// Ignore for testing purposes
// ignore_for_file: prefer_const_constructors

import 'package:flutter_test/flutter_test.dart';
import 'package:local_db_chat_app/app/app.dart';
import 'package:local_db_chat_app/chat/chat.dart';

void main() {
  group('App', () {
    testWidgets('renders ChatPage', (tester) async {
      await tester.pumpWidget(App());
      expect(find.byType(ChatPage), findsOneWidget);
    });
  });
}
