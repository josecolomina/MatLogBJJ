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

    // Generate tag if not exists (we can't easily check if it exists here without an extra read, 
    // but for now let's generate it if we are creating/updating profile and assume it might be new or we just overwrite/merge)
    // Actually, better to read first or just generate a new one if we don't have it locally. 
    // Since this is updateProfile, usually called on onboarding, let's generate it.
    
    final tag = (1000 + DateTime.now().microsecond % 9000).toString(); // Simple random 4-digit
    final usernameTag = '$name#$tag';

    final data = {
      'name': name,
      'academy': academy,
      'belt_info': beltInfo.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
      'last_activity_week': '',
      'weekly_goal_progress': 0,
      'is_anonymous': user.isAnonymous,
      'tag': tag,
      'username_tag': usernameTag,
      'search_key': usernameTag.toLowerCase(), // For easier searching
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
  Future<void> ensureUserTag() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) return;

    final data = doc.data();
    if (data != null && data['username_tag'] == null) {
      final name = data['name'] as String? ?? 'User';
      final tag = (1000 + DateTime.now().microsecond % 9000).toString();
      final usernameTag = '$name#$tag';

      await _firestore.collection('users').doc(user.uid).update({
        'tag': tag,
        'username_tag': usernameTag,
        'search_key': usernameTag.toLowerCase(),
      });
    }
  }

  Future<void> updateMissionStats({
    int submissions = 0,
    int passes = 0,
    int sweeps = 0,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final updates = <String, dynamic>{};
    if (submissions > 0) updates['total_submissions'] = FieldValue.increment(submissions);
    if (passes > 0) updates['total_passes'] = FieldValue.increment(passes);
    if (sweeps > 0) updates['total_sweeps'] = FieldValue.increment(sweeps);

    if (updates.isNotEmpty) {
      await _firestore.collection('users').doc(user.uid).update(updates);
    }
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

