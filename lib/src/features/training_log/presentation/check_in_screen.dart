import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:matlog/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../authentication/data/auth_repository.dart';
import '../data/training_repository.dart';
import '../domain/activity.dart';
import '../domain/technical_log.dart';
import '../../../services/gemini_service.dart';
import '../../technique_library/domain/technique_extraction_service.dart';
import '../../technique_library/presentation/level_up_dialog.dart';

// ... (existing imports)



class CheckInScreen extends ConsumerStatefulWidget {
  const CheckInScreen({super.key});

  @override
  ConsumerState<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends ConsumerState<CheckInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _durationController = TextEditingController(text: '60');
  final _notesController = TextEditingController();
  String _selectedType = 'gi';
  double _rpe = 5.0;
  bool _isLoading = false;

  // Manual Technique Entry State
  final List<Map<String, dynamic>> _manualTechniques = [];

  @override
  void dispose() {
    _durationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _addTechnique() {
    setState(() {
      _manualTechniques.add({
        'name': '',
        'position': 'Guard',
        'type': 'Drill',
      });
    });
  }

  void _removeTechnique(int index) {
    setState(() {
      _manualTechniques.removeAt(index);
    });
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      print('🕵️ SPY: User tapped submit. Validating form...');
      setState(() => _isLoading = true);
      try {
        final user = ref.read(authRepositoryProvider).currentUser;
        if (user == null) {
          print('🕵️ SPY: Error - User not logged in.');
          throw Exception('User not logged in');
        }
        print('🕵️ SPY: User authenticated: ${user.uid}');

        final activityId = const Uuid().v4();
        final now = DateTime.now();
        final hasNotes = _notesController.text.isNotEmpty;
        final hasTechniques = _manualTechniques.isNotEmpty;

        // Create Activity first
        final activity = Activity(
          activityId: activityId,
          userId: user.uid,
          userName: user.displayName ?? 'Unknown',
          userRank: 'white', // TODO: Get from user profile
          academyName: 'Default Academy', // TODO: Get from user profile
          timestampStart: now,
          durationMinutes: int.parse(_durationController.text),
          type: _selectedType,
          rpe: _rpe.round(),
          likesCount: 0,
          hasTechnicalNotes: hasNotes || hasTechniques,
        );

        print('🕵️ SPY: Adding activity to repository: $activityId');
        await ref.read(trainingRepositoryProvider).addActivity(activity);
        print('🕵️ SPY: Activity added successfully.');

        if (hasNotes || hasTechniques) {
          print('🕵️ SPY: Notes or Techniques detected. Processing...');
          
          final extractionService = ref.read(techniqueExtractionServiceProvider);
          
          // Manual Processing (Bypassing AI)
          final techniquesList = _manualTechniques.map((t) {
            return ProcessedTechnique(
              techniqueName: t['name'] ?? 'Unknown',
              category: t['type'] ?? 'Drill',
              positionStart: t['position'] ?? 'Unknown',
              positionEnd: 'Unknown', // Not capturing end position manually for now
              tags: [],
              masteryLevel: 0, // Initial level
            );
          }).toList();
          
          final logId = const Uuid().v4();
          final technicalLog = TechnicalLog(
            logId: logId,
            activityRef: activityId,
            rawInputText: _notesController.text, // Keep notes for reference
            processedTechniques: techniquesList,
            aiSummary: 'Manual Entry',
            createdAt: now,
          );

          print('🕵️ SPY: Saving technical log: $logId with ${techniquesList.length} techniques');
          await ref.read(trainingRepositoryProvider).addTechnicalLog(user.uid, technicalLog);
          
          // Update Technique Library & Missions
          print('🕵️ SPY: Updating technique library and missions...');
          final leveledUpTechniques = await extractionService.processTechnicalLog(technicalLog, activity);
          print('🕵️ SPY: Technique library updated. Level ups: ${leveledUpTechniques.length}');
          
          if (mounted && leveledUpTechniques.isNotEmpty) {
             // Show level up dialogs sequentially or just the first one for now
             for (final technique in leveledUpTechniques) {
               HapticFeedback.mediumImpact(); // Haptic feedback for level up
               await showDialog(
                 context: context,
                 builder: (context) => LevelUpDialog(technique: technique),
               );
             }
          }
        } else {
          print('🕵️ SPY: No notes or techniques provided.');
        }

        if (mounted) {
          print('🕵️ SPY: Submission complete. Closing screen.');
          HapticFeedback.mediumImpact(); // Haptic feedback for training logged
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.trainingLogged)),
          );
        }
      } catch (e) {
        print('🕵️ SPY: Critical error during submission: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.errorLabel(e.toString()))),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.checkInTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedType,
                    isExpanded: true,
                    icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF1565C0)),
                    items: ['Gi', 'Nogi', 'Open mat', 'Seminario']
                        .map((type) => DropdownMenuItem(
                              value: type.toLowerCase().replaceAll(' ', '_'),
                              child: Text(
                                type,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ))
                        .toList(),
                    onChanged: (value) => setState(() => _selectedType = value!),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _durationController,
                decoration: InputDecoration(labelText: '${AppLocalizations.of(context)!.durationLabel} (min)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  if (int.tryParse(value) == null) return 'Invalid number';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Text('${AppLocalizations.of(context)!.rpeLabel}: ${_rpe.round()}'),
              Slider(
                value: _rpe,
                min: 1,
                max: 10,
                divisions: 9,
                label: _rpe.round().toString(),
                onChanged: (value) => setState(() => _rpe = value),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.trainingNotes,
                  hintText: '...',
                  border: const OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              
              // Manual Technique Entry Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Técnicas',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: Color(0xFF1565C0)),
                    onPressed: _addTechnique,
                  ),
                ],
              ),
              if (_manualTechniques.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('No techniques added yet.', style: TextStyle(color: Colors.grey)),
                ),
              ..._manualTechniques.asMap().entries.map((entry) {
                final index = entry.key;
                final technique = entry.value;
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                initialValue: technique['name'],
                                decoration: const InputDecoration(labelText: 'Nombre (e.g. Armbar)'),
                                onChanged: (val) => technique['name'] = val,
                                validator: (val) => val!.isEmpty ? 'Required' : null,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _removeTechnique(index),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: technique['position'],
                                items: ['Guard', 'Side Control', 'Mount', 'Back', 'Standing']
                                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                                    .toList(),
                                onChanged: (val) => setState(() => technique['position'] = val),
                                decoration: const InputDecoration(labelText: 'Posición'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: technique['type'],
                                items: ['Drill', 'Sparring', 'Submission', 'Pass', 'Sweep', 'Escape']
                                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                                    .toList(),
                                onChanged: (val) => setState(() => technique['type'] = val),
                                decoration: const InputDecoration(labelText: 'Tipo'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),

              const SizedBox(height: 24),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submit,
                      child: Text(AppLocalizations.of(context)!.saveLabel),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
