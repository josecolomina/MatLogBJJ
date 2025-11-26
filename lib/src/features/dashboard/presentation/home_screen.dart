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

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileAsync = ref.watch(userProfileProvider);

    // Check weekly goal on load
    ref.listen(dashboardControllerProvider, (_, __) {});
    // Trigger check (this is a bit hacky for a build method, better in init state or provider)
    // For MVP, we'll rely on the provider watching the stream or manual trigger
    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.people_outline),
          onPressed: () => context.push('/rivals'),
        ),
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
          IconButton(
            icon: const Icon(Icons.library_books),
            tooltip: 'Technique Library',
            onPressed: () => context.push('/techniques'),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
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
        ],
      ),
      body: userProfileAsync.when(
        data: (snapshot) {
          if (!snapshot.exists) return const Center(child: Text('Perfil de usuario no encontrado'));
          final data = snapshot.data() as Map<String, dynamic>;
          final progress = data['weekly_goal_progress'] as int? ?? 0;
          final target = data['weekly_goal_target'] as int? ?? 3;
          final percent = (progress / target).clamp(0.0, 1.0);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.weeklyGoal,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Icon(Icons.flag_outlined, color: Theme.of(context).primaryColor),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$progress',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6, left: 4),
                      child: Text(
                        '/ $target ${AppLocalizations.of(context)!.sessions}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: percent,
                    minHeight: 8,
                    backgroundColor: Colors.grey[100],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 32),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/check-in'),
        backgroundColor: const Color(0xFF1565C0),
        child: const Icon(Icons.add, color: Colors.white),
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
