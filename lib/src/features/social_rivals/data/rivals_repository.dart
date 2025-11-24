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

  Future<void> addMatchResult(String userId, String rivalId, String rivalName, String result) async {
    final rivalRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('rivals')
        .doc(rivalId);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(rivalRef);

      if (!snapshot.exists) {
        transaction.set(rivalRef, {
          'rivalUid': rivalId,
          'rivalName': rivalName,
          'wins': result == 'win' ? 1 : 0,
          'losses': result == 'loss' ? 1 : 0,
          'draws': result == 'draw' ? 1 : 0,
          'lastRolledAt': FieldValue.serverTimestamp(),
          'notes': '',
        });
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
