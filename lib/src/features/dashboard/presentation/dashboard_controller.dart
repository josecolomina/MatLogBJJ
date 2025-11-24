import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../authentication/data/auth_repository.dart';

class DashboardController extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  DashboardController(this._ref) : super(const AsyncValue.data(null));

  Future<void> checkWeeklyGoal() async {
    final user = _ref.read(authRepositoryProvider).currentUser;
    if (user == null) return;

    final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    if (!userDoc.exists) return;

    final data = userDoc.data()!;
    final lastActivityWeek = data['last_activity_week'] as String?;
    final currentWeek = _getCurrentWeek();

    if (lastActivityWeek != currentWeek) {
      // Reset progress for new week
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'weekly_goal_progress': 0,
        'last_activity_week': currentWeek,
      });
    }
  }

  String _getCurrentWeek() {
    final now = DateTime.now();
    // Simple ISO week calculation (simplified)
    final dayOfYear = int.parse("${now.year}${now.difference(DateTime(now.year, 1, 1)).inDays + 1}");
    final week = (dayOfYear / 7).ceil();
    return "${now.year}-W$week";
  }
}

final dashboardControllerProvider = StateNotifierProvider<DashboardController, AsyncValue<void>>((ref) {
  return DashboardController(ref);
});

final userProfileProvider = StreamProvider<DocumentSnapshot>((ref) {
  final user = ref.watch(authRepositoryProvider).currentUser;
  if (user == null) return const Stream.empty();
  return FirebaseFirestore.instance.collection('users').doc(user.uid).snapshots();
});
