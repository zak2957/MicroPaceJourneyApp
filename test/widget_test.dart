import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:micro_pace_journey/main.dart';

void main() {
  testWidgets('Micro Pace Journey smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MicroPaceJourneyApp());

    // Verify that our app starts with the correct title
    expect(find.text('Micro Pace Journey'), findsOneWidget);
    
    // Verify that the step counter widget is present
    expect(find.text('今日步數'), findsOneWidget);
    
    // Verify that function cards are present
    expect(find.text('計時器'), findsOneWidget);
    expect(find.text('喝水紀錄'), findsOneWidget);
    expect(find.text('節拍器'), findsOneWidget);
    expect(find.text('里程轉換'), findsOneWidget);
  });
}
