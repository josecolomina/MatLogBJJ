import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matlog/src/features/profile/data/profile_repository.dart';
import '../domain/mission.dart';

class MissionRepository {
  final ProfileRepository _profileRepository;

  MissionRepository(this._profileRepository);

  Stream<List<Mission>> getMissions() {
    return _profileRepository.getUserProfile().map((snapshot) {
      if (!snapshot.exists) return [];
      
      final data = snapshot.data() as Map<String, dynamic>;
      final progress = data['weekly_goal_progress'] as int? ?? 0;
      final target = data['weekly_goal_target'] as int? ?? 3;
      
      // Get list of viewed missions
      final viewedMissions = List<String>.from(data['viewed_missions'] ?? []);

      // Real Mission: Weekly Goal
      final weeklyGoal = Mission(
        id: 'weekly_goal',
        title: 'Objetivo Semanal', // TODO: Localize
        description: 'Completa $target sesiones de entrenamiento esta semana.',
        currentProgress: progress,
        target: target,
        isCompleted: progress >= target,
        isNew: false,
      );

      // Real Stats
      final totalSubmissions = data['total_submissions'] as int? ?? 0;
      final totalPasses = data['total_passes'] as int? ?? 0;
      // final totalSweeps = data['total_sweeps'] as int? ?? 0;

      // Real Missions
      final realMissions = [
        Mission(
          id: 'first_submission',
          title: 'Primera Finalización',
          description: 'Logra tu primera finalización en un sparring.',
          currentProgress: totalSubmissions,
          target: 1,
          isCompleted: totalSubmissions >= 1,
          isNew: !viewedMissions.contains('first_submission') && totalSubmissions >= 1, // Only show as new if completed? Or always? Let's stick to simple logic for now.
        ),
        Mission(
          id: 'guard_passer',
          title: 'Pasador de Guardia',
          description: 'Pasa la guardia 10 veces.',
          currentProgress: totalPasses,
          target: 10,
          isCompleted: totalPasses >= 10,
          isNew: !viewedMissions.contains('guard_passer') && totalPasses >= 10,
        ),
        // Keep Iron Defense as mock for now as we don't track "rounds survived" yet
        Mission(
          id: 'iron_defense',
          title: 'Defensa de Hierro',
          description: 'Sobrevive 5 rounds sin ser finalizado.',
          currentProgress: 5,
          target: 5,
          isCompleted: true,
          isNew: false,
        ),
      ];

      return [weeklyGoal, ...realMissions];

      return [weeklyGoal, ...mockMissions];
    });
  }

  Future<void> markMissionsAsViewed(List<String> missionIds) async {
    await _profileRepository.updateViewedMissions(missionIds);
  }
}

final missionRepositoryProvider = Provider<MissionRepository>((ref) {
  return MissionRepository(ref.watch(profileRepositoryProvider));
});

final missionsStreamProvider = StreamProvider<List<Mission>>((ref) {
  return ref.watch(missionRepositoryProvider).getMissions();
});
