// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Welcome back!`
  String get welcomeBack {
    return Intl.message(
      'Welcome back!',
      name: 'welcomeBack',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get usernameHint {
    return Intl.message('Username', name: 'usernameHint', desc: '', args: []);
  }

  /// `Password`
  String get passwordHint {
    return Intl.message('Password', name: 'passwordHint', desc: '', args: []);
  }

  /// `Sign in`
  String get loginButton {
    return Intl.message('Sign in', name: 'loginButton', desc: '', args: []);
  }

  /// `Sign in`
  String get signIn {
    return Intl.message('Sign in', name: 'signIn', desc: '', args: []);
  }

  /// `Registration`
  String get registration {
    return Intl.message(
      'Registration',
      name: 'registration',
      desc: '',
      args: [],
    );
  }

  /// `Tell us about yourself`
  String get tellAboutYourself {
    return Intl.message(
      'Tell us about yourself',
      name: 'tellAboutYourself',
      desc: '',
      args: [],
    );
  }

  /// `Gender`
  String get gender {
    return Intl.message('Gender', name: 'gender', desc: '', args: []);
  }

  /// `Male`
  String get male {
    return Intl.message('Male', name: 'male', desc: '', args: []);
  }

  /// `Female`
  String get female {
    return Intl.message('Female', name: 'female', desc: '', args: []);
  }

  /// `Description`
  String get description {
    return Intl.message('Description', name: 'description', desc: '', args: []);
  }

  /// `Tell us about yourself`
  String get tellAboutYourselfValidation {
    return Intl.message(
      'Tell us about yourself',
      name: 'tellAboutYourselfValidation',
      desc: '',
      args: [],
    );
  }

  /// `Dating goals`
  String get datingGoals {
    return Intl.message(
      'Dating goals',
      name: 'datingGoals',
      desc: '',
      args: [],
    );
  }

  /// `Friendship`
  String get friendship {
    return Intl.message('Friendship', name: 'friendship', desc: '', args: []);
  }

  /// `Love`
  String get love {
    return Intl.message('Love', name: 'love', desc: '', args: []);
  }

  /// `Communication`
  String get communication {
    return Intl.message(
      'Communication',
      name: 'communication',
      desc: '',
      args: [],
    );
  }

  /// `Interests`
  String get interests {
    return Intl.message('Interests', name: 'interests', desc: '', args: []);
  }

  /// `Sports`
  String get sports {
    return Intl.message('Sports', name: 'sports', desc: '', args: []);
  }

  /// `Games`
  String get games {
    return Intl.message('Games', name: 'games', desc: '', args: []);
  }

  /// `Books`
  String get books {
    return Intl.message('Books', name: 'books', desc: '', args: []);
  }

  /// `Music`
  String get music {
    return Intl.message('Music', name: 'music', desc: '', args: []);
  }

  /// `Your photo`
  String get yourPhoto {
    return Intl.message('Your photo', name: 'yourPhoto', desc: '', args: []);
  }

  /// `Sign up`
  String get signUp {
    return Intl.message('Sign up', name: 'signUp', desc: '', args: []);
  }

  /// `Next`
  String get next {
    return Intl.message('Next', name: 'next', desc: '', args: []);
  }

  /// `Credentials`
  String get credentials {
    return Intl.message('Credentials', name: 'credentials', desc: '', args: []);
  }

  /// `Username`
  String get username {
    return Intl.message('Username', name: 'username', desc: '', args: []);
  }

  /// `Please enter username`
  String get enterUsername {
    return Intl.message(
      'Please enter username',
      name: 'enterUsername',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Please enter email`
  String get enterEmail {
    return Intl.message(
      'Please enter email',
      name: 'enterEmail',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email`
  String get invalidEmail {
    return Intl.message(
      'Invalid email',
      name: 'invalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Please enter password`
  String get enterPassword {
    return Intl.message(
      'Please enter password',
      name: 'enterPassword',
      desc: '',
      args: [],
    );
  }

  /// `At least 6 characters`
  String get minPassword {
    return Intl.message(
      'At least 6 characters',
      name: 'minPassword',
      desc: '',
      args: [],
    );
  }

  /// `Allow my profile to be searchable`
  String get allowProfileSearch {
    return Intl.message(
      'Allow my profile to be searchable',
      name: 'allowProfileSearch',
      desc: '',
      args: [],
    );
  }

  /// `Personal information`
  String get personalInfo {
    return Intl.message(
      'Personal information',
      name: 'personalInfo',
      desc: '',
      args: [],
    );
  }

  /// `First name`
  String get firstName {
    return Intl.message('First name', name: 'firstName', desc: '', args: []);
  }

  /// `Please enter first name`
  String get enterFirstName {
    return Intl.message(
      'Please enter first name',
      name: 'enterFirstName',
      desc: '',
      args: [],
    );
  }

  /// `Last name`
  String get lastName {
    return Intl.message('Last name', name: 'lastName', desc: '', args: []);
  }

  /// `Please enter last name`
  String get enterLastName {
    return Intl.message(
      'Please enter last name',
      name: 'enterLastName',
      desc: '',
      args: [],
    );
  }

  /// `Age`
  String get age {
    return Intl.message('Age', name: 'age', desc: '', args: []);
  }

  /// `Please enter age`
  String get enterAge {
    return Intl.message(
      'Please enter age',
      name: 'enterAge',
      desc: '',
      args: [],
    );
  }

  /// `Minimum age is 14`
  String get minAge {
    return Intl.message(
      'Minimum age is 14',
      name: 'minAge',
      desc: '',
      args: [],
    );
  }

  /// `City`
  String get city {
    return Intl.message('City', name: 'city', desc: '', args: []);
  }

  /// `Please enter city`
  String get enterCity {
    return Intl.message(
      'Please enter city',
      name: 'enterCity',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message('Register', name: 'register', desc: '', args: []);
  }

  /// `Search`
  String get search {
    return Intl.message('Search', name: 'search', desc: '', args: []);
  }

  /// `Chat`
  String get chat {
    return Intl.message('Chat', name: 'chat', desc: '', args: []);
  }

  /// `Friends`
  String get friends {
    return Intl.message('Friends', name: 'friends', desc: '', args: []);
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `Temporary Chats`
  String get temporaryChats {
    return Intl.message(
      'Temporary Chats',
      name: 'temporaryChats',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get errorPrefix {
    return Intl.message('Error', name: 'errorPrefix', desc: '', args: []);
  }

  /// `No temporary chats`
  String get noTemporaryChats {
    return Intl.message(
      'No temporary chats',
      name: 'noTemporaryChats',
      desc: '',
      args: [],
    );
  }

  /// `Anonymous chat`
  String get anonymousChat {
    return Intl.message(
      'Anonymous chat',
      name: 'anonymousChat',
      desc: '',
      args: [],
    );
  }

  /// `Tap to view`
  String get tapToView {
    return Intl.message('Tap to view', name: 'tapToView', desc: '', args: []);
  }

  /// `Chats`
  String get chats {
    return Intl.message('Chats', name: 'chats', desc: '', args: []);
  }

  /// `Permanent Chats`
  String get permanentChats {
    return Intl.message(
      'Permanent Chats',
      name: 'permanentChats',
      desc: '',
      args: [],
    );
  }

  /// `You have no permanent chats yet`
  String get noPermanentChats {
    return Intl.message(
      'You have no permanent chats yet',
      name: 'noPermanentChats',
      desc: '',
      args: [],
    );
  }

  /// `Start communicating to add people as friends`
  String get startCommunicationHint {
    return Intl.message(
      'Start communicating to add people as friends',
      name: 'startCommunicationHint',
      desc: '',
      args: [],
    );
  }

  /// `Start communicating`
  String get startCommunication {
    return Intl.message(
      'Start communicating',
      name: 'startCommunication',
      desc: '',
      args: [],
    );
  }

  /// `Anonymous`
  String get anonymous {
    return Intl.message('Anonymous', name: 'anonymous', desc: '', args: []);
  }

  /// `Stop-stop, think about where you want to start...`
  String get stopThink {
    return Intl.message(
      'Stop-stop, think about where you want to start...',
      name: 'stopThink',
      desc: '',
      args: [],
    );
  }

  /// `Timer:`
  String get timerSeconds {
    return Intl.message('Timer:', name: 'timerSeconds', desc: '', args: []);
  }

  /// `seconds`
  String get seconds {
    return Intl.message('seconds', name: 'seconds', desc: '', args: []);
  }

  /// `Continue`
  String get continues {
    return Intl.message('Continue', name: 'continues', desc: '', args: []);
  }

  /// `Chat time is coming to an end`
  String get chatTimeEnding {
    return Intl.message(
      'Chat time is coming to an end',
      name: 'chatTimeEnding',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to extend the chat time or go to the questionnaire?`
  String get extendOrQuestionnaire {
    return Intl.message(
      'Do you want to extend the chat time or go to the questionnaire?',
      name: 'extendOrQuestionnaire',
      desc: '',
      args: [],
    );
  }

  /// `Add 3 minutes`
  String get add3Minutes {
    return Intl.message(
      'Add 3 minutes',
      name: 'add3Minutes',
      desc: '',
      args: [],
    );
  }

  /// `Open questionnaire`
  String get openQuestionnaire {
    return Intl.message(
      'Open questionnaire',
      name: 'openQuestionnaire',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message('Close', name: 'close', desc: '', args: []);
  }

  /// `Finish temporary chat?`
  String get finishTemporaryChat {
    return Intl.message(
      'Finish temporary chat?',
      name: 'finishTemporaryChat',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to finish this temporary chat or just close it?`
  String get finishOrClose {
    return Intl.message(
      'Do you want to finish this temporary chat or just close it?',
      name: 'finishOrClose',
      desc: '',
      args: [],
    );
  }

  /// `Finish`
  String get finish {
    return Intl.message('Finish', name: 'finish', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Anonymous user`
  String get anonymousUser {
    return Intl.message(
      'Anonymous user',
      name: 'anonymousUser',
      desc: '',
      args: [],
    );
  }

  /// `connecting...`
  String get connecting {
    return Intl.message(
      'connecting...',
      name: 'connecting',
      desc: '',
      args: [],
    );
  }

  /// `typing...`
  String get typing {
    return Intl.message('typing...', name: 'typing', desc: '', args: []);
  }

  /// `offline`
  String get offline {
    return Intl.message('offline', name: 'offline', desc: '', args: []);
  }

  /// `sending file`
  String get sendingFile {
    return Intl.message(
      'sending file',
      name: 'sendingFile',
      desc: '',
      args: [],
    );
  }

  /// `sending photo`
  String get sendingImage {
    return Intl.message(
      'sending photo',
      name: 'sendingImage',
      desc: '',
      args: [],
    );
  }

  /// `online`
  String get online {
    return Intl.message('online', name: 'online', desc: '', args: []);
  }

  /// `Error`
  String get error {
    return Intl.message('Error', name: 'error', desc: '', args: []);
  }

  /// `Retry`
  String get retry {
    return Intl.message('Retry', name: 'retry', desc: '', args: []);
  }

  /// `Message...`
  String get messageHint {
    return Intl.message('Message...', name: 'messageHint', desc: '', args: []);
  }

  /// `Loading messages...`
  String get loadingMessages {
    return Intl.message(
      'Loading messages...',
      name: 'loadingMessages',
      desc: '',
      args: [],
    );
  }

  /// `Found`
  String get found {
    return Intl.message('Found', name: 'found', desc: '', args: []);
  }

  /// `Available commands`
  String get availableCommands {
    return Intl.message(
      'Available commands',
      name: 'availableCommands',
      desc: '',
      args: [],
    );
  }

  /// `You have no friends yet`
  String get noFriendsYet {
    return Intl.message(
      'You have no friends yet',
      name: 'noFriendsYet',
      desc: '',
      args: [],
    );
  }

  /// `Send message`
  String get sendMessage {
    return Intl.message(
      'Send message',
      name: 'sendMessage',
      desc: '',
      args: [],
    );
  }

  /// `Remove friend`
  String get removeFriend {
    return Intl.message(
      'Remove friend',
      name: 'removeFriend',
      desc: '',
      args: [],
    );
  }

  /// `Search friends...`
  String get searchFriendsHint {
    return Intl.message(
      'Search friends...',
      name: 'searchFriendsHint',
      desc: '',
      args: [],
    );
  }

  /// `Account Settings`
  String get accountSettings {
    return Intl.message(
      'Account Settings',
      name: 'accountSettings',
      desc: '',
      args: [],
    );
  }

  /// `App Settings`
  String get appSettings {
    return Intl.message(
      'App Settings',
      name: 'appSettings',
      desc: '',
      args: [],
    );
  }

  /// `About App`
  String get aboutApp {
    return Intl.message('About App', name: 'aboutApp', desc: '', args: []);
  }

  /// `Profile`
  String get profile {
    return Intl.message('Profile', name: 'profile', desc: '', args: []);
  }

  /// `Friend Requests`
  String get friendRequests {
    return Intl.message(
      'Friend Requests',
      name: 'friendRequests',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `Russian`
  String get russian {
    return Intl.message('Russian', name: 'russian', desc: '', args: []);
  }

  /// `QR Scanner`
  String get qrScanner {
    return Intl.message('QR Scanner', name: 'qrScanner', desc: '', args: []);
  }

  /// `Notifications`
  String get notifications {
    return Intl.message(
      'Notifications',
      name: 'notifications',
      desc: '',
      args: [],
    );
  }

  /// `Security`
  String get security {
    return Intl.message('Security', name: 'security', desc: '', args: []);
  }

  /// `Theme`
  String get theme {
    return Intl.message('Theme', name: 'theme', desc: '', args: []);
  }

  /// `Support`
  String get support {
    return Intl.message('Support', name: 'support', desc: '', args: []);
  }

  /// `Exit`
  String get exit {
    return Intl.message('Exit', name: 'exit', desc: '', args: []);
  }

  /// `{count} friends`
  String friendsCount(Object count) {
    return Intl.message(
      '$count friends',
      name: 'friendsCount',
      desc: '',
      args: [count],
    );
  }

  /// `Version {version}`
  String version(Object version) {
    return Intl.message(
      'Version $version',
      name: 'version',
      desc: '',
      args: [version],
    );
  }

  /// `Theme Selection`
  String get themeSelection {
    return Intl.message(
      'Theme Selection',
      name: 'themeSelection',
      desc: '',
      args: [],
    );
  }

  /// `Choose a theme`
  String get chooseTheme {
    return Intl.message(
      'Choose a theme',
      name: 'chooseTheme',
      desc: '',
      args: [],
    );
  }

  /// `Changes will affect the entire app interface`
  String get themeChangesAffect {
    return Intl.message(
      'Changes will affect the entire app interface',
      name: 'themeChangesAffect',
      desc: '',
      args: [],
    );
  }

  /// `Light Theme`
  String get lightTheme {
    return Intl.message('Light Theme', name: 'lightTheme', desc: '', args: []);
  }

  /// `Dark Theme`
  String get darkTheme {
    return Intl.message('Dark Theme', name: 'darkTheme', desc: '', args: []);
  }

  /// `Clean and bright design`
  String get lightDescription {
    return Intl.message(
      'Clean and bright design',
      name: 'lightDescription',
      desc: '',
      args: [],
    );
  }

  /// `Stylish and modern design`
  String get darkDescription {
    return Intl.message(
      'Stylish and modern design',
      name: 'darkDescription',
      desc: '',
      args: [],
    );
  }

  /// `Current`
  String get currents {
    return Intl.message('Current', name: 'currents', desc: '', args: []);
  }

  /// `Primary`
  String get primary {
    return Intl.message('Primary', name: 'primary', desc: '', args: []);
  }

  /// `Background`
  String get background {
    return Intl.message('Background', name: 'background', desc: '', args: []);
  }

  /// `Text`
  String get text {
    return Intl.message('Text', name: 'text', desc: '', args: []);
  }

  /// `Edit Profile`
  String get editProfile {
    return Intl.message(
      'Edit Profile',
      name: 'editProfile',
      desc: '',
      args: [],
    );
  }

  /// `About me`
  String get aboutMe {
    return Intl.message('About me', name: 'aboutMe', desc: '', args: []);
  }

  /// `Visible in search`
  String get visibleInSearch {
    return Intl.message(
      'Visible in search',
      name: 'visibleInSearch',
      desc: '',
      args: [],
    );
  }

  /// `Other users can find you`
  String get visibleInSearchDescription {
    return Intl.message(
      'Other users can find you',
      name: 'visibleInSearchDescription',
      desc: '',
      args: [],
    );
  }

  /// `My Interests`
  String get myInterests {
    return Intl.message(
      'My Interests',
      name: 'myInterests',
      desc: '',
      args: [],
    );
  }

  /// `Add interest`
  String get addInterestHint {
    return Intl.message(
      'Add interest',
      name: 'addInterestHint',
      desc: '',
      args: [],
    );
  }

  /// `Add purpose`
  String get addPurposeHint {
    return Intl.message(
      'Add purpose',
      name: 'addPurposeHint',
      desc: '',
      args: [],
    );
  }

  /// `Select gender`
  String get selectGender {
    return Intl.message(
      'Select gender',
      name: 'selectGender',
      desc: '',
      args: [],
    );
  }

  /// `Select age`
  String get selectAge {
    return Intl.message('Select age', name: 'selectAge', desc: '', args: []);
  }

  /// `City (optional)`
  String get cityOptional {
    return Intl.message(
      'City (optional)',
      name: 'cityOptional',
      desc: '',
      args: [],
    );
  }

  /// `Only verified users`
  String get onlyVerified {
    return Intl.message(
      'Only verified users',
      name: 'onlyVerified',
      desc: '',
      args: [],
    );
  }

  /// `Purposes`
  String get purposes {
    return Intl.message('Purposes', name: 'purposes', desc: '', args: []);
  }

  /// `Start search`
  String get startSearch {
    return Intl.message(
      'Start search',
      name: 'startSearch',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `My Profile`
  String get myProfile {
    return Intl.message('My Profile', name: 'myProfile', desc: '', args: []);
  }

  /// `View all`
  String get viewAll {
    return Intl.message('View all', name: 'viewAll', desc: '', args: []);
  }

  /// `years`
  String get years {
    return Intl.message('years', name: 'years', desc: '', args: []);
  }

  /// `Friend`
  String get friend {
    return Intl.message('Friend', name: 'friend', desc: '', args: []);
  }

  /// `QR Scanning`
  String get qrScanning {
    return Intl.message('QR Scanning', name: 'qrScanning', desc: '', args: []);
  }

  /// `Camera start error`
  String get cameraStartError {
    return Intl.message(
      'Camera start error',
      name: 'cameraStartError',
      desc: '',
      args: [],
    );
  }

  /// `Scanned`
  String get scanned {
    return Intl.message('Scanned', name: 'scanned', desc: '', args: []);
  }

  /// `QR scanning is not available on this platform`
  String get qrNotAvailable {
    return Intl.message(
      'QR scanning is not available on this platform',
      name: 'qrNotAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Enter PIN code`
  String get enterPinCode {
    return Intl.message(
      'Enter PIN code',
      name: 'enterPinCode',
      desc: '',
      args: [],
    );
  }

  /// `Incorrect PIN code`
  String get incorrectPinCode {
    return Intl.message(
      'Incorrect PIN code',
      name: 'incorrectPinCode',
      desc: '',
      args: [],
    );
  }

  /// `Auto Lock`
  String get autoLock {
    return Intl.message('Auto Lock', name: 'autoLock', desc: '', args: []);
  }

  /// `Lock the app after 5 minutes of inactivity`
  String get autoLockDescription {
    return Intl.message(
      'Lock the app after 5 minutes of inactivity',
      name: 'autoLockDescription',
      desc: '',
      args: [],
    );
  }

  /// `PIN Protection`
  String get pinProtection {
    return Intl.message(
      'PIN Protection',
      name: 'pinProtection',
      desc: '',
      args: [],
    );
  }

  /// `Enable PIN`
  String get enablePin {
    return Intl.message('Enable PIN', name: 'enablePin', desc: '', args: []);
  }

  /// `Change PIN`
  String get changePin {
    return Intl.message('Change PIN', name: 'changePin', desc: '', args: []);
  }

  /// `Privacy Mode`
  String get privacyMode {
    return Intl.message(
      'Privacy Mode',
      name: 'privacyMode',
      desc: '',
      args: [],
    );
  }

  /// `Hide sensitive information in background`
  String get privacyModeDescription {
    return Intl.message(
      'Hide sensitive information in background',
      name: 'privacyModeDescription',
      desc: '',
      args: [],
    );
  }

  /// `Confirm PIN`
  String get confirmPin {
    return Intl.message('Confirm PIN', name: 'confirmPin', desc: '', args: []);
  }

  /// `Set new PIN`
  String get setNewPin {
    return Intl.message('Set new PIN', name: 'setNewPin', desc: '', args: []);
  }

  /// `PIN codes do not match`
  String get pinMismatch {
    return Intl.message(
      'PIN codes do not match',
      name: 'pinMismatch',
      desc: '',
      args: [],
    );
  }

  /// `PIN code set successfully`
  String get pinSetSuccess {
    return Intl.message(
      'PIN code set successfully',
      name: 'pinSetSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Confirm`
  String get confirm {
    return Intl.message('Confirm', name: 'confirm', desc: '', args: []);
  }

  /// `Point your camera at the QR code`
  String get qrScanInstruction {
    return Intl.message(
      'Point your camera at the QR code',
      name: 'qrScanInstruction',
      desc: '',
      args: [],
    );
  }

  /// `Unable to recognize data`
  String get qrNoValue {
    return Intl.message(
      'Unable to recognize data',
      name: 'qrNoValue',
      desc: '',
      args: [],
    );
  }

  /// `Enter current PIN`
  String get enterCurrentPin {
    return Intl.message(
      'Enter current PIN',
      name: 'enterCurrentPin',
      desc: '',
      args: [],
    );
  }

  /// `Incorrect PIN`
  String get incorrectPin {
    return Intl.message(
      'Incorrect PIN',
      name: 'incorrectPin',
      desc: '',
      args: [],
    );
  }

  /// `Please enter all 4 digits`
  String get enterFullPin {
    return Intl.message(
      'Please enter all 4 digits',
      name: 'enterFullPin',
      desc: '',
      args: [],
    );
  }

  /// `PIN changed successfully`
  String get pinChangedSuccess {
    return Intl.message(
      'PIN changed successfully',
      name: 'pinChangedSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Clear History`
  String get clearHistory {
    return Intl.message(
      'Clear History',
      name: 'clearHistory',
      desc: '',
      args: [],
    );
  }

  /// `DeleteChat`
  String get deletechat {
    return Intl.message('DeleteChat', name: 'deletechat', desc: '', args: []);
  }

  /// `BlockUser`
  String get blockuser {
    return Intl.message('BlockUser', name: 'blockuser', desc: '', args: []);
  }

  /// `ReportUser`
  String get reportuser {
    return Intl.message('ReportUser', name: 'reportuser', desc: '', args: []);
  }

  /// `clearHistoryConfirmation`
  String get clearhistoryconfirmation {
    return Intl.message(
      'clearHistoryConfirmation',
      name: 'clearhistoryconfirmation',
      desc: '',
      args: [],
    );
  }

  /// `historyCleared`
  String get historycleared {
    return Intl.message(
      'historyCleared',
      name: 'historycleared',
      desc: '',
      args: [],
    );
  }

  /// `clear`
  String get clear {
    return Intl.message('clear', name: 'clear', desc: '', args: []);
  }

  /// `deleteChatConfirmation`
  String get deletechatconfirmation {
    return Intl.message(
      'deleteChatConfirmation',
      name: 'deletechatconfirmation',
      desc: '',
      args: [],
    );
  }

  /// `chatDeleted`
  String get chatdeleted {
    return Intl.message('chatDeleted', name: 'chatdeleted', desc: '', args: []);
  }

  /// `delete`
  String get delete {
    return Intl.message('delete', name: 'delete', desc: '', args: []);
  }

  /// `blockUserConfirmation`
  String get blockuserconfirmation {
    return Intl.message(
      'blockUserConfirmation',
      name: 'blockuserconfirmation',
      desc: '',
      args: [],
    );
  }

  /// `userBlocked`
  String get userblocked {
    return Intl.message('userBlocked', name: 'userblocked', desc: '', args: []);
  }

  /// `block`
  String get block {
    return Intl.message('block', name: 'block', desc: '', args: []);
  }

  /// `reportUserDescription`
  String get reportuserdescription {
    return Intl.message(
      'reportUserDescription',
      name: 'reportuserdescription',
      desc: '',
      args: [],
    );
  }

  /// `selectReason`
  String get selectreason {
    return Intl.message(
      'selectReason',
      name: 'selectreason',
      desc: '',
      args: [],
    );
  }

  /// `additionalComments`
  String get additionalcomments {
    return Intl.message(
      'additionalComments',
      name: 'additionalcomments',
      desc: '',
      args: [],
    );
  }

  /// `reportSubmitted`
  String get reportsubmitted {
    return Intl.message(
      'reportSubmitted',
      name: 'reportsubmitted',
      desc: '',
      args: [],
    );
  }

  /// `submitReport`
  String get submitreport {
    return Intl.message(
      'submitReport',
      name: 'submitreport',
      desc: '',
      args: [],
    );
  }

  /// `spam`
  String get spam {
    return Intl.message('spam', name: 'spam', desc: '', args: []);
  }

  /// `harassment`
  String get harassment {
    return Intl.message('harassment', name: 'harassment', desc: '', args: []);
  }

  /// `inappropriateContent`
  String get inappropriatecontent {
    return Intl.message(
      'inappropriateContent',
      name: 'inappropriatecontent',
      desc: '',
      args: [],
    );
  }

  /// `fakeProfile`
  String get fakeprofile {
    return Intl.message('fakeProfile', name: 'fakeprofile', desc: '', args: []);
  }

  /// `other`
  String get other {
    return Intl.message('other', name: 'other', desc: '', args: []);
  }

  /// `changePassword`
  String get changepassword {
    return Intl.message(
      'changePassword',
      name: 'changepassword',
      desc: '',
      args: [],
    );
  }

  /// `newPassword`
  String get newpassword {
    return Intl.message('newPassword', name: 'newpassword', desc: '', args: []);
  }

  /// `oldPassword`
  String get oldpassword {
    return Intl.message('oldPassword', name: 'oldpassword', desc: '', args: []);
  }

  /// `noPurposesAdded`
  String get nopurposesadded {
    return Intl.message(
      'noPurposesAdded',
      name: 'nopurposesadded',
      desc: '',
      args: [],
    );
  }

  /// `noInterestsAdded`
  String get nointerestsadded {
    return Intl.message(
      'noInterestsAdded',
      name: 'nointerestsadded',
      desc: '',
      args: [],
    );
  }

  /// `passwordChangedSuccessfully`
  String get passwordchangedsuccessfully {
    return Intl.message(
      'passwordChangedSuccessfully',
      name: 'passwordchangedsuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `profileUpdatedSuccessfully`
  String get profileupdatedsuccessfully {
    return Intl.message(
      'profileUpdatedSuccessfully',
      name: 'profileupdatedsuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `avatarUploadFailed`
  String get avataruploadfailed {
    return Intl.message(
      'avatarUploadFailed',
      name: 'avataruploadfailed',
      desc: '',
      args: [],
    );
  }

  /// `avatarUpdatedSuccessfully`
  String get avatarupdatedsuccessfully {
    return Intl.message(
      'avatarUpdatedSuccessfully',
      name: 'avatarupdatedsuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `uploadingAvatar`
  String get uploadingavatar {
    return Intl.message(
      'uploadingAvatar',
      name: 'uploadingavatar',
      desc: '',
      args: [],
    );
  }

  /// `Searching`
  String get searching {
    return Intl.message('Searching', name: 'searching', desc: '', args: []);
  }

  /// `Обновление...`
  String get updating {
    return Intl.message('Обновление...', name: 'updating', desc: '', args: []);
  }

  /// `Мои жалобы`
  String get my_report {
    return Intl.message('Мои жалобы', name: 'my_report', desc: '', args: []);
  }

  /// `Настройки уведомлений`
  String get notification_settings {
    return Intl.message(
      'Настройки уведомлений',
      name: 'notification_settings',
      desc: '',
      args: [],
    );
  }

  /// `Мои вопросы в поддержку`
  String get my_question_support {
    return Intl.message(
      'Мои вопросы в поддержку',
      name: 'my_question_support',
      desc: '',
      args: [],
    );
  }

  /// `Стикеры не найдены`
  String get stickers_not_found {
    return Intl.message(
      'Стикеры не найдены',
      name: 'stickers_not_found',
      desc: '',
      args: [],
    );
  }

  /// `Повторить`
  String get repeat {
    return Intl.message('Повторить', name: 'repeat', desc: '', args: []);
  }

  /// `Ошибка загрузки стикеров:`
  String get sticker_loading_error {
    return Intl.message(
      'Ошибка загрузки стикеров:',
      name: 'sticker_loading_error',
      desc: '',
      args: [],
    );
  }

  /// `Стикеры`
  String get stickers {
    return Intl.message('Стикеры', name: 'stickers', desc: '', args: []);
  }

  /// `Пожалуйста, выберите причину жалобы`
  String get please_select_the_reason_for_the_complaint {
    return Intl.message(
      'Пожалуйста, выберите причину жалобы',
      name: 'please_select_the_reason_for_the_complaint',
      desc: '',
      args: [],
    );
  }

  /// `Добавить время`
  String get add_time {
    return Intl.message('Добавить время', name: 'add_time', desc: '', args: []);
  }

  /// `Продолжить чат`
  String get continue_the_chat {
    return Intl.message(
      'Продолжить чат',
      name: 'continue_the_chat',
      desc: '',
      args: [],
    );
  }

  /// `Добавить в друзья?`
  String get add_to_friends {
    return Intl.message(
      'Добавить в друзья?',
      name: 'add_to_friends',
      desc: '',
      args: [],
    );
  }

  /// `Хотите отправить заявку в друзья пользователю`
  String get would_you_like_to_send_a_friend_request_to_a_user {
    return Intl.message(
      'Хотите отправить заявку в друзья пользователю',
      name: 'would_you_like_to_send_a_friend_request_to_a_user',
      desc: '',
      args: [],
    );
  }

  /// `Заявка в друзья отправлена`
  String get the_friend_request_has_been_sent {
    return Intl.message(
      'Заявка в друзья отправлена',
      name: 'the_friend_request_has_been_sent',
      desc: '',
      args: [],
    );
  }

  /// `Отправить`
  String get send {
    return Intl.message('Отправить', name: 'send', desc: '', args: []);
  }

  /// `Загрузка...`
  String get loading {
    return Intl.message('Загрузка...', name: 'loading', desc: '', args: []);
  }

  /// `Ошибка загрузки`
  String get download_error {
    return Intl.message(
      'Ошибка загрузки',
      name: 'download_error',
      desc: '',
      args: [],
    );
  }

  /// `Изображение недоступно`
  String get the_image_is_unavailable {
    return Intl.message(
      'Изображение недоступно',
      name: 'the_image_is_unavailable',
      desc: '',
      args: [],
    );
  }

  /// `Стикер`
  String get sticker {
    return Intl.message('Стикер', name: 'sticker', desc: '', args: []);
  }

  /// `Продолжить общение`
  String get continue_communication {
    return Intl.message(
      'Продолжить общение',
      name: 'continue_communication',
      desc: '',
      args: [],
    );
  }

  /// `Собеседник предлагает продолжить общение в постоянном чате. `
  String
  get the_interlocutor_suggests_continuing_the_conversation_in_a_permanent_chat {
    return Intl.message(
      'Собеседник предлагает продолжить общение в постоянном чате. ',
      name:
          'the_interlocutor_suggests_continuing_the_conversation_in_a_permanent_chat',
      desc: '',
      args: [],
    );
  }

  /// `Вы согласны`
  String get do_you_agree {
    return Intl.message(
      'Вы согласны',
      name: 'do_you_agree',
      desc: '',
      args: [],
    );
  }

  /// `Отклонить`
  String get reject {
    return Intl.message('Отклонить', name: 'reject', desc: '', args: []);
  }

  /// `Принять`
  String get accept {
    return Intl.message('Принять', name: 'accept', desc: '', args: []);
  }

  /// `Постоянный чат создан`
  String get permanent_chat_has_been_created {
    return Intl.message(
      'Постоянный чат создан',
      name: 'permanent_chat_has_been_created',
      desc: '',
      args: [],
    );
  }

  /// `Теперь вы можете продолжить общение в постоянном чате. `
  String get now_you_can_continue_chatting_in_a_permanent_chat_room {
    return Intl.message(
      'Теперь вы можете продолжить общение в постоянном чате. ',
      name: 'now_you_can_continue_chatting_in_a_permanent_chat_room',
      desc: '',
      args: [],
    );
  }

  /// `Все сообщения сохранены.`
  String get all_messages_are_saved {
    return Intl.message(
      'Все сообщения сохранены.',
      name: 'all_messages_are_saved',
      desc: '',
      args: [],
    );
  }

  /// `Ожидание ответа`
  String get waiting_for_a_response {
    return Intl.message(
      'Ожидание ответа',
      name: 'waiting_for_a_response',
      desc: '',
      args: [],
    );
  }

  /// `Запрос на продолжение чата отправлен. `
  String get the_request_to_continue_the_chat_has_been_sent {
    return Intl.message(
      'Запрос на продолжение чата отправлен. ',
      name: 'the_request_to_continue_the_chat_has_been_sent',
      desc: '',
      args: [],
    );
  }

  /// `Ожидаем ответа от собеседника...`
  String get we_are_waiting_for_a_response_from_the_interlocutor {
    return Intl.message(
      'Ожидаем ответа от собеседника...',
      name: 'we_are_waiting_for_a_response_from_the_interlocutor',
      desc: '',
      args: [],
    );
  }

  /// `Хотите предложить собеседнику продолжить общение в постоянном чате?`
  String
  get do_you_want_to_invite_your_conversation_partner_to_continue_chatting_in_a_permanent_chat_room {
    return Intl.message(
      'Хотите предложить собеседнику продолжить общение в постоянном чате?',
      name:
          'do_you_want_to_invite_your_conversation_partner_to_continue_chatting_in_a_permanent_chat_room',
      desc: '',
      args: [],
    );
  }

  /// `Предложить`
  String get offer {
    return Intl.message('Предложить', name: 'offer', desc: '', args: []);
  }

  /// `Время чата подходит к концу`
  String get the_chat_time_is_coming_to_an_end {
    return Intl.message(
      'Время чата подходит к концу',
      name: 'the_chat_time_is_coming_to_an_end',
      desc: '',
      args: [],
    );
  }

  /// `Выберите действие:`
  String get select_an_action {
    return Intl.message(
      'Выберите действие:',
      name: 'select_an_action',
      desc: '',
      args: [],
    );
  }

  /// `Продолжить в постоянном чате`
  String get continue_in_constant_chat {
    return Intl.message(
      'Продолжить в постоянном чате',
      name: 'continue_in_constant_chat',
      desc: '',
      args: [],
    );
  }

  /// `Завершить чат`
  String get end_the_chat {
    return Intl.message(
      'Завершить чат',
      name: 'end_the_chat',
      desc: '',
      args: [],
    );
  }

  /// `Добавить время к чату`
  String get add_time_to_the_chat {
    return Intl.message(
      'Добавить время к чату',
      name: 'add_time_to_the_chat',
      desc: '',
      args: [],
    );
  }

  /// `мин`
  String get mines {
    return Intl.message('мин', name: 'mines', desc: '', args: []);
  }

  /// `Предложение добавить время`
  String get suggestion_to_add_time {
    return Intl.message(
      'Предложение добавить время',
      name: 'suggestion_to_add_time',
      desc: '',
      args: [],
    );
  }

  /// `Собеседник предлагает добавить `
  String get the_interlocutor_suggests_adding {
    return Intl.message(
      'Собеседник предлагает добавить ',
      name: 'the_interlocutor_suggests_adding',
      desc: '',
      args: [],
    );
  }

  /// `минут к чату.`
  String get minutes_to_chat {
    return Intl.message(
      'минут к чату.',
      name: 'minutes_to_chat',
      desc: '',
      args: [],
    );
  }

  /// `Принять`
  String get to_accept {
    return Intl.message('Принять', name: 'to_accept', desc: '', args: []);
  }

  /// `Добавлено`
  String get added {
    return Intl.message('Добавлено', name: 'added', desc: '', args: []);
  }

  /// `Предложение добавления времени отклонено`
  String get the_suggestion_of_adding_time_is_rejected {
    return Intl.message(
      'Предложение добавления времени отклонено',
      name: 'the_suggestion_of_adding_time_is_rejected',
      desc: '',
      args: [],
    );
  }

  /// `Время вышло`
  String get times_up {
    return Intl.message('Время вышло', name: 'times_up', desc: '', args: []);
  }

  /// `Время чата истекло. Чат будет завершен.`
  String get chat_time_has_expired_the_chat_will_be_terminated {
    return Intl.message(
      'Время чата истекло. Чат будет завершен.',
      name: 'chat_time_has_expired_the_chat_will_be_terminated',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message('OK', name: 'ok', desc: '', args: []);
  }

  /// `Удалить чат`
  String get delete_a_chat {
    return Intl.message(
      'Удалить чат',
      name: 'delete_a_chat',
      desc: '',
      args: [],
    );
  }

  /// `Выберите вариант удаления:`
  String get select_the_deletion_option {
    return Intl.message(
      'Выберите вариант удаления:',
      name: 'select_the_deletion_option',
      desc: '',
      args: [],
    );
  }

  /// `Только для меня`
  String get just_for_me {
    return Intl.message(
      'Только для меня',
      name: 'just_for_me',
      desc: '',
      args: [],
    );
  }

  /// `Для обоих`
  String get for_both {
    return Intl.message('Для обоих', name: 'for_both', desc: '', args: []);
  }

  /// `Удалить для обоих`
  String get delete_for_both {
    return Intl.message(
      'Удалить для обоих',
      name: 'delete_for_both',
      desc: '',
      args: [],
    );
  }

  /// `Это действие нельзя отменить. Чат будет удален для всех участников.`
  String
  get this_action_cannot_be_undone_the_chat_will_be_deleted_for_all_participants {
    return Intl.message(
      'Это действие нельзя отменить. Чат будет удален для всех участников.',
      name:
          'this_action_cannot_be_undone_the_chat_will_be_deleted_for_all_participants',
      desc: '',
      args: [],
    );
  }

  /// `Вчера`
  String get yesterday {
    return Intl.message('Вчера', name: 'yesterday', desc: '', args: []);
  }

  /// `Нет чатов`
  String get there_are_no_chats {
    return Intl.message(
      'Нет чатов',
      name: 'there_are_no_chats',
      desc: '',
      args: [],
    );
  }

  /// `Нет постоянных чатов`
  String get there_are_no_permanent_chats {
    return Intl.message(
      'Нет постоянных чатов',
      name: 'there_are_no_permanent_chats',
      desc: '',
      args: [],
    );
  }

  /// `Нет временных чатов`
  String get there_are_no_temporary_chats {
    return Intl.message(
      'Нет временных чатов',
      name: 'there_are_no_temporary_chats',
      desc: '',
      args: [],
    );
  }

  /// `Постоянные чаты`
  String get constant_chats {
    return Intl.message(
      'Постоянные чаты',
      name: 'constant_chats',
      desc: '',
      args: [],
    );
  }

  /// `Начните общение`
  String get start_chatting {
    return Intl.message(
      'Начните общение',
      name: 'start_chatting',
      desc: '',
      args: [],
    );
  }

  /// `Временные чаты`
  String get temporary_chats {
    return Intl.message(
      'Временные чаты',
      name: 'temporary_chats',
      desc: '',
      args: [],
    );
  }

  /// `Анонимный чат`
  String get anonymous_chat {
    return Intl.message(
      'Анонимный чат',
      name: 'anonymous_chat',
      desc: '',
      args: [],
    );
  }

  /// `Это анонимный чат`
  String get this_is_an_anonymous_chat {
    return Intl.message(
      'Это анонимный чат',
      name: 'this_is_an_anonymous_chat',
      desc: '',
      args: [],
    );
  }

  /// `Вы уверены, что хотите удалить этот временный чат?`
  String get are_you_sure_you_want_to_delete_this_temporary_chat {
    return Intl.message(
      'Вы уверены, что хотите удалить этот временный чат?',
      name: 'are_you_sure_you_want_to_delete_this_temporary_chat',
      desc: '',
      args: [],
    );
  }

  /// `Временный чат удален`
  String get temporary_chat_deleted {
    return Intl.message(
      'Временный чат удален',
      name: 'temporary_chat_deleted',
      desc: '',
      args: [],
    );
  }

  /// `Вход успешный`
  String get login_is_successful {
    return Intl.message(
      'Вход успешный',
      name: 'login_is_successful',
      desc: '',
      args: [],
    );
  }

  /// `Введите логин и пароль`
  String get enter_your_username_and_password {
    return Intl.message(
      'Введите логин и пароль',
      name: 'enter_your_username_and_password',
      desc: '',
      args: [],
    );
  }

  /// `Укажите свои Интересы:`
  String get specify_your_interests {
    return Intl.message(
      'Укажите свои Интересы:',
      name: 'specify_your_interests',
      desc: '',
      args: [],
    );
  }

  /// `Начните вводить название города`
  String get start_entering_the_name_of_the_city {
    return Intl.message(
      'Начните вводить название города',
      name: 'start_entering_the_name_of_the_city',
      desc: '',
      args: [],
    );
  }

  /// `Введите город`
  String get enter_the_city {
    return Intl.message(
      'Введите город',
      name: 'enter_the_city',
      desc: '',
      args: [],
    );
  }

  /// `Города не найдены`
  String get cities_not_found {
    return Intl.message(
      'Города не найдены',
      name: 'cities_not_found',
      desc: '',
      args: [],
    );
  }

  /// `Укажите свои Цели:`
  String get specify_your_goals {
    return Intl.message(
      'Укажите свои Цели:',
      name: 'specify_your_goals',
      desc: '',
      args: [],
    );
  }

  /// `Нет запросов в друзья`
  String get no_friend_requests {
    return Intl.message(
      'Нет запросов в друзья',
      name: 'no_friend_requests',
      desc: '',
      args: [],
    );
  }

  /// `points`
  String get points {
    return Intl.message('points', name: 'points', desc: '', args: []);
  }

  /// `Пока нет доступных игр`
  String get there_are_no_games_available_yet {
    return Intl.message(
      'Пока нет доступных игр',
      name: 'there_are_no_games_available_yet',
      desc: '',
      args: [],
    );
  }

  /// `Не удалось загрузить игры`
  String get couldnt_load_games {
    return Intl.message(
      'Не удалось загрузить игры',
      name: 'couldnt_load_games',
      desc: '',
      args: [],
    );
  }

  /// `Попробовать снова`
  String get try_again {
    return Intl.message(
      'Попробовать снова',
      name: 'try_again',
      desc: '',
      args: [],
    );
  }

  /// `Подготовка игры...`
  String get game_preparation {
    return Intl.message(
      'Подготовка игры...',
      name: 'game_preparation',
      desc: '',
      args: [],
    );
  }

  /// `Не удалось получить ссылку на игру`
  String get couldnt_get_the_link_to_the_game {
    return Intl.message(
      'Не удалось получить ссылку на игру',
      name: 'couldnt_get_the_link_to_the_game',
      desc: '',
      args: [],
    );
  }

  /// `Покупка успешна!`
  String get the_purchase_was_successful {
    return Intl.message(
      'Покупка успешна!',
      name: 'the_purchase_was_successful',
      desc: '',
      args: [],
    );
  }

  /// `Вы приобрели подарок:`
  String get you_have_purchased_a_gift {
    return Intl.message(
      'Вы приобрели подарок:',
      name: 'you_have_purchased_a_gift',
      desc: '',
      args: [],
    );
  }

  /// `Потрачено поинтов:`
  String get points_spent {
    return Intl.message(
      'Потрачено поинтов:',
      name: 'points_spent',
      desc: '',
      args: [],
    );
  }

  /// `Новый баланс:`
  String get new_balance_sheet {
    return Intl.message(
      'Новый баланс:',
      name: 'new_balance_sheet',
      desc: '',
      args: [],
    );
  }

  /// `Недостаточно очков для покупки. Нужно:`
  String get not_enough_points_to_purchase_you_need {
    return Intl.message(
      'Недостаточно очков для покупки. Нужно:',
      name: 'not_enough_points_to_purchase_you_need',
      desc: '',
      args: [],
    );
  }

  /// `Подтверждение покупки`
  String get purchase_confirmation {
    return Intl.message(
      'Подтверждение покупки',
      name: 'purchase_confirmation',
      desc: '',
      args: [],
    );
  }

  /// `Вы хотите купить `
  String get do_you_want_to_buy {
    return Intl.message(
      'Вы хотите купить ',
      name: 'do_you_want_to_buy',
      desc: '',
      args: [],
    );
  }

  /// `Стоимость:`
  String get cost {
    return Intl.message('Стоимость:', name: 'cost', desc: '', args: []);
  }

  /// `Купить`
  String get buy {
    return Intl.message('Купить', name: 'buy', desc: '', args: []);
  }

  /// `Ошибка при покупке:`
  String get purchase_error {
    return Intl.message(
      'Ошибка при покупке:',
      name: 'purchase_error',
      desc: '',
      args: [],
    );
  }

  /// `Магазин`
  String get shop {
    return Intl.message('Магазин', name: 'shop', desc: '', args: []);
  }

  /// `Выберите раздел`
  String get select_a_section {
    return Intl.message(
      'Выберите раздел',
      name: 'select_a_section',
      desc: '',
      args: [],
    );
  }

  /// `Ежедневный подарок`
  String get a_daily_gift {
    return Intl.message(
      'Ежедневный подарок',
      name: 'a_daily_gift',
      desc: '',
      args: [],
    );
  }

  /// `Серия:`
  String get series {
    return Intl.message('Серия:', name: 'series', desc: '', args: []);
  }

  /// `дней`
  String get days {
    return Intl.message('дней', name: 'days', desc: '', args: []);
  }

  /// `Вы уже получили подарок сегодня`
  String get have_you_already_received_a_gift_today {
    return Intl.message(
      'Вы уже получили подарок сегодня',
      name: 'have_you_already_received_a_gift_today',
      desc: '',
      args: [],
    );
  }

  /// `Получить`
  String get receive {
    return Intl.message('Получить', name: 'receive', desc: '', args: []);
  }

  /// `Последний подарок:`
  String get the_last_gift {
    return Intl.message(
      'Последний подарок:',
      name: 'the_last_gift',
      desc: '',
      args: [],
    );
  }

  /// `Ваш баланс:`
  String get your_balance {
    return Intl.message(
      'Ваш баланс:',
      name: 'your_balance',
      desc: '',
      args: [],
    );
  }

  /// `Не удалось загрузить`
  String get failed_to_upload {
    return Intl.message(
      'Не удалось загрузить',
      name: 'failed_to_upload',
      desc: '',
      args: [],
    );
  }

  /// `Доступно:`
  String get available {
    return Intl.message('Доступно:', name: 'available', desc: '', args: []);
  }

  /// `шт.`
  String get pc {
    return Intl.message('шт.', name: 'pc', desc: '', args: []);
  }

  /// `Ограниченный тираж`
  String get limited_edition {
    return Intl.message(
      'Ограниченный тираж',
      name: 'limited_edition',
      desc: '',
      args: [],
    );
  }

  /// `Недостаточно очков`
  String get not_enough_points {
    return Intl.message(
      'Недостаточно очков',
      name: 'not_enough_points',
      desc: '',
      args: [],
    );
  }

  /// `РАСПРОДАНО`
  String get sold_out {
    return Intl.message('РАСПРОДАНО', name: 'sold_out', desc: '', args: []);
  }

  /// `Ограниченный`
  String get limited {
    return Intl.message('Ограниченный', name: 'limited', desc: '', args: []);
  }

  /// `У вас еще нет купленных подарков`
  String get you_havent_bought_any_gifts_yet {
    return Intl.message(
      'У вас еще нет купленных подарков',
      name: 'you_havent_bought_any_gifts_yet',
      desc: '',
      args: [],
    );
  }

  /// `От друга`
  String get from_a_friend {
    return Intl.message('От друга', name: 'from_a_friend', desc: '', args: []);
  }

  /// `Количество:`
  String get quantity {
    return Intl.message('Количество:', name: 'quantity', desc: '', args: []);
  }

  /// `Получено:`
  String get received {
    return Intl.message('Получено:', name: 'received', desc: '', args: []);
  }

  /// `г.`
  String get year {
    return Intl.message('г.', name: 'year', desc: '', args: []);
  }

  /// `мес.`
  String get month {
    return Intl.message('мес.', name: 'month', desc: '', args: []);
  }

  /// `д.`
  String get day {
    return Intl.message('д.', name: 'day', desc: '', args: []);
  }

  /// `ч.`
  String get hour {
    return Intl.message('ч.', name: 'hour', desc: '', args: []);
  }

  /// `только что`
  String get just_now {
    return Intl.message('только что', name: 'just_now', desc: '', args: []);
  }

  /// `Game`
  String get game {
    return Intl.message('Game', name: 'game', desc: '', args: []);
  }

  /// `Жалоб пока нет`
  String get there_are_no_complaints_yet {
    return Intl.message(
      'Жалоб пока нет',
      name: 'there_are_no_complaints_yet',
      desc: '',
      args: [],
    );
  }

  /// `Отправлено`
  String get shipped {
    return Intl.message('Отправлено', name: 'shipped', desc: '', args: []);
  }

  /// `В обработке`
  String get in_processing {
    return Intl.message(
      'В обработке',
      name: 'in_processing',
      desc: '',
      args: [],
    );
  }

  /// `Завершено`
  String get completed {
    return Intl.message('Завершено', name: 'completed', desc: '', args: []);
  }

  /// `Причина:`
  String get reason {
    return Intl.message('Причина:', name: 'reason', desc: '', args: []);
  }

  /// `Дата:`
  String get date {
    return Intl.message('Дата:', name: 'date', desc: '', args: []);
  }

  /// `Отозвать`
  String get revoke {
    return Intl.message('Отозвать', name: 'revoke', desc: '', args: []);
  }

  /// `Сбросить настройки?`
  String get reset_the_settings {
    return Intl.message(
      'Сбросить настройки?',
      name: 'reset_the_settings',
      desc: '',
      args: [],
    );
  }

  /// `Все настройки уведомлений будут сброшены к значениям по умолчанию.`
  String get all_notification_settings_will_be_reset_to_their_default_values {
    return Intl.message(
      'Все настройки уведомлений будут сброшены к значениям по умолчанию.',
      name: 'all_notification_settings_will_be_reset_to_their_default_values',
      desc: '',
      args: [],
    );
  }

  /// `Настройки сброшены`
  String get settings_have_been_reset {
    return Intl.message(
      'Настройки сброшены',
      name: 'settings_have_been_reset',
      desc: '',
      args: [],
    );
  }

  /// `Сбросить`
  String get throw_off {
    return Intl.message('Сбросить', name: 'throw_off', desc: '', args: []);
  }

  /// `Настройки сохраняются автоматически и применяются к новым уведомлениям.`
  String get settings_are_saved_automatically_and_applied_to_new_notifications {
    return Intl.message(
      'Настройки сохраняются автоматически и применяются к новым уведомлениям.',
      name: 'settings_are_saved_automatically_and_applied_to_new_notifications',
      desc: '',
      args: [],
    );
  }

  /// `Настройка тихих часов`
  String get setting_up_a_quiet_clock {
    return Intl.message(
      'Настройка тихих часов',
      name: 'setting_up_a_quiet_clock',
      desc: '',
      args: [],
    );
  }

  /// `Настройка тихих часов будет добавлена в следующем обновлении.`
  String get the_quiet_clock_setting_will_be_added_in_the_next_update {
    return Intl.message(
      'Настройка тихих часов будет добавлена в следующем обновлении.',
      name: 'the_quiet_clock_setting_will_be_added_in_the_next_update',
      desc: '',
      args: [],
    );
  }

  /// `Основные настройки`
  String get basic_settings {
    return Intl.message(
      'Основные настройки',
      name: 'basic_settings',
      desc: '',
      args: [],
    );
  }

  /// `Включить уведомления`
  String get enable_notifications {
    return Intl.message(
      'Включить уведомления',
      name: 'enable_notifications',
      desc: '',
      args: [],
    );
  }

  /// `Звук`
  String get sound {
    return Intl.message('Звук', name: 'sound', desc: '', args: []);
  }

  /// `Вибрация`
  String get vibration {
    return Intl.message('Вибрация', name: 'vibration', desc: '', args: []);
  }

  /// `Значок счётчика`
  String get the_counter_icon {
    return Intl.message(
      'Значок счётчика',
      name: 'the_counter_icon',
      desc: '',
      args: [],
    );
  }

  /// `Показывать содержимое`
  String get show_content {
    return Intl.message(
      'Показывать содержимое',
      name: 'show_content',
      desc: '',
      args: [],
    );
  }

  /// `Тихий режим`
  String get quiet_mode {
    return Intl.message('Тихий режим', name: 'quiet_mode', desc: '', args: []);
  }

  /// `Тихие часы`
  String get quiet_hours {
    return Intl.message('Тихие часы', name: 'quiet_hours', desc: '', args: []);
  }

  /// `Настроить`
  String get to_configure {
    return Intl.message('Настроить', name: 'to_configure', desc: '', args: []);
  }

  /// `Типы уведомлений`
  String get types_of_notifications {
    return Intl.message(
      'Типы уведомлений',
      name: 'types_of_notifications',
      desc: '',
      args: [],
    );
  }

  /// `Сообщения`
  String get messages {
    return Intl.message('Сообщения', name: 'messages', desc: '', args: []);
  }

  /// `Новые сообщения в чатах`
  String get new_chat_messages {
    return Intl.message(
      'Новые сообщения в чатах',
      name: 'new_chat_messages',
      desc: '',
      args: [],
    );
  }

  /// `Запросы в друзья`
  String get friend_requests {
    return Intl.message(
      'Запросы в друзья',
      name: 'friend_requests',
      desc: '',
      args: [],
    );
  }

  /// `Новые запросы на добавление в друзья`
  String get new_friend_requests {
    return Intl.message(
      'Новые запросы на добавление в друзья',
      name: 'new_friend_requests',
      desc: '',
      args: [],
    );
  }

  /// `Системные уведомления`
  String get system_notifications {
    return Intl.message(
      'Системные уведомления',
      name: 'system_notifications',
      desc: '',
      args: [],
    );
  }

  /// `Обновления и системные сообщения`
  String get updates_and_system_messages {
    return Intl.message(
      'Обновления и системные сообщения',
      name: 'updates_and_system_messages',
      desc: '',
      args: [],
    );
  }

  /// `Аккаунт`
  String get account {
    return Intl.message('Аккаунт', name: 'account', desc: '', args: []);
  }

  /// `Дата регистрации:`
  String get registration_date {
    return Intl.message(
      'Дата регистрации:',
      name: 'registration_date',
      desc: '',
      args: [],
    );
  }

  /// `Роли:`
  String get roles {
    return Intl.message('Роли:', name: 'roles', desc: '', args: []);
  }

  /// `О себе`
  String get about_me {
    return Intl.message('О себе', name: 'about_me', desc: '', args: []);
  }

  /// `Подтвержден`
  String get confirmed {
    return Intl.message('Подтвержден', name: 'confirmed', desc: '', args: []);
  }

  /// `Администратор`
  String get administrator {
    return Intl.message(
      'Администратор',
      name: 'administrator',
      desc: '',
      args: [],
    );
  }

  /// `Модератор`
  String get moderator {
    return Intl.message('Модератор', name: 'moderator', desc: '', args: []);
  }

  /// `Цели`
  String get goals {
    return Intl.message('Цели', name: 'goals', desc: '', args: []);
  }

  /// `Фото`
  String get photo {
    return Intl.message('Фото', name: 'photo', desc: '', args: []);
  }

  /// `Ошибка загрузки. Нажмите для повтора`
  String get download_error_click_to_repeat {
    return Intl.message(
      'Ошибка загрузки. Нажмите для повтора',
      name: 'download_error_click_to_repeat',
      desc: '',
      args: [],
    );
  }

  /// `Не удалось загрузить изображение. Нажмите для повтора`
  String get failed_to_load_image_click_to_retry {
    return Intl.message(
      'Не удалось загрузить изображение. Нажмите для повтора',
      name: 'failed_to_load_image_click_to_retry',
      desc: '',
      args: [],
    );
  }

  /// `Пока нет фотографий`
  String get there_are_no_photos_yet {
    return Intl.message(
      'Пока нет фотографий',
      name: 'there_are_no_photos_yet',
      desc: '',
      args: [],
    );
  }

  /// `Добавьте фото, чтобы другие пользователи могли вас узнать`
  String get add_a_photo_so_that_other_users_can_recognize_you {
    return Intl.message(
      'Добавьте фото, чтобы другие пользователи могли вас узнать',
      name: 'add_a_photo_so_that_other_users_can_recognize_you',
      desc: '',
      args: [],
    );
  }

  /// `Выберите интересы`
  String get choose_your_interests {
    return Intl.message(
      'Выберите интересы',
      name: 'choose_your_interests',
      desc: '',
      args: [],
    );
  }

  /// `Поиск интересов...`
  String get search_for_interests {
    return Intl.message(
      'Поиск интересов...',
      name: 'search_for_interests',
      desc: '',
      args: [],
    );
  }

  /// `Применить`
  String get apply {
    return Intl.message('Применить', name: 'apply', desc: '', args: []);
  }

  /// `Выберите цели`
  String get select_goals {
    return Intl.message(
      'Выберите цели',
      name: 'select_goals',
      desc: '',
      args: [],
    );
  }

  /// `Поиск целей...`
  String get goal_search {
    return Intl.message(
      'Поиск целей...',
      name: 'goal_search',
      desc: '',
      args: [],
    );
  }

  /// `Ошибка загрузки профиля`
  String get profile_upload_error {
    return Intl.message(
      'Ошибка загрузки профиля',
      name: 'profile_upload_error',
      desc: '',
      args: [],
    );
  }

  /// `Мои жалобы`
  String get my_complaints {
    return Intl.message(
      'Мои жалобы',
      name: 'my_complaints',
      desc: '',
      args: [],
    );
  }

  /// `Вопрос успешно создан`
  String get the_question_was_created_successfully {
    return Intl.message(
      'Вопрос успешно создан',
      name: 'the_question_was_created_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Статус обновлен`
  String get status_updated {
    return Intl.message(
      'Статус обновлен',
      name: 'status_updated',
      desc: '',
      args: [],
    );
  }

  /// `Вопросов пока нет`
  String get no_questions_yet {
    return Intl.message(
      'Вопросов пока нет',
      name: 'no_questions_yet',
      desc: '',
      args: [],
    );
  }

  /// `Нажмите "+" чтобы создать вопрос`
  String get click_plus_to_create_a_question {
    return Intl.message(
      'Нажмите "+" чтобы создать вопрос',
      name: 'click_plus_to_create_a_question',
      desc: '',
      args: [],
    );
  }

  /// `Произошла ошибка`
  String get an_error_has_occurred {
    return Intl.message(
      'Произошла ошибка',
      name: 'an_error_has_occurred',
      desc: '',
      args: [],
    );
  }

  /// `Автор:`
  String get author {
    return Intl.message('Автор:', name: 'author', desc: '', args: []);
  }

  /// `Создать вопрос`
  String get create_a_question {
    return Intl.message(
      'Создать вопрос',
      name: 'create_a_question',
      desc: '',
      args: [],
    );
  }

  /// `Заголовок`
  String get heading {
    return Intl.message('Заголовок', name: 'heading', desc: '', args: []);
  }

  /// `Введите заголовок`
  String get enter_the_title {
    return Intl.message(
      'Введите заголовок',
      name: 'enter_the_title',
      desc: '',
      args: [],
    );
  }

  /// `Введите описание`
  String get enter_a_description {
    return Intl.message(
      'Введите описание',
      name: 'enter_a_description',
      desc: '',
      args: [],
    );
  }

  /// `Создать`
  String get to_create {
    return Intl.message('Создать', name: 'to_create', desc: '', args: []);
  }

  /// `Информация`
  String get information {
    return Intl.message('Информация', name: 'information', desc: '', args: []);
  }

  /// `Создан`
  String get generated {
    return Intl.message('Создан', name: 'generated', desc: '', args: []);
  }

  /// `Обновлен`
  String get updated {
    return Intl.message('Обновлен', name: 'updated', desc: '', args: []);
  }

  /// `ID вопроса`
  String get question_id {
    return Intl.message('ID вопроса', name: 'question_id', desc: '', args: []);
  }

  /// `Ответы`
  String get answers {
    return Intl.message('Ответы', name: 'answers', desc: '', args: []);
  }

  /// `Добавить ответ`
  String get add_a_response {
    return Intl.message(
      'Добавить ответ',
      name: 'add_a_response',
      desc: '',
      args: [],
    );
  }

  /// `Ответов пока нет`
  String get there_are_no_answers_yet {
    return Intl.message(
      'Ответов пока нет',
      name: 'there_are_no_answers_yet',
      desc: '',
      args: [],
    );
  }

  /// `Введите ваш ответ...`
  String get enter_your_answer {
    return Intl.message(
      'Введите ваш ответ...',
      name: 'enter_your_answer',
      desc: '',
      args: [],
    );
  }

  /// `ОЖИДАЕТ`
  String get AWAITING {
    return Intl.message('ОЖИДАЕТ', name: 'AWAITING', desc: '', args: []);
  }

  /// `ПОЛУЧЕНО`
  String get RECEIVED {
    return Intl.message('ПОЛУЧЕНО', name: 'RECEIVED', desc: '', args: []);
  }

  /// `РЕШЕНО`
  String get ITSDECIDED {
    return Intl.message('РЕШЕНО', name: 'ITSDECIDED', desc: '', args: []);
  }

  /// `Вопросы не найдены`
  String get no_questions_found {
    return Intl.message(
      'Вопросы не найдены',
      name: 'no_questions_found',
      desc: '',
      args: [],
    );
  }

  /// `Ответов:`
  String get responses {
    return Intl.message('Ответов:', name: 'responses', desc: '', args: []);
  }

  /// `Добавьте аватар профиля`
  String get add_a_profile_avatar {
    return Intl.message(
      'Добавьте аватар профиля',
      name: 'add_a_profile_avatar',
      desc: '',
      args: [],
    );
  }

  /// `Аватар выбран. Подтвердите загрузку.`
  String get the_avatar_is_selected_confirm_the_upload {
    return Intl.message(
      'Аватар выбран. Подтвердите загрузку.',
      name: 'the_avatar_is_selected_confirm_the_upload',
      desc: '',
      args: [],
    );
  }

  /// `Загрузка аватара...`
  String get uploading_an_avatar {
    return Intl.message(
      'Загрузка аватара...',
      name: 'uploading_an_avatar',
      desc: '',
      args: [],
    );
  }

  /// `Аватар успешно загружен!`
  String get the_avatar_has_been_uploaded_successfully {
    return Intl.message(
      'Аватар успешно загружен!',
      name: 'the_avatar_has_been_uploaded_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Выбрать аватар`
  String get choose_an_avatar {
    return Intl.message(
      'Выбрать аватар',
      name: 'choose_an_avatar',
      desc: '',
      args: [],
    );
  }

  /// `Подтвердить и загрузить аватар`
  String get confirm_and_upload_your_avatar {
    return Intl.message(
      'Подтвердить и загрузить аватар',
      name: 'confirm_and_upload_your_avatar',
      desc: '',
      args: [],
    );
  }

  /// `Удалить аватар`
  String get delete_an_avatar {
    return Intl.message(
      'Удалить аватар',
      name: 'delete_an_avatar',
      desc: '',
      args: [],
    );
  }

  /// `Изменить аватар`
  String get change_your_avatar {
    return Intl.message(
      'Изменить аватар',
      name: 'change_your_avatar',
      desc: '',
      args: [],
    );
  }

  /// `10 изображений`
  String get ten_images {
    return Intl.message(
      '10 изображений',
      name: 'ten_images',
      desc: '',
      args: [],
    );
  }

  /// `Добавьте изображения в галерею`
  String get add_images_to_the_gallery {
    return Intl.message(
      'Добавьте изображения в галерею',
      name: 'add_images_to_the_gallery',
      desc: '',
      args: [],
    );
  }

  /// `Добавить еще изображения`
  String get add_more_images {
    return Intl.message(
      'Добавить еще изображения',
      name: 'add_more_images',
      desc: '',
      args: [],
    );
  }

  /// `Добавить изображения`
  String get add_Images {
    return Intl.message(
      'Добавить изображения',
      name: 'add_Images',
      desc: '',
      args: [],
    );
  }

  /// `Достигнут лимит в 10 изображений`
  String get the_limit_of_ten_images_has_been_reached {
    return Intl.message(
      'Достигнут лимит в 10 изображений',
      name: 'the_limit_of_ten_images_has_been_reached',
      desc: '',
      args: [],
    );
  }

  /// `Перейти на главный экран`
  String get go_to_the_main_screen {
    return Intl.message(
      'Перейти на главный экран',
      name: 'go_to_the_main_screen',
      desc: '',
      args: [],
    );
  }

  /// `Загрузка изображений`
  String get uploading_images {
    return Intl.message(
      'Загрузка изображений',
      name: 'uploading_images',
      desc: '',
      args: [],
    );
  }

  /// `Постоянные`
  String get permanent {
    return Intl.message('Постоянные', name: 'permanent', desc: '', args: []);
  }

  /// `Временные`
  String get temporary {
    return Intl.message('Временные', name: 'temporary', desc: '', args: []);
  }

  /// `Все`
  String get all {
    return Intl.message('Все', name: 'all', desc: '', args: []);
  }

  /// `Удалить фото`
  String get delete_photo {
    return Intl.message(
      'Удалить фото',
      name: 'delete_photo',
      desc: '',
      args: [],
    );
  }

  /// `Вы уверены, что хотите удалить это фото?`
  String get are_you_sure_you_want_to_delete_this_photo {
    return Intl.message(
      'Вы уверены, что хотите удалить это фото?',
      name: 'are_you_sure_you_want_to_delete_this_photo',
      desc: '',
      args: [],
    );
  }

  /// `Подтвердите удаление`
  String get confirm_delete {
    return Intl.message(
      'Подтвердите удаление',
      name: 'confirm_delete',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
