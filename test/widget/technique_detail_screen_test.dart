import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matlog/src/features/technique_library/presentation/technique_detail_screen.dart';
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
  testWidgets('TechniqueDetailScreen displays details and allows editing notes', (WidgetTester tester) async {
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

    // Initial load
    await tester.pump(); // Start future
    await tester.pump(); // Finish future

    expect(find.text('Armbar'), findsOneWidget);
    expect(find.text('BLUE BELT'), findsOneWidget);
    expect(find.text('Initial notes'), findsOneWidget);

    // Tap edit button
    await tester.tap(find.byIcon(Icons.edit));
    await tester.pump();

    // Edit notes
    await tester.enterText(find.byType(TextField), 'Updated notes');
    await tester.pumpAndSettle(const Duration(milliseconds: 600)); // Debounce wait

    // Tap save button
    await tester.tap(find.byIcon(Icons.save));
    await tester.pump();

    verify(mockRepository.updateTechnique(any)).called(1);
  });
}
