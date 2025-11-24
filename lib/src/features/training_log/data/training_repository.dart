import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/activity.dart';
import '../domain/technical_log.dart';

class TrainingRepository {
  final FirebaseFirestore _firestore;

  TrainingRepository(this._firestore);

  Future<void> addActivity(Activity activity) async {
    await _firestore
        .collection('activities')
        .doc(activity.activityId)
        .set(activity.toJson());
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
}

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final trainingRepositoryProvider = Provider<TrainingRepository>((ref) {
  return TrainingRepository(ref.watch(firestoreProvider));
});
