import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matlog/src/features/technique_library/presentation/technique_library_screen.dart';
import 'package:matlog/src/features/technique_library/domain/technique.dart';
import 'package:matlog/src/features/technique_library/domain/mastery_belt.dart';
import 'package:matlog/src/features/technique_library/data/technique_repository.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:matlog/l10n/app_localizations.dart';

@GenerateNiceMocks([MockSpec<TechniqueRepository>()])
import 'technique_library_screen_test.mocks.dart';

void main() {
  testWidgets('TechniqueLibraryScreen displays techniques', (WidgetTester tester) async {
    final mockRepository = MockTechniqueRepository();
    
    final techniques = [
      Technique(
        id: '1',
        name: 'Armbar',
        position: 'Guard',
        category: 'Submission',
        totalRepetitions: 20,
        masteryBelt: MasteryBelt.blue,
        lastPracticedAt: DateTime.now(),
      ),
      Technique(
        id: '2',
        name: 'Kimura',
        position: 'Side Control',
        category: 'Submission',
        totalRepetitions: 5,
        masteryBelt: MasteryBelt.white,
        lastPracticedAt: DateTime.now(),
      ),
    ];

    when(mockRepository.watchTechniques()).thenAnswer((_) => Stream.value(techniques));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          techniqueRepositoryProvider.overrideWithValue(mockRepository),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: TechniqueLibraryScreen(),
        ),
      ),
    );

    await tester.pump(); // Allow stream to emit

    expect(find.text('Armbar'), findsOneWidget);
    expect(find.text('Kimura'), findsOneWidget);
    expect(find.text('Guard • Submission'), findsOneWidget);
    expect(find.text('20 Repetitions'), findsOneWidget);
    expect(find.text('5 Repetitions'), findsOneWidget);
  });

  testWidgets('TechniqueLibraryScreen displays empty state', (WidgetTester tester) async {
    final mockRepository = MockTechniqueRepository();
    when(mockRepository.watchTechniques()).thenAnswer((_) => Stream.value([]));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          techniqueRepositoryProvider.overrideWithValue(mockRepository),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: TechniqueLibraryScreen(),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('No techniques learned yet.'), findsOneWidget);
  });
}
