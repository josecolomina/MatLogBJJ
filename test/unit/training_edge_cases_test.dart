import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:matlog/src/features/training_log/data/training_repository.dart';
import 'package:matlog/src/features/training_log/domain/activity.dart';

void main() {
  late FakeFirebaseFirestore mockFirestore;
  late TrainingRepository trainingRepository;

  setUp(() {
    mockFirestore = FakeFirebaseFirestore();
    trainingRepository = TrainingRepository(mockFirestore);
  });

  group('TrainingRepository Edge Cases', () {
    test('addActivity handles maximum integer duration', () async {
      final activity = Activity(
        activityId: 'max_duration_id',
        userId: 'user_1',
        userName: 'Test User',
        userRank: 'white',
        academyName: 'Test Academy',
        timestampStart: DateTime.now(),
        durationMinutes: 2147483647, // Max 32-bit signed int
        type: 'gi',
        rpe: 10,
        likesCount: 0,
        hasTechnicalNotes: false,
      );

      await trainingRepository.addActivity(activity);

      final doc = await mockFirestore.collection('activities').doc('max_duration_id').get();
      expect(doc.exists, true);
      expect(doc.data()?['durationMinutes'], 2147483647);
    });

    test('addActivity handles extremely long notes/text', () async {
      final longText = 'A' * 10000; // 10k characters
      final activity = Activity(
        activityId: 'long_text_id',
        userId: 'user_1',
        userName: longText, // Using username field to test long string storage
        userRank: 'white',
        academyName: 'Test Academy',
        timestampStart: DateTime.now(),
        durationMinutes: 60,
        type: 'gi',
        rpe: 5,
        likesCount: 0,
        hasTechnicalNotes: true,
      );

      await trainingRepository.addActivity(activity);

      final doc = await mockFirestore.collection('activities').doc('long_text_id').get();
      expect(doc.exists, true);
      expect(doc.data()?['userName'], longText);
    });

    test('addActivity handles special characters and emojis', () async {
      const specialChars = 'ñÑáéíóúÁÉÍÓÚüÜ!@#\$%^&*()_+{}:"<>?|~`¬€£¥§¶•ªº';
      const emojis = '🥋🤼‍♂️🔥💪🧠🤕🏥🚑💊💉🧬🦠🧪🧫🔬🔭📡🛰🚀🛸';
      final combined = '$specialChars $emojis';
      
      final activity = Activity(
        activityId: 'special_chars_id',
        userId: 'user_1',
        userName: 'Test User',
        userRank: 'white',
        academyName: combined,
        timestampStart: DateTime.now(),
        durationMinutes: 60,
        type: 'gi',
        rpe: 5,
        likesCount: 0,
        hasTechnicalNotes: false,
      );

      await trainingRepository.addActivity(activity);

      final doc = await mockFirestore.collection('activities').doc('special_chars_id').get();
      expect(doc.exists, true);
      expect(doc.data()?['academyName'], combined);
    });
  });
}
