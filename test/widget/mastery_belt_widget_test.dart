import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matlog/src/features/technique_library/presentation/mastery_belt_widget.dart';
import 'package:matlog/src/features/technique_library/domain/mastery_belt.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:matlog/l10n/app_localizations.dart';

void main() {
  testWidgets('MasteryBeltWidget renders correctly inside Row with MainAxisSize.min', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('es')],
        home: Scaffold(
          body: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                MasteryBeltWidget(belt: MasteryBelt.blue),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.byType(MasteryBeltWidget), findsOneWidget);
    expect(find.text('CINTURÓN AZUL'), findsOneWidget);
  });

  testWidgets('MasteryBeltWidget expands width when expandWidth is true', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('es')],
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 200,
              child: Row(
                children: const [
                  Expanded(child: MasteryBeltWidget(belt: MasteryBelt.black, expandWidth: true, showLabel: false)),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(Spacer), findsOneWidget);
    // Verify it takes full width (minus margins/padding if any, but here we check Spacer presence)
  });
}
