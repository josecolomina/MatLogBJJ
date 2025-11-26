import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../training_log/domain/technical_log.dart';
import '../../training_log/domain/activity.dart';
import '../data/technique_repository.dart';
import 'technique.dart';
import 'mastery_belt.dart';

class TechniqueExtractionService {
  final TechniqueRepository _repository;

  TechniqueExtractionService(this._repository);

  Future<List<Technique>> processTechnicalLog(TechnicalLog log, Activity activity) async {
    final multiplier = activity.type == 'open_mat' ? 2 : 1;
    final leveledUpTechniques = <Technique>[];

    for (final technique in log.processedTechniques) {
      final amount = 1 * multiplier;

      // We need to fetch the technique BEFORE incrementing to check for level up?
      // Or increment and check if belt changed?
      // The repository increment is atomic but doesn't return the new state easily unless we fetch it.
      // Let's fetch, calculate locally to check, then increment.
      // Or better: Repository increment could return the new Technique or we fetch it after.
      
      // Let's fetch it first to see current reps.
      // Ideally this should be transactional in the repo, but for now:
      final id = '${technique.techniqueName}_${technique.positionStart}'.toLowerCase().replaceAll(RegExp(r'\s+'), '_');
      final existing = await _repository.getTechnique(id);
      final currentReps = existing?.totalRepetitions ?? 0;
      final newReps = currentReps + amount;
      
      final oldBelt = MasteryBelt.fromRepetitions(currentReps);
      final newBelt = MasteryBelt.fromRepetitions(newReps);
      
      await _repository.incrementRepetitions(
        name: technique.techniqueName,
        position: technique.positionStart,
        category: technique.category,
        amount: amount,
      );

      if (newBelt.index > oldBelt.index) {
        // It leveled up!
        // Fetch the updated technique to return it
        final updated = await _repository.getTechnique(id);
        if (updated != null) {
          leveledUpTechniques.add(updated);
        }
      }
    }
    
    return leveledUpTechniques;
  }
}

final techniqueExtractionServiceProvider = Provider<TechniqueExtractionService>((ref) {
  final repository = ref.watch(techniqueRepositoryProvider);
  return TechniqueExtractionService(repository);
});
