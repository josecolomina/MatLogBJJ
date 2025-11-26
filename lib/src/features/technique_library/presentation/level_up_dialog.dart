import 'package:flutter/material.dart';
import '../domain/technique.dart';
import 'mastery_belt_widget.dart';

class LevelUpDialog extends StatelessWidget {
  final Technique technique;

  const LevelUpDialog({super.key, required this.technique});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'LEVEL UP!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Your technique has reached a new mastery level!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            Text(
              technique.name,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(technique.position, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 24),
            MasteryBeltWidget(belt: technique.masteryBelt, height: 40),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('AWESOME!'),
            ),
          ],
        ),
      ),
    );
  }
}
