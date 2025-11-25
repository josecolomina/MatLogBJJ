import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:convert';

class GeminiService {
  final GenerativeModel _model;

  GeminiService(String apiKey)
      : _model = GenerativeModel(
          model: 'gemini-1.5-flash',
          apiKey: apiKey,
          generationConfig: GenerationConfig(
            temperature: 0.2,
            responseMimeType: 'application/json',
          ),
        );

  Future<Map<String, dynamic>> processTechnicalNote(String text) async {
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
    final response = await _model.generateContent(content);

    if (response.text == null) {
      throw Exception('Empty response from Gemini');
    }

    try {
      return jsonDecode(response.text!);
    } catch (e) {
      throw Exception('Failed to parse Gemini response: $e');
    }
  }
}

// TODO: Replace with actual API key management (e.g. from environment or remote config)
final geminiApiKeyProvider = Provider<String>((ref) {
  return 'AIzaSyDbH8IjJKAe7NLPB2MO7IzOSJVP7qUgxms'; 
});

final geminiServiceProvider = Provider<GeminiService>((ref) {
  final apiKey = ref.watch(geminiApiKeyProvider);
  return GeminiService(apiKey);
});
