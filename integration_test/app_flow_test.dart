import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matlog/main.dart' as app;
import 'package:matlog/src/features/authentication/data/auth_repository.dart';
import 'package:matlog/src/features/training_log/data/training_repository.dart';
import 'package:matlog/src/services/gemini_service.dart';
import 'package:mockito/mockito.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Mocks
class MockTrainingRepository extends Mock implements TrainingRepository {
  @override
  Future<void> addActivity(dynamic activity) async {}
  
  @override
  Future<void> addTechnicalLog(String userId, dynamic log) async {}
}

class MockGeminiService extends Mock implements GeminiService {}

class MockAuthRepository extends Mock implements AuthRepository {
  final User _user;
  MockAuthRepository(this._user);

  @override
  User? get currentUser => _user;
}

class MockUser extends Mock implements User {
  @override
  String get uid => 'test_uid';
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Full App Flow: Login -> Check-in -> Save', (WidgetTester tester) async {
    // Setup Mocks
    final mockUser = MockUser();
    final mockFirestore = FakeFirebaseFirestore();
    final mockTrainingRepository = MockTrainingRepository();
    final mockGeminiService = MockGeminiService();
    final mockAuthRepository = MockAuthRepository(mockUser);

    // Setup User Profile in Firestore
    await mockFirestore.collection('users').doc('test_uid').set({
      'weekly_goal_progress': 0,
      'weekly_goal_target': 3,
    });

    // Run App with Overrides
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
          trainingRepositoryProvider.overrideWithValue(mockTrainingRepository),
          geminiServiceProvider.overrideWithValue(mockGeminiService),
          // We need to override the main app's provider scope, but main() creates its own.
          // So we should probably just pump the App widget directly here instead of calling app.main()
          // or modify main to accept overrides (which is cleaner but requires code change).
          // For this test, let's reconstruct the app structure.
        ],
        child: const app.MatLogApp(), 
      ),
    );

    await tester.pumpAndSettle();

    // 1. Verify Home Screen (since we started signed in)
    expect(find.text('MatLog'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);

    // 2. Navigate to Check-in
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // 3. Verify Check-in Screen
    expect(find.text('Check-in'), findsOneWidget);

    // 4. Fill Form
    await tester.enterText(find.byType(TextFormField).at(0), '60'); // Duration
    await tester.enterText(find.byType(TextFormField).at(1), 'Integration Test Notes'); // Notes
    await tester.tap(find.text('Save Training'));
    await tester.pumpAndSettle();

    // 5. Verify Return to Home and Success Message
    expect(find.text('MatLog'), findsOneWidget);
    expect(find.text('Training logged successfully!'), findsOneWidget);
  });
}
