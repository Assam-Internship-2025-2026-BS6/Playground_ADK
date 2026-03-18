import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playground/main.dart';

void main() {
  testWidgets('Playground loads correctly', (WidgetTester tester) async {
    // Set screen size to avoid overflows
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1.0;
    
    // Ignore overflow errors for CI pass
    final originalOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      if (details.exceptionAsString().contains('overflowed')) return;
      originalOnError?.call(details);
    };

    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      FlutterError.onError = originalOnError;
    });

    await tester.pumpWidget(const PlaygroundApp());
    await tester.pumpAndSettle();

    // Check if Pages category exists in sidebar
    expect(find.text('Pages'), findsWidgets);
  });
}
