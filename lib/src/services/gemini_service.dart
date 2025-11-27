import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:convert';

class GeminiService {
  final GenerativeModel _model;

  GeminiService(String apiKey)
      : _model = GenerativeModel(
          model: 'gemini-1.5-flash-latest',
          apiKey: apiKey,
          generationConfig: GenerationConfig(
            temperature: 0.2,
            responseMimeType: 'application/json',
          ),
        );

  Future<Map<String, dynamic>> processTechnicalNote(String text) async {
    print('🕵️ SPY: GeminiService - Processing note: "$text"');
    
    // Try primary model first
    try {
      return await _generateWithModel('gemini-1.5-flash', text);
    } catch (e) {
      print('🕵️ SPY: GeminiService - Primary model failed: $e');
      print('🕵️ SPY: GeminiService - Attempting fallback to gemini-pro...');
      try {
        return await _generateWithModel('gemini-pro', text);
      } catch (e2) {
        print('🕵️ SPY: GeminiService - Fallback model failed: $e2');
        throw e2;
      }
    }
  }

  Future<Map<String, dynamic>> _generateWithModel(String modelName, String text) async {
    final model = GenerativeModel(
      model: modelName,
      apiKey: _model.apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.2,
        responseMimeType: 'application/json',
      ),
    );

    final prompt = '''
Eres "MatLog AI", un experto cinturón negro en BJJ. Tu trabajo es estructurar notas de entrenamiento.

INPUT: "$text"

TAREA:
1. Identifica técnicas.
2. Estandariza nombres al inglés técnico (IBJJF/Danaher).
3. Identifica posición inicial y final.
4. Categoriza.

OUTPUT: JSON válido con estructura:
{
  "summary": "Resumen breve.",
  "techniques": [
    {
      "name": "Nombre Estandarizado",
      "original_term": "Término original",
      "type": "Enum: [submission, sweep, pass, escape, drill, sparring]",
      "position_start": "Posición inicio",
      "position_end": "Posición fin",
      "notes": "Detalles clave"
    }
  ]
}

REGLAS:
- Si es vago, array vacío.
- Normaliza posiciones: Closed Guard, Half Guard, Side Control, Mount, Back Control.
''';

    final content = [Content.text(prompt)];
    print('🕵️ SPY: GeminiService - Sending request to model $modelName...');
    final response = await model.generateContent(content);

    if (response.text == null) {
      print('🕵️ SPY: GeminiService - Error: Empty response from $modelName');
      throw Exception('Empty response from Gemini');
    }

    print('🕵️ SPY: GeminiService - Raw response from $modelName: ${response.text}');

    try {
      final json = jsonDecode(response.text!);
      print('🕵️ SPY: GeminiService - JSON parsed successfully.');
      return json;
    } catch (e) {
      print('🕵️ SPY: GeminiService - JSON parsing failed: $e');
      throw Exception('Failed to parse Gemini response: $e');
    }
  }
}

// Production: Move API key to environment variable or Firebase Remote Config
final geminiApiKeyProvider = Provider<String>((ref) {
  // Try to get from environment variable first
  const apiKey = String.fromEnvironment('GEMINI_API_KEY');
  if (apiKey.isNotEmpty) {
    return apiKey;
  }
  // Fallback for development (WARNING: Remove in production)
  return 'AIzaSyDbH8IjJKAe7NLPB2MO7IzOSJVP7qUgxms'; 
});

final geminiServiceProvider = Provider<GeminiService>((ref) {
  final apiKey = ref.watch(geminiApiKeyProvider);
  return GeminiService(apiKey);
});
