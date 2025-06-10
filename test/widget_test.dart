import 'package:firebase_core/firebase_core.dart';
// ignore: unused_import
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:veyo/app.dart'; // <-- Update to your main widget file

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
  });

  testWidgets('Login button is present', (WidgetTester tester) async {
    await tester.pumpWidget(const NairobiGoApp());
    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('Email and Password fields are present', (WidgetTester tester) async {
    await tester.pumpWidget(const NairobiGoApp());
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.widgetWithText(TextFormField, 'Email'), findsOneWidget);
    expect(find.widgetWithText(TextFormField, 'Password'), findsOneWidget);
  });

  testWidgets('Tapping Login button triggers action', (WidgetTester tester) async {
    await tester.pumpWidget(const NairobiGoApp());
    final loginButton = find.text('Login');
    expect(loginButton, findsOneWidget);
    await tester.tap(loginButton);
    await tester.pump();
    // Optionally, check for a loading indicator, navigation, or error message
  });

  testWidgets('Sign Up button is present', (WidgetTester tester) async {
    await tester.pumpWidget(const NairobiGoApp());
    expect(find.text('Sign Up'), findsOneWidget);
  });
}
