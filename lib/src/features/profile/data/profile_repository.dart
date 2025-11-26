import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../authentication/data/auth_repository.dart';
import '../../authentication/domain/belt_info.dart';

class ProfileRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  ProfileRepository(this._firestore, this._auth);

  Stream<BeltInfo> watchUserBeltInfo() {
    final user = _auth.currentUser;
    if (user == null) return Stream.value(const BeltInfo(color: BeltColor.white, stripes: 0));

    return _firestore
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) return const BeltInfo(color: BeltColor.white, stripes: 0);
      final data = snapshot.data();
      return BeltInfo.fromMap(data?['belt_info']);
    });
  }
  
  Stream<DocumentSnapshot> getUserProfile() {
    final user = _auth.currentUser;
    if (user == null) return const Stream.empty();
    return _firestore.collection('users').doc(user.uid).snapshots();
  }

  Future<void> updateBeltInfo(BeltInfo beltInfo) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('users').doc(user.uid).update({
      'belt_info': beltInfo.toMap(),
    });
  }

  Future<void> updateViewedMissions(List<String> missionIds) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('users').doc(user.uid).update({
      'viewed_missions': missionIds,
    });
  }

  Future<void> updateProfile({
    required String name,
    required String academy,
    required BeltInfo beltInfo,
    List<int>? trainingDays,
    String? trainingTime,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final data = {
      'name': name,
      'academy': academy,
      'belt_info': beltInfo.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
      'last_activity_week': '',
      'weekly_goal_progress': 0,
      'is_anonymous': user.isAnonymous,
    };

    if (trainingDays != null) {
      data['training_days'] = trainingDays;
    }
    if (trainingTime != null) {
      data['training_time'] = trainingTime;
    }

    await _firestore.collection('users').doc(user.uid).set(data, SetOptions(merge: true));
  }

  Future<void> updateSchedule({
    required List<int> trainingDays,
    required String trainingTime,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('users').doc(user.uid).update({
      'training_days': trainingDays,
      'training_time': trainingTime,
    });
  }
}

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(
    ref.watch(firestoreProvider),
    ref.watch(firebaseAuthProvider),
  );
});

final userBeltInfoProvider = StreamProvider<BeltInfo>((ref) {
  return ref.watch(profileRepositoryProvider).watchUserBeltInfo();
});

final userProfileStreamProvider = StreamProvider((ref) {
  return ref.watch(profileRepositoryProvider).getUserProfile();
});

