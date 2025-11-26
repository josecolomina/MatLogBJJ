import 'package:flutter/material.dart';
import 'dart:async';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/authentication/data/auth_repository.dart';
import '../features/authentication/presentation/login_screen.dart';
import '../features/authentication/presentation/register_screen.dart';
import '../features/dashboard/presentation/main_navigation_screen.dart';
import '../features/onboarding/presentation/onboarding_screen.dart';
import '../features/training_log/presentation/check_in_screen.dart';
import '../features/social_rivals/presentation/rivals_screen.dart';
import '../features/technique_library/presentation/technique_library_screen.dart';
import '../features/technique_library/presentation/technique_detail_screen.dart';
import '../features/tutorial/presentation/tutorial_screen.dart';
import '../features/tutorial/data/tutorial_repository.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges()),
    redirect: (context, state) {
      final user = authRepository.currentUser;
      final isLoggedIn = user != null;
      final location = state.uri.toString();
      final isOnRoot = location == '/';
      final isLoggingIn = location == '/login';
      final isOnboarding = location == '/onboarding';
      final isTutorial = location == '/tutorial';

      // Redirect from root
      if (isOnRoot) {
        return isLoggedIn ? '/home' : '/onboarding';
      }

      // If not logged in and not on login/onboarding/tutorial pages, redirect to onboarding
      if (!isLoggedIn && !isLoggingIn && !isOnboarding && !isTutorial) {
        return '/onboarding';
      }

      // If logged in and trying to access login/onboarding, redirect to home
      // BUT allow tutorial even when logged in (for first-time setup)
      if (isLoggedIn && (isLoggingIn || isOnboarding)) {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/tutorial',
        pageBuilder: (context, state) => NoTransitionPage(
          key: state.pageKey,
          child: const TutorialScreen(),
        ),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const MainNavigationScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/check-in',
        builder: (context, state) => const CheckInScreen(),
      ),
      GoRoute(
        path: '/techniques/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return TechniqueDetailScreen(techniqueId: id);
        },
      ),
    ],
  );
});

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

