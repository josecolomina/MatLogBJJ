import 'package:flutter/material.dart';
import '../domain/tutorial_step.dart';
import 'spotlight_painter.dart';

class TutorialOverlay extends StatelessWidget {
  final TutorialStep step;
  final VoidCallback onNext;
  final int currentStep;
  final int totalSteps;

  const TutorialOverlay({
    super.key,
    required this.step,
    required this.onNext,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate best position for description card
    bool shouldPlaceAtTop = false;
    if (step.highlightRect != null) {
      final screenHeight = MediaQuery.of(context).size.height;
      final spotlightBottom = step.highlightRect!.bottom;
      final spotlightTop = step.highlightRect!.top;
      
      // Place at top if spotlight is in bottom half of screen
      shouldPlaceAtTop = spotlightTop > screenHeight / 2;
    }
    
    return Stack(
      children: [
        // Spotlight overlay
        Positioned.fill(
          child: GestureDetector(
            onTap: step.highlightRect != null ? null : onNext,
            child: CustomPaint(
              painter: SpotlightPainter(spotlight: step.highlightRect),
            ),
          ),
        ),

        // Description card - positioned to not cover spotlight
        Positioned(
          top: shouldPlaceAtTop ? 60 : null,
          bottom: shouldPlaceAtTop ? null : 100,
          left: 24,
          right: 24,
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          step.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1565C0),
                          ),
                        ),
                      ),
                      Text(
                        '$currentStep/$totalSteps',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    step.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[800],
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: onNext,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1565C0),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                        ),
                        child: Text(
                          step.actionText ?? 'Siguiente',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
