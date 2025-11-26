import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matlog/src/features/authentication/presentation/login_screen.dart';
import 'package:matlog/src/features/authentication/data/auth_repository.dart';
import 'package:mockito/mockito.dart';

// Mock AuthRepository directly
class MockAuthRepository extends Mock implements AuthRepository {
  @override
  Future<void> signInWithEmailAndPassword(String? email, String? password) async {
    // Simulate success or failure based on input if needed
    if (email == null || password == null) return;
  }
}

void main() {
  testWidgets('LoginScreen renders correctly', (WidgetTester tester) async {
    final mockAuthRepository = MockAuthRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ],
        child: const MaterialApp(
          home: LoginScreen(),
        ),
      ),
    );

    // Verify logo and text
    expect(find.text('MatLog'), findsNothing); // Title is not in LoginScreen anymore, it's 'Bienvenido a MatLog'
    expect(find.text('Bienvenido a MatLog'), findsOneWidget);
    expect(find.text('Tu diario de BJJ'), findsOneWidget);

    // Verify text fields
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.text('Correo electrónico'), findsOneWidget);
    expect(find.text('Contraseña'), findsOneWidget);

    // Verify buttons
    expect(find.text('Entrar'), findsOneWidget);
    expect(find.text('¿No tienes cuenta? Regístrate'), findsOneWidget);
  });

  testWidgets('LoginScreen shows validation errors', (WidgetTester tester) async {
    final mockAuthRepository = MockAuthRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockAuthRepository),
        ],
        child: const MaterialApp(
          home: LoginScreen(),
        ),
      ),
    );

    // Tap login without entering data
    await tester.tap(find.text('Entrar'));
    await tester.pump();

    // Verify validation errors
    expect(find.text('Por favor, introduce tu correo'), findsOneWidget);
    expect(find.text('Por favor, introduce tu contraseña'), findsOneWidget);
  });
}
