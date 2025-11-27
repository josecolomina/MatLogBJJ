import 'package:flutter/material.dart';
import 'package:matlog/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../data/technique_repository.dart';
import '../domain/technique.dart';
import 'mastery_belt_widget.dart';
import '../../tutorial/presentation/tutorial_keys.dart';

class TechniqueLibraryScreen extends ConsumerWidget {
  final GlobalKey? addTrainingFabKey;
  const TechniqueLibraryScreen({super.key, this.addTrainingFabKey});

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
          
          // Group techniques by category
          final groupedTechniques = <String, List<Technique>>{};
          for (var technique in techniques) {
            final category = technique.category.isEmpty ? 'Otros' : technique.category;
            if (!groupedTechniques.containsKey(category)) {
              groupedTechniques[category] = [];
            }
            groupedTechniques[category]!.add(technique);
          }
          
          final sortedCategories = groupedTechniques.keys.toList()..sort();

          return ListView.builder(
            itemCount: sortedCategories.length,
            itemBuilder: (context, index) {
              final category = sortedCategories[index];
              final categoryTechniques = groupedTechniques[category]!;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 2,
                child: ExpansionTile(
                  shape: const Border(),
                  collapsedShape: const Border(),
                  title: Text(
                    category,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF1565C0)),
                  ),
                  initiallyExpanded: true,
                  children: categoryTechniques.map((technique) {
                    return ListTile(
                      title: Text(technique.name, style: const TextStyle(fontWeight: FontWeight.w500)),
                      subtitle: Text(technique.position),
                      trailing: SizedBox(
                        width: 100,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MasteryBeltWidget(belt: technique.masteryBelt, height: 12, showLabel: false),
                            const SizedBox(height: 4),
                            Text('${technique.totalRepetitions} reps', style: Theme.of(context).textTheme.bodySmall),
                          ],
                        ),
                      ),
                      onTap: () => context.push('/techniques/${technique.id}'),
                    );
                  }).toList(),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text(AppLocalizations.of(context)!.errorLabel(err.toString()))),
      ),
      floatingActionButton: FloatingActionButton(
        key: addTrainingFabKey,
        onPressed: () => context.push('/check-in'),
        backgroundColor: const Color(0xFF1565C0),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

final techniquesStreamProvider = StreamProvider<List<Technique>>((ref) {
  final repository = ref.watch(techniqueRepositoryProvider);
  return repository.watchTechniques();
});
