import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('pt'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'MatLog'**
  String get appTitle;

  /// No description provided for @weeklyGoal.
  ///
  /// In en, this message translates to:
  /// **'Weekly Goal'**
  String get weeklyGoal;

  /// No description provided for @sessions.
  ///
  /// In en, this message translates to:
  /// **'sessions'**
  String get sessions;

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get recentActivity;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get profileTitle;

  /// No description provided for @currentBelt.
  ///
  /// In en, this message translates to:
  /// **'Current Belt'**
  String get currentBelt;

  /// No description provided for @degree.
  ///
  /// In en, this message translates to:
  /// **'degree'**
  String get degree;

  /// No description provided for @degrees.
  ///
  /// In en, this message translates to:
  /// **'degrees'**
  String get degrees;

  /// No description provided for @editProgress.
  ///
  /// In en, this message translates to:
  /// **'Edit Progress'**
  String get editProgress;

  /// No description provided for @belt.
  ///
  /// In en, this message translates to:
  /// **'Belt'**
  String get belt;

  /// No description provided for @stripes.
  ///
  /// In en, this message translates to:
  /// **'Stripes'**
  String get stripes;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @notificationsSchedule.
  ///
  /// In en, this message translates to:
  /// **'Notifications & Schedule'**
  String get notificationsSchedule;

  /// No description provided for @trainingDays.
  ///
  /// In en, this message translates to:
  /// **'Training Days'**
  String get trainingDays;

  /// No description provided for @usualTime.
  ///
  /// In en, this message translates to:
  /// **'Usual Class Time'**
  String get usualTime;

  /// No description provided for @linkEmail.
  ///
  /// In en, this message translates to:
  /// **'Link Email'**
  String get linkEmail;

  /// No description provided for @secureAccount.
  ///
  /// In en, this message translates to:
  /// **'Secure Account'**
  String get secureAccount;

  /// No description provided for @saveProgress.
  ///
  /// In en, this message translates to:
  /// **'Save your progress'**
  String get saveProgress;

  /// No description provided for @linkAccountDesc.
  ///
  /// In en, this message translates to:
  /// **'Link your account to an email to avoid losing data if you change devices.'**
  String get linkAccountDesc;

  /// No description provided for @rivalsTitle.
  ///
  /// In en, this message translates to:
  /// **'Training Partners'**
  String get rivalsTitle;

  /// No description provided for @noRivals.
  ///
  /// In en, this message translates to:
  /// **'No training partners yet.'**
  String get noRivals;

  /// No description provided for @addRival.
  ///
  /// In en, this message translates to:
  /// **'Add Partner'**
  String get addRival;

  /// No description provided for @newRivalTitle.
  ///
  /// In en, this message translates to:
  /// **'New Partner'**
  String get newRivalTitle;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @saveLabel.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveLabel;

  /// No description provided for @cancelLabel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelLabel;

  /// No description provided for @matchVs.
  ///
  /// In en, this message translates to:
  /// **'Match vs'**
  String get matchVs;

  /// No description provided for @winLabel.
  ///
  /// In en, this message translates to:
  /// **'Win'**
  String get winLabel;

  /// No description provided for @lossLabel.
  ///
  /// In en, this message translates to:
  /// **'Loss'**
  String get lossLabel;

  /// No description provided for @drawLabel.
  ///
  /// In en, this message translates to:
  /// **'Draw'**
  String get drawLabel;

  /// No description provided for @techniqueLibraryTitle.
  ///
  /// In en, this message translates to:
  /// **'Technique Library'**
  String get techniqueLibraryTitle;

  /// No description provided for @noTechniques.
  ///
  /// In en, this message translates to:
  /// **'No techniques learned yet.'**
  String get noTechniques;

  /// No description provided for @repetitionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Repetitions'**
  String get repetitionsLabel;

  /// No description provided for @levelLabel.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get levelLabel;

  /// No description provided for @techniqueDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Technique Detail'**
  String get techniqueDetailTitle;

  /// No description provided for @notesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notesLabel;

  /// No description provided for @saveNotes.
  ///
  /// In en, this message translates to:
  /// **'Save Notes'**
  String get saveNotes;

  /// No description provided for @historyLabel.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyLabel;

  /// No description provided for @checkInTitle.
  ///
  /// In en, this message translates to:
  /// **'Check-in'**
  String get checkInTitle;

  /// No description provided for @sessionType.
  ///
  /// In en, this message translates to:
  /// **'Session Type'**
  String get sessionType;

  /// No description provided for @durationLabel.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get durationLabel;

  /// No description provided for @trainingNotes.
  ///
  /// In en, this message translates to:
  /// **'Training Notes'**
  String get trainingNotes;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @accountSection.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountSection;

  /// No description provided for @manageSubscription.
  ///
  /// In en, this message translates to:
  /// **'Manage Subscription'**
  String get manageSubscription;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @aboutSection.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutSection;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @versionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get versionLabel;

  /// No description provided for @pleaseLogin.
  ///
  /// In en, this message translates to:
  /// **'Please login'**
  String get pleaseLogin;

  /// No description provided for @errorLabel.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorLabel(String error);

  /// No description provided for @matchResultQuestion.
  ///
  /// In en, this message translates to:
  /// **'What was the result of the training?'**
  String get matchResultQuestion;

  /// No description provided for @addedRivalMessage.
  ///
  /// In en, this message translates to:
  /// **'{name} added to your rivals'**
  String addedRivalMessage(String name);

  /// No description provided for @imageSelectionError.
  ///
  /// In en, this message translates to:
  /// **'Error selecting image: {error}'**
  String imageSelectionError(String error);

  /// No description provided for @scheduleUpdated.
  ///
  /// In en, this message translates to:
  /// **'Schedule updated'**
  String get scheduleUpdated;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully'**
  String get profileUpdated;

  /// No description provided for @updateError.
  ///
  /// In en, this message translates to:
  /// **'Error updating: {error}'**
  String updateError(String error);

  /// No description provided for @accountSecured.
  ///
  /// In en, this message translates to:
  /// **'Account secured successfully!'**
  String get accountSecured;

  /// No description provided for @linkButton.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get linkButton;

  /// No description provided for @trainingLogged.
  ///
  /// In en, this message translates to:
  /// **'Training logged successfully!'**
  String get trainingLogged;

  /// No description provided for @rpeLabel.
  ///
  /// In en, this message translates to:
  /// **'RPE (Intensity)'**
  String get rpeLabel;

  /// No description provided for @beltWhite.
  ///
  /// In en, this message translates to:
  /// **'White Belt'**
  String get beltWhite;

  /// No description provided for @beltBlue.
  ///
  /// In en, this message translates to:
  /// **'Blue Belt'**
  String get beltBlue;

  /// No description provided for @beltPurple.
  ///
  /// In en, this message translates to:
  /// **'Purple Belt'**
  String get beltPurple;

  /// No description provided for @beltBrown.
  ///
  /// In en, this message translates to:
  /// **'Brown Belt'**
  String get beltBrown;

  /// No description provided for @beltBlack.
  ///
  /// In en, this message translates to:
  /// **'Black Belt'**
  String get beltBlack;

  /// No description provided for @analyticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Analytics & Progress'**
  String get analyticsTitle;

  /// No description provided for @gameStyleTitle.
  ///
  /// In en, this message translates to:
  /// **'Game Style'**
  String get gameStyleTitle;

  /// No description provided for @gameStyleExplanation.
  ///
  /// In en, this message translates to:
  /// **'This chart shows your technical profile based on the techniques you practice. The larger the area in each category, the more techniques you master in that style.'**
  String get gameStyleExplanation;

  /// No description provided for @trainingDistributionTitle.
  ///
  /// In en, this message translates to:
  /// **'Training Distribution'**
  String get trainingDistributionTitle;

  /// No description provided for @trainingDistributionExplanation.
  ///
  /// In en, this message translates to:
  /// **'Shows what percentage of your training is with Gi vs NoGi. Helps you see if you are balanced or focusing more on one modality.'**
  String get trainingDistributionExplanation;

  /// No description provided for @matTimeTitle.
  ///
  /// In en, this message translates to:
  /// **'Mat Time'**
  String get matTimeTitle;

  /// No description provided for @matTimeExplanation.
  ///
  /// In en, this message translates to:
  /// **'This chart shows your accumulated training hours over time. The line always goes up, representing your total effort on the mat.'**
  String get matTimeExplanation;

  /// No description provided for @intensityTitle.
  ///
  /// In en, this message translates to:
  /// **'Intensity (RPE)'**
  String get intensityTitle;

  /// No description provided for @intensityExplanation.
  ///
  /// In en, this message translates to:
  /// **'Each point represents the intensity of a training session (RPE from 1 to 10). Green = light session, Orange = moderate, Red = very intense. Helps you avoid overtraining.'**
  String get intensityExplanation;

  /// No description provided for @topPositionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Technique Categories'**
  String get topPositionsTitle;

  /// No description provided for @topPositionsExplanation.
  ///
  /// In en, this message translates to:
  /// **'Shows the categories where you have the most techniques registered (Guard, Passing, Submission, Defense, Takedowns). Defines which areas you focus on most.'**
  String get topPositionsExplanation;

  /// No description provided for @weeklyConsistencyTitle.
  ///
  /// In en, this message translates to:
  /// **'Weekly Consistency'**
  String get weeklyConsistencyTitle;

  /// No description provided for @weeklyConsistencyExplanation.
  ///
  /// In en, this message translates to:
  /// **'Shows which days of the week you train most frequently. Helps you identify your training routine.'**
  String get weeklyConsistencyExplanation;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
