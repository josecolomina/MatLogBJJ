import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matlog/src/features/technique_library/presentation/technique_detail_screen.dart';
import 'package:matlog/src/features/technique_library/presentation/mastery_belt_widget.dart';
import 'package:matlog/src/features/technique_library/domain/technique.dart';
import 'package:matlog/src/features/technique_library/domain/mastery_belt.dart';
import 'package:matlog/src/features/technique_library/data/technique_repository.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:matlog/l10n/app_localizations.dart';

@GenerateNiceMocks([MockSpec<TechniqueRepository>()])
import 'technique_detail_screen_test.mocks.dart';

void main() {
  testWidgets('TechniqueDetailScreen renders without errors', (WidgetTester tester) async {
    final mockRepository = MockTechniqueRepository();
    final technique = Technique(
      id: '1',
      name: 'Armbar',
      position: 'Guard',
      category: 'Submission',
      totalRepetitions: 20,
      masteryBelt: MasteryBelt.blue,
      lastPracticedAt: DateTime.now(),
      notes: 'Initial notes',
    );

    when(mockRepository.getTechnique('1')).thenAnswer((_) async => technique);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          techniqueRepositoryProvider.overrideWithValue(mockRepository),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: TechniqueDetailScreen(techniqueId: '1'),
        ),
      ),
    );

    // Allow async operations to complete
    await tester.pumpAndSettle();

    // Just verify the widget tree was built without errors
    // The actual content may vary depending on providers and state
    expect(find.byType(TechniqueDetailScreen), findsOneWidget);
  });
}
