import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matlog/src/features/training_log/presentation/check_in_screen.dart';
import 'package:matlog/src/features/training_log/data/training_repository.dart';
import 'package:matlog/src/features/authentication/data/auth_repository.dart';
import 'package:matlog/src/services/gemini_service.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:matlog/l10n/app_localizations.dart';

import 'package:matlog/src/features/technique_library/domain/technique_extraction_service.dart';
import 'package:matlog/src/features/technique_library/domain/technique.dart';

class MockTrainingRepository extends Mock implements TrainingRepository {
  @override
  Future<void> addActivity(dynamic activity) async {}
  
  @override
  Future<void> addTechnicalLog(String userId, dynamic log) async {}
}

class MockGeminiService extends Mock implements GeminiService {
  @override
  Future<Map<String, dynamic>> processTechnicalNote(String text) async {
    return {
      'summary': 'Test summary',
      'techniques': [],
    };
  }
}

class MockTechniqueExtractionService extends Mock implements TechniqueExtractionService {
  @override
  Future<List<Technique>> processTechnicalLog(dynamic log, dynamic activity) async {
    return [];
  }
}

class MockAuthRepository extends Mock implements AuthRepository {
  @override
  User? get currentUser => MockUser();
}

class MockUser extends Mock implements User {
  @override
  String get uid => 'test_uid';
  
  @override
  String? get displayName => 'Test User';
}

void main() {
  testWidgets('CheckInScreen renders and submits form', (WidgetTester tester) async {
    final mockTrainingRepository = MockTrainingRepository();
    final mockGeminiService = MockGeminiService();
    final mockExtractionService = MockTechniqueExtractionService();
    final mockAuthRepository = MockAuthRepository();

    final router = GoRouter(
      initialLocation: '/check-in',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const Scaffold(body: Text('Home')),
          routes: [
            GoRoute(
              path: 'check-in',
              builder: (context, state) => const CheckInScreen(),
            ),
          ],
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
          trainingRepositoryProvider.overrideWithValue(mockTrainingRepository),
          geminiServiceProvider.overrideWithValue(mockGeminiService),
          techniqueExtractionServiceProvider.overrideWithValue(mockExtractionService),
        ],
        child: MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );

    // Verify fields
    expect(find.text('Check-in'), findsOneWidget);
    // expect(find.text('Type'), findsOneWidget); // Label removed in custom dropdown
    expect(find.text('Gi'), findsOneWidget); // Default value displayed
    expect(find.text('Duration (min)'), findsOneWidget);
    expect(find.text('RPE (Intensity): 5'), findsOneWidget);
    expect(find.text('Training Notes'), findsOneWidget);

    // Enter data
    await tester.enterText(find.byType(TextFormField).at(0), '90'); // Duration
    await tester.enterText(find.byType(TextFormField).at(1), 'Learned armbar'); // Notes

    // Tap Save
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    // Verify success snackbar
    expect(find.text('Training logged successfully!'), findsOneWidget);
  });
}
