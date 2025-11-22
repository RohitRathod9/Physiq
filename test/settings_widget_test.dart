import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:physiq/screens/settings_screen.dart';
import 'package:physiq/widgets/settings/invite_card.dart';

void main() {
  testWidgets('Settings screen renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: SettingsScreen(),
        ),
      ),
    );

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Personal details'), findsOneWidget);
    expect(find.byType(InviteCard), findsOneWidget);
  });

  testWidgets('Tapping InviteCard opens sheet', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(body: InviteCard()),
        ),
      ),
    );

    await tester.tap(find.byType(InviteCard));
    await tester.pumpAndSettle();

    expect(find.text('Invite Friends'), findsOneWidget);
  });
}
