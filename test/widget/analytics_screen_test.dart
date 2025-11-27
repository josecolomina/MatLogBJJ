import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matlog/src/features/analytics/presentation/analytics_screen.dart';
import 'package:matlog/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  testWidgets('AnalyticsScreen renders without errors', (WidgetTester tester) async {
    // Build the widget with proper localizations
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: AnalyticsScreen(),
        ),
      ),
    );

    // Wait for all animations and async operations
    await tester.pumpAndSettle();

    // Verify that the screen renders without errors
    // We don't check for specific charts because they may not render without data
    expect(find.byType(AnalyticsScreen), findsOneWidget);
  });
}
