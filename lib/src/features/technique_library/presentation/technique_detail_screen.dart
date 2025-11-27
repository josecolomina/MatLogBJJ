import 'package:flutter/material.dart';
import 'package:matlog/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/technique_repository.dart';
import '../domain/technique.dart';
import '../domain/mastery_belt.dart';
import 'mastery_belt_widget.dart';
import '../../profile/data/profile_repository.dart';
import '../../authentication/domain/belt_info.dart';

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

  // Convert BeltColor to MasteryBelt
  MasteryBelt _beltColorToMasteryBelt(BeltColor color) {
    switch (color) {
      case BeltColor.white:
        return MasteryBelt.white;
      case BeltColor.blue:
        return MasteryBelt.blue;
      case BeltColor.purple:
        return MasteryBelt.purple;
      case BeltColor.brown:
        return MasteryBelt.brown;
      case BeltColor.black:
        return MasteryBelt.black;
    }
  }

  // Get list of available belts up to user's belt
  List<MasteryBelt> _getAvailableBelts(BeltColor userBelt) {
    final userMasteryBelt = _beltColorToMasteryBelt(userBelt);
    final allBelts = MasteryBelt.values;
    return allBelts.where((belt) => belt.index <= userMasteryBelt.index).toList();
  }

  Future<void> _showBeltSelector(Technique technique, BeltColor userBelt) async {
    final availableBelts = _getAvailableBelts(userBelt);
    
    final selected = await showDialog<MasteryBelt>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Seleccionar Nivel'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: availableBelts.map((belt) {
            return ListTile(
              leading: MasteryBeltWidget(belt: belt, height: 24, showLabel: false),
              title: Text(_getBeltName(belt)),
              selected: belt == technique.masteryBelt,
              onTap: () => Navigator.of(context).pop(belt),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context)!.cancelLabel),
          ),
        ],
      ),
    );

    if (selected != null && selected != technique.masteryBelt) {
      final updated = technique.copyWith(masteryBelt: selected);
      await ref.read(techniqueRepositoryProvider).updateTechnique(updated);
      ref.invalidate(techniqueProvider(widget.techniqueId));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nivel actualizado')),
        );
      }
    }
  }

  String _getBeltName(MasteryBelt belt) {
    final l10n = AppLocalizations.of(context)!;
    switch (belt) {
      case MasteryBelt.white:
        return l10n.beltWhite;
      case MasteryBelt.blue:
        return l10n.beltBlue;
      case MasteryBelt.purple:
        return l10n.beltPurple;
      case MasteryBelt.brown:
        return l10n.beltBrown;
      case MasteryBelt.black:
        return l10n.beltBlack;
    }
  }

  @override
  Widget build(BuildContext context) {
    final techniqueAsync = ref.watch(techniqueProvider(widget.techniqueId));
    final userBeltAsync = ref.watch(userBeltInfoProvider);

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

          return userBeltAsync.when(
            data: (userBelt) => SingleChildScrollView(
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MasteryBeltWidget(belt: technique.masteryBelt, height: 40),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.edit, size: 20),
                              tooltip: 'Cambiar nivel',
                              onPressed: () => _showBeltSelector(technique, userBelt.color),
                            ),
                          ],
                        ),
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
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const Center(child: Text('Error loading user belt')),
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
