import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:matlog/src/features/authentication/data/auth_repository.dart';

// Generate mocks for FirebaseAuth, User, and UserCredential
@GenerateMocks([FirebaseAuth, User, UserCredential])
import 'auth_repository_test.mocks.dart';

void main() {
  group('AuthRepository', () {
    late MockFirebaseAuth mockFirebaseAuth;
    late FakeFirebaseFirestore mockFirestore;
    late AuthRepository authRepository;

    setUp(() {
      mockFirebaseAuth = MockFirebaseAuth();
      mockFirestore = FakeFirebaseFirestore();
      authRepository = AuthRepository(mockFirebaseAuth, mockFirestore);
    });

    test('signInWithEmailAndPassword succeeds', () async {
      // Arrange
      final mockUserCredential = MockUserCredential();
      final mockUser = MockUser();
      
      when(mockUser.email).thenReturn('test@example.com');
      when(mockUser.uid).thenReturn('test_uid');
      when(mockUserCredential.user).thenReturn(mockUser);

      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: 'test@example.com',
        password: 'password',
      )).thenAnswer((_) async => mockUserCredential);

      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

      // Act
      await authRepository.signInWithEmailAndPassword('test@example.com', 'password');

      // Assert
      verify(mockFirebaseAuth.signInWithEmailAndPassword(
        email: 'test@example.com',
        password: 'password',
      )).called(1);
      expect(authRepository.currentUser, isNotNull);
      expect(authRepository.currentUser!.email, 'test@example.com');
    });

    test('createUserWithEmailAndPassword creates user and firestore document', () async {
      // Arrange
      final mockUserCredential = MockUserCredential();
      final mockUser = MockUser();
      
      when(mockUser.email).thenReturn('new@example.com');
      when(mockUser.uid).thenReturn('new_uid');
      when(mockUserCredential.user).thenReturn(mockUser);

      when(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: 'new@example.com',
        password: 'password',
      )).thenAnswer((_) async => mockUserCredential);

      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

      // Act
      await authRepository.createUserWithEmailAndPassword('new@example.com', 'password');

      // Assert
      verify(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: 'new@example.com',
        password: 'password',
      )).called(1);

      final userDoc = await mockFirestore.collection('users').doc('new_uid').get();
      expect(userDoc.exists, true);
      expect(userDoc.data()!['email'], 'new@example.com');
    });

    test('signOut signs out the user', () async {
      // Act
      await authRepository.signOut();

      // Assert
      verify(mockFirebaseAuth.signOut()).called(1);
    });
  });
}
