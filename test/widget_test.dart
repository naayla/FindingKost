import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tugas_kelompok/main.dart';

void main() {
  testWidgets('App smoke test', (tester) async {
    await tester.pumpWidget(const FindingKostApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
