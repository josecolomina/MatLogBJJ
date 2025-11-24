# MatLog - Tu Diario de Entrenamiento de BJJ (iOS & Android)

MatLog es una **aplicación móvil nativa** diseñada específicamente para practicantes de Brazilian Jiu-Jitsu (BJJ). Su objetivo es ser tu compañero digital en el tatami, permitiéndote llevar un control detallado de tu evolución desde tu dispositivo móvil, ya sea iPhone o Android.

## 📱 ¿Qué es esto?

MatLog es una experiencia **Mobile-First** y **Offline-First**. Entendemos que en el gimnasio no siempre hay buena conexión, por lo que la app está diseñada para funcionar sin interrupciones, sincronizando tus datos cuando vuelves a estar en línea.

Es más que un simple bloc de notas; es una herramienta de bolsillo para:
*   **Registrar Entrenamientos:** Añade sesiones de sparring, drills o clases en segundos.
*   **Análisis con IA:** Usa la cámara o el micrófono de tu móvil para dictar lo que aprendiste, y nuestra IA organizará tus notas técnicas automáticamente.
*   **Social Rivals:** Conecta con tus compañeros de equipo y lleva un registro privado de tus "piques" y resultados en los combates (rolls).

## 🛠 ¿Cómo está hecho?

Este proyecto es una aplicación móvil multiplataforma construida con **Flutter**, lo que nos permite desplegar en iOS y Android con una única base de código de alto rendimiento.

### Stack Tecnológico Móvil:
- **Framework:** [Flutter](https://flutter.dev/) (Dart) - Para una UI nativa fluida a 60fps.
- **Gestión de Estado:** [Riverpod](https://riverpod.dev/) - Gestión reactiva y eficiente del estado de la app.
- **Navegación:** [GoRouter](https://pub.dev/packages/go_router) - Manejo robusto de pantallas y deep links.
- **Backend Mobile:** [Firebase](https://firebase.google.com/)
    - **Authentication:** Login seguro y persistente en el dispositivo.
    - **Cloud Firestore:** Base de datos NoSQL con soporte offline (caché local).
- **Inteligencia Artificial:** [Google Generative AI](https://pub.dev/packages/google_generative_ai) integrada directamente en la app.

### Arquitectura

El proyecto sigue una arquitectura **Feature-First** modular, ideal para aplicaciones móviles escalables:

Estructura en `lib/src/`:
- **`features/`**: Módulos funcionales (Auth, Training Log, Social).
- **`routing/`**: Mapa de navegación de la app.

## 🚀 ¿Cómo funciona?

La app está diseñada para el flujo de vida de un luchador:

1.  **Check-In Rápido:** Al llegar al tatami, registra tu asistencia con un par de toques.
2.  **Modo Diario:** Al terminar, dicta tus notas o escribe rápidamente los detalles técnicos.
3.  **Comunidad:** Revisa el feed para ver quién más ha entrenado hoy y mantén viva la competencia sana.

## 🏁 Ejecutar en tu Móvil (o Simulador)

Para probar la aplicación en tu dispositivo o emulador:

1.  **Instalar dependencias:**
    ```bash
    flutter pub get
    ```

2.  **Generación de código:**
    ```bash
    dart run build_runner build -d
    ```

3.  **Lanzar la App:**
    Conecta tu dispositivo Android o inicia el Simulador de iOS y corre:
    ```bash
    flutter run
    ```

> **Nota:** Para probar en un dispositivo físico iOS, necesitarás una cuenta de desarrollador de Apple y configurar la firma en Xcode. Para Android, asegúrate de tener activada la depuración USB.
