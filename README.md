# MatLog - Tu Diario de Entrenamiento de BJJ

MatLog es una aplicación móvil diseñada para practicantes de Brazilian Jiu-Jitsu (BJJ) que buscan llevar un control detallado de su evolución en el tatami. La aplicación combina herramientas de registro de entrenamiento con funcionalidades sociales para conectar con compañeros de equipo y rivales.

## 🚀 ¿Qué es esto?

MatLog no es solo un bloc de notas; es una herramienta integral para el practicante de BJJ. Permite registrar sesiones de entrenamiento, detallar técnicas aprendidas (actividades, logs técnicos) y mantener un historial de tu progreso. Además, la capa social ("Social Rivals") fomenta la competitividad sana y el aprendizaje comunitario.

## 🛠 ¿Cómo está hecho?

Este proyecto está construido utilizando **Flutter**, aprovechando un stack tecnológico moderno y robusto enfocado en la escalabilidad y el rendimiento.

### Tech Stack Principal:
- **Framework:** [Flutter](https://flutter.dev/) (Dart)
- **Gestión de Estado:** [Riverpod](https://riverpod.dev/) (con `riverpod_generator` para una sintaxis más limpia y segura).
- **Navegación:** [GoRouter](https://pub.dev/packages/go_router) para un manejo de rutas declarativo y flexible.
- **Backend & Servicios:** [Firebase](https://firebase.google.com/) (Authentication, Cloud Firestore).
- **Modelado de Datos:** [Freezed](https://pub.dev/packages/freezed) y [JsonSerializable](https://pub.dev/packages/json_serializable) para inmutabilidad y serialización segura.
- **Inteligencia Artificial:** Integración con [Google Generative AI](https://pub.dev/packages/google_generative_ai) para funcionalidades avanzadas.

### Arquitectura

El proyecto sigue una arquitectura **Feature-First** (por características), lo que significa que el código está organizado alrededor de las funcionalidades del negocio en lugar de capas técnicas. Esto facilita la mantenibilidad y la escalabilidad.

Estructura clave en `lib/src/`:
- **`features/`**: Cada carpeta aquí representa un dominio funcional (ej. `authentication`, `training_log`, `social_rivals`), conteniendo su propia capa de presentación, dominio y datos.
- **`routing/`**: Configuración centralizada de la navegación.

## 📱 ¿Cómo funciona?

La aplicación se divide en varios módulos principales:

1.  **Autenticación:** Sistema seguro de login y registro para proteger los datos del usuario.
2.  **Training Log (Diario):**
    - **Actividades:** Registro de sesiones de entrenamiento (sparring, drills, clases).
    - **Technical Log:** Detalle de técnicas específicas aprendidas o practicadas.
3.  **Social Rivals:**
    - **Feed:** Visualización de la actividad de tu red.
    - **Rivales:** Gestión de conexiones con otros practicantes.

## 🏁 Primeros Pasos

Para ejecutar este proyecto localmente:

1.  **Instalar dependencias:**
    ```bash
    flutter pub get
    ```

2.  **Generación de código:**
    Dado que usamos Riverpod y Freezed, es necesario generar el código auxiliar:
    ```bash
    dart run build_runner build -d
    ```

3.  **Ejecutar la App:**
    ```bash
    flutter run
    ```

> **Nota:** Asegúrate de tener configurado tu entorno de Firebase si planeas ejecutar todas las funcionalidades conectadas a la nube.
