import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:matlog/src/features/technique_library/domain/technique_extraction_service.dart';
import 'package:matlog/src/features/technique_library/data/technique_repository.dart';
import 'package:matlog/src/features/technique_library/domain/technique.dart';
import 'package:matlog/src/features/technique_library/domain/mastery_belt.dart';
import 'package:matlog/src/features/training_log/domain/technical_log.dart';
import 'package:matlog/src/features/training_log/domain/activity.dart';

// Generate mocks
@GenerateNiceMocks([MockSpec<TechniqueRepository>()])
import 'technique_extraction_service_test.mocks.dart';

void main() {
  late TechniqueExtractionService service;
  late MockTechniqueRepository mockRepository;

  setUp(() {
    mockRepository = MockTechniqueRepository();
    service = TechniqueExtractionService(mockRepository);
  });

  group('TechniqueExtractionService', () {
    test('processTechnicalLog increments repetitions correctly for drill', () async {
      final activity = Activity(
        activityId: '1',
        userId: 'user1',
        userName: 'User',
        userRank: 'white',
        academyName: 'Academy',
        timestampStart: DateTime.now(),
        durationMinutes: 60,
        type: 'gi', // Drill multiplier = 1
        rpe: 5,
        likesCount: 0,
        hasTechnicalNotes: true,
      );

      final log = TechnicalLog(
        logId: 'log1',
        activityRef: '1',
        rawInputText: 'notes',
        processedTechniques: [
          const ProcessedTechnique(
            techniqueName: 'Armbar',
            category: 'Submission',
            positionStart: 'Guard',
            positionEnd: 'Submission',
            tags: [],
            masteryLevel: 0,
          ),
        ],
        aiSummary: 'summary',
        createdAt: DateTime.now(),
      );

      // Mock getTechnique to return null (new technique)
      when(mockRepository.getTechnique(any)).thenAnswer((_) async => null);

      await service.processTechnicalLog(log, activity);

      verify(mockRepository.incrementRepetitions(
        name: 'Armbar',
        position: 'Guard',
        category: 'Sumisión',  // Normalized from 'Submission'
        amount: 1,
      )).called(1);
    });

    test('processTechnicalLog increments repetitions correctly for sparring', () async {
      final activity = Activity(
        activityId: '1',
        userId: 'user1',
        userName: 'User',
        userRank: 'white',
        academyName: 'Academy',
        timestampStart: DateTime.now(),
        durationMinutes: 60,
        type: 'open_mat', // Sparring multiplier = 2
        rpe: 5,
        likesCount: 0,
        hasTechnicalNotes: true,
      );

      final log = TechnicalLog(
        logId: 'log1',
        activityRef: '1',
        rawInputText: 'notes',
        processedTechniques: [
          const ProcessedTechnique(
            techniqueName: 'Armbar',
            category: 'Submission',
            positionStart: 'Guard',
            positionEnd: 'Submission',
            tags: [],
            masteryLevel: 0,
          ),
        ],
        aiSummary: 'summary',
        createdAt: DateTime.now(),
      );

      when(mockRepository.getTechnique(any)).thenAnswer((_) async => null);

      await service.processTechnicalLog(log, activity);

      verify(mockRepository.incrementRepetitions(
        name: 'Armbar',
        position: 'Guard',
        category: 'Sumisión',  // Normalized from 'Submission'
        amount: 2,
      )).called(1);
    });

    test('processTechnicalLog returns leveled up techniques', () async {
      final activity = Activity(
        activityId: '1',
        userId: 'user1',
        userName: 'User',
        userRank: 'white',
        academyName: 'Academy',
        timestampStart: DateTime.now(),
        durationMinutes: 60,
        type: 'gi',
        rpe: 5,
        likesCount: 0,
        hasTechnicalNotes: true,
      );

      final log = TechnicalLog(
        logId: 'log1',
        activityRef: '1',
        rawInputText: 'notes',
        processedTechniques: [
          const ProcessedTechnique(
            techniqueName: 'Armbar',
            category: 'Submission',
            positionStart: 'Guard',
            positionEnd: 'Submission',
            tags: [],
            masteryLevel: 0,
          ),
        ],
        aiSummary: 'summary',
        createdAt: DateTime.now(),
      );

      // Mock existing technique at 10 reps (White Belt)
      final existingTechnique = Technique(
        id: 'armbar_guard',
        name: 'Armbar',
        position: 'Guard',
        category: 'Submission',
        totalRepetitions: 10,
        masteryBelt: MasteryBelt.white,
        lastPracticedAt: DateTime.now(),
      );

      when(mockRepository.getTechnique(any)).thenAnswer((_) async => existingTechnique);
      
      // Mock updated technique at 11 reps (Blue Belt)
      final updatedTechnique = existingTechnique.copyWith(
        totalRepetitions: 11,
        masteryBelt: MasteryBelt.blue,
      );
      
      // We need to ensure the second call to getTechnique returns the updated one
      // Since we can't easily sequence returns with simple 'when' if arguments are same,
      // we can rely on the fact that the service calls increment then get? 
      // Wait, the service calls get (to check old), then increment, then get (to return new if leveled up).
      // So we need to mock getTechnique to return existing first, then updated.
      
      int callCount = 0;
      when(mockRepository.getTechnique(any)).thenAnswer((_) async {
        callCount++;
        if (callCount == 1) return existingTechnique;
        return updatedTechnique;
      });

      final leveledUp = await service.processTechnicalLog(log, activity);

      expect(leveledUp.length, 1);
      expect(leveledUp.first.masteryBelt, MasteryBelt.blue);
      expect(leveledUp.first.totalRepetitions, 11);
    });
  });
}
