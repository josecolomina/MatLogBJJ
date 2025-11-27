import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matlog/src/features/tutorial/presentation/tutorial_screen.dart';
import 'package:matlog/src/features/tutorial/data/tutorial_repository.dart';
import 'package:mockito/mockito.dart';
import 'package:go_router/go_router.dart';
import 'package:matlog/src/features/technique_library/data/technique_repository.dart';
import 'package:matlog/src/features/technique_library/domain/technique.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:matlog/src/features/dashboard/presentation/dashboard_controller.dart';
import 'package:matlog/l10n/app_localizations.dart';
import 'package:matlog/src/features/training_log/data/training_repository.dart';
import 'package:matlog/src/features/training_log/domain/activity.dart';
import 'package:matlog/src/features/authentication/data/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:matlog/src/features/social_rivals/data/rivals_repository.dart';
import 'package:matlog/src/features/social_rivals/domain/rival.dart';
import 'package:matlog/src/features/profile/data/profile_repository.dart';
import 'package:matlog/src/features/authentication/domain/belt_info.dart';
import 'package:matlog/src/features/missions/data/mission_repository.dart';
import 'package:matlog/src/features/missions/domain/mission.dart';

class MockUser extends Mock implements User {
  @override
  String get uid => 'test_uid';
  
  @override
  String? get email => 'test@example.com';
  
  @override
  String? get displayName => 'Test User';
}

class FakeTutorialRepository implements TutorialRepository {
  bool completed = false;

  @override
  Future<void> markTutorialCompleted() async {
    completed = true;
  }
  
  @override
  Future<bool> isTutorialCompleted() async => completed;
  
  @override
  Future<void> resetTutorial() async {
    completed = false;
  }
}

class MockTechniqueRepository extends Mock implements TechniqueRepository {
  @override
  Stream<List<Technique>> watchTechniques() {
    return Stream.value([]);
  }
}

class MockTrainingRepository extends Mock implements TrainingRepository {
  @override
  Stream<List<Activity>> getActivities() {
    return Stream.value([]);
  }
}

class MockAuthRepository extends Mock implements AuthRepository {
  @override
  User? get currentUser => MockUser();
}

class MockRivalsRepository extends Mock implements RivalsRepository {
  @override
  Stream<List<Rival>> watchRivals(String userId) {
    return Stream.value([]);
  }
}

class MockProfileRepository extends Mock implements ProfileRepository {
  final FirebaseFirestore firestore;
  
  MockProfileRepository(this.firestore);

  @override
  Stream<BeltInfo> watchUserBeltInfo() {
    return Stream.value(const BeltInfo(color: BeltColor.white, stripes: 0));
  }
  
  @override
  Stream<DocumentSnapshot> getUserProfile() {
    return firestore.collection('users').doc('test_uid').snapshots();
  }
}

class MockMissionRepository extends Mock implements MissionRepository {
  @override
  Stream<List<Mission>> watchMissions() {
    return Stream.value([]);
  }
}

void main() {
  testWidgets('TutorialScreen displays steps and navigates correctly', (WidgetTester tester) async {
    final fakeTutorialRepository = FakeTutorialRepository();
    final mockTechniqueRepository = MockTechniqueRepository();
    final mockTrainingRepository = MockTrainingRepository();
    final mockAuthRepository = MockAuthRepository();
    final mockRivalsRepository = MockRivalsRepository();
    final mockFirestore = FakeFirebaseFirestore();
    final mockProfileRepository = MockProfileRepository(mockFirestore);
    final mockMissionRepository = MockMissionRepository();
    
    // Setup mock user profile
    await mockFirestore.collection('users').doc('test_uid').set({
      'weekly_goal_progress': 2,
      'weekly_goal_target': 4,
    });

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const TutorialScreen(),
        ),
        GoRoute(
          path: '/home',
          builder: (context, state) => const Scaffold(body: Text('Home Screen')),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          tutorialRepositoryProvider.overrideWithValue(fakeTutorialRepository),
          techniqueRepositoryProvider.overrideWithValue(mockTechniqueRepository),
          trainingRepositoryProvider.overrideWithValue(mockTrainingRepository),
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
          rivalsRepositoryProvider.overrideWithValue(mockRivalsRepository),
          profileRepositoryProvider.overrideWithValue(mockProfileRepository),
          missionRepositoryProvider.overrideWithValue(mockMissionRepository),
          userProfileProvider.overrideWith((ref) => mockFirestore.collection('users').doc('test_uid').snapshots()),
        ],
        child: MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );

    // Initial step: Welcome
    expect(find.text('¡Bienvenido a MatLog!'), findsOneWidget);
    await tester.tap(find.text('Comenzar Tour'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    // Step 2: Add Training
    expect(find.text('Registra tus Entrenamientos'), findsOneWidget);
    await tester.tap(find.text('Siguiente'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    // Step 3: Missions
    expect(find.text('Completa Misiones'), findsOneWidget);
    await tester.tap(find.text('Siguiente'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    // Step 4: Upcoming Classes
    expect(find.text('Nunca Olvides una Clase'), findsOneWidget);
    await tester.tap(find.text('Siguiente'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    // Step 6: Social Tab
    expect(find.text('Conecta con Compañeros'), findsOneWidget);
    await tester.tap(find.text('Siguiente'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    // Step 7: Techniques Tab
    expect(find.text('Domina tu Técnica'), findsOneWidget);
    await tester.tap(find.text('Siguiente'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    // Step 8: Profile
    expect(find.text('Personaliza tu Perfil'), findsOneWidget);
    await tester.tap(find.text('Siguiente'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    // Step 9: Analytics (New Step)
    expect(find.text('Analiza tu Progreso'), findsOneWidget);
    expect(find.text('Visualiza tus estadísticas de entrenamiento y mejora tu rendimiento.'), findsOneWidget);
    
    // Verify we are on the Analytics tab (index 3)
    // We can check if the BottomNavigationBar has the correct index selected
    // Or check if AnalyticsScreen content is visible (but it might be empty or mocked)
    
    await tester.tap(find.text('Siguiente'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    // Step 10: Ready to start
    expect(find.text('¡Listo para Empezar!'), findsOneWidget);
    await tester.tap(find.text('Empezar'));
    await tester.pump(); // Start animation/transition
    await tester.pump(); // Flush callbacks and rebuild
    await tester.pump(const Duration(seconds: 1)); // Wait for transition

    // Verify completion
    expect(fakeTutorialRepository.completed, isTrue);
    
    // Verify navigation to Home
    expect(find.text('Home Screen'), findsOneWidget);
  });
}
