import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../training_log/domain/technical_log.dart';
import '../../training_log/domain/activity.dart';
import '../data/technique_repository.dart';
import 'technique.dart';
import 'mastery_belt.dart';
import 'technique_input_validator.dart';

/// Servicio que procesa logs técnicos y actualiza técnicas
/// 
/// Responsabilidades:
/// - Validar y sanitizar datos de entrada
/// - Procesar técnicas de forma atómica
/// - Manejar errores gracefully
/// - Detectar level-ups
/// - Logging para debugging
class TechniqueExtractionService {
  final TechniqueRepository _repository;

  TechniqueExtractionService(this._repository);

  /// Procesa un log técnico completo
  /// 
  /// Para cada técnica en el log:
  /// 1. Valida y sanitiza los datos
  /// 2. Incrementa repeticiones
  /// 3. Detecta level-ups
  /// 
  /// [log] - Log técnico con técnicas procesadas
  /// [activity] - Actividad asociada (para determinar multiplicador)
  /// 
  /// Returns lista de técnicas que subieron de nivel
  /// 
  /// NOTA: Los errores en técnicas individuales NO causan que falle todo el procesamiento.
  /// Si una técnica falla, se registra el error y se continúa con las demás.
  Future<List<Technique>> processTechnicalLog(
    TechnicalLog log,
    Activity activity,
  ) async {
    try {
      print('DEBUG: Processing technical log: ${log.logId} with ${log.processedTechniques.length} techniques');
      
      final multiplier = activity.type == 'open_mat' ? 2 : 1;
      final leveledUpTechniques = <Technique>[];
      int successCount = 0;
      int failureCount = 0;

      for (final technique in log.processedTechniques) {
        try {
          final processed = await _processSingleTechnique(
            technique,
            multiplier,
          );
          
          if (processed != null) {
            leveledUpTechniques.add(processed);
          }
          successCount++;
        } catch (e, stackTrace) {
          failureCount++;
          // Log error pero continuar con otras técnicas
          print('ERROR: Failed to process technique "${technique.techniqueName}": $e');
          print('Stack trace: $stackTrace');
          // NO re-lanzar - queremos procesar todas las técnicas posibles
        }
      }
      
      print('DEBUG: Processed ${log.processedTechniques.length} techniques. Success: $successCount, Failures: $failureCount, Level-ups: ${leveledUpTechniques.length}');
      
      return leveledUpTechniques;
      
    } catch (e, stackTrace) {
      print('CRITICAL ERROR: Failed to process technical log ${log.logId}: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Procesa una técnica individual con validación y retry logic
  /// 
  /// Returns la técnica actualizada si subió de nivel, null en caso contrario
  Future<Technique?> _processSingleTechnique(
    ProcessedTechnique technique,
    int multiplier,
  ) async {
    // PASO 1: VALIDAR Y SANITIZAR ENTRADA
    final String cleanName;
    final String cleanCategory;
    final String cleanPosition;
    
    try {
      cleanName = TechniqueInputValidator.sanitizeTechniqueName(
        technique.techniqueName,
      );
      cleanCategory = TechniqueInputValidator.normalizeCategory(
        technique.category,
      );
      cleanPosition = TechniqueInputValidator.normalizePosition(
        technique.positionStart,
      );
      
      print('DEBUG: Sanitized technique: "$cleanName" ($cleanPosition - $cleanCategory)');
    } on ValidationException catch (e) {
      print('WARNING: Invalid technique data, skipping: $e');
      return null; // Skip invalid techniques
    }
    
    // PASO 2: GENERAR ID SEGURO
    final String id;
    try {
      id = TechniqueInputValidator.generateSafeId(cleanName, cleanPosition);
    } on ValidationException catch (e) {
      print('WARNING: Cannot generate ID, skipping: $e');
      return null;
    }
    
    // PASO 3: OPERACIÓN ATÓMICA CON RETRY
    const maxRetries = 3;
    Exception? lastException;
    
    for (int attempt = 0; attempt < maxRetries; attempt++) {
      try {
        // Fetch current state
        final existing = await _repository.getTechnique(id);
        final currentReps = existing?.totalRepetitions ?? 0;
        final amount = 1 * multiplier;
        final newReps = currentReps + amount;
        
        // Calculate belts
        final oldBelt = MasteryBelt.fromRepetitions(currentReps);
        final newBelt = MasteryBelt.fromRepetitions(newReps);
        
        if (attempt > 0) {
          print('DEBUG: Retry attempt $attempt for technique: $cleanName');
        }
        
        // Increment repetitions
        await _repository.incrementRepetitions(
          name: cleanName,
          position: cleanPosition,
          category: cleanCategory,
          amount: amount,
        );

        // Check for level up
        if (newBelt.index > oldBelt.index) {
          final updated = await _repository.getTechnique(id);
          if (updated != null) {
            print('INFO: ✨ Technique leveled up: $cleanName from ${oldBelt.name.toUpperCase()} to ${newBelt.name.toUpperCase()}');
            return updated;
          }
        }
        
        // Success - no level up
        return null;
        
      } on FirebaseException catch (e) {
        lastException = e;
        
        if (attempt == maxRetries - 1) {
          // Last attempt failed
          print('ERROR: Failed after $maxRetries attempts for technique "$cleanName": ${e.code} - ${e.message}');
          rethrow;
        }
        
        // Wait before retry with exponential backoff
        final delayMs = 100 * (attempt + 1);
        print('WARNING: Attempt ${attempt + 1} failed for "$cleanName", retrying in ${delayMs}ms...');
        await Future.delayed(Duration(milliseconds: delayMs));
      }
    }
    
    // This should never happen due to rethrow above, but just in case
    if (lastException != null) {
      throw lastException;
    }
    
    return null;
  }
}

final techniqueExtractionServiceProvider = Provider<TechniqueExtractionService>((ref) {
  final repository = ref.watch(techniqueRepositoryProvider);
  return TechniqueExtractionService(repository);
});
