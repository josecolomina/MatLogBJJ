import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matlog/src/features/onboarding/presentation/onboarding_screen.dart';
import 'package:matlog/src/features/authentication/data/auth_repository.dart';
import 'package:matlog/src/features/profile/data/profile_repository.dart';
import 'package:matlog/src/features/tutorial/data/tutorial_repository.dart';
import 'package:matlog/src/features/notifications/data/notification_service.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:firebase_auth/firebase_auth.dart';

@GenerateNiceMocks([
  MockSpec<AuthRepository>(),
  MockSpec<ProfileRepository>(),
  MockSpec<TutorialRepository>(),
  MockSpec<NotificationService>(),
])
import 'onboarding_login_test.mocks.dart';

void main() {
  late MockAuthRepository mockAuthRepository;
  late MockProfileRepository mockProfileRepository;
  late MockTutorialRepository mockTutorialRepository;
  late MockNotificationService mockNotificationService;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockProfileRepository = MockProfileRepository();
    mockTutorialRepository = MockTutorialRepository();
    mockNotificationService = MockNotificationService();
  });

  testWidgets('Inline login form expands and allows login', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
          profileRepositoryProvider.overrideWithValue(mockProfileRepository),
          tutorialRepositoryProvider.overrideWithValue(mockTutorialRepository),
          notificationServiceProvider.overrideWithValue(mockNotificationService),
        ],
        child: const MaterialApp(
          home: OnboardingScreen(),
        ),
      ),
    );

    // Verify "Already have an account?" text exists
    expect(find.text('¿Ya tienes cuenta? Inicia sesión'), findsOneWidget);

    // Scroll to make it visible
    final finder = find.byKey(const Key('inlineLoginExpansionTile'));
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();

    // Tap to expand
    await tester.tap(finder);
    await tester.pumpAndSettle();

    // Verify fields are visible
    expect(find.text('Correo electrónico'), findsOneWidget);
    expect(find.text('Contraseña'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);

    // Enter credentials
    await tester.enterText(find.widgetWithText(TextFormField, 'Correo electrónico'), 'test@example.com');
    await tester.enterText(find.widgetWithText(TextFormField, 'Contraseña'), 'password123');

    // Tap login
    final loginButton = find.text('Entrar');
    await tester.ensureVisible(loginButton);
    await tester.pumpAndSettle();
    await tester.tap(loginButton);
    await tester.pump(); // Start loading

    // Verify signInWithEmailAndPassword was called
    verify(mockAuthRepository.signInWithEmailAndPassword('test@example.com', 'password123')).called(1);
  });
}
