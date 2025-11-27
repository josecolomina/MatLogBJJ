// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'MatLog';

  @override
  String get weeklyGoal => 'Objetivo Semanal';

  @override
  String get sessions => 'sesiones';

  @override
  String get recentActivity => 'Actividad Reciente';

  @override
  String get profileTitle => 'Mi Perfil';

  @override
  String get currentBelt => 'Tu Cinturón Actual';

  @override
  String get degree => 'grado';

  @override
  String get degrees => 'grados';

  @override
  String get editProgress => 'Editar Progreso';

  @override
  String get belt => 'Cinturón';

  @override
  String get stripes => 'Grados';

  @override
  String get saveChanges => 'Guardar Cambios';

  @override
  String get notificationsSchedule => 'Notificaciones y Horarios';

  @override
  String get trainingDays => 'Días de entrenamiento';

  @override
  String get usualTime => 'Hora habitual de clase';

  @override
  String get linkEmail => 'Vincular Correo';

  @override
  String get secureAccount => 'Asegurar Cuenta';

  @override
  String get saveProgress => 'Guarda tu progreso';

  @override
  String get linkAccountDesc =>
      'Asocia tu cuenta a un correo electrónico para no perder tus datos si cambias de dispositivo.';

  @override
  String get rivalsTitle => 'Compañeros de Entreno';

  @override
  String get noRivals => 'Aún no tienes compañeros guardados.';

  @override
  String get addRival => 'Añadir';

  @override
  String get newRivalTitle => 'Nuevo Compañero';

  @override
  String get nameLabel => 'Nombre';

  @override
  String get saveLabel => 'Guardar';

  @override
  String get cancelLabel => 'Cancelar';

  @override
  String get matchVs => 'Combate vs';

  @override
  String get winLabel => 'Victoria';

  @override
  String get lossLabel => 'Derrota';

  @override
  String get drawLabel => 'Empate';

  @override
  String get techniqueLibraryTitle => 'Biblioteca Técnica';

  @override
  String get noTechniques => 'No hay técnicas aprendidas aún.';

  @override
  String get repetitionsLabel => 'Repeticiones';

  @override
  String get levelLabel => 'Nivel';

  @override
  String get techniqueDetailTitle => 'Detalle de Técnica';

  @override
  String get notesLabel => 'Notas';

  @override
  String get saveNotes => 'Guardar Notas';

  @override
  String get historyLabel => 'Historial';

  @override
  String get checkInTitle => 'Check-in';

  @override
  String get sessionType => 'Tipo de sesión';

  @override
  String get durationLabel => 'Duración';

  @override
  String get trainingNotes => 'Notas de entrenamiento';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get accountSection => 'Cuenta';

  @override
  String get manageSubscription => 'Gestionar Suscripción';

  @override
  String get signOut => 'Cerrar Sesión';

  @override
  String get deleteAccount => 'Eliminar Cuenta';

  @override
  String get aboutSection => 'Acerca de';

  @override
  String get privacyPolicy => 'Política de Privacidad';

  @override
  String get termsOfService => 'Términos de Servicio';

  @override
  String get versionLabel => 'Versión';

  @override
  String get pleaseLogin => 'Por favor inicia sesión';

  @override
  String errorLabel(String error) {
    return 'Error: $error';
  }

  @override
  String get matchResultQuestion => '¿Cuál fue el resultado del entrenamiento?';

  @override
  String addedRivalMessage(String name) {
    return '$name añadido a tus compañeros';
  }

  @override
  String imageSelectionError(String error) {
    return 'Error al seleccionar imagen: $error';
  }

  @override
  String get scheduleUpdated => 'Horario actualizado';

  @override
  String get profileUpdated => 'Perfil actualizado correctamente';

  @override
  String updateError(String error) {
    return 'Error al actualizar: $error';
  }

  @override
  String get accountSecured => '¡Cuenta asegurada con éxito!';

  @override
  String get linkButton => 'Vincular';

  @override
  String get trainingLogged => '¡Entrenamiento registrado con éxito!';

  @override
  String get rpeLabel => 'RPE (Intensidad)';

  @override
  String get beltWhite => 'Cinturón Blanco';

  @override
  String get beltBlue => 'Cinturón Azul';

  @override
  String get beltPurple => 'Cinturón Morado';

  @override
  String get beltBrown => 'Cinturón Marrón';

  @override
  String get beltBlack => 'Cinturón Negro';

  @override
  String get analyticsTitle => 'Analytics & Progreso';

  @override
  String get gameStyleTitle => 'Estilo de Juego';

  @override
  String get gameStyleExplanation =>
      'Este gráfico muestra tu perfil técnico basado en las técnicas que practicas. Cuanto mayor sea el área en cada categoría, más técnicas dominas en ese estilo.';

  @override
  String get trainingDistributionTitle => 'Distribución de Entrenamiento';

  @override
  String get trainingDistributionExplanation =>
      'Muestra qué porcentaje de tu entrenamiento es con Kimono (Gi) vs Sin Kimono (NoGi). Te ayuda a ver si estás equilibrado o si te enfocas más en una modalidad.';

  @override
  String get matTimeTitle => 'Tiempo en el Tatami';

  @override
  String get matTimeExplanation =>
      'Este gráfico muestra tus horas acumuladas de entrenamiento a lo largo del tiempo. La línea siempre sube, representando tu esfuerzo total en el tatami.';

  @override
  String get intensityTitle => 'Intensidad (RPE)';

  @override
  String get intensityExplanation =>
      'Cada punto representa la intensidad de una sesión de entrenamiento (RPE de 1 a 10). Verde = sesión suave, Naranja = moderada, Rojo = muy intensa. Te ayuda a evitar el sobreentrenamiento.';

  @override
  String get topPositionsTitle => 'Categorías de Técnicas';

  @override
  String get topPositionsExplanation =>
      'Muestra las categorías donde tienes más técnicas registradas (Guardia, Pasaje, Sumisión, Defensa, Derribo). Define en qué áreas te enfocas más.';

  @override
  String get weeklyConsistencyTitle => 'Consistencia Semanal';

  @override
  String get weeklyConsistencyExplanation =>
      'Muestra qué días de la semana entrenas más frecuentemente. Te ayuda a identificar tu rutina de entrenamiento.';
}
