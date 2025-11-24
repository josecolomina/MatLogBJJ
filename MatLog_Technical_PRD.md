PRD Técnico: MatLog (MVP)

Versión: 1.2
Enfoque: Mobile-First, Offline-First, Zero-Cost Infrastructure.
Stack: Flutter + Firebase (Spark) + Gemini 1.5 Flash.

1. Arquitectura de Datos (Firestore NoSQL)

Para cumplir con la "Privacidad Híbrida" (Feed público / Notas privadas) y mantener el coste de lectura bajo en Firebase, utilizaremos un patrón de Desacoplamiento de Actividad y Contenido.

Colecciones Principales

A. users (Perfil Público/Privado)

Información base del practicante y estado de sus misiones.

{
  "uid": "string (Auth ID)",
  "display_name": "string",
  "belt_rank": "string (white|blue|purple|brown|black)",
  "default_academy_id": "string (ref)", // Academia predeterminada
  "default_academy_name": "string", // Desnormalizado para UI rápida
  
  // Gamificación Semanal
  "weekly_goal_target": "number (default: 3)", 
  "weekly_goal_progress": "number",
  "last_activity_week": "string (ISO-8601 Year-Week, ej: 2024-W45)", // Para resetear contador en cliente
  
  "total_mat_time_minutes": "number",
  "current_streak_days": "number",
  "created_at": "timestamp"
}


B. activities (Público - Feed Social)

Documentos ligeros optimizados para lecturas masivas en el feed. NO contiene notas técnicas.

{
  "activity_id": "string (UUID)",
  "user_id": "string",
  "user_name": "string", 
  "user_rank": "string", 
  "academy_name": "string", // Pre-llenado con default, editable
  "timestamp_start": "timestamp",
  "duration_minutes": "number",
  "type": "string (gi|nogi|open_mat|seminar)",
  "rpe": "number (1-10)", 
  "likes_count": "number",
  "has_technical_notes": "boolean" 
}


C. technical_logs (Privado - El "Cerebro")

Subcolección dentro de users (o colección raíz con reglas de seguridad estrictas). Contiene la data procesada por IA.

{
  "log_id": "string",
  "activity_ref": "string",
  "raw_input_text": "string",
  "processed_techniques": [ 
    {
      "technique_name": "string",
      "category": "string",
      "position_start": "string",
      "position_end": "string",
      "tags": ["array", "string"],
      "mastery_level": "number"
    }
  ],
  "ai_summary": "string",
  "created_at": "timestamp"
}


D. rivals (Privado - Modo VS)

Subcolección dentro de users/{uid}/rivals. Permite llevar un registro personal de "combates" contra amigos.

{
  "rival_uid": "string (User ID del amigo)",
  "rival_name": "string", // Desnormalizado
  "wins": "number", // Tapouts a favor
  "losses": "number", // Tapouts en contra
  "draws": "number",
  "last_rolled_at": "timestamp",
  "notes": "string (ej: 'Cuidado con su guillotina')"
}


E. academies (Global - Shared)

{
  "academy_id": "string",
  "name": "string",
  "address": "string"
}


2. Integración de IA (Prompt Engineering)

Para el MVP, la llamada a Gemini se hará desde el Cliente (Flutter) usando el SDK google_generative_ai.

Modelo: gemini-1.5-flash.
Temperatura: 0.2.

System Prompt (La "Instrucción Maestra")

Eres "MatLog AI", un experto cinturón negro en BJJ. Tu trabajo es estructurar notas de entrenamiento.

INPUT: Texto informal sobre una sesión de entrenamiento.

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


3. Lógica de Negocio (User Journey Técnico)

El flujo está diseñado para ser Offline-First.

Fase 1: El Check-In (Sin Fricción)

Apertura y Lógica de Misión:

Al abrir la app, se verifica last_activity_week vs current_week.

Si es una semana nueva, weekly_goal_progress se resetea a 0 localmente y se actualiza en Firestore (Lazy Reset).

Dashboard: Muestra barra de progreso: "Misión Semanal: 1/3 Entrenamientos".

Formulario Smart-Default:

El usuario pulsa "+".

Academia: Pre-cargada con users.default_academy_name. Solo se edita si es un drop-in.

Datos: Duración y Tipo.

Guardar: Crea documento en activities, incrementa weekly_goal_progress.

Fase 2: El Diario Técnico (Valor Agregado)

Prompt: "¿Qué aprendiste hoy?"

Input: Voz o Texto.

Procesamiento IA: Gemini estructura el texto.

Guardado: Se escribe en technical_logs.

Fase 3: Modo VS (Social Competitivo)

Contexto: Después de guardar el entreno o desde el perfil de un amigo.

Acción: Botón "Registrar Combate/Roll".

Formulario VS:

Seleccionar Rival (Lista de amigos).

Input: Resultado (Gané / Perdí / Empate) o Score numérico (ej: 2 sumisiones a 1).

Lógica:

Busca/Crea documento en users/{me}/rivals/{friend}.

Incrementa contador correspondiente (wins, losses, draws).

Nota: Esto es privado por defecto, no se notifica al rival.

Fase 4: Feed Social & Grafo

Feed: Muestra actividades de amigos.

Grafo: Visualización local de técnicas aprendidas basada en technical_logs.

4. Stack Tecnológico y Estándares (MANDATORIO)

La implementación debe seguir estrictamente estas directrices para evitar deuda técnica:

4.1. Flutter Core

Gestión de Estado: Riverpod (v2.x con code generation). NO usar GetX ni Bloc (boilerplate innecesario para MVP).

Routing: go_router para manejo de navegación declarativa y deep links.

Modelos: freezed + json_serializable para inmutabilidad y parseo seguro.

Estilos: Material 3 activado (useMaterial3: true).

4.2. Estructura de Carpetas (Feature-First)

lib/
├── src/
│   ├── features/
│   │   ├── authentication/   # Login, Registro
│   │   ├── dashboard/        # Home, Feed, Misiones
│   │   ├── training_log/     # Check-in, IA Analysis
│   │   └── social_rivals/    # Modo VS, Perfil amigos
│   ├── shared/               # Widgets comunes, Themes
│   ├── services/             # Firebase, Gemini API, Geolocator
│   └── routing/              # AppRouter config
└── main.dart


4.3. Reglas de Seguridad Firestore (Firestore Rules)

Copia y pega estas reglas en la consola de Firebase para garantizar la privacidad:

rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Función helper para ver si está autenticado
    function isSignedIn() {
      return request.auth != null;
    }

    // 1. Usuarios: Cualquiera puede leer perfiles básicos, solo dueño edita
    match /users/{userId} {
      allow read: if isSignedIn(); 
      allow write: if request.auth.uid == userId;
      
      // 2. Technical Logs (PRIVADO): Solo el dueño lee y escribe
      match /technical_logs/{logId} {
        allow read, write: if request.auth.uid == userId;
      }
      
      // 3. Rivals (PRIVADO): Solo el dueño lee y escribe
      match /rivals/{rivalId} {
        allow read, write: if request.auth.uid == userId;
      }
    }

    // 4. Actividades (PÚBLICO): Feed social
    match /activities/{activityId} {
      allow read: if isSignedIn(); // Todo el mundo ve que entrenaste
      allow create: if request.auth.uid == request.resource.data.user_id;
      // Solo el dueño puede editar/borrar su actividad (ej: borrar un entreno erróneo)
      allow update, delete: if request.auth.uid == resource.data.user_id;
    }
    
    // 5. Academias (GLOBAL): Lectura pública
    match /academies/{academyId} {
      allow read: if isSignedIn();
      allow write: if false; // Solo admin (o cloud functions) crea academias por ahora
    }
  }
}
