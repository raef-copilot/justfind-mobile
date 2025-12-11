// Basic Flutter widget test for JustFind App

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_storage/get_storage.dart';

import 'package:justfind_app/app/my_app.dart';

void main() {
  setUpAll(() async {
    await GetStorage.init();
  });

  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that app loads
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
