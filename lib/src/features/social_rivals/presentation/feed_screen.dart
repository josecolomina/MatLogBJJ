import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../training_log/data/training_repository.dart';
import '../../training_log/domain/activity.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Ensure locale is initialized (this is usually done in main, but for safety here)
    // In a real app, use flutter_localizations
    final activitiesStream = ref.watch(trainingRepositoryProvider).getActivities();

    return StreamBuilder<List<Activity>>(
      stream: activitiesStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final activities = snapshot.data ?? [];

        if (activities.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history, size: 48, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text(
                  'No hay actividad reciente.',
                  style: TextStyle(color: Colors.grey[500]),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          itemCount: activities.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final activity = activities[index];
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFFE3F2FD),
                  child: Text(
                    activity.userName[0].toUpperCase(),
                    style: const TextStyle(
                      color: Color(0xFF1565C0),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  '${activity.userName} entrenó ${activity.type[0].toUpperCase()}${activity.type.substring(1).toLowerCase()}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.place_outlined, size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text(activity.academyName, style: TextStyle(color: Colors.grey[600])),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.timer_outlined, size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text('${activity.durationMinutes} min', style: TextStyle(color: Colors.grey[600])),
                          const SizedBox(width: 12),
                          Icon(Icons.speed, size: 14, color: Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text('RPE ${activity.rpe}', style: TextStyle(color: Colors.grey[600])),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        DateFormat.yMMMd('es').add_jm().format(activity.timestampStart),
                        style: TextStyle(color: Colors.grey[400], fontSize: 12),
                      ),
                    ],
                  ),
                ),
                trailing: activity.hasTechnicalNotes
                    ? const Icon(Icons.sticky_note_2_outlined, color: Color(0xFF1565C0))
                    : null,
              ),
            );
          },
        );
      },
    );
  }
}
