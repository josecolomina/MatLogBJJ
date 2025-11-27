import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../domain/tutorial_step.dart';
import 'tutorial_overlay.dart';
import '../data/tutorial_repository.dart';
import '../../dashboard/presentation/main_navigation_screen.dart';
import 'tutorial_keys.dart';

class TutorialScreen extends ConsumerStatefulWidget {
  const TutorialScreen({super.key});

  @override
  ConsumerState<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends ConsumerState<TutorialScreen> {
  int _currentStepIndex = 0;
  late PageController _pageController;
  bool _showOverlay = true; // Control overlay visibility
  double _overlayOpacity = 1.0; // Control overlay opacity for transitions

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 1);
    // print('DEBUG TutorialScreen: initState called');
  }

  @override
  void dispose() {
    // print('DEBUG TutorialScreen: dispose called');
    _pageController.dispose();
    super.dispose();
  }

  Rect? _getRectFromKey(GlobalKey key, {double padding = 0, double paddingBottom = 0, double verticalOffset = 0, GlobalKey? fallbackKey}) {
    RenderBox? renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    
    // Try fallback key if main key not found or not ready
    if ((renderBox == null || !renderBox.hasSize) && fallbackKey != null) {
      renderBox = fallbackKey.currentContext?.findRenderObject() as RenderBox?;
    }

    if (renderBox == null || !renderBox.hasSize) {
      // If we can't find the render box or it's not laid out yet, 
      // schedule a rebuild for the next frame to try again
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {});
        }
      });
      return null;
    }
    
    final offset = renderBox.localToGlobal(Offset.zero);
    return Rect.fromLTWH(
      offset.dx - padding,
      offset.dy - padding + verticalOffset,
      renderBox.size.width + (padding * 2),
      renderBox.size.height + (padding * 2) + paddingBottom,
    );
  }

  List<TutorialStep> _getSteps(BuildContext context) {
    // print('DEBUG TutorialScreen: _getSteps called');
    return [
      // Step 1: Welcome
      const TutorialStep(
        title: '¡Bienvenido a MatLog!',
        description: 'Tu compañero perfecto para el entrenamiento de Jiu Jitsu. Vamos a hacer un tour rápido de todas las funcionalidades.',
        highlightRect: null,
        actionText: 'Comenzar Tour',
      ),
      
      // Step 2: Add Training (FAB in Techniques) - Navigate to Techniques tab
      TutorialStep(
        title: 'Registra tus Entrenamientos',
        description: 'Toca el botón + para registrar tu sesión de entrenamiento y las técnicas que practicaste.',
        highlightRect: _getRectFromKey(TutorialKeys.addTrainingFabKey, padding: 8),
      ),
      
      // Step 3: Missions - Navigate back to Home
      TutorialStep(
        title: 'Completa Misiones',
        description: 'Revisa tus objetivos semanales, gana logros y mantén tu motivación alta.',
        highlightRect: _getRectFromKey(TutorialKeys.missionsKey),
      ),
      
      // Step 4: Upcoming Classes - Stay on Home
      TutorialStep(
        title: 'Nunca Olvides una Clase',
        description: 'Te recordamos tus próximas sesiones de entrenamiento basadas en tu horario.',
        highlightRect: _getRectFromKey(TutorialKeys.classesKey),
      ),
      
      // Step 6: Social Tab - Navigate to Social
      TutorialStep(
        title: 'Conecta con Compañeros',
        description: 'Añade a tus compañeros de equipo y registra tus sparrings con ellos.',
        highlightRect: _getRectFromKey(TutorialKeys.socialTabKey, padding: 24, paddingBottom: 20, verticalOffset: 12, fallbackKey: TutorialKeys.socialTabActiveKey),
      ),
      
      // Step 7: Techniques Tab - Navigate to Techniques
      TutorialStep(
        title: 'Domina tu Técnica',
        description: 'Ve tu progreso en cada técnica y sube de cinturón conforme practicas.',
        highlightRect: _getRectFromKey(TutorialKeys.techniquesTabKey, padding: 24, paddingBottom: 20, verticalOffset: 12, fallbackKey: TutorialKeys.techniquesTabActiveKey),
      ),
      
      // Step 8: Profile - Navigate back to Home to show profile
      TutorialStep(
        title: 'Personaliza tu Perfil',
        description: 'Configura tu cinturón, academia, foto de perfil y horario de entrenamientos.',
        highlightRect: _getRectFromKey(TutorialKeys.profileKey, padding: 8),
      ),
      
      // Step 9: Ready to start
      const TutorialStep(
        title: '¡Listo para Empezar!',
        description: 'Ahora configura tu perfil y comienza tu viaje en el Jiu Jitsu. ¡Oss!',
        highlightRect: null,
        actionText: 'Empezar',
      ),
    ];
  }

  void _navigateToTab(int tabIndex) {
    _pageController.animateToPage(
      tabIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _nextStep(BuildContext context) async {
    final steps = _getSteps(context);
    if (_currentStepIndex < steps.length - 1) {
      
      // Fade out current step
      if (mounted) {
        setState(() {
          _overlayOpacity = 0.0;
        });
      }
      
      // Wait for fade out
      await Future.delayed(const Duration(milliseconds: 200));

      // Determine if we need to navigate
      int? targetTab;
      switch (_currentStepIndex + 1) { // Check next step index
        case 1: // Step 2: Register trainings (Techniques tab)
          targetTab = 2;
          break;
        case 2: // Step 3: Missions (Home tab)
        case 3: // Step 4: Classes (Home tab)
          targetTab = 1;
          break;
        case 4: // Step 6: Social tab (was 5)
          targetTab = 0;
          break;
        case 5: // Step 7: Techniques tab (was 6)
          targetTab = 2;
          break;
        case 6: // Step 8: Profile - go to Home to show profile icon (was 7)
          targetTab = 1;
          break;
      }

      if (targetTab != null) {
        _navigateToTab(targetTab);
        // Wait for animation to complete before showing next step
        await Future.delayed(const Duration(milliseconds: 350));
      }

      if (mounted) {
        setState(() {
          _currentStepIndex++;
          // Fade in next step
          _overlayOpacity = 1.0;
        });
      }
    } else {
      _completeTutorial();
    }
  }

  void _completeTutorial() async {
    await ref.read(tutorialRepositoryProvider).markTutorialCompleted();
    if (mounted) {
      // Schedule navigation for next frame to avoid layout errors during transition
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.go('/home');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // print('DEBUG TutorialScreen: build called, step: $_currentStepIndex');
    final steps = _getSteps(context);
    
    return Scaffold(
      body: Stack(
        children: [
          // Real MainNavigationScreen with external PageController
          MainNavigationScreen(
            externalPageController: _pageController,
            socialTabKey: TutorialKeys.socialTabKey,
            socialTabActiveKey: TutorialKeys.socialTabActiveKey,
            techniquesTabKey: TutorialKeys.techniquesTabKey,
            techniquesTabActiveKey: TutorialKeys.techniquesTabActiveKey,
            missionsKey: TutorialKeys.missionsKey,
            classesKey: TutorialKeys.classesKey,
            profileKey: TutorialKeys.profileKey,
            addTrainingFabKey: TutorialKeys.addTrainingFabKey,
          ),
          
          // Tutorial overlay - only show if _showOverlay is true
          if (_showOverlay)
            AnimatedOpacity(
              opacity: _overlayOpacity,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: TutorialOverlay(
                step: steps[_currentStepIndex],
                onNext: () => _nextStep(context),
                currentStep: _currentStepIndex + 1,
                totalSteps: steps.length,
              ),
            ),
        ],
      ),
    );
  }
}

