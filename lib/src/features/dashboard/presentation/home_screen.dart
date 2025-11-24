import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../authentication/data/auth_repository.dart';
import '../../social_rivals/presentation/feed_screen.dart';
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
        title: const Text('MatLog Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.people),
            onPressed: () => context.push('/rivals'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authRepositoryProvider).signOut();
            },
          ),
        ],
      ),
      body: userProfileAsync.when(
        data: (snapshot) {
          if (!snapshot.exists) return const Center(child: Text('User profile not found'));
          final data = snapshot.data() as Map<String, dynamic>;
          final progress = data['weekly_goal_progress'] as int? ?? 0;
          final target = data['weekly_goal_target'] as int? ?? 3;
          final percent = (progress / target).clamp(0.0, 1.0);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Weekly Goal: $progress / $target', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                LinearProgressIndicator(value: percent, minHeight: 10),
                const SizedBox(height: 24),
                const Text('Recent Activity', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Expanded(child: SingleChildScrollView(child: FeedScreen())),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/check-in'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
