import 'package:flutter/foundation.dart';

/// Valida y sanitiza entradas de técnicas para garantizar datos limpios y consistentes
class TechniqueInputValidator {
  static const int maxNameLength = 100;
  static const int maxCategoryLength = 50;
  static const int maxPositionLength = 50;
  
  /// Sanitiza y valida nombre de técnica
  /// 
  /// Realiza las siguientes operaciones:
  /// 1. Trim de espacios
  /// 2. Elimina caracteres especiales (mantiene letras, números, guiones, espacios)
  /// 3. Normaliza espacios múltiples a uno solo
  /// 4. Capitaliza primera letra de cada palabra
  /// 5. Limita longitud máxima
  /// 
  /// Throws [ValidationException] si el input es inválido
  static String sanitizeTechniqueName(String input) {
    if (input.isEmpty) {
      throw ValidationException('Technique name cannot be empty');
    }
    
    // 1. Trim whitespace
    String clean = input.trim();
    
    // 2. Remove special characters except letters, numbers, spaces, hyphens
    // Mantener unicode para soportar caracteres como 'ñ', 'á', etc.
    clean = clean.replaceAll(RegExp(r'[^\p{L}\p{N}\s-]', unicode: true), '');
    
    // 3. Normalize multiple spaces to single space
    clean = clean.replaceAll(RegExp(r'\s+'), ' ');
    
    // 4. Capitalize words
    clean = _capitalizeWords(clean);
    
    // 5. Limit length
    if (clean.length > maxNameLength) {
      clean = clean.substring(0, maxNameLength).trim();
    }
    
    // Final validation
    if (clean.isEmpty) {
      throw ValidationException('Invalid technique name after sanitization');
    }
    
    return clean;
  }
  
  /// Normaliza categoría a valores estándar conocidos
  /// 
  /// Mapea variaciones comunes a categorías estándar:
  /// - Guardia: guard, guardia, guarda
  /// - Pasaje: passing, pass, pasaje
  /// - Sumisión: submission, sub, finish, sumision
  /// - Defensa: defense, escape, defensa
  /// - Derribo: takedown, throw, derribo
  /// 
  /// Retorna 'Otra' para categorías no reconocidas
  static String normalizeCategory(String input) {
    final clean = input.trim().toLowerCase();
    
    // Map variations to standard categories
    const categoryMap = {
      'guard': 'Guardia',
      'guardia': 'Guardia',
      'guarda': 'Guardia',
      'passing': 'Pasaje',
      'pasaje': 'Pasaje',
      'pass': 'Pasaje',
      'pase': 'Pasaje',
      'submission': 'Sumisión',
      'sumision': 'Sumisión',
      'sumisión': 'Sumisión',
      'sub': 'Sumisión',
      'finish': 'Sumisión',
      'finalizacion': 'Sumisión',
      'defense': 'Defensa',
      'defensa': 'Defensa',
      'escape': 'Defensa',
      'takedown': 'Derribo',
      'derribo': 'Derribo',
      'throw': 'Derribo',
      'proyeccion': 'Derribo',
    };
    
    return categoryMap[clean] ?? 'Otra';
  }
  
  /// Normaliza posición a formato estándar
  /// 
  /// Mapea variaciones comunes y capitaliza palabras
  static String normalizePosition(String input) {
    if (input.isEmpty) {
      throw ValidationException('Position cannot be empty');
    }
    
    final clean = input.trim();
    
    // Map common variations
    const positionMap = {
      'guard': 'Guard',
      'guardia': 'Guard',
      'closed guard': 'Closed Guard',
      'guardia cerrada': 'Closed Guard',
      'half guard': 'Half Guard',
      'media guardia': 'Half Guard',
      'side control': 'Side Control',
      'control lateral': 'Side Control',
      'mount': 'Mount',
      'monta': 'Mount',
      'montada': 'Mount',
      'back': 'Back',
      'espalda': 'Back',
      'standing': 'Standing',
      'de pie': 'Standing',
      'top': 'Top',
      'bottom': 'Bottom',
    };
    
    final normalized = positionMap[clean.toLowerCase()];
    if (normalized != null) {
      return normalized;
    }
    
    // If not in map, capitalize words
    String result = _capitalizeWords(clean);
    
    // Limit length
    if (result.length > maxPositionLength) {
      result = result.substring(0, maxPositionLength).trim();
    }
    
    return result;
  }
  
  /// Valida y normaliza tags
  static List<String> normalizeTags(List<String> tags) {
    return tags
        .map((tag) => tag.trim().toLowerCase())
        .where((tag) => tag.isNotEmpty)
        .where((tag) => tag.length <= 30) // Limit tag length
        .take(10) // Limit number of tags
        .toSet() // Remove duplicates
        .toList();
  }
  
  /// Capitaliza la primera letra de cada palabra
  static String _capitalizeWords(String input) {
    if (input.isEmpty) return input;
    
    return input.split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }
  
  /// Genera un ID seguro y determinístico para una técnica
  /// 
  /// El ID es usado como clave en Firestore y debe ser:
  /// - Determinístico (mismo input = mismo ID)
  /// - Seguro (sin caracteres especiales)
  /// - Único (combina nombre y posición)
  static String generateSafeId(String name, String position) {
    final combined = '${name}_$position'
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w]+', unicode: true), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
        
    if (combined.isEmpty) {
      throw ValidationException('Cannot generate valid ID from inputs');
    }
    
    // Limit ID length to prevent Firestore issues
    if (combined.length > 100) {
      return combined.substring(0, 100);
    }
    
    return combined;
  }
}

/// Excepción lanzada cuando la validación falla
@immutable
class ValidationException implements Exception {
  final String message;
  
  const ValidationException(this.message);
  
  @override
  String toString() => 'ValidationException: $message';
  
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ValidationException &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => message.hashCode;
}
