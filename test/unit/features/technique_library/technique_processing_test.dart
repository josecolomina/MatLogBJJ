import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:matlog/src/features/technique_library/domain/technique_extraction_service.dart';
import 'package:matlog/src/features/technique_library/data/technique_repository.dart';
import 'package:matlog/src/features/profile/data/profile_repository.dart';
import 'package:matlog/src/features/training_log/domain/technical_log.dart';
import 'package:matlog/src/features/training_log/domain/activity.dart';
import 'package:matlog/src/features/technique_library/domain/technique.dart';
import 'package:matlog/src/features/technique_library/domain/mastery_belt.dart';

// Generate mocks
@GenerateNiceMocks([
  MockSpec<TechniqueRepository>(),
  MockSpec<ProfileRepository>(),
])
import 'technique_processing_test.mocks.dart';

void main() {
  late TechniqueExtractionService service;
  late MockTechniqueRepository mockTechniqueRepository;
  late MockProfileRepository mockProfileRepository;

  setUp(() {
    mockTechniqueRepository = MockTechniqueRepository();
    mockProfileRepository = MockProfileRepository();
    service = TechniqueExtractionService(
      mockTechniqueRepository,
      mockProfileRepository,
    );
  });

  group('TechniqueExtractionService Tests', () {
    final activity = Activity(
      activityId: 'act-1',
      userId: 'user-1',
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

    test('Should update submission stats when processing a submission', () async {
      // Arrange
      final log = TechnicalLog(
        logId: 'log-1',
        activityRef: 'act-1',
        rawInputText: 'Armbar',
        processedTechniques: [
          ProcessedTechnique(
            techniqueName: 'Armbar',
            category: 'Submission',
            positionStart: 'Guard',
            positionEnd: 'Unknown',
            tags: [],
            masteryLevel: 0,
          ),
        ],
        aiSummary: '',
        createdAt: DateTime.now(),
      );

      // Act
      await service.processTechnicalLog(log, activity);

      // Assert
      verify(mockProfileRepository.updateMissionStats(
        submissions: 1,
        passes: 0,
        sweeps: 0,
      )).called(1);
    });

    test('Should update pass stats when processing a pass', () async {
      // Arrange
      final log = TechnicalLog(
        logId: 'log-2',
        activityRef: 'act-1',
        rawInputText: 'Pass',
        processedTechniques: [
          ProcessedTechnique(
            techniqueName: 'Knee Cut',
            category: 'Pass',
            positionStart: 'Standing',
            positionEnd: 'Side Control',
            tags: [],
            masteryLevel: 0,
          ),
        ],
        aiSummary: '',
        createdAt: DateTime.now(),
      );

      // Act
      await service.processTechnicalLog(log, activity);

      // Assert
      verify(mockProfileRepository.updateMissionStats(
        submissions: 0,
        passes: 1,
        sweeps: 0,
      )).called(1);
    });

    test('Should update multiple stats correctly', () async {
      // Arrange
      final log = TechnicalLog(
        logId: 'log-3',
        activityRef: 'act-1',
        rawInputText: 'Mixed',
        processedTechniques: [
          ProcessedTechnique(
            techniqueName: 'Armbar',
            category: 'Submission',
            positionStart: 'Guard',
            positionEnd: 'Unknown',
            tags: [],
            masteryLevel: 0,
          ),
          ProcessedTechnique(
            techniqueName: 'Triangle',
            category: 'Submission',
            positionStart: 'Guard',
            positionEnd: 'Unknown',
            tags: [],
            masteryLevel: 0,
          ),
          ProcessedTechnique(
            techniqueName: 'Knee Cut',
            category: 'Pass',
            positionStart: 'Standing',
            positionEnd: 'Side Control',
            tags: [],
            masteryLevel: 0,
          ),
        ],
        aiSummary: '',
        createdAt: DateTime.now(),
      );

      // Act
      await service.processTechnicalLog(log, activity);

      // Assert
      verify(mockProfileRepository.updateMissionStats(
        submissions: 2,
        passes: 1,
        sweeps: 0,
      )).called(1);
    });

    test('Should increment repetitions in repository', () async {
      // Arrange
      final log = TechnicalLog(
        logId: 'log-4',
        activityRef: 'act-1',
        rawInputText: 'Drill',
        processedTechniques: [
          ProcessedTechnique(
            techniqueName: 'Armbar',
            category: 'Drill',
            positionStart: 'Guard',
            positionEnd: 'Unknown',
            tags: [],
            masteryLevel: 0,
          ),
        ],
        aiSummary: '',
        createdAt: DateTime.now(),
      );

      // Act
      await service.processTechnicalLog(log, activity);

      // Assert
      verify(mockTechniqueRepository.incrementRepetitions(
        name: anyNamed('name'),
        position: anyNamed('position'),
        category: anyNamed('category'),
        amount: 1,
      )).called(1);
    });
  });
}
