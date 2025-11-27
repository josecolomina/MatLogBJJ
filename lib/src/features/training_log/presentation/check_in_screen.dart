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

  @override
  void dispose() {
    _durationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final user = ref.read(authRepositoryProvider).currentUser;
        if (user == null) throw Exception('User not logged in');

        final activityId = const Uuid().v4();
        final now = DateTime.now();
        final hasNotes = _notesController.text.isNotEmpty;

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
          hasTechnicalNotes: hasNotes,
        );

        await ref.read(trainingRepositoryProvider).addActivity(activity);

        if (hasNotes) {
          // AI processing
          final geminiService = ref.read(geminiServiceProvider);
          final extractionService = ref.read(techniqueExtractionServiceProvider);
          
          Map<String, dynamic> aiResult = {'summary': '', 'techniques': []};
          try {
             aiResult = await geminiService.processTechnicalNote(_notesController.text);
          } catch (e) {
            print('AI Processing failed: $e');
            // Continue without AI data if it fails, or show error? 
            // For now, let's continue with empty techniques to not block saving.
          }

          final techniquesList = (aiResult['techniques'] as List? ?? []).map((t) {
            return ProcessedTechnique(
              techniqueName: t['name'] ?? 'Unknown',
              category: t['type'] ?? 'Drill',
              positionStart: t['position_start'] ?? 'Unknown',
              positionEnd: t['position_end'] ?? 'Unknown',
              tags: [],
              masteryLevel: 0, // Initial level
            );
          }).toList();
          
          final logId = const Uuid().v4();
          final technicalLog = TechnicalLog(
            logId: logId,
            activityRef: activityId,
            rawInputText: _notesController.text,
            processedTechniques: techniquesList,
            aiSummary: aiResult['summary'] ?? '',
            createdAt: now,
          );

          await ref.read(trainingRepositoryProvider).addTechnicalLog(user.uid, technicalLog);
          
          // Update Technique Library
          final leveledUpTechniques = await extractionService.processTechnicalLog(technicalLog, activity);
          
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
        }

        if (mounted) {
          HapticFeedback.mediumImpact(); // Haptic feedback for training logged
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.trainingLogged)),
          );
        }
      } catch (e) {
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
                maxLines: 5,
              ),
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
