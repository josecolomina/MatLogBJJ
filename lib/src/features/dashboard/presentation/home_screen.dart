import 'package:flutter/material.dart';
import 'package:matlog/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:matlog/src/features/settings/presentation/settings_screen.dart';
import '../../authentication/data/auth_repository.dart';
import '../../social_rivals/presentation/feed_screen.dart';
import '../../subscription/presentation/ad_banner_widget.dart';
import 'package:matlog/src/common_widgets/belt_display_widget.dart';
import 'package:matlog/src/common_widgets/profile_image_widget.dart';
import '../../authentication/domain/belt_info.dart';
import '../../profile/data/profile_repository.dart';
import 'dashboard_controller.dart';
import '../../missions/data/mission_repository.dart';
import '../../missions/presentation/missions_modal.dart';
import '../../tutorial/data/tutorial_repository.dart';
import '../../tutorial/presentation/tutorial_keys.dart';

class HomeScreen extends ConsumerWidget {
  final GlobalKey? missionsKey;
  final GlobalKey? classesKey;
  final GlobalKey? profileKey;

  const HomeScreen({
    super.key,
    this.missionsKey,
    this.classesKey,
    this.profileKey,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileAsync = ref.watch(userProfileProvider);

    // Check weekly goal on load
    ref.listen(dashboardControllerProvider, (_, __) {});
    
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(context)!.appTitle,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            ref.watch(userBeltInfoProvider).when(
                  data: (belt) => BeltDisplayWidget(
                    beltInfo: belt,
                    height: 32,
                    width: 100,
                  ),
                  loading: () => const SizedBox.shrink(),
                  error: (_, _) => const SizedBox.shrink(),
                ),
          ],
        ),
        actions: [
          // DEBUG: Reset Tutorial Button
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.orange),
            tooltip: 'DEBUG: Reset Tutorial',
            onPressed: () async {
              // Reset tutorial
              await ref.read(tutorialRepositoryProvider).resetTutorial();
              
              // Sign out to test tutorial again
              await ref.read(authRepositoryProvider).signOut();
              
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Tutorial reseteado. Redirigiendo a onboarding...'),
                    backgroundColor: Colors.orange,
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
          ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SettingsScreen()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Container(
                  key: profileKey,
                  child: ref.watch(userProfileProvider).when(
                        data: (snapshot) {
                          final data = snapshot.data() as Map<String, dynamic>?;
                          final beltMap = data?['belt_info'] as Map<String, dynamic>?;
                          final beltInfo = beltMap != null ? BeltInfo.fromMap(beltMap) : null;
                          final photoUrl = data?['photoUrl'] as String?; // Assuming photoUrl field exists or will exist
            
                          return ProfileImageWidget(
                            radius: 18,
                            beltInfo: beltInfo,
                            photoUrl: photoUrl,
                          );
                        },
                        loading: () => const CircleAvatar(radius: 18, child: CircularProgressIndicator(strokeWidth: 2)),
                        error: (_, __) => const Icon(Icons.account_circle),
                      ),
                ),
              ),
            ),
        ],
      ),
      body: userProfileAsync.when(
        data: (snapshot) {
          if (!snapshot.exists) return const Center(child: Text('Perfil de usuario no encontrado'));
          
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _MissionsCard(missionsKey: missionsKey),
                const SizedBox(height: 16),
                _UpcomingClassesCard(classesKey: classesKey),
                const SizedBox(height: 24),
                Text(
                  AppLocalizations.of(context)!.recentActivity,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1565C0),
                      ),
                ),
                const SizedBox(height: 16),
                const Expanded(child: FeedScreen()),
                const SizedBox(height: 16), // Reduced padding since ads are gone
                // const AdBannerWidget(), // Ads disabled for now
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
  String _getRandomSplashText() {
    final splashes = [
      '¡Oss!',
      'La técnica vence a la fuerza.',
      'El tatami no miente.',
      'Entrena duro, lucha fácil.',
      'Jiu Jitsu para todos.',
      'Mantén la calma.',
      'Deja el ego en la puerta.',
      'Ganar o aprender.',
      'El sudor ahorra sangre.',
      'Respeta a tus compañeros.',
      'Cuida a tu uke.',
      'Fluye como el agua.',
      'Presión, presión, presión.',
      '¡A entrenar!',
    ];
    return splashes[DateTime.now().microsecond % splashes.length];
  }
}

class _MissionsCard extends ConsumerWidget {
  final GlobalKey? missionsKey;
  const _MissionsCard({this.missionsKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final missionsAsync = ref.watch(missionsStreamProvider);

    return missionsAsync.when(
      data: (missions) {
        final hasNew = missions.any((m) => m.isNew && !m.isCompleted);
        final allCompleted = missions.isNotEmpty && missions.every((m) => m.isCompleted);
        final completedCount = missions.where((m) => m.isCompleted).length;
        final totalCount = missions.length;

        return GestureDetector(
          key: missionsKey,
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => const MissionsModal(),
            );
          },
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: allCompleted 
                    ? [Colors.green.shade50, Colors.green.shade100]
                    : [const Color(0xFF1565C0).withOpacity(0.1), const Color(0xFF0D47A1).withOpacity(0.1)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: allCompleted ? Colors.green : const Color(0xFF1565C0),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      allCompleted ? Icons.check_circle : Icons.flag,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                'Misiones Semanales',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1565C0),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (hasNew)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Text(
                                  'NUEVA',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$completedCount de $totalCount completadas',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.grey[400],
                    size: 28,
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => Card(
        key: missionsKey,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Padding(
          padding: EdgeInsets.all(32.0),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _UpcomingClassesCard extends ConsumerWidget {
  final GlobalKey? classesKey;
  const _UpcomingClassesCard({this.classesKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileAsync = ref.watch(userProfileStreamProvider);

    return userProfileAsync.when(
      data: (snapshot) {
        if (!snapshot.exists) return const SizedBox.shrink();
        
        final data = snapshot.data() as Map<String, dynamic>;
        final trainingDays = List<int>.from(data['training_days'] ?? []);
        final trainingTime = data['training_time'] as String? ?? '18:00';
        
        if (trainingDays.isEmpty) return const SizedBox.shrink();

        // Get next upcoming classes (max 3)
        final upcoming = _getUpcomingClasses(trainingDays, trainingTime);
        if (upcoming.isEmpty) return const SizedBox.shrink();

        return Card(
          key: classesKey,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1565C0).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.calendar_today,
                        color: Color(0xFF1565C0),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Próximas Clases',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1565C0),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...upcoming.map((classInfo) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    children: [
                      Container(
                        width: 4,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1565C0),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              classInfo['day']!,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              classInfo['time']!,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (classInfo['isToday'] == true)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'HOY',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      if (classInfo['isTomorrow'] == true)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'MAÑANA',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                )).toList(),
              ],
            ),
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }

  List<Map<String, dynamic>> _getUpcomingClasses(List<int> trainingDays, String time) {
    final now = DateTime.now();
    final today = now.weekday; // 1 = Monday, 7 = Sunday
    final upcoming = <Map<String, dynamic>>[];

    // Parse training time
    final timeParts = time.split(':');
    final classHour = int.parse(timeParts[0]);
    final classMinute = int.parse(timeParts[1]);
    
    // Check if today's class has already passed
    final todayClassTime = DateTime(now.year, now.month, now.day, classHour, classMinute);
    final todayClassPassed = now.isAfter(todayClassTime);

    // Sort training days
    final sortedDays = List<int>.from(trainingDays)..sort();

    // Find next 3 occurrences
    int dayOffset = todayClassPassed ? 1 : 0; // Start from tomorrow if today's class passed
    
    for (int i = dayOffset; i < 7 && upcoming.length < 3; i++) {
      final checkDay = ((today - 1 + i) % 7) + 1; // Convert to 1-7 range
      if (sortedDays.contains(checkDay)) {
        final isToday = i == 0 && !todayClassPassed;
        final isTomorrow = i == 1 || (i == 0 && todayClassPassed);
        
        upcoming.add({
          'day': _getDayName(checkDay),
          'time': time,
          'isToday': isToday,
          'isTomorrow': isTomorrow && !isToday,
        });
      }
    }

    return upcoming;
  }

  String _getDayName(int day) {
    const days = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
    return days[day - 1];
  }
}

