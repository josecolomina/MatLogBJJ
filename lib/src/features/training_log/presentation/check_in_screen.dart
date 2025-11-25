import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../authentication/data/auth_repository.dart';
import '../data/training_repository.dart';
import '../../../services/gemini_service.dart';
import '../domain/activity.dart';
import '../domain/technical_log.dart';

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

        // Process notes with AI if present
        String aiSummary = '';
        List<ProcessedTechnique> techniques = [];

        if (hasNotes) {
          // AI processing disabled for now
          // final result = await ref.read(geminiServiceProvider).processTechnicalNote(_notesController.text);
          
          final logId = const Uuid().v4();
          final technicalLog = TechnicalLog(
            logId: logId,
            activityRef: activityId,
            rawInputText: _notesController.text,
            processedTechniques: [], // No AI processing
            aiSummary: '', // No AI summary
            createdAt: now,
          );

          await ref.read(trainingRepositoryProvider).addTechnicalLog(user.uid, technicalLog);
        }

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

        if (mounted) {
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Training logged successfully!')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.toString()}')),
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
      appBar: AppBar(title: const Text('Check-in')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: _selectedType,
                items: ['gi', 'nogi', 'open_mat', 'seminar']
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type.toUpperCase()),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _selectedType = value!),
                decoration: const InputDecoration(labelText: 'Type'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _durationController,
                decoration: const InputDecoration(labelText: 'Duration (minutes)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  if (int.tryParse(value) == null) return 'Invalid number';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Text('RPE (Intensity): ${_rpe.round()}'),
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
                decoration: const InputDecoration(
                  labelText: 'What did you learn today?',
                  hintText: 'Describe techniques, drills, or sparring notes...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submit,
                      child: const Text('Save Training'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
