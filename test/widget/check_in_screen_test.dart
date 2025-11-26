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

class MockTrainingRepository extends Mock implements TrainingRepository {
  @override
  Future<void> addActivity(dynamic activity) async {}
  
  @override
  Future<void> addTechnicalLog(String userId, dynamic log) async {}
}

class MockGeminiService extends Mock implements GeminiService {}

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
        ],
        child: MaterialApp.router(
          routerConfig: router,
        ),
      ),
    );

    // Verify fields
    expect(find.text('Check-in'), findsOneWidget);
    expect(find.text('Type'), findsOneWidget);
    expect(find.text('Duration (minutes)'), findsOneWidget);
    expect(find.text('RPE (Intensity): 5'), findsOneWidget);
    expect(find.text('What did you learn today?'), findsOneWidget);

    // Enter data
    await tester.enterText(find.byType(TextFormField).at(0), '90'); // Duration
    await tester.enterText(find.byType(TextFormField).at(1), 'Learned armbar'); // Notes

    // Tap Save
    await tester.tap(find.text('Save Training'));
    await tester.pumpAndSettle();

    // Verify success snackbar
    expect(find.text('Training logged successfully!'), findsOneWidget);
  });
}
