import 'package:flutter/material.dart';
import 'package:matlog/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:matlog/src/features/authentication/data/auth_repository.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:matlog/src/features/training_log/data/training_repository.dart';
import '../../subscription/presentation/paywall_screen.dart';
import '../../profile/presentation/profile_screen.dart';
import '../../dashboard/presentation/dashboard_controller.dart';
import '../../authentication/domain/belt_info.dart';
import 'package:matlog/src/common_widgets/profile_image_widget.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      // Handle error
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settingsTitle),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                _SectionHeader(title: AppLocalizations.of(context)!.accountSection),
                ListTile(
                  leading: SizedBox(
                    width: 40,
                    height: 40,
                    child: Consumer(
                      builder: (context, ref, child) {
                        return ref.watch(userProfileProvider).when(
                              data: (snapshot) {
                                final data = snapshot.data() as Map<String, dynamic>?;
                                final beltMap = data?['belt_info'] as Map<String, dynamic>?;
                                final beltInfo = beltMap != null ? BeltInfo.fromMap(beltMap) : null;
                                final photoUrl = data?['photoUrl'] as String?;

                                return ProfileImageWidget(
                                  radius: 20,
                                  beltInfo: beltInfo,
                                  photoUrl: photoUrl,
                                );
                              },
                              loading: () => const CircularProgressIndicator(),
                              error: (_, __) => const Icon(Icons.person, color: Colors.blue),
                            );
                      },
                    ),
                  ),
                  title: Text(AppLocalizations.of(context)!.profileTitle),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const ProfileScreen()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.star, color: Colors.amber),
                  title: Text(AppLocalizations.of(context)!.manageSubscription),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const PaywallScreen()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: Text(AppLocalizations.of(context)!.signOut),
                  onTap: () {
                    ref.read(authRepositoryProvider).signOut();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete_forever, color: Colors.red),
                  title: Text(AppLocalizations.of(context)!.deleteAccount, style: const TextStyle(color: Colors.red)),
                  onTap: () {
                    _showDeleteConfirmation(context, ref);
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () => _launchUrl('https://matlog-app.web.app/privacy'),
                      child: Text(AppLocalizations.of(context)!.privacyPolicy, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ),
                    const Text('|', style: TextStyle(color: Colors.grey)),
                    TextButton(
                      onPressed: () => _launchUrl('https://matlog-app.web.app/terms'),
                      child: Text(AppLocalizations.of(context)!.termsOfService, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ),
                  ],
                ),
                Text(
                  '${AppLocalizations.of(context)!.versionLabel} 1.0.0',
                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account?'),
        content: const Text(
          'This action is irreversible. All your training logs and data will be permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(context); // Close dialog
              try {
                await ref.read(authRepositoryProvider).deleteAccount();
                // Auth state change will handle navigation
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error deleting account: $e')),
                  );
                }
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Future<void> _exportData(BuildContext context, WidgetRef ref) async {
    try {
      final user = ref.read(authRepositoryProvider).currentUser;
      if (user == null) return;

      // Show loading indicator
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Generating export...')),
        );
      }

      final activities = await ref
          .read(trainingRepositoryProvider)
          .getUserActivitiesJson(user.uid);

      final jsonString = jsonEncode(activities);
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/matlog_export.json');
      await file.writeAsString(jsonString);

      if (context.mounted) {
        await Share.shareXFiles([XFile(file.path)], text: 'My MatLog Training Data');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error exporting data: $e')),
        );
      }
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
