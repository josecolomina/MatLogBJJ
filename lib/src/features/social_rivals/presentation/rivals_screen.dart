import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../authentication/data/auth_repository.dart';
import '../data/rivals_repository.dart';
import '../domain/rival.dart';

class RivalsScreen extends ConsumerWidget {
  const RivalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authRepositoryProvider).currentUser;
    if (user == null) return const Center(child: Text('Please login'));

    final rivalsStream = ref.watch(rivalsRepositoryProvider).getRivals(user.uid);

    return Scaffold(
      appBar: AppBar(title: const Text('Rivals')),
      body: StreamBuilder<List<Rival>>(
        stream: rivalsStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final rivals = snapshot.data ?? [];

          if (rivals.isEmpty) {
            return const Center(child: Text('No rivals yet. Add a match!'));
          }

          return ListView.builder(
            itemCount: rivals.length,
            itemBuilder: (context, index) {
              final rival = rivals[index];
              return ListTile(
                title: Text(rival.rivalName),
                subtitle: Text('W: ${rival.wins} - L: ${rival.losses} - D: ${rival.draws}'),
                trailing: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _showAddMatchDialog(context, ref, user.uid, rival),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNewRivalDialog(context, ref, user.uid),
        child: const Icon(Icons.person_add),
      ),
    );
  }

  void _showAddMatchDialog(BuildContext context, WidgetRef ref, String userId, Rival rival) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Match vs ${rival.rivalName}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('I Won'),
              onTap: () {
                ref.read(rivalsRepositoryProvider).addMatchResult(userId, rival.rivalUid, rival.rivalName, 'win');
                context.pop();
              },
            ),
            ListTile(
              title: const Text('I Lost'),
              onTap: () {
                ref.read(rivalsRepositoryProvider).addMatchResult(userId, rival.rivalUid, rival.rivalName, 'loss');
                context.pop();
              },
            ),
            ListTile(
              title: const Text('Draw'),
              onTap: () {
                ref.read(rivalsRepositoryProvider).addMatchResult(userId, rival.rivalUid, rival.rivalName, 'draw');
                context.pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showNewRivalDialog(BuildContext context, WidgetRef ref, String userId) {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Rival'),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Rival Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // For MVP, using name as ID is risky but simple. Ideally select from users.
              // Here we just create a dummy ID based on name for simplicity if not selecting real users.
              // But PRD says "Select Rival (List of friends)".
              // For now, we'll just allow adding by name and generating a random ID or using name.
              final name = nameController.text.trim();
              if (name.isNotEmpty) {
                // We don't have a "friends" list implemented yet, so we just add a "rival" by name.
                // We'll treat this as registering a new rival.
                // To actually "add" them to the list, we need to record a match or just create the doc.
                // The repository addMatchResult creates if not exists.
                // So we can just trigger a match or create a method to add without match.
                // For MVP, let's just add a match immediately or create a dummy match?
                // Or better, update repo to allow creating rival without match.
                // For now, let's just close and let user add match from list? No, list is empty.
                // So we need to add match to create rival.
                _showAddMatchDialog(context, ref, userId, Rival(
                  rivalUid: name.toLowerCase().replaceAll(' ', '_'), // Dummy ID
                  rivalName: name,
                  wins: 0,
                  losses: 0,
                  draws: 0,
                  lastRolledAt: DateTime.now(),
                  notes: '',
                ));
              }
            },
            child: const Text('Next'),
          ),
        ],
      ),
    );
  }
}
