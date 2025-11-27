import 'dart:math';
import 'package:uuid/uuid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/training_log/domain/activity.dart';
import '../features/training_log/data/training_repository.dart';
import '../features/authentication/data/auth_repository.dart';
import '../features/technique_library/data/technique_repository.dart';

final dataSeederProvider = Provider((ref) => DataSeeder(ref));

class DataSeeder {
  final Ref _ref;
  final Random _random = Random();

  DataSeeder(this._ref);

  Future<void> seedTrainingData() async {
    final user = _ref.read(authRepositoryProvider).currentUser;
    if (user == null) return;

    final repository = _ref.read(trainingRepositoryProvider);
    final techniqueRepository = _ref.read(techniqueRepositoryProvider);
    final now = DateTime.now();

    // Generate 6 months of realistic history (24 weeks)
    // Simulate a progression: starting slowly, building up, with some rest periods
    for (int i = 23; i >= 0; i--) { // Go from oldest to newest
      final weekStart = now.subtract(Duration(days: now.weekday - 1 + (i * 7)));
      
      // Determine training frequency based on week (simulate progression and rest)
      double attendanceRate;
      if (i > 20) {
        // First month: getting started (50-60% attendance)
        attendanceRate = 0.5 + (_random.nextDouble() * 0.1);
      } else if (i > 16) {
        // Month 2: building consistency (70-80%)
        attendanceRate = 0.7 + (_random.nextDouble() * 0.1);
      } else if (i > 12) {
        // Month 3: high consistency (85-95%)
        attendanceRate = 0.85 + (_random.nextDouble() * 0.1);
      } else if (i == 10 || i == 11) {
        // Simulated vacation/rest week (30%)
        attendanceRate = 0.3;
      } else if (i > 6) {
        // Back to training (80-90%)
        attendanceRate = 0.8 + (_random.nextDouble() * 0.1);
      } else if (i == 4) {
        // Minor injury/rest (40%)
        attendanceRate = 0.4;
      } else {
        // Recent weeks: consistent (85-95%)
        attendanceRate = 0.85 + (_random.nextDouble() * 0.1);
      }
      
      // Schedule: Mon (Gi), Wed (Gi), Fri (NoGi), Sat (Open Mat)
      final trainingDays = [0, 2, 4, 5]; 
      
      for (final dayOffset in trainingDays) {
        // Apply attendance rate
        if (_random.nextDouble() > (1 - attendanceRate)) {
          final isNoGi = dayOffset == 4;
          final isOpenMat = dayOffset == 5;
          
          final trainingDate = weekStart.add(Duration(days: dayOffset, hours: 18 + _random.nextInt(2)));
          
          if (trainingDate.isAfter(now)) continue;

          // Realistic RPE distribution (bell curve around 6-7)
          int rpe;
          final rpeRoll = _random.nextDouble();
          if (rpeRoll < 0.1) {
            rpe = 3 + _random.nextInt(2); // 10% light (3-4)
          } else if (rpeRoll < 0.7) {
            rpe = 5 + _random.nextInt(3); // 60% moderate (5-7)
          } else if (rpeRoll < 0.95) {
            rpe = 7 + _random.nextInt(2); // 25% hard (7-8)
          } else {
            rpe = 9 + _random.nextInt(2); // 5% very hard (9-10)
          }

          // Open mat tends to be lighter
          if (isOpenMat && rpe > 7) {
            rpe = 5 + _random.nextInt(3);
          }

          final activity = Activity(
            activityId: const Uuid().v4(),
            userId: user.uid,
            userName: user.displayName ?? 'User',
            userRank: 'white',
            academyName: 'MatLog Academy',
            timestampStart: trainingDate,
            durationMinutes: isOpenMat ? 120 : 90,
            type: isOpenMat ? 'open mat' : (isNoGi ? 'nogi' : 'gi'),
            rpe: rpe,
            likesCount: 0,
            hasTechnicalNotes: false,
          );

          await repository.addActivity(activity);

          // Learn techniques more frequently in middle period (consolidation phase)
          double techniqueLearningRate = i > 16 ? 0.3 : (i > 8 ? 0.7 : 0.5);
          if (!isOpenMat && _random.nextDouble() > (1 - techniqueLearningRate)) {
            await _seedTechnique(techniqueRepository);
          }
        }
      }
    }
  }

  Future<void> _seedTechnique(TechniqueRepository repo) async {
    final categories = {
      'Guardia': ['Closed Guard Armbar', 'Triangle Choke', 'Scissor Sweep', 'De La Riva Sweep', 'Berimbolo'],
      'Pasaje': ['Knee Cut Pass', 'Torreando Pass', 'Stack Pass', 'Leg Drag', 'Long Step Pass'],
      'Sumisión': ['Rear Naked Choke', 'Kimura', 'Guillotine', 'Armbar from Mount', 'Bow and Arrow'],
      'Defensa': ['Mount Escape', 'Side Control Escape', 'Back Escape', 'Armbar Defense', 'Triangle Defense'],
      'Derribo': ['Double Leg', 'Single Leg', 'Osoto Gari', 'Tomoe Nage', 'Ankle Pick'],
    };

    final techniqueNotes = {
      'Closed Guard Armbar': '1. Controla el brazo cruzado.\n2. Pon el pie en la cadera del mismo lado.\n3. Gira el cuerpo y pasa la pierna por encima de la cabeza.\n4. Levanta la cadera para finalizar.',
      'Triangle Choke': '1. Empuja un brazo dentro y mantén el otro fuera.\n2. Cierra las piernas alrededor del cuello y el brazo.\n3. Ajusta el ángulo moviendo la cadera.\n4. Tira de la cabeza y levanta la cadera.',
      'Scissor Sweep': '1. Agarra la solapa y la manga.\n2. Saca la cadera y cruza la pierna a la altura del pecho.\n3. Barre la pierna de base del oponente mientras tiras de la manga.',
      'De La Riva Sweep': '1. Gancho De La Riva en la pierna adelantada.\n2. Controla el talón y la manga opuesta.\n3. Desequilibra al oponente hacia atrás o hacia el lado.',
      'Berimbolo': '1. Desde De La Riva, invierte y gira sobre los hombros.\n2. Agarra el cinturón o el pantalón.\n3. Rueda hasta la espalda del oponente.',
      'Knee Cut Pass': '1. Entra la rodilla entre las piernas del oponente.\n2. Controla la solapa y el brazo.\n3. Desliza la rodilla hacia el suelo mientras controlas la cadera.',
      'Torreando Pass': '1. Controla ambos pantalones a la altura de las rodillas.\n2. Empuja las piernas hacia un lado y camina hacia el otro.\n3. Establece el control lateral.',
      'Stack Pass': '1. Levanta las caderas del oponente poniendo sus rodillas en su cara.\n2. Agarra el cuello y presiona con tu peso.\n3. Pasa hacia un lado manteniendo la presión.',
      'Leg Drag': '1. Arrastra la pierna del oponente cruzando tu cuerpo.\n2. Bloquea su cadera con tu cuerpo.\n3. Avanza hacia el control lateral o la espalda.',
      'Long Step Pass': '1. Desde media guardia, da un paso largo hacia atrás con la pierna libre.\n2. Gira la cadera y cae sobre el hombro.\n3. Estabiliza la posición.',
      'Rear Naked Choke': '1. Controla la espalda con los ganchos.\n2. Pasa un brazo alrededor del cuello.\n3. Bloquea con el bíceps del otro brazo y presiona.',
      'Kimura': '1. Agarra la muñeca del oponente.\n2. Pasa tu otro brazo por encima y agarra tu propia muñeca.\n3. Gira el brazo del oponente hacia su espalda.',
      'Guillotine': '1. Rodea el cuello del oponente con tu brazo.\n2. Cierra la guardia si estás abajo.\n3. Arquea la espalda y tira hacia arriba.',
      'Armbar from Mount': '1. Aísla un brazo y empuja el pecho hacia adelante.\n2. Pasa la pierna por encima de la cabeza.\n3. Siéntate y extiende la cadera.',
      'Bow and Arrow': '1. Desde la espalda, agarra la solapa cruzada.\n2. Agarra el pantalón de la pierna opuesta.\n3. Extiende tu cuerpo como un arco.',
      'Mount Escape': '1. Atrapa un brazo y el pie del mismo lado.\n2. Haz puente (Upa) hacia ese lado.\n3. Gira y establece la guardia.',
      'Side Control Escape': '1. Crea espacio con los antebrazos.\n2. Haz puente y saca la cadera (gamba).\n3. Repón la guardia metiendo la rodilla.',
      'Back Escape': '1. Defiende el cuello primero.\n2. Deslízate hacia el lado del brazo que estrangula.\n3. Pon la espalda en el suelo y gira.',
      'Armbar Defense': '1. Junta las manos (Mata Leão grip).\n2. Apila al oponente poniendo peso sobre él.\n3. Saca el codo poco a poco.',
      'Triangle Defense': '1. Postura fuerte, mira hacia arriba.\n2. Esconde el codo dentro de sus piernas.\n3. Pasa la pierna sobre su cara si es posible.',
      'Double Leg': '1. Cambia de nivel y entra profundo.\n2. Cabeza por fuera, manos detrás de las rodillas.\n3. Empuja con la cabeza y tira de las piernas.',
      'Single Leg': '1. Atrapa una pierna entre las tuyas.\n2. Cabeza pegada al pecho o costillas.\n3. Gira o barre la pierna de apoyo.',
      'Osoto Gari': '1. Rompe el equilibrio hacia atrás.\n2. Da un paso al lado de su pie.\n3. Barre su pierna con la tuya con fuerza.',
      'Tomoe Nage': '1. Agarra solapa y manga.\n2. Déjate caer hacia atrás poniendo un pie en su cadera.\n3. Lánzalo por encima de ti.',
      'Ankle Pick': '1. Baja el nivel simulando un derribo alto.\n2. Agarra el tobillo opuesto y tira.\n3. Empuja la cabeza hacia la rodilla.',
    };

    final category = categories.keys.elementAt(_random.nextInt(categories.length));
    final techniqueName = categories[category]![_random.nextInt(categories[category]!.length)];
    
    // Simulate different mastery levels
    int repsToAdd = 5 + _random.nextInt(20);
    
    // Occasional "deep dive" (Brown Belt level)
    if (_random.nextDouble() > 0.85) {
      repsToAdd += 100; 
    }

    // GUARANTEED BLACK BELT: 'Rear Naked Choke' will be the master move
    if (techniqueName == 'Rear Naked Choke') {
      repsToAdd = 1005; // Instant Black Belt (>1000 reps)
    }

    await repo.incrementRepetitions(
      name: techniqueName,
      position: category == 'Guardia' ? 'Bottom' : 'Top',
      category: category,
      amount: repsToAdd,
    );

    // Add notes if available
    if (techniqueNotes.containsKey(techniqueName)) {
      // We need to fetch the technique first to get its ID properly or construct it
      // Since incrementRepetitions creates/updates based on name/position, we can try to update it.
      // However, TechniqueRepository doesn't expose a direct 'updateNotes' easily without ID.
      // But we know how ID is generated in repo: '${name}_${position}'.toLowerCase()...
      // Let's rely on the repo to handle this if we add a method, OR just assume the ID format here for the seed.
      // A cleaner way is to fetch it by ID.
      
      final docId = '${techniqueName}_${category == 'Guardia' ? 'Bottom' : 'Top'}'.toLowerCase().replaceAll(RegExp(r'\s+'), '_');
      final technique = await repo.getTechnique(docId);
      
      if (technique != null) {
        final updatedTechnique = technique.copyWith(notes: techniqueNotes[techniqueName]!);
        await repo.updateTechnique(updatedTechnique);
      }
    }
  }
}
