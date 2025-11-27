// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'MatLog';

  @override
  String get weeklyGoal => 'Weekly Goal';

  @override
  String get sessions => 'sessions';

  @override
  String get recentActivity => 'Recent Activity';

  @override
  String get profileTitle => 'My Profile';

  @override
  String get currentBelt => 'Current Belt';

  @override
  String get degree => 'degree';

  @override
  String get degrees => 'degrees';

  @override
  String get editProgress => 'Edit Progress';

  @override
  String get belt => 'Belt';

  @override
  String get stripes => 'Stripes';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get notificationsSchedule => 'Notifications & Schedule';

  @override
  String get trainingDays => 'Training Days';

  @override
  String get usualTime => 'Usual Class Time';

  @override
  String get linkEmail => 'Link Email';

  @override
  String get secureAccount => 'Secure Account';

  @override
  String get saveProgress => 'Save your progress';

  @override
  String get linkAccountDesc =>
      'Link your account to an email to avoid losing data if you change devices.';

  @override
  String get rivalsTitle => 'Training Partners';

  @override
  String get noRivals => 'No training partners yet.';

  @override
  String get addRival => 'Add Partner';

  @override
  String get newRivalTitle => 'New Partner';

  @override
  String get nameLabel => 'Name';

  @override
  String get saveLabel => 'Save';

  @override
  String get cancelLabel => 'Cancel';

  @override
  String get matchVs => 'Match vs';

  @override
  String get winLabel => 'Win';

  @override
  String get lossLabel => 'Loss';

  @override
  String get drawLabel => 'Draw';

  @override
  String get techniqueLibraryTitle => 'Technique Library';

  @override
  String get noTechniques => 'No techniques learned yet.';

  @override
  String get repetitionsLabel => 'Repetitions';

  @override
  String get levelLabel => 'Level';

  @override
  String get techniqueDetailTitle => 'Technique Detail';

  @override
  String get notesLabel => 'Notes';

  @override
  String get saveNotes => 'Save Notes';

  @override
  String get historyLabel => 'History';

  @override
  String get checkInTitle => 'Check-in';

  @override
  String get sessionType => 'Session Type';

  @override
  String get durationLabel => 'Duration';

  @override
  String get trainingNotes => 'Training Notes';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get accountSection => 'Account';

  @override
  String get manageSubscription => 'Manage Subscription';

  @override
  String get signOut => 'Sign Out';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get aboutSection => 'About';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get versionLabel => 'Version';

  @override
  String get pleaseLogin => 'Please login';

  @override
  String errorLabel(String error) {
    return 'Error: $error';
  }

  @override
  String get matchResultQuestion => 'What was the result of the training?';

  @override
  String addedRivalMessage(String name) {
    return '$name added to your rivals';
  }

  @override
  String imageSelectionError(String error) {
    return 'Error selecting image: $error';
  }

  @override
  String get scheduleUpdated => 'Schedule updated';

  @override
  String get profileUpdated => 'Profile updated successfully';

  @override
  String updateError(String error) {
    return 'Error updating: $error';
  }

  @override
  String get accountSecured => 'Account secured successfully!';

  @override
  String get linkButton => 'Link';

  @override
  String get trainingLogged => 'Training logged successfully!';

  @override
  String get rpeLabel => 'RPE (Intensity)';

  @override
  String get beltWhite => 'White Belt';

  @override
  String get beltBlue => 'Blue Belt';

  @override
  String get beltPurple => 'Purple Belt';

  @override
  String get beltBrown => 'Brown Belt';

  @override
  String get beltBlack => 'Black Belt';

  @override
  String get analyticsTitle => 'Analytics & Progress';

  @override
  String get gameStyleTitle => 'Game Style';

  @override
  String get gameStyleExplanation =>
      'This chart shows your technical profile based on the techniques you practice. The larger the area in each category, the more techniques you master in that style.';

  @override
  String get trainingDistributionTitle => 'Training Distribution';

  @override
  String get trainingDistributionExplanation =>
      'Shows what percentage of your training is with Gi vs NoGi. Helps you see if you are balanced or focusing more on one modality.';

  @override
  String get matTimeTitle => 'Mat Time';

  @override
  String get matTimeExplanation =>
      'This chart shows your accumulated training hours over time. The line always goes up, representing your total effort on the mat.';

  @override
  String get intensityTitle => 'Intensity (RPE)';

  @override
  String get intensityExplanation =>
      'Each point represents the intensity of a training session (RPE from 1 to 10). Green = light session, Orange = moderate, Red = very intense. Helps you avoid overtraining.';

  @override
  String get topPositionsTitle => 'Technique Categories';

  @override
  String get topPositionsExplanation =>
      'Shows the categories where you have the most techniques registered (Guard, Passing, Submission, Defense, Takedowns). Defines which areas you focus on most.';

  @override
  String get weeklyConsistencyTitle => 'Weekly Consistency';

  @override
  String get weeklyConsistencyExplanation =>
      'Shows which days of the week you train most frequently. Helps you identify your training routine.';
}
