import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../authentication/data/auth_repository.dart';
import '../../authentication/domain/belt_info.dart';
import '../../profile/data/profile_repository.dart';

import '../../notifications/data/notification_service.dart';
import '../../tutorial/data/tutorial_repository.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _nameController = TextEditingController();
  final _academyController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  BeltColor _selectedBelt = BeltColor.white;
  int _selectedStripes = 0;
  final List<int> _selectedWeekdays = [];
  TimeOfDay _selectedTime = const TimeOfDay(hour: 19, minute: 30);
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _academyController.dispose();
    super.dispose();
  }

  Future<void> _startTraining() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        // 1. Sign in anonymously
        final userCredential = await ref.read(authRepositoryProvider).signInAnonymously();
        
        // 2. Save profile data
        if (userCredential.user != null) {
          final beltInfo = BeltInfo(color: _selectedBelt, stripes: _selectedStripes);
          
          await ref.read(profileRepositoryProvider).updateProfile(
            name: _nameController.text.trim(),
            academy: _academyController.text.trim(),
            beltInfo: beltInfo,
            trainingDays: _selectedWeekdays,
            trainingTime: '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
          );

          // 3. Schedule Notifications
          if (_selectedWeekdays.isNotEmpty) {
            final notificationService = ref.read(notificationServiceProvider);
            await notificationService.requestPermissions();
            final reminderTime = TimeOfDay(
              hour: (_selectedTime.hour + 2) % 24,
              minute: _selectedTime.minute,
            );
            await notificationService.schedulePostTrainingNotification(
              time: reminderTime,
              weekdays: _selectedWeekdays,
            );
          }
          
          // 4. Check if tutorial has been completed
          final tutorialCompleted = await ref.read(tutorialRepositoryProvider).isTutorialCompleted();
          
          // DEBUG
          print('DEBUG: Tutorial completed: $tutorialCompleted');
          print('DEBUG: Will navigate to: ${tutorialCompleted ? "/home" : "/tutorial"}');
          
          if (mounted) {
            if (!tutorialCompleted) {
              // Show tutorial first, user is now authenticated
              print('DEBUG: Navigating to /tutorial');
              context.go('/tutorial');
            } else {
              // Go directly to home
              print('DEBUG: Navigating to /home');
              context.go('/home');
            }
          }
        }
      } catch (e) {
        print('DEBUG: Error during registration: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
          setState(() => _isLoading = false);
        }
      }
      // Don't set isLoading to false here - we're navigating away
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.shield_outlined, size: 80, color: Color(0xFF1565C0)),
                  const SizedBox(height: 24),
                  Text(
                    'Bienvenido a MatLog',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: const Color(0xFF1565C0),
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Configura tu perfil para empezar',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 48),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre',
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, introduce tu nombre';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _academyController,
                    decoration: const InputDecoration(
                      labelText: 'Academia / Equipo',
                      prefixIcon: Icon(Icons.shield_outlined),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, introduce tu academia';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<BeltColor>(
                          value: _selectedBelt,
                          decoration: const InputDecoration(
                            labelText: 'Cinturón',
                            prefixIcon: Icon(Icons.military_tech),
                          ),
                          items: BeltColor.values.map((belt) {
                            return DropdownMenuItem(
                              value: belt,
                              child: Text(belt.displayName),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedBelt = value;
                                // Reset stripes if switching to/from black belt with incompatible value
                                if (_selectedBelt == BeltColor.black && _selectedStripes >= 10) {
                                  _selectedStripes = 0;
                                } else if (_selectedBelt != BeltColor.black && _selectedStripes >= 5) {
                                  _selectedStripes = 0;
                                }
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<int>(
                          value: _selectedStripes,
                          decoration: const InputDecoration(
                            labelText: 'Grados',
                            prefixIcon: Icon(Icons.linear_scale),
                          ),
                          items: List.generate(
                            _selectedBelt == BeltColor.black ? 10 : 5,
                            (index) {
                              return DropdownMenuItem(
                                value: index,
                                child: Text('$index'),
                              );
                            },
                          ),
                          onChanged: (value) {
                            if (value != null) setState(() => _selectedStripes = value);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Tu Rutina de Entrenamiento',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Te recordaremos registrar tu progreso estos días.',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    children: List.generate(7, (index) {
                      final dayIndex = index + 1; // 1 = Monday
                      final isSelected = _selectedWeekdays.contains(dayIndex);
                      final dayName = ['L', 'M', 'X', 'J', 'V', 'S', 'D'][index];
                      return FilterChip(
                        label: Text(dayName),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedWeekdays.add(dayIndex);
                            } else {
                              _selectedWeekdays.remove(dayIndex);
                            }
                          });
                        },
                        selectedColor: const Color(0xFF1565C0).withValues(alpha: 0.2),
                        checkmarkColor: const Color(0xFF1565C0),
                        labelStyle: TextStyle(
                          color: isSelected ? const Color(0xFF1565C0) : Colors.black,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: const Text('Hora habitual de clase'),
                    subtitle: Text(_selectedTime.format(context)),
                    trailing: const Icon(Icons.access_time),
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: _selectedTime,
                      );
                      if (time != null) {
                        setState(() => _selectedTime = time);
                      }
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Color(0xFFE0E0E0)),
                    ),
                  ),
                  const SizedBox(height: 40),
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: _startTraining,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Empezar a Entrenar'),
                        ),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () => context.go('/login'),
                    child: const Text('¿Ya tienes cuenta? Inicia sesión'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
