import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:matlog/src/features/technique_library/presentation/technique_detail_screen.dart';
import 'package:matlog/src/features/technique_library/presentation/technique_library_screen.dart';
import 'package:matlog/src/features/technique_library/data/technique_repository.dart';
import 'package:matlog/src/features/technique_library/domain/technique.dart';
import 'package:matlog/src/features/technique_library/domain/mastery_belt.dart';
import 'package:matlog/src/features/authentication/domain/belt_info.dart';
import 'package:matlog/src/features/profile/data/profile_repository.dart';
import 'package:matlog/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([MockSpec<TechniqueRepository>()])
import 'technique_navigation_test.mocks.dart';

void main() {
  late MockTechniqueRepository mockTechniqueRepository;

  setUp(() {
    mockTechniqueRepository = MockTechniqueRepository();
  });

  testWidgets('Navigation to and from TechniqueDetailScreen works without crash', (WidgetTester tester) async {
    final technique = Technique(
      id: '1',
      name: 'Armbar',
      category: 'Submission',
      position: 'Guard',
      masteryBelt: MasteryBelt.white,
      totalRepetitions: 10,
      notes: 'Keep tight',
      lastPracticedAt: DateTime.now(),
    );

    when(mockTechniqueRepository.getTechnique('1')).thenAnswer((_) async => technique);
    // when(mockTechniqueRepository.getTechniques()).thenAnswer((_) => Stream.value([technique])); // Not needed for detail screen

    when(mockTechniqueRepository.watchTechniques()).thenAnswer((_) => Stream.value([technique]));

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const TechniqueLibraryScreen(),
        ),
        GoRoute(
          path: '/techniques/:id',
          builder: (context, state) => TechniqueDetailScreen(techniqueId: state.pathParameters['id']!),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          techniqueRepositoryProvider.overrideWithValue(mockTechniqueRepository),
          userBeltInfoProvider.overrideWith((ref) => Stream.value(const BeltInfo(color: BeltColor.white, stripes: 0))),
        ],
        child: MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('es')],
        ),
      ),
    );
    
    await tester.pumpAndSettle(); // Allow stream to emit

    // Initial state
    expect(find.byType(TechniqueLibraryScreen), findsOneWidget);
    expect(find.text('Armbar'), findsOneWidget);

    // Navigate to detail
    await tester.tap(find.text('Armbar'));
    await tester.pumpAndSettle();

    expect(find.byType(TechniqueDetailScreen), findsOneWidget);
    expect(find.text('Armbar'), findsOneWidget);

    // Navigate back
    final backButton = find.byType(BackButton);
    if (backButton.evaluate().isNotEmpty) {
       await tester.tap(backButton);
    } else {
       await tester.tap(find.byIcon(Icons.arrow_back));
    }
    
    await tester.pumpAndSettle();

    // Should be back at library
    expect(find.byType(TechniqueLibraryScreen), findsOneWidget);
    expect(find.text('Armbar'), findsOneWidget);
  });
}
