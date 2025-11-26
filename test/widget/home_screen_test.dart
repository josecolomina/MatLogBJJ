import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matlog/src/features/dashboard/presentation/home_screen.dart';
import 'package:matlog/src/features/dashboard/presentation/dashboard_controller.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:matlog/src/features/training_log/data/training_repository.dart';
import 'package:matlog/src/features/training_log/domain/activity.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:matlog/l10n/app_localizations.dart';

class MockTrainingRepository extends Mock implements TrainingRepository {
  @override
  Stream<List<Activity>> getActivities() {
    return Stream.value([]);
  }
}

void main() {
  testWidgets('HomeScreen renders correctly with user data', (WidgetTester tester) async {
    final mockFirestore = FakeFirebaseFirestore();
    final mockTrainingRepository = MockTrainingRepository();
    
    // Setup mock user profile
    await mockFirestore.collection('users').doc('test_uid').set({
      'weekly_goal_progress': 2,
      'weekly_goal_target': 4,
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          userProfileProvider.overrideWith((ref) => mockFirestore.collection('users').doc('test_uid').snapshots()),
          trainingRepositoryProvider.overrideWithValue(mockTrainingRepository),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: HomeScreen(),
        ),
      ),
    );

    // Allow stream to emit
    await tester.pump();

    // Verify Title
    expect(find.text('MatLog'), findsOneWidget);
    
    // Weekly Goal card has been replaced with Missions button
    // Missions button is in AppBar, so no specific text to check here

    // Verify Feed Section
    expect(find.text('Recent Activity'), findsOneWidget);
  });
}
