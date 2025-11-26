import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../authentication/domain/belt_info.dart';
import 'package:matlog/src/common_widgets/belt_display_widget.dart';
import '../../authentication/data/auth_repository.dart';
import '../data/profile_repository.dart';
import '../../notifications/data/notification_service.dart';
import '../../dashboard/presentation/dashboard_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  BeltColor? _selectedBelt;
  int? _selectedStripes;
  bool _isLoading = false;
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );
      
      if (image != null) {
        setState(() {
          _profileImage = File(image.path);
        });
        // TODO: Upload to Firebase Storage in future
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al seleccionar imagen: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final beltInfoAsync = ref.watch(userBeltInfoProvider);
    final userProfileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
      ),
      body: userProfileAsync.when(
        data: (snapshot) {
          final data = snapshot.data() as Map<String, dynamic>? ?? {};
          return beltInfoAsync.when(
            data: (currentBelt) {
              // Initialize state with current values if not set
              _selectedBelt ??= currentBelt.color;
              _selectedStripes ??= currentBelt.stripes;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: _pickImage,
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 60,
                                  backgroundColor: const Color(0xFFE0E0E0),
                                  backgroundImage: _profileImage != null 
                                      ? FileImage(_profileImage!) 
                                      : null,
                                  child: _profileImage == null
                                      ? const Icon(Icons.person, size: 70, color: Colors.grey)
                                      : null,
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF1565C0),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 4,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Tu Cinturón Actual',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 12),
                          BeltDisplayWidget(
                            beltInfo: BeltInfo(
                              color: _selectedBelt!,
                              stripes: _selectedStripes!,
                            ),
                            height: 60,
                            width: 280,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${_selectedBelt!.displayName} - $_selectedStripes ${_selectedStripes == 1 ? "grado" : "grados"}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (ref.read(authRepositoryProvider).currentUser?.isAnonymous ?? false)
                      Card(
                        margin: const EdgeInsets.only(bottom: 32),
                        elevation: 0,
                        color: Colors.blue.shade50,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.blue.shade100),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.cloud_upload_outlined, color: Color(0xFF1565C0)),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'Guarda tu progreso',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1565C0),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Asocia tu cuenta a un correo electrónico para no perder tus datos si cambias de dispositivo.',
                                style: TextStyle(fontSize: 14, color: Colors.black87),
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () => _showLinkAccountDialog(context, ref),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF1565C0),
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                  ),
                                  child: const Text('Vincular Correo'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 8),
                    const Text(
                      'Editar Progreso',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: DropdownButtonFormField<BeltColor>(
                        value: _selectedBelt,
                        decoration: InputDecoration(
                          labelText: 'Cinturón',
                          labelStyle: const TextStyle(
                            color: Color(0xFF1565C0),
                            fontWeight: FontWeight.w600,
                          ),
                          prefixIcon: const Icon(
                            Icons.sports_martial_arts,
                            color: Color(0xFF1565C0),
                            size: 28,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 20,
                          ),
                        ),
                        items: BeltColor.values.map((belt) {
                          return DropdownMenuItem(
                            value: belt,
                            child: Text(
                              belt.displayName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) setState(() => _selectedBelt = value);
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: DropdownButtonFormField<int>(
                        value: _selectedStripes,
                        decoration: InputDecoration(
                          labelText: 'Grados',
                          labelStyle: const TextStyle(
                            color: Color(0xFF1565C0),
                            fontWeight: FontWeight.w600,
                          ),
                          prefixIcon: const Icon(
                            Icons.linear_scale,
                            color: Color(0xFF1565C0),
                            size: 28,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 20,
                          ),
                        ),
                        items: List.generate(5, (index) {
                          return DropdownMenuItem(
                            value: index,
                            child: Text(
                              '$index',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }),
                        onChanged: (value) {
                          if (value != null) setState(() => _selectedStripes = value);
                        },
                      ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF1565C0).withValues(alpha: 0.3),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: () => _saveProfile(ref),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: const Text(
                                  'Guardar Cambios',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Notificaciones y Horarios',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    _buildScheduleSection(context, ref, data),
                    const SizedBox(height: 32),
                  ],
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildScheduleSection(BuildContext context, WidgetRef ref, Map<String, dynamic> data) {
    final trainingDays = List<int>.from(data['training_days'] ?? []);
    final trainingTimeStr = data['training_time'] as String? ?? '19:30';
    final timeParts = trainingTimeStr.split(':');
    final trainingTime = TimeOfDay(
      hour: int.parse(timeParts[0]),
      minute: int.parse(timeParts[1]),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Días de entrenamiento',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: List.generate(7, (index) {
            final dayIndex = index + 1;
            final isSelected = trainingDays.contains(dayIndex);
            final dayName = ['L', 'M', 'X', 'J', 'V', 'S', 'D'][index];
            return FilterChip(
              label: Text(dayName),
              selected: isSelected,
              onSelected: (selected) async {
                final newDays = List<int>.from(trainingDays);
                if (selected) {
                  newDays.add(dayIndex);
                } else {
                  newDays.remove(dayIndex);
                }
                await _updateSchedule(ref, newDays, trainingTime);
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
          contentPadding: EdgeInsets.zero,
          title: const Text('Hora habitual de clase'),
          subtitle: Text(trainingTime.format(context)),
          trailing: const Icon(Icons.edit),
          onTap: () async {
            final time = await showTimePicker(
              context: context,
              initialTime: trainingTime,
            );
            if (time != null) {
              await _updateSchedule(ref, trainingDays, time);
            }
          },
        ),
      ],
    );
  }

  Future<void> _updateSchedule(
    WidgetRef ref,
    List<int> days,
    TimeOfDay time,
  ) async {
    try {
      // 1. Update Firestore
      await ref.read(profileRepositoryProvider).updateSchedule(
            trainingDays: days,
            trainingTime: '${time.hour}:${time.minute}',
          );

      // 2. Update Notifications
      final notificationService = ref.read(notificationServiceProvider);
      await notificationService.requestPermissions();
      
      if (days.isEmpty) {
        await notificationService.cancelAllNotifications();
      } else {
        final reminderTime = TimeOfDay(
          hour: (time.hour + 2) % 24,
          minute: time.minute,
        );
        await notificationService.schedulePostTrainingNotification(
          time: reminderTime,
          weekdays: days,
        );
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Horario actualizado')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _saveProfile(WidgetRef ref) async {
    if (_selectedBelt == null || _selectedStripes == null) return;

    setState(() => _isLoading = true);
    try {
      await ref.read(profileRepositoryProvider).updateBeltInfo(
            BeltInfo(color: _selectedBelt!, stripes: _selectedStripes!),
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Perfil actualizado correctamente')),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al actualizar: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showLinkAccountDialog(BuildContext context, WidgetRef ref) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool isLinking = false;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Asegurar Cuenta'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Introduce un email' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: 'Contraseña'),
                  obscureText: true,
                  validator: (value) =>
                      (value?.length ?? 0) < 6 ? 'Mínimo 6 caracteres' : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            isLinking
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        setState(() => isLinking = true);
                        try {
                          await ref
                              .read(authRepositoryProvider)
                              .convertAnonymousToPermanent(
                                emailController.text.trim(),
                                passwordController.text.trim(),
                              );
                          if (context.mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('¡Cuenta asegurada con éxito!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            // Force rebuild to hide the warning
                            setState(() {}); 
                          }
                        } catch (e) {
                          if (context.mounted) {
                            setState(() => isLinking = false);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: $e')),
                            );
                          }
                        }
                      }
                    },
                    child: const Text('Vincular'),
                  ),
          ],
        ),
      ),
    );
  }
}
