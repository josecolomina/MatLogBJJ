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
      appBar: AppBar(title: const Text('Amigos')),
      body: StreamBuilder<List<Rival>>(
        stream: rivalsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final rivals = snapshot.data ?? [];

          if (rivals.isEmpty) {
            return const Center(child: Text('Aún no tienes amigos. ¡Añade uno!'));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: rivals.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final rival = rivals[index];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFFE3F2FD),
                    child: Text(
                      rival.rivalName[0].toUpperCase(),
                      style: const TextStyle(
                        color: Color(0xFF1565C0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    rival.rivalName,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      'V: ${rival.wins} - D: ${rival.losses} - E: ${rival.draws}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.add_circle_outline, color: Color(0xFF1565C0)),
                    onPressed: () => _showAddMatchDialog(context, ref, user.uid, rival),
                  ),
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
      builder: (context) {
        return AlertDialog(
          title: Text('Combate vs ${rival.rivalName}'),
          content: const Text('¿Cuál fue el resultado?'),
          actions: [
            TextButton(
              onPressed: () {
                ref.read(rivalsRepositoryProvider).addMatchResult(userId, rival.rivalUid, rival.rivalName, 'win');
                Navigator.of(context).pop();
              },
              child: const Text('Victoria'),
            ),
            TextButton(
              onPressed: () {
                ref.read(rivalsRepositoryProvider).addMatchResult(userId, rival.rivalUid, rival.rivalName, 'loss');
                Navigator.of(context).pop();
              },
              child: const Text('Derrota'),
            ),
            TextButton(
              onPressed: () {
                ref.read(rivalsRepositoryProvider).addMatchResult(userId, rival.rivalUid, rival.rivalName, 'draw');
                Navigator.of(context).pop();
              },
              child: const Text('Empate'),
            ),
          ],
        );
      },
    );
  }

  void _showNewRivalDialog(BuildContext context, WidgetRef ref, String userId) {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nuevo Amigo'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Nombre del amigo'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final name = nameController.text.trim();
                if (name.isNotEmpty) {
                  // TODO: Implement proper friend system.
                  // For now, we reuse the "rival" logic but call it "friend/amigo" in UI.
                  // We'll treat this as registering a new rival/friend.
                  // Currently, the backend requires adding a match to create a rival document
                  // if it doesn't exist, or we can just create it.
                  // For simplicity in this prototype, we'll trigger a "draw" match 
                  // or just update the logic later.
                  // Let's just add a dummy match to initialize the friend for now
                  // Or better, update repo to allow creating rival without match.
                  
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
        );
      },
    );
  }
}
