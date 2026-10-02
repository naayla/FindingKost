import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tugas_kelompok/main.dart';

void main() {
  testWidgets('dark mode can be toggled from login', (tester) async {
    await tester.pumpWidget(const FindingKostApp());

    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.light,
    );

    await tester.tap(find.byTooltip('Ganti tema'));
    await tester.pumpAndSettle();

    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.dark,
    );
  });

  testWidgets('chatbot answers and complaint form validates and submits', (
    tester,
  ) async {
    await tester.pumpWidget(const FindingKostApp());
    await tester.tap(find.textContaining('Masuk').first);
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Chat dengan asisten'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('chat-input')),
      'Berapa harga kos?',
    );
    await tester.tap(find.byKey(const Key('chat-send')));
    await tester.pumpAndSettle();
    expect(find.textContaining('Rp'), findsWidgets);

    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Buat pengaduan'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('report-submit')));
    await tester.pumpAndSettle();
    expect(find.textContaining('minimal 8 karakter'), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('report-description')),
      'Lampu kamar tidak menyala',
    );
    await tester.tap(find.byKey(const Key('report-submit')));
    await tester.pumpAndSettle();
    expect(find.textContaining('Riwayat Pengaduan'), findsOneWidget);
  });

  testWidgets('bottom navigation opens favorites and editable profile', (
    tester,
  ) async {
    await tester.pumpWidget(const FindingKostApp());
    await tester.tap(find.textContaining('Masuk').first);
    await tester.pumpAndSettle();

    expect(find.byType(NavigationBar), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('nav-seeker-profil')));
    await tester.pumpAndSettle();
    expect(find.text('Nayla Syifa Tanjung'), findsOneWidget);

    await tester.tap(find.text('Edit Profil'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).first, 'Nayla Syifa');
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();
    expect(find.text('Nayla Syifa'), findsOneWidget);
  });
}
