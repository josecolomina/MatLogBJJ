import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../domain/tutorial_step.dart';
import 'tutorial_overlay.dart';
import '../data/tutorial_repository.dart';
import '../../dashboard/presentation/main_navigation_screen.dart';

class TutorialScreen extends ConsumerStatefulWidget {
  const TutorialScreen({super.key});

  @override
  ConsumerState<TutorialScreen> createState() => _TutorialScreenState();
}

class _TutorialScreenState extends ConsumerState<TutorialScreen> {
  int _currentStepIndex = 0;
  late PageController _pageController;
  bool _showOverlay = true; // Control overlay visibility

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 1);
    print('DEBUG TutorialScreen: initState called');
  }

  @override
  void dispose() {
    print('DEBUG TutorialScreen: dispose called');
    _pageController.dispose();
    super.dispose();
  }

  List<TutorialStep> _getSteps(BuildContext context) {
    print('DEBUG TutorialScreen: _getSteps called');
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
        highlightRect: Rect.fromLTWH(
          MediaQuery.of(context).size.width - 90,
          MediaQuery.of(context).size.height - 150,
          70,
          70,
        ),
      ),
      
      // Step 3: Missions - Navigate back to Home
      TutorialStep(
        title: 'Completa Misiones',
        description: 'Revisa tus objetivos semanales, gana logros y mantén tu motivación alta.',
        highlightRect: Rect.fromLTWH(
          12,
          140,
          MediaQuery.of(context).size.width - 24,
          150,
        ),
      ),
      
      // Step 4: Upcoming Classes - Stay on Home
      TutorialStep(
        title: 'Nunca Olvides una Clase',
        description: 'Te recordamos tus próximas sesiones de entrenamiento basadas en tu horario.',
        highlightRect: Rect.fromLTWH(
          12,
          310,
          MediaQuery.of(context).size.width - 24,
          170,
        ),
      ),
      
      // Step 5: Activity Feed - Stay on Home
      const TutorialStep(
        title: 'Sigue tu Progreso',
        description: 'Ve tu progreso y el de tus compañeros de equipo en tiempo real.',
        highlightRect: null,
      ),
      
      // Step 6: Social Tab - Navigate to Social
      TutorialStep(
        title: 'Conecta con Compañeros',
        description: 'Añade a tus compañeros de equipo y registra tus sparrings con ellos.',
        highlightRect: Rect.fromLTWH(
          0,
          MediaQuery.of(context).size.height - 65,
          MediaQuery.of(context).size.width * 0.33,
          65,
        ),
      ),
      
      // Step 7: Techniques Tab - Navigate to Techniques
      TutorialStep(
        title: 'Domina tu Técnica',
        description: 'Ve tu progreso en cada técnica y sube de cinturón conforme practicas.',
        highlightRect: Rect.fromLTWH(
          MediaQuery.of(context).size.width * 0.66,
          MediaQuery.of(context).size.height - 65,
          MediaQuery.of(context).size.width * 0.34,
          65,
        ),
      ),
      
      // Step 8: Profile - Navigate back to Home to show profile
      TutorialStep(
        title: 'Personaliza tu Perfil',
        description: 'Configura tu cinturón, academia, foto de perfil y horario de entrenamientos.',
        highlightRect: Rect.fromLTWH(
          MediaQuery.of(context).size.width - 60,
          MediaQuery.of(context).padding.top + 5,
          50,
          50,
        ),
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

  void _nextStep(BuildContext context) {
    final steps = _getSteps(context);
    if (_currentStepIndex < steps.length - 1) {
      setState(() {
        _currentStepIndex++;
      });
      
      // Navigate to appropriate screen based on step
      switch (_currentStepIndex) {
        case 1: // Step 2: Register trainings (Techniques tab)
          _navigateToTab(2);
          break;
        case 2: // Step 3: Missions (Home tab)
        case 3: // Step 4: Classes (Home tab)
        case 4: // Step 5: Activity (Home tab)
          _navigateToTab(1);
          break;
        case 5: // Step 6: Social tab
          _navigateToTab(0);
          break;
        case 6: // Step 7: Techniques tab
          _navigateToTab(2);
          break;
        case 7: // Step 8: Profile - go to Home to show profile icon
          _navigateToTab(1);
          break;
        // Step 9 stay on current tab
      }
    } else {
      _completeTutorial();
    }
  }

  void _completeTutorial() async {
    await ref.read(tutorialRepositoryProvider).markTutorialCompleted();
    if (mounted) {
      // Hide overlay instead of navigating
      setState(() {
        _showOverlay = false;
      });
      // Navigate after a short delay to let overlay fade
      await Future.delayed(const Duration(milliseconds: 100));
      if (mounted) {
        context.replace('/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print('DEBUG TutorialScreen: build called, step: $_currentStepIndex');
    final steps = _getSteps(context);
    
    return Scaffold(
      body: Stack(
        children: [
          // Real MainNavigationScreen with external PageController
          MainNavigationScreen(externalPageController: _pageController),
          
          // Tutorial overlay - only show if _showOverlay is true
          if (_showOverlay)
            TutorialOverlay(
              step: steps[_currentStepIndex],
              onNext: () => _nextStep(context),
              currentStep: _currentStepIndex + 1,
              totalSteps: steps.length,
            ),
        ],
      ),
    );
  }
}

