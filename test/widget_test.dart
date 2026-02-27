import 'package:flutter_test/flutter_test.dart';
import 'package:playground/main.dart';

void main() {
  testWidgets('Playground loads correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const PlaygroundApp());

    // Check if Pages category exists in sidebar
    expect(find.text('Pages'), findsOneWidget);
  });
}
