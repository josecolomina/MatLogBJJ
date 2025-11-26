import 'package:flutter/material.dart';
import 'package:matlog/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../data/technique_repository.dart';
import '../domain/technique.dart';
import 'mastery_belt_widget.dart';

class TechniqueLibraryScreen extends ConsumerWidget {
  const TechniqueLibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final techniquesAsync = ref.watch(techniquesStreamProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.techniqueLibraryTitle),
      ),
      body: techniquesAsync.when(
        data: (techniques) {
          if (techniques.isEmpty) {
            return Center(
              child: Text(AppLocalizations.of(context)!.noTechniques),
            );
          }
          
          // Group by position or category? Let's just list them for now.
          return ListView.builder(
            itemCount: techniques.length,
            itemBuilder: (context, index) {
              final technique = techniques[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(technique.name),
                  subtitle: Text('${technique.position} • ${technique.category}'),
                  trailing: SizedBox(
                    width: 100,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MasteryBeltWidget(belt: technique.masteryBelt, height: 16, showLabel: false),
                        const SizedBox(height: 4),
                        Text('${technique.totalRepetitions} ${AppLocalizations.of(context)!.repetitionsLabel}', style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                  onTap: () {
                    // Navigate to detail
                    context.push('/techniques/${technique.id}');
                  },
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text(AppLocalizations.of(context)!.errorLabel(err.toString()))),
      ),
    );
  }
}

final techniquesStreamProvider = StreamProvider<List<Technique>>((ref) {
  final repository = ref.watch(techniqueRepositoryProvider);
  return repository.watchTechniques();
});
