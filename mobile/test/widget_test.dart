import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sensepad/features/auth/screens/login.dart';

void main() {
  testWidgets('LoginScreen builds', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    expect(find.byType(Scaffold), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });
}
