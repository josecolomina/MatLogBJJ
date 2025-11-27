import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/technique.dart';
import '../domain/mastery_belt.dart';
import '../../authentication/data/auth_repository.dart';

abstract class TechniqueRepository {
  Stream<List<Technique>> watchTechniques();
  Future<Technique?> getTechnique(String id);
  Future<void> updateTechnique(Technique technique);
  Future<void> incrementRepetitions({
    required String name,
    required String position,
    required String category,
    required int amount,
  });
}

class FirestoreTechniqueRepository implements TechniqueRepository {
  final FirebaseFirestore _firestore;
  final String _userId; // Assuming we have user context

  FirestoreTechniqueRepository(this._firestore, this._userId);

  CollectionReference<Map<String, dynamic>> get _techniquesCollection =>
      _firestore.collection('users').doc(_userId).collection('techniques');

  @override
  Stream<List<Technique>> watchTechniques() {
    return _techniquesCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Technique.fromJson(doc.data()..['id'] = doc.id);
      }).toList();
    });
  }

  @override
  Future<Technique?> getTechnique(String id) async {
    final doc = await _techniquesCollection.doc(id).get();
    if (!doc.exists) return null;
    return Technique.fromJson(doc.data()!..['id'] = doc.id);
  }

  @override
  Future<void> updateTechnique(Technique technique) async {
    await _techniquesCollection.doc(technique.id).update(technique.toJson());
  }

  @override
  Future<void> incrementRepetitions({
    required String name,
    required String position,
    required String category,
    required int amount,
  }) async {
    final docId = '${name}_${position}'.toLowerCase().replaceAll(RegExp(r'\s+'), '_');
    final docRef = _techniquesCollection.doc(docId);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);

      if (!snapshot.exists) {
        // Create new
        final newTechnique = Technique(
          id: docId,
          name: name,
          position: position,
          category: category,
          totalRepetitions: amount,
          masteryBelt: MasteryBelt.fromRepetitions(amount),
          lastPracticedAt: DateTime.now(),
        );
        transaction.set(docRef, newTechnique.toJson());
      } else {
        // Update existing
        final data = snapshot.data()!;
        final currentReps = data['totalRepetitions'] as int;
        final newReps = currentReps + amount;
        final newBelt = MasteryBelt.fromRepetitions(newReps);
        
        transaction.update(docRef, {
          'totalRepetitions': newReps,
          'masteryBelt': newBelt.name, 
          'lastPracticedAt': Timestamp.fromDate(DateTime.now()),
        });
      }
    });
  }
}

final techniqueRepositoryProvider = Provider<TechniqueRepository>((ref) {
  final user = ref.watch(authRepositoryProvider).currentUser;
  if (user == null) {
    throw Exception('User not authenticated');
  }
  return FirestoreTechniqueRepository(FirebaseFirestore.instance, user.uid);
});

final userTechniquesProvider = StreamProvider<List<Technique>>((ref) {
  final repository = ref.watch(techniqueRepositoryProvider);
  return repository.watchTechniques();
});
