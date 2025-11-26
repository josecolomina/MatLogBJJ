import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:matlog/src/features/technique_library/data/technique_repository.dart';
import 'package:matlog/src/features/technique_library/domain/technique.dart';
import 'package:matlog/src/features/technique_library/domain/mastery_belt.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late FirestoreTechniqueRepository repository;
  const userId = 'test_user';

  setUp(() async {
    fakeFirestore = FakeFirebaseFirestore();
    repository = FirestoreTechniqueRepository(fakeFirestore, userId);
    // Create user document to ensure subcollections can be created/accessed in FakeFirestore
    await fakeFirestore.collection('users').doc(userId).set({});
  });

  group('FirestoreTechniqueRepository', () {
    test('incrementRepetitions creates new technique if not exists', () async {
      await repository.incrementRepetitions(
        name: 'Armbar',
        position: 'Guard',
        category: 'Submission',
        amount: 5,
      );

      final techniques = await repository.watchTechniques().first;
      expect(techniques.length, 1);
      
      final technique = techniques.first;
      expect(technique.name, 'Armbar');
      expect(technique.position, 'Guard');
      expect(technique.totalRepetitions, 5);
      expect(technique.masteryBelt, MasteryBelt.white);
    });

    test('incrementRepetitions updates existing technique', () async {
      // Create initial technique
      await repository.incrementRepetitions(
        name: 'Armbar',
        position: 'Guard',
        category: 'Submission',
        amount: 10,
      );

      // Increment
      await repository.incrementRepetitions(
        name: 'Armbar',
        position: 'Guard',
        category: 'Submission',
        amount: 5,
      );

      final techniques = await repository.watchTechniques().first;
      expect(techniques.length, 1);
      
      final technique = techniques.first;
      expect(technique.totalRepetitions, 15);
      expect(technique.masteryBelt, MasteryBelt.blue); // 15 is Blue (11-50)
    });

    test('getTechnique returns correct technique', () async {
      await repository.incrementRepetitions(
        name: 'Triangle',
        position: 'Mount',
        category: 'Submission',
        amount: 1,
      );

      final techniques = await repository.watchTechniques().first;
      final id = techniques.first.id;

      final technique = await repository.getTechnique(id);
      expect(technique, isNotNull);
      expect(technique!.name, 'Triangle');
    });

    test('updateTechnique updates notes', () async {
      await repository.incrementRepetitions(
        name: 'Sweep',
        position: 'Half Guard',
        category: 'Sweep',
        amount: 1,
      );

      final techniques = await repository.watchTechniques().first;
      final technique = techniques.first;

      final updatedTechnique = technique.copyWith(notes: 'Keep hips low');
      await repository.updateTechnique(updatedTechnique);

      final fetched = await repository.getTechnique(technique.id);
      expect(fetched!.notes, 'Keep hips low');
    });
  });
}
