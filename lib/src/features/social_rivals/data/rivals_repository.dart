import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/rival.dart';

class RivalsRepository {
  final FirebaseFirestore _firestore;

  RivalsRepository(this._firestore);

  Stream<List<Rival>> getRivals(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('rivals')
        .orderBy('lastRolledAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Rival.fromJson(doc.data()))
            .toList());
  }

  Future<void> addRival(String userId, String rivalName) async {
    final rivalId = rivalName.toLowerCase().replaceAll(' ', '_');
    final rivalRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('rivals')
        .doc(rivalId);

    final snapshot = await rivalRef.get();
    if (!snapshot.exists) {
      await rivalRef.set({
        'rivalUid': rivalId,
        'rivalName': rivalName,
        'wins': 0,
        'losses': 0,
        'draws': 0,
        'lastRolledAt': FieldValue.serverTimestamp(),
        'notes': '',
      });
    }
  }

  Future<void> logMatch(String userId, String rivalId, String result) async {
    final rivalRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('rivals')
        .doc(rivalId);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(rivalRef);

      if (!snapshot.exists) {
        // Should not happen if we are logging a match against an existing rival
        // But we can handle it or throw
        return; 
      } else {
        final data = snapshot.data()!;
        int wins = data['wins'] ?? 0;
        int losses = data['losses'] ?? 0;
        int draws = data['draws'] ?? 0;

        if (result == 'win') wins++;
        if (result == 'loss') losses++;
        if (result == 'draw') draws++;

        transaction.update(rivalRef, {
          'wins': wins,
          'losses': losses,
          'draws': draws,
          'lastRolledAt': FieldValue.serverTimestamp(),
        });
      }
    });
  }
}

final rivalsRepositoryProvider = Provider<RivalsRepository>((ref) {
  return RivalsRepository(FirebaseFirestore.instance);
});

final rivalsStreamProvider = StreamProvider.family<List<Rival>, String>((ref, userId) {
  return ref.watch(rivalsRepositoryProvider).getRivals(userId);
});
