import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:matlog/src/features/training_log/data/training_repository.dart';
import 'package:matlog/src/features/training_log/domain/activity.dart';

void main() {
  group('TrainingRepository', () {
    late FakeFirebaseFirestore mockFirestore;
    late TrainingRepository trainingRepository;

    setUp(() async {
      mockFirestore = FakeFirebaseFirestore();
      trainingRepository = TrainingRepository(mockFirestore);
      // Create user document for update calls
      await mockFirestore.collection('users').doc('user_123').set({
        'weekly_goal_progress': 0,
        'weekly_goal_target': 4,
      });
    });

    test('addActivity adds document to firestore', () async {
      // Arrange
      final activity = Activity(
        activityId: 'test_activity_id',
        userId: 'user_123',
        userName: 'Test User',
        userRank: 'white',
        academyName: 'Test Academy',
        timestampStart: DateTime.now(),
        durationMinutes: 60,
        type: 'gi',
        rpe: 5,
        likesCount: 0,
        hasTechnicalNotes: false,
      );

      // Act
      await trainingRepository.addActivity(activity);

      // Assert
      final doc = await mockFirestore.collection('activities').doc('test_activity_id').get();
      expect(doc.exists, true);
      expect(doc.data()!['userId'], 'user_123');
      expect(doc.data()!['type'], 'gi');
    });

    test('getActivities returns stream of activities', () async {
      // Arrange
      final activity = Activity(
        activityId: 'test_activity_id',
        userId: 'user_123',
        userName: 'Test User',
        userRank: 'white',
        academyName: 'Test Academy',
        timestampStart: DateTime.now(),
        durationMinutes: 60,
        type: 'gi',
        rpe: 5,
        likesCount: 0,
        hasTechnicalNotes: false,
      );
      await trainingRepository.addActivity(activity);

      // Act
      final stream = trainingRepository.getActivities();

      // Assert
      expect(stream, emits(isA<List<Activity>>()));
      final activities = await stream.first;
      expect(activities.length, 1);
      expect(activities.first.activityId, 'test_activity_id');
    });
  });
}
