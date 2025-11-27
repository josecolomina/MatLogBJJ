import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matlog/src/features/tutorial/presentation/tutorial_overlay.dart';
import 'package:matlog/src/features/tutorial/domain/tutorial_step.dart';

void main() {
  group('TutorialOverlay', () {
    testWidgets('displays tutorial step title and description', (tester) async {
      final step = TutorialStep(
        title: 'Test Title',
        description: 'Test Description',
        highlightRect: null,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TutorialOverlay(
              step: step,
              onNext: () {},
              currentStep: 1,
              totalSteps: 5,
            ),
          ),
        ),
      );

      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
      expect(find.text('1/5'), findsOneWidget);
    });

    testWidgets('next button triggers onNext callback', (tester) async {
      bool nextCalled = false;

      final step = TutorialStep(
        title: 'Test',
        description: 'Description',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TutorialOverlay(
              step: step,
              onNext: () => nextCalled = true,
              currentStep: 1,
              totalSteps: 5,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Siguiente'));
      expect(nextCalled, true);
    });

    testWidgets('displays custom action text when provided', (tester) async {
      final step = TutorialStep(
        title: 'Test',
        description: 'Description',
        actionText: 'Custom Action',
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TutorialOverlay(
              step: step,
              onNext: () {},
              currentStep: 1,
              totalSteps: 5,
            ),
          ),
        ),
      );

      expect(find.text('Custom Action'), findsOneWidget);
      expect(find.text('Siguiente'), findsNothing);
    });
  });
}
