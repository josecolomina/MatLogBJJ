import 'package:flutter_test/flutter_test.dart';
import 'package:matlog/src/features/tutorial/data/tutorial_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('TutorialRepository', () {
    late TutorialRepository repository;

    setUp(() async {
      // Clear shared preferences before each test
      SharedPreferences.setMockInitialValues({});
      repository = TutorialRepository();
    });

    test('isTutorialCompleted returns false initially', () async {
      final result = await repository.isTutorialCompleted();
      expect(result, false);
    });

    test('markTutorialCompleted sets tutorial as completed', () async {
      await repository.markTutorialCompleted();
      final result = await repository.isTutorialCompleted();
      expect(result, true);
    });

    test('resetTutorial clears completion status', () async {
      await repository.markTutorialCompleted();
      expect(await repository.isTutorialCompleted(), true);
      
      await repository.resetTutorial();
      expect(await repository.isTutorialCompleted(), false);
    });

    test('tutorial status persists across repository instances', () async {
      await repository.markTutorialCompleted();
      
      // Create new instance
      final newRepository = TutorialRepository();
      final result = await newRepository.isTutorialCompleted();
      
      expect(result, true);
    });
  });
}
