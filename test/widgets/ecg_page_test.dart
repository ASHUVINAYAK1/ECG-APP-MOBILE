import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../mocks/mock_ecg_page.dart';

void main() {
  testWidgets('MockEcgPage can be instantiated', (WidgetTester tester) async {
    // Build the MockEcgPage widget
    await tester.pumpWidget(const MaterialApp(home: MockEcgPage()));

    // Verify that the widget builds without errors
    expect(find.byType(MockEcgPage), findsOneWidget);

    // Check for expected UI elements
    expect(find.text('ECG Monitor'), findsOneWidget);
    expect(find.text('Using simulated ECG data'), findsOneWidget);
    expect(find.text('Diagnosis:'), findsOneWidget);
    expect(find.text('Normal sinus rhythm'), findsOneWidget);
  });
}
