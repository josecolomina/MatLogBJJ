import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:matlog/src/features/authentication/data/auth_repository.dart';
import 'package:matlog/src/features/authentication/domain/belt_info.dart';
import 'auth_repository_test.mocks.dart';

void main() {
  late MockFirebaseAuth mockFirebaseAuth;
  late FakeFirebaseFirestore mockFirestore;
  late AuthRepository authRepository;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockFirestore = FakeFirebaseFirestore();
    authRepository = AuthRepository(mockFirebaseAuth, mockFirestore);
  });

  group('AuthRepository Edge Cases', () {
    test('signInWithEmailAndPassword throws on network error', () async {
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenThrow(FirebaseAuthException(
        code: 'network-request-failed',
        message: 'Network error',
      ));

      expect(
        () => authRepository.signInWithEmailAndPassword('test@example.com', 'password'),
        throwsA(isA<FirebaseAuthException>()),
      );
    });

    test('createUserWithEmailAndPassword throws on network error', () async {
      when(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: anyNamed('email'),
        password: anyNamed('password'),
      )).thenThrow(FirebaseAuthException(
        code: 'network-request-failed',
        message: 'Network error',
      ));

      expect(
        () async => await authRepository.createUserWithEmailAndPassword(
          'test@example.com',
          'password123',
          const BeltInfo(color: BeltColor.white, stripes: 0),
        ),
        throwsA(isA<FirebaseAuthException>()),
      );
    });

    test('signInWithEmailAndPassword handles extremely long email', () async {
      final longEmail = '${'a' * 100}@example.com';
      
      // Mock successful sign in for this specific long email
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: longEmail,
        password: 'password',
      )).thenAnswer((_) async => MockUserCredential());

      await authRepository.signInWithEmailAndPassword(longEmail, 'password');
      
      verify(mockFirebaseAuth.signInWithEmailAndPassword(
        email: longEmail,
        password: 'password',
      )).called(1);
    });

    test('createUserWithEmailAndPassword handles special characters in email', () async {
      final specialEmail = 'test+special%chars@example.com';
      final mockUserCredential = MockUserCredential();
      final mockUser = MockUser();
      
      when(mockUser.uid).thenReturn('test_uid');
      when(mockUserCredential.user).thenReturn(mockUser);

      when(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: specialEmail,
        password: 'password',
      )).thenAnswer((_) async => mockUserCredential);

      await authRepository.createUserWithEmailAndPassword(
        specialEmail,
        'password',
        const BeltInfo(color: BeltColor.white, stripes: 0),
      );

      verify(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: specialEmail,
        password: 'password',
      )).called(1);
      
      // Verify it was saved to Firestore correctly
      final userDoc = await mockFirestore.collection('users').doc('test_uid').get();
      expect(userDoc.exists, true);
      expect(userDoc.data()?['email'], specialEmail);
    });
  });
}
