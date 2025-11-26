import 'package:flutter/material.dart';
import 'package:matlog/l10n/app_localizations.dart';
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

    final rivalsAsync = ref.watch(rivalsStreamProvider(user.uid));

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.rivalsTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: rivalsAsync.when(
        data: (rivals) {
          if (rivals.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!.noRivals,
                    style: TextStyle(color: Colors.grey[600], fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: rivals.length,
            itemBuilder: (context, index) {
              final rival = rivals[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ExpansionTile(
                  leading: CircleAvatar(
                    backgroundColor: const Color(0xFF1565C0),
                    child: Text(
                      rival.rivalName.substring(0, 1).toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    rival.rivalName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${rival.wins}W - ${rival.losses}L - ${rival.draws}D',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _MatchButton(
                            label: AppLocalizations.of(context)!.winLabel,
                            color: Colors.green,
                            icon: Icons.emoji_events,
                            onPressed: () => _logMatch(context, ref, user.uid, rival, 'win'),
                          ),
                          _MatchButton(
                            label: AppLocalizations.of(context)!.lossLabel,
                            color: Colors.red,
                            icon: Icons.close,
                            onPressed: () => _logMatch(context, ref, user.uid, rival, 'loss'),
                          ),
                          _MatchButton(
                            label: AppLocalizations.of(context)!.drawLabel,
                            color: Colors.orange,
                            icon: Icons.handshake,
                            onPressed: () => _logMatch(context, ref, user.uid, rival, 'draw'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text(AppLocalizations.of(context)!.errorLabel(err.toString()))),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showNewRivalDialog(context, ref, user.uid),
        icon: const Icon(Icons.add),
        label: Text(AppLocalizations.of(context)!.addRival),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
      ),
    );
  }

  Future<void> _showNewRivalDialog(BuildContext context, WidgetRef ref, String userId) async {
    final nameController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.newRivalTitle),
        content: TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.nameLabel,
            border: const OutlineInputBorder(),
          ),
          textCapitalization: TextCapitalization.sentences,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancelLabel),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                ref.read(rivalsRepositoryProvider).addRival(userId, nameController.text.trim());
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(AppLocalizations.of(context)!.addedRivalMessage(nameController.text.trim()))),
                );
              }
            },
            child: Text(AppLocalizations.of(context)!.saveLabel),
          ),
        ],
      ),
    );
  }

  Future<void> _logMatch(
    BuildContext context,
    WidgetRef ref,
    String userId,
    Rival rival,
    String result,
  ) async {
    await ref.read(rivalsRepositoryProvider).logMatch(userId, rival.rivalUid, result);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${AppLocalizations.of(context)!.matchVs} ${rival.rivalName}: $result')),
      );
    }
  }
}

class _MatchButton extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  final VoidCallback onPressed;

  const _MatchButton({
    required this.label,
    required this.color,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
