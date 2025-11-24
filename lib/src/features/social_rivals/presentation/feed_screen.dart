import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../training_log/data/training_repository.dart';
import '../../training_log/domain/activity.dart';
import 'package:intl/intl.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          return const Text('No recent activity.');
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: activities.length,
          itemBuilder: (context, index) {
            final activity = activities[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(activity.userName[0].toUpperCase()),
                ),
                title: Text('${activity.userName} trained ${activity.type.toUpperCase()}'),
                subtitle: Text(
                  '${activity.academyName} • ${activity.durationMinutes} min • RPE ${activity.rpe}\n${DateFormat.yMMMd().add_jm().format(activity.timestampStart)}',
                ),
                isThreeLine: true,
                trailing: activity.hasTechnicalNotes
                    ? const Icon(Icons.sticky_note_2, color: Colors.blue)
                    : null,
              ),
            );
          },
        );
      },
    );
  }
}
