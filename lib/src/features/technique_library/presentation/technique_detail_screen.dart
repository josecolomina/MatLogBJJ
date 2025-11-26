import 'package:flutter/material.dart';
import 'package:matlog/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/technique_repository.dart';
import '../domain/technique.dart';
import '../domain/mastery_belt.dart';
import 'mastery_belt_widget.dart';

class TechniqueDetailScreen extends ConsumerStatefulWidget {
  final String techniqueId;

  const TechniqueDetailScreen({super.key, required this.techniqueId});

  @override
  ConsumerState<TechniqueDetailScreen> createState() => _TechniqueDetailScreenState();
}

class _TechniqueDetailScreenState extends ConsumerState<TechniqueDetailScreen> {
  late TextEditingController _notesController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final techniqueAsync = ref.watch(techniqueProvider(widget.techniqueId));

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.techniqueDetailTitle),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: () async {
              if (_isEditing) {
                // Save
                final technique = techniqueAsync.value;
                if (technique != null) {
                  final updated = technique.copyWith(notes: _notesController.text);
                  await ref.read(techniqueRepositoryProvider).updateTechnique(updated);
                  // Refresh provider? It should auto-update if using stream, 
                  // but here we used future provider for single fetch or stream?
                  // Let's assume stream or invalidate.
                  ref.invalidate(techniqueProvider(widget.techniqueId));
                }
              } else {
                // Start editing
                if (techniqueAsync.value != null) {
                  _notesController.text = techniqueAsync.value!.notes;
                }
              }
              setState(() => _isEditing = !_isEditing);
            },
          ),
        ],
      ),
      body: techniqueAsync.when(
        data: (technique) {
          if (technique == null) return const Center(child: Text('Technique not found'));
          
          // Initialize controller if not editing and empty (first load)
          if (!_isEditing && _notesController.text.isEmpty) {
             _notesController.text = technique.notes;
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      Text(technique.name, style: Theme.of(context).textTheme.headlineMedium),
                      const SizedBox(height: 8),
                      Text('${technique.position} • ${technique.category}', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 16),
                      MasteryBeltWidget(belt: technique.masteryBelt, height: 40),
                      const SizedBox(height: 8),
                      Text('${technique.totalRepetitions} ${AppLocalizations.of(context)!.repetitionsLabel}', style: Theme.of(context).textTheme.bodyLarge),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Text(AppLocalizations.of(context)!.notesLabel, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                _isEditing
                    ? TextField(
                        controller: _notesController,
                        maxLines: 10,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: '...',
                        ),
                      )
                    : Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Text(
                          technique.notes.isEmpty ? '-' : technique.notes,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }
}

final techniqueProvider = FutureProvider.family<Technique?, String>((ref, id) {
  final repository = ref.watch(techniqueRepositoryProvider);
  return repository.getTechnique(id);
});
