import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/activity.dart';
import '../domain/technical_log.dart';

class TrainingRepository {
  final FirebaseFirestore _firestore;

  TrainingRepository(this._firestore);

  Future<void> addActivity(Activity activity) async {
    try {
      print('DEBUG: Attempting to add activity: ${activity.activityId}');
      await _firestore
          .collection('activities')
          .doc(activity.activityId)
          .set(activity.toJson());
      
      // Update weekly goal progress
      // Ideally this should be a transaction or a cloud function, but for now client-side is fine for MVP
      final userRef = _firestore.collection('users').doc(activity.userId);
      await userRef.update({
        'weekly_goal_progress': FieldValue.increment(1),
        'last_activity_week': _getCurrentWeek(),
      });

      print('DEBUG: Activity added successfully');
    } catch (e, stackTrace) {
      print('DEBUG: Error adding activity: $e');
      print('DEBUG: Stack trace: $stackTrace');
      throw e; // Re-throw to let UI handle it
    }
  }

  String _getCurrentWeek() {
    final now = DateTime.now();
    final dayOfYear = int.parse("${now.year}${now.difference(DateTime(now.year, 1, 1)).inDays + 1}");
    final week = (dayOfYear / 7).ceil();
    return "${now.year}-W$week";
  }

  Future<void> addTechnicalLog(String userId, TechnicalLog log) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('technical_logs')
        .doc(log.logId)
        .set(log.toJson());
  }

  Stream<List<Activity>> getActivities() {
    return _firestore
        .collection('activities')
        .orderBy('timestamp_start', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Activity.fromJson(doc.data()))
            .toList());
  }

  Future<List<Map<String, dynamic>>> getUserActivitiesJson(String userId) async {
    final snapshot = await _firestore
        .collection('activities')
        .where('userId', isEqualTo: userId)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }
}

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final trainingRepositoryProvider = Provider<TrainingRepository>((ref) {
  return TrainingRepository(ref.watch(firestoreProvider));
});
