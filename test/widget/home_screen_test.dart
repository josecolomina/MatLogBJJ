import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matlog/src/features/dashboard/presentation/home_screen.dart';
import 'package:matlog/src/features/dashboard/presentation/dashboard_controller.dart';
import 'package:matlog/src/features/authentication/data/auth_repository.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:matlog/src/features/training_log/data/training_repository.dart';
import 'package:matlog/src/features/training_log/domain/activity.dart';
import 'package:mockito/mockito.dart';

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
          home: HomeScreen(),
        ),
      ),
    );

    // Allow stream to emit
    await tester.pump();

    // Verify Title
    expect(find.text('MatLog'), findsOneWidget);
    
    // Verify Splash Text (It's random, so we just check for any text in that style or position, 
    // but since we can't easily predict the text, we check if a Column in AppBar contains it)
    // A better way is to check if there is a text widget with italic style below MatLog.
    // For now, let's just check MatLog is there.

    // Verify Weekly Goal
    expect(find.text('Objetivo Semanal'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('/ 4 sesiones'), findsOneWidget);

    // Verify Feed Section
    expect(find.text('Actividad Reciente'), findsOneWidget);
  });
}
