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
}
