import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TutorialRepository {
  static const String _tutorialCompletedKey = 'tutorial_completed';

  Future<bool> isTutorialCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_tutorialCompletedKey) ?? false;
  }

  Future<void> markTutorialCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_tutorialCompletedKey, true);
  }

  Future<void> resetTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tutorialCompletedKey);
  }
}

final tutorialRepositoryProvider = Provider<TutorialRepository>((ref) {
  return TutorialRepository();
});

final tutorialCompletedProvider = FutureProvider<bool>((ref) async {
  return ref.watch(tutorialRepositoryProvider).isTutorialCompleted();
});
