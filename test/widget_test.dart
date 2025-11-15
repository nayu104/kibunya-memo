import 'package:flutter_test/flutter_test.dart';

import 'package:memomemo/core/app.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MemoMemoApp());

    // Verify that the app bar title is shown.
    expect(find.text('気分×色メモ'), findsOneWidget);
  });
}
