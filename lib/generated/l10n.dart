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

  /// `Delete Chat`
  String get deletechat {
    return Intl.message('Delete Chat', name: 'deletechat', desc: '', args: []);
  }

  /// `Block User`
  String get blockuser {
    return Intl.message('Block User', name: 'blockuser', desc: '', args: []);
  }

  /// `Report User`
  String get reportuser {
    return Intl.message('Report User', name: 'reportuser', desc: '', args: []);
  }

  /// `Are you sure you want to clear the history?`
  String get clearhistoryconfirmation {
    return Intl.message(
      'Are you sure you want to clear the history?',
      name: 'clearhistoryconfirmation',
      desc: '',
      args: [],
    );
  }

  /// `History cleared`
  String get historycleared {
    return Intl.message(
      'History cleared',
      name: 'historycleared',
      desc: '',
      args: [],
    );
  }

  /// `Clear`
  String get clear {
    return Intl.message('Clear', name: 'clear', desc: '', args: []);
  }

  /// `Are you sure you want to delete the chat?`
  String get deletechatconfirmation {
    return Intl.message(
      'Are you sure you want to delete the chat?',
      name: 'deletechatconfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Chat deleted`
  String get chatdeleted {
    return Intl.message(
      'Chat deleted',
      name: 'chatdeleted',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `Are you sure you want to block this user?`
  String get blockuserconfirmation {
    return Intl.message(
      'Are you sure you want to block this user?',
      name: 'blockuserconfirmation',
      desc: '',
      args: [],
    );
  }

  /// `User blocked`
  String get userblocked {
    return Intl.message(
      'User blocked',
      name: 'userblocked',
      desc: '',
      args: [],
    );
  }

  /// `Block`
  String get block {
    return Intl.message('Block', name: 'block', desc: '', args: []);
  }

  /// `Please select the reason for reporting this user:`
  String get reportuserdescription {
    return Intl.message(
      'Please select the reason for reporting this user:',
      name: 'reportuserdescription',
      desc: '',
      args: [],
    );
  }

  /// `Select reason`
  String get selectreason {
    return Intl.message(
      'Select reason',
      name: 'selectreason',
      desc: '',
      args: [],
    );
  }

  /// `Additional comments`
  String get additionalcomments {
    return Intl.message(
      'Additional comments',
      name: 'additionalcomments',
      desc: '',
      args: [],
    );
  }

  /// `Report submitted`
  String get reportsubmitted {
    return Intl.message(
      'Report submitted',
      name: 'reportsubmitted',
      desc: '',
      args: [],
    );
  }

  /// `Submit report`
  String get submitreport {
    return Intl.message(
      'Submit report',
      name: 'submitreport',
      desc: '',
      args: [],
    );
  }

  /// `Spam`
  String get spam {
    return Intl.message('Spam', name: 'spam', desc: '', args: []);
  }

  /// `Harassment`
  String get harassment {
    return Intl.message('Harassment', name: 'harassment', desc: '', args: []);
  }

  /// `Inappropriate content`
  String get inappropriatecontent {
    return Intl.message(
      'Inappropriate content',
      name: 'inappropriatecontent',
      desc: '',
      args: [],
    );
  }

  /// `Fake profile`
  String get fakeprofile {
    return Intl.message(
      'Fake profile',
      name: 'fakeprofile',
      desc: '',
      args: [],
    );
  }

  /// `Other`
  String get other {
    return Intl.message('Other', name: 'other', desc: '', args: []);
  }

  /// `Change password`
  String get changepassword {
    return Intl.message(
      'Change password',
      name: 'changepassword',
      desc: '',
      args: [],
    );
  }

  /// `New password`
  String get newpassword {
    return Intl.message(
      'New password',
      name: 'newpassword',
      desc: '',
      args: [],
    );
  }

  /// `Old password`
  String get oldpassword {
    return Intl.message(
      'Old password',
      name: 'oldpassword',
      desc: '',
      args: [],
    );
  }

  /// `No purposes added yet`
  String get nopurposesadded {
    return Intl.message(
      'No purposes added yet',
      name: 'nopurposesadded',
      desc: '',
      args: [],
    );
  }

  /// `No interests added yet`
  String get nointerestsadded {
    return Intl.message(
      'No interests added yet',
      name: 'nointerestsadded',
      desc: '',
      args: [],
    );
  }

  /// `Password changed successfully`
  String get passwordchangedsuccessfully {
    return Intl.message(
      'Password changed successfully',
      name: 'passwordchangedsuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Profile updated successfully`
  String get profileupdatedsuccessfully {
    return Intl.message(
      'Profile updated successfully',
      name: 'profileupdatedsuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Avatar upload failed`
  String get avataruploadfailed {
    return Intl.message(
      'Avatar upload failed',
      name: 'avataruploadfailed',
      desc: '',
      args: [],
    );
  }

  /// `Avatar updated successfully`
  String get avatarupdatedsuccessfully {
    return Intl.message(
      'Avatar updated successfully',
      name: 'avatarupdatedsuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Uploading avatar...`
  String get uploadingavatar {
    return Intl.message(
      'Uploading avatar...',
      name: 'uploadingavatar',
      desc: '',
      args: [],
    );
  }

  /// `Searching`
  String get searching {
    return Intl.message('Searching', name: 'searching', desc: '', args: []);
  }

  /// `Updating...`
  String get updating {
    return Intl.message('Updating...', name: 'updating', desc: '', args: []);
  }

  /// `My Reports`
  String get my_report {
    return Intl.message('My Reports', name: 'my_report', desc: '', args: []);
  }

  /// `Notification Settings`
  String get notification_settings {
    return Intl.message(
      'Notification Settings',
      name: 'notification_settings',
      desc: '',
      args: [],
    );
  }

  /// `My Support Questions`
  String get my_question_support {
    return Intl.message(
      'My Support Questions',
      name: 'my_question_support',
      desc: '',
      args: [],
    );
  }

  /// `Stickers not found`
  String get stickers_not_found {
    return Intl.message(
      'Stickers not found',
      name: 'stickers_not_found',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get repeat {
    return Intl.message('Retry', name: 'repeat', desc: '', args: []);
  }

  /// `Sticker loading error:`
  String get sticker_loading_error {
    return Intl.message(
      'Sticker loading error:',
      name: 'sticker_loading_error',
      desc: '',
      args: [],
    );
  }

  /// `Stickers`
  String get stickers {
    return Intl.message('Stickers', name: 'stickers', desc: '', args: []);
  }

  /// `Please select the reason for the complaint`
  String get please_select_the_reason_for_the_complaint {
    return Intl.message(
      'Please select the reason for the complaint',
      name: 'please_select_the_reason_for_the_complaint',
      desc: '',
      args: [],
    );
  }

  /// `Add time`
  String get add_time {
    return Intl.message('Add time', name: 'add_time', desc: '', args: []);
  }

  /// `Continue the chat`
  String get continue_the_chat {
    return Intl.message(
      'Continue the chat',
      name: 'continue_the_chat',
      desc: '',
      args: [],
    );
  }

  /// `Add to friends?`
  String get add_to_friends {
    return Intl.message(
      'Add to friends?',
      name: 'add_to_friends',
      desc: '',
      args: [],
    );
  }

  /// `Would you like to send a friend request to this user?`
  String get would_you_like_to_send_a_friend_request_to_a_user {
    return Intl.message(
      'Would you like to send a friend request to this user?',
      name: 'would_you_like_to_send_a_friend_request_to_a_user',
      desc: '',
      args: [],
    );
  }

  /// `Friend request has been sent`
  String get the_friend_request_has_been_sent {
    return Intl.message(
      'Friend request has been sent',
      name: 'the_friend_request_has_been_sent',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get send {
    return Intl.message('Send', name: 'send', desc: '', args: []);
  }

  /// `Loading...`
  String get loading {
    return Intl.message('Loading...', name: 'loading', desc: '', args: []);
  }

  /// `Download error`
  String get download_error {
    return Intl.message(
      'Download error',
      name: 'download_error',
      desc: '',
      args: [],
    );
  }

  /// `The image is unavailable`
  String get the_image_is_unavailable {
    return Intl.message(
      'The image is unavailable',
      name: 'the_image_is_unavailable',
      desc: '',
      args: [],
    );
  }

  /// `Sticker`
  String get sticker {
    return Intl.message('Sticker', name: 'sticker', desc: '', args: []);
  }

  /// `Continue communication`
  String get continue_communication {
    return Intl.message(
      'Continue communication',
      name: 'continue_communication',
      desc: '',
      args: [],
    );
  }

  /// `Your interlocutor suggests continuing the conversation in a permanent chat.`
  String
  get the_interlocutor_suggests_continuing_the_conversation_in_a_permanent_chat {
    return Intl.message(
      'Your interlocutor suggests continuing the conversation in a permanent chat.',
      name:
          'the_interlocutor_suggests_continuing_the_conversation_in_a_permanent_chat',
      desc: '',
      args: [],
    );
  }

  /// `Do you agree?`
  String get do_you_agree {
    return Intl.message(
      'Do you agree?',
      name: 'do_you_agree',
      desc: '',
      args: [],
    );
  }

  /// `Reject`
  String get reject {
    return Intl.message('Reject', name: 'reject', desc: '', args: []);
  }

  /// `Accept`
  String get accept {
    return Intl.message('Accept', name: 'accept', desc: '', args: []);
  }

  /// `Permanent chat has been created`
  String get permanent_chat_has_been_created {
    return Intl.message(
      'Permanent chat has been created',
      name: 'permanent_chat_has_been_created',
      desc: '',
      args: [],
    );
  }

  /// `Now you can continue chatting in a permanent chat room.`
  String get now_you_can_continue_chatting_in_a_permanent_chat_room {
    return Intl.message(
      'Now you can continue chatting in a permanent chat room.',
      name: 'now_you_can_continue_chatting_in_a_permanent_chat_room',
      desc: '',
      args: [],
    );
  }

  /// `All messages are saved.`
  String get all_messages_are_saved {
    return Intl.message(
      'All messages are saved.',
      name: 'all_messages_are_saved',
      desc: '',
      args: [],
    );
  }

  /// `Waiting for a response`
  String get waiting_for_a_response {
    return Intl.message(
      'Waiting for a response',
      name: 'waiting_for_a_response',
      desc: '',
      args: [],
    );
  }

  /// `The request to continue the chat has been sent.`
  String get the_request_to_continue_the_chat_has_been_sent {
    return Intl.message(
      'The request to continue the chat has been sent.',
      name: 'the_request_to_continue_the_chat_has_been_sent',
      desc: '',
      args: [],
    );
  }

  /// `We are waiting for a response from the interlocutor...`
  String get we_are_waiting_for_a_response_from_the_interlocutor {
    return Intl.message(
      'We are waiting for a response from the interlocutor...',
      name: 'we_are_waiting_for_a_response_from_the_interlocutor',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to invite your conversation partner to continue chatting in a permanent chat room?`
  String
  get do_you_want_to_invite_your_conversation_partner_to_continue_chatting_in_a_permanent_chat_room {
    return Intl.message(
      'Do you want to invite your conversation partner to continue chatting in a permanent chat room?',
      name:
          'do_you_want_to_invite_your_conversation_partner_to_continue_chatting_in_a_permanent_chat_room',
      desc: '',
      args: [],
    );
  }

  /// `Offer`
  String get offer {
    return Intl.message('Offer', name: 'offer', desc: '', args: []);
  }

  /// `The chat time is coming to an end`
  String get the_chat_time_is_coming_to_an_end {
    return Intl.message(
      'The chat time is coming to an end',
      name: 'the_chat_time_is_coming_to_an_end',
      desc: '',
      args: [],
    );
  }

  /// `Select an action:`
  String get select_an_action {
    return Intl.message(
      'Select an action:',
      name: 'select_an_action',
      desc: '',
      args: [],
    );
  }

  /// `Continue in permanent chat`
  String get continue_in_constant_chat {
    return Intl.message(
      'Continue in permanent chat',
      name: 'continue_in_constant_chat',
      desc: '',
      args: [],
    );
  }

  /// `End the chat`
  String get end_the_chat {
    return Intl.message(
      'End the chat',
      name: 'end_the_chat',
      desc: '',
      args: [],
    );
  }

  /// `Add time to the chat`
  String get add_time_to_the_chat {
    return Intl.message(
      'Add time to the chat',
      name: 'add_time_to_the_chat',
      desc: '',
      args: [],
    );
  }

  /// `min`
  String get mines {
    return Intl.message('min', name: 'mines', desc: '', args: []);
  }

  /// `Suggestion to add time`
  String get suggestion_to_add_time {
    return Intl.message(
      'Suggestion to add time',
      name: 'suggestion_to_add_time',
      desc: '',
      args: [],
    );
  }

  /// `Your interlocutor suggests adding `
  String get the_interlocutor_suggests_adding {
    return Intl.message(
      'Your interlocutor suggests adding ',
      name: 'the_interlocutor_suggests_adding',
      desc: '',
      args: [],
    );
  }

  /// ` minutes to the chat.`
  String get minutes_to_chat {
    return Intl.message(
      ' minutes to the chat.',
      name: 'minutes_to_chat',
      desc: '',
      args: [],
    );
  }

  /// `To accept`
  String get to_accept {
    return Intl.message('To accept', name: 'to_accept', desc: '', args: []);
  }

  /// `Added`
  String get added {
    return Intl.message('Added', name: 'added', desc: '', args: []);
  }

  /// `The suggestion to add time has been rejected`
  String get the_suggestion_of_adding_time_is_rejected {
    return Intl.message(
      'The suggestion to add time has been rejected',
      name: 'the_suggestion_of_adding_time_is_rejected',
      desc: '',
      args: [],
    );
  }

  /// `Time's up`
  String get times_up {
    return Intl.message('Time\'s up', name: 'times_up', desc: '', args: []);
  }

  /// `Chat time has expired. The chat will be terminated.`
  String get chat_time_has_expired_the_chat_will_be_terminated {
    return Intl.message(
      'Chat time has expired. The chat will be terminated.',
      name: 'chat_time_has_expired_the_chat_will_be_terminated',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message('OK', name: 'ok', desc: '', args: []);
  }

  /// `Delete a chat`
  String get delete_a_chat {
    return Intl.message(
      'Delete a chat',
      name: 'delete_a_chat',
      desc: '',
      args: [],
    );
  }

  /// `Select the deletion option:`
  String get select_the_deletion_option {
    return Intl.message(
      'Select the deletion option:',
      name: 'select_the_deletion_option',
      desc: '',
      args: [],
    );
  }

  /// `Just for me`
  String get just_for_me {
    return Intl.message('Just for me', name: 'just_for_me', desc: '', args: []);
  }

  /// `For both`
  String get for_both {
    return Intl.message('For both', name: 'for_both', desc: '', args: []);
  }

  /// `Delete for both`
  String get delete_for_both {
    return Intl.message(
      'Delete for both',
      name: 'delete_for_both',
      desc: '',
      args: [],
    );
  }

  /// `This action cannot be undone. The chat will be deleted for all participants.`
  String
  get this_action_cannot_be_undone_the_chat_will_be_deleted_for_all_participants {
    return Intl.message(
      'This action cannot be undone. The chat will be deleted for all participants.',
      name:
          'this_action_cannot_be_undone_the_chat_will_be_deleted_for_all_participants',
      desc: '',
      args: [],
    );
  }

  /// `Yesterday`
  String get yesterday {
    return Intl.message('Yesterday', name: 'yesterday', desc: '', args: []);
  }

  /// `No chats`
  String get there_are_no_chats {
    return Intl.message(
      'No chats',
      name: 'there_are_no_chats',
      desc: '',
      args: [],
    );
  }

  /// `No permanent chats`
  String get there_are_no_permanent_chats {
    return Intl.message(
      'No permanent chats',
      name: 'there_are_no_permanent_chats',
      desc: '',
      args: [],
    );
  }

  /// `No temporary chats`
  String get there_are_no_temporary_chats {
    return Intl.message(
      'No temporary chats',
      name: 'there_are_no_temporary_chats',
      desc: '',
      args: [],
    );
  }

  /// `Permanent chats`
  String get constant_chats {
    return Intl.message(
      'Permanent chats',
      name: 'constant_chats',
      desc: '',
      args: [],
    );
  }

  /// `Start chatting`
  String get start_chatting {
    return Intl.message(
      'Start chatting',
      name: 'start_chatting',
      desc: '',
      args: [],
    );
  }

  /// `Temporary chats`
  String get temporary_chats {
    return Intl.message(
      'Temporary chats',
      name: 'temporary_chats',
      desc: '',
      args: [],
    );
  }

  /// `Anonymous chat`
  String get anonymous_chat {
    return Intl.message(
      'Anonymous chat',
      name: 'anonymous_chat',
      desc: '',
      args: [],
    );
  }

  /// `This is an anonymous chat`
  String get this_is_an_anonymous_chat {
    return Intl.message(
      'This is an anonymous chat',
      name: 'this_is_an_anonymous_chat',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this temporary chat?`
  String get are_you_sure_you_want_to_delete_this_temporary_chat {
    return Intl.message(
      'Are you sure you want to delete this temporary chat?',
      name: 'are_you_sure_you_want_to_delete_this_temporary_chat',
      desc: '',
      args: [],
    );
  }

  /// `Temporary chat deleted`
  String get temporary_chat_deleted {
    return Intl.message(
      'Temporary chat deleted',
      name: 'temporary_chat_deleted',
      desc: '',
      args: [],
    );
  }

  /// `Login successful`
  String get login_is_successful {
    return Intl.message(
      'Login successful',
      name: 'login_is_successful',
      desc: '',
      args: [],
    );
  }

  /// `Enter your username and password`
  String get enter_your_username_and_password {
    return Intl.message(
      'Enter your username and password',
      name: 'enter_your_username_and_password',
      desc: '',
      args: [],
    );
  }

  /// `Specify your interests:`
  String get specify_your_interests {
    return Intl.message(
      'Specify your interests:',
      name: 'specify_your_interests',
      desc: '',
      args: [],
    );
  }

  /// `Start entering the city name`
  String get start_entering_the_name_of_the_city {
    return Intl.message(
      'Start entering the city name',
      name: 'start_entering_the_name_of_the_city',
      desc: '',
      args: [],
    );
  }

  /// `Enter the city`
  String get enter_the_city {
    return Intl.message(
      'Enter the city',
      name: 'enter_the_city',
      desc: '',
      args: [],
    );
  }

  /// `Cities not found`
  String get cities_not_found {
    return Intl.message(
      'Cities not found',
      name: 'cities_not_found',
      desc: '',
      args: [],
    );
  }

  /// `Specify your goals:`
  String get specify_your_goals {
    return Intl.message(
      'Specify your goals:',
      name: 'specify_your_goals',
      desc: '',
      args: [],
    );
  }

  /// `No friend requests`
  String get no_friend_requests {
    return Intl.message(
      'No friend requests',
      name: 'no_friend_requests',
      desc: '',
      args: [],
    );
  }

  /// `points`
  String get points {
    return Intl.message('points', name: 'points', desc: '', args: []);
  }

  /// `There are no games available yet`
  String get there_are_no_games_available_yet {
    return Intl.message(
      'There are no games available yet',
      name: 'there_are_no_games_available_yet',
      desc: '',
      args: [],
    );
  }

  /// `Could not load games`
  String get couldnt_load_games {
    return Intl.message(
      'Could not load games',
      name: 'couldnt_load_games',
      desc: '',
      args: [],
    );
  }

  /// `Try again`
  String get try_again {
    return Intl.message('Try again', name: 'try_again', desc: '', args: []);
  }

  /// `Game preparation...`
  String get game_preparation {
    return Intl.message(
      'Game preparation...',
      name: 'game_preparation',
      desc: '',
      args: [],
    );
  }

  /// `Could not get the link to the game`
  String get couldnt_get_the_link_to_the_game {
    return Intl.message(
      'Could not get the link to the game',
      name: 'couldnt_get_the_link_to_the_game',
      desc: '',
      args: [],
    );
  }

  /// `Purchase successful!`
  String get the_purchase_was_successful {
    return Intl.message(
      'Purchase successful!',
      name: 'the_purchase_was_successful',
      desc: '',
      args: [],
    );
  }

  /// `You have purchased a gift:`
  String get you_have_purchased_a_gift {
    return Intl.message(
      'You have purchased a gift:',
      name: 'you_have_purchased_a_gift',
      desc: '',
      args: [],
    );
  }

  /// `Points spent:`
  String get points_spent {
    return Intl.message(
      'Points spent:',
      name: 'points_spent',
      desc: '',
      args: [],
    );
  }

  /// `New balance:`
  String get new_balance_sheet {
    return Intl.message(
      'New balance:',
      name: 'new_balance_sheet',
      desc: '',
      args: [],
    );
  }

  /// `Not enough points to purchase. You need:`
  String get not_enough_points_to_purchase_you_need {
    return Intl.message(
      'Not enough points to purchase. You need:',
      name: 'not_enough_points_to_purchase_you_need',
      desc: '',
      args: [],
    );
  }

  /// `Purchase confirmation`
  String get purchase_confirmation {
    return Intl.message(
      'Purchase confirmation',
      name: 'purchase_confirmation',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to buy `
  String get do_you_want_to_buy {
    return Intl.message(
      'Do you want to buy ',
      name: 'do_you_want_to_buy',
      desc: '',
      args: [],
    );
  }

  /// `Cost:`
  String get cost {
    return Intl.message('Cost:', name: 'cost', desc: '', args: []);
  }

  /// `Buy`
  String get buy {
    return Intl.message('Buy', name: 'buy', desc: '', args: []);
  }

  /// `Purchase error:`
  String get purchase_error {
    return Intl.message(
      'Purchase error:',
      name: 'purchase_error',
      desc: '',
      args: [],
    );
  }

  /// `Shop`
  String get shop {
    return Intl.message('Shop', name: 'shop', desc: '', args: []);
  }

  /// `Select a section`
  String get select_a_section {
    return Intl.message(
      'Select a section',
      name: 'select_a_section',
      desc: '',
      args: [],
    );
  }

  /// `A daily gift`
  String get a_daily_gift {
    return Intl.message(
      'A daily gift',
      name: 'a_daily_gift',
      desc: '',
      args: [],
    );
  }

  /// `Series:`
  String get series {
    return Intl.message('Series:', name: 'series', desc: '', args: []);
  }

  /// `days`
  String get days {
    return Intl.message('days', name: 'days', desc: '', args: []);
  }

  /// `Have you already received a gift today?`
  String get have_you_already_received_a_gift_today {
    return Intl.message(
      'Have you already received a gift today?',
      name: 'have_you_already_received_a_gift_today',
      desc: '',
      args: [],
    );
  }

  /// `Receive`
  String get receive {
    return Intl.message('Receive', name: 'receive', desc: '', args: []);
  }

  /// `The last gift:`
  String get the_last_gift {
    return Intl.message(
      'The last gift:',
      name: 'the_last_gift',
      desc: '',
      args: [],
    );
  }

  /// `Your balance:`
  String get your_balance {
    return Intl.message(
      'Your balance:',
      name: 'your_balance',
      desc: '',
      args: [],
    );
  }

  /// `Failed to upload`
  String get failed_to_upload {
    return Intl.message(
      'Failed to upload',
      name: 'failed_to_upload',
      desc: '',
      args: [],
    );
  }

  /// `Available:`
  String get available {
    return Intl.message('Available:', name: 'available', desc: '', args: []);
  }

  /// `pcs.`
  String get pc {
    return Intl.message('pcs.', name: 'pc', desc: '', args: []);
  }

  /// `Limited edition`
  String get limited_edition {
    return Intl.message(
      'Limited edition',
      name: 'limited_edition',
      desc: '',
      args: [],
    );
  }

  /// `Not enough points`
  String get not_enough_points {
    return Intl.message(
      'Not enough points',
      name: 'not_enough_points',
      desc: '',
      args: [],
    );
  }

  /// `SOLD OUT`
  String get sold_out {
    return Intl.message('SOLD OUT', name: 'sold_out', desc: '', args: []);
  }

  /// `Limited`
  String get limited {
    return Intl.message('Limited', name: 'limited', desc: '', args: []);
  }

  /// `You haven't bought any gifts yet`
  String get you_havent_bought_any_gifts_yet {
    return Intl.message(
      'You haven\'t bought any gifts yet',
      name: 'you_havent_bought_any_gifts_yet',
      desc: '',
      args: [],
    );
  }

  /// `From a friend`
  String get from_a_friend {
    return Intl.message(
      'From a friend',
      name: 'from_a_friend',
      desc: '',
      args: [],
    );
  }

  /// `Quantity:`
  String get quantity {
    return Intl.message('Quantity:', name: 'quantity', desc: '', args: []);
  }

  /// `Received:`
  String get received {
    return Intl.message('Received:', name: 'received', desc: '', args: []);
  }

  /// `y.`
  String get year {
    return Intl.message('y.', name: 'year', desc: '', args: []);
  }

  /// `mo.`
  String get month {
    return Intl.message('mo.', name: 'month', desc: '', args: []);
  }

  /// `d.`
  String get day {
    return Intl.message('d.', name: 'day', desc: '', args: []);
  }

  /// `h.`
  String get hour {
    return Intl.message('h.', name: 'hour', desc: '', args: []);
  }

  /// `just now`
  String get just_now {
    return Intl.message('just now', name: 'just_now', desc: '', args: []);
  }

  /// `Game`
  String get game {
    return Intl.message('Game', name: 'game', desc: '', args: []);
  }

  /// `There are no complaints yet`
  String get there_are_no_complaints_yet {
    return Intl.message(
      'There are no complaints yet',
      name: 'there_are_no_complaints_yet',
      desc: '',
      args: [],
    );
  }

  /// `Shipped`
  String get shipped {
    return Intl.message('Shipped', name: 'shipped', desc: '', args: []);
  }

  /// `In processing`
  String get in_processing {
    return Intl.message(
      'In processing',
      name: 'in_processing',
      desc: '',
      args: [],
    );
  }

  /// `Completed`
  String get completed {
    return Intl.message('Completed', name: 'completed', desc: '', args: []);
  }

  /// `Reason:`
  String get reason {
    return Intl.message('Reason:', name: 'reason', desc: '', args: []);
  }

  /// `Date:`
  String get date {
    return Intl.message('Date:', name: 'date', desc: '', args: []);
  }

  /// `Revoke`
  String get revoke {
    return Intl.message('Revoke', name: 'revoke', desc: '', args: []);
  }

  /// `Reset the settings?`
  String get reset_the_settings {
    return Intl.message(
      'Reset the settings?',
      name: 'reset_the_settings',
      desc: '',
      args: [],
    );
  }

  /// `All notification settings will be reset to their default values.`
  String get all_notification_settings_will_be_reset_to_their_default_values {
    return Intl.message(
      'All notification settings will be reset to their default values.',
      name: 'all_notification_settings_will_be_reset_to_their_default_values',
      desc: '',
      args: [],
    );
  }

  /// `Settings have been reset`
  String get settings_have_been_reset {
    return Intl.message(
      'Settings have been reset',
      name: 'settings_have_been_reset',
      desc: '',
      args: [],
    );
  }

  /// `Reset`
  String get throw_off {
    return Intl.message('Reset', name: 'throw_off', desc: '', args: []);
  }

  /// `Settings are saved automatically and applied to new notifications.`
  String get settings_are_saved_automatically_and_applied_to_new_notifications {
    return Intl.message(
      'Settings are saved automatically and applied to new notifications.',
      name: 'settings_are_saved_automatically_and_applied_to_new_notifications',
      desc: '',
      args: [],
    );
  }

  /// `Setting up quiet hours`
  String get setting_up_a_quiet_clock {
    return Intl.message(
      'Setting up quiet hours',
      name: 'setting_up_a_quiet_clock',
      desc: '',
      args: [],
    );
  }

  /// `The quiet hours setting will be added in the next update.`
  String get the_quiet_clock_setting_will_be_added_in_the_next_update {
    return Intl.message(
      'The quiet hours setting will be added in the next update.',
      name: 'the_quiet_clock_setting_will_be_added_in_the_next_update',
      desc: '',
      args: [],
    );
  }

  /// `Basic settings`
  String get basic_settings {
    return Intl.message(
      'Basic settings',
      name: 'basic_settings',
      desc: '',
      args: [],
    );
  }

  /// `Enable notifications`
  String get enable_notifications {
    return Intl.message(
      'Enable notifications',
      name: 'enable_notifications',
      desc: '',
      args: [],
    );
  }

  /// `Sound`
  String get sound {
    return Intl.message('Sound', name: 'sound', desc: '', args: []);
  }

  /// `Vibration`
  String get vibration {
    return Intl.message('Vibration', name: 'vibration', desc: '', args: []);
  }

  /// `Counter icon`
  String get the_counter_icon {
    return Intl.message(
      'Counter icon',
      name: 'the_counter_icon',
      desc: '',
      args: [],
    );
  }

  /// `Show content`
  String get show_content {
    return Intl.message(
      'Show content',
      name: 'show_content',
      desc: '',
      args: [],
    );
  }

  /// `Quiet mode`
  String get quiet_mode {
    return Intl.message('Quiet mode', name: 'quiet_mode', desc: '', args: []);
  }

  /// `Quiet hours`
  String get quiet_hours {
    return Intl.message('Quiet hours', name: 'quiet_hours', desc: '', args: []);
  }

  /// `Configure`
  String get to_configure {
    return Intl.message('Configure', name: 'to_configure', desc: '', args: []);
  }

  /// `Types of notifications`
  String get types_of_notifications {
    return Intl.message(
      'Types of notifications',
      name: 'types_of_notifications',
      desc: '',
      args: [],
    );
  }

  /// `Messages`
  String get messages {
    return Intl.message('Messages', name: 'messages', desc: '', args: []);
  }

  /// `New chat messages`
  String get new_chat_messages {
    return Intl.message(
      'New chat messages',
      name: 'new_chat_messages',
      desc: '',
      args: [],
    );
  }

  /// `Friend requests`
  String get friend_requests {
    return Intl.message(
      'Friend requests',
      name: 'friend_requests',
      desc: '',
      args: [],
    );
  }

  /// `New friend requests`
  String get new_friend_requests {
    return Intl.message(
      'New friend requests',
      name: 'new_friend_requests',
      desc: '',
      args: [],
    );
  }

  /// `System notifications`
  String get system_notifications {
    return Intl.message(
      'System notifications',
      name: 'system_notifications',
      desc: '',
      args: [],
    );
  }

  /// `Updates and system messages`
  String get updates_and_system_messages {
    return Intl.message(
      'Updates and system messages',
      name: 'updates_and_system_messages',
      desc: '',
      args: [],
    );
  }

  /// `Account`
  String get account {
    return Intl.message('Account', name: 'account', desc: '', args: []);
  }

  /// `Registration date:`
  String get registration_date {
    return Intl.message(
      'Registration date:',
      name: 'registration_date',
      desc: '',
      args: [],
    );
  }

  /// `Roles:`
  String get roles {
    return Intl.message('Roles:', name: 'roles', desc: '', args: []);
  }

  /// `About me`
  String get about_me {
    return Intl.message('About me', name: 'about_me', desc: '', args: []);
  }

  /// `Confirmed`
  String get confirmed {
    return Intl.message('Confirmed', name: 'confirmed', desc: '', args: []);
  }

  /// `Administrator`
  String get administrator {
    return Intl.message(
      'Administrator',
      name: 'administrator',
      desc: '',
      args: [],
    );
  }

  /// `Moderator`
  String get moderator {
    return Intl.message('Moderator', name: 'moderator', desc: '', args: []);
  }

  /// `Goals`
  String get goals {
    return Intl.message('Goals', name: 'goals', desc: '', args: []);
  }

  /// `Photo`
  String get photo {
    return Intl.message('Photo', name: 'photo', desc: '', args: []);
  }

  /// `Download error. Click to retry`
  String get download_error_click_to_repeat {
    return Intl.message(
      'Download error. Click to retry',
      name: 'download_error_click_to_repeat',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load image. Click to retry`
  String get failed_to_load_image_click_to_retry {
    return Intl.message(
      'Failed to load image. Click to retry',
      name: 'failed_to_load_image_click_to_retry',
      desc: '',
      args: [],
    );
  }

  /// `There are no photos yet`
  String get there_are_no_photos_yet {
    return Intl.message(
      'There are no photos yet',
      name: 'there_are_no_photos_yet',
      desc: '',
      args: [],
    );
  }

  /// `Add a photo so other users can recognize you`
  String get add_a_photo_so_that_other_users_can_recognize_you {
    return Intl.message(
      'Add a photo so other users can recognize you',
      name: 'add_a_photo_so_that_other_users_can_recognize_you',
      desc: '',
      args: [],
    );
  }

  /// `Choose your interests`
  String get choose_your_interests {
    return Intl.message(
      'Choose your interests',
      name: 'choose_your_interests',
      desc: '',
      args: [],
    );
  }

  /// `Search interests...`
  String get search_for_interests {
    return Intl.message(
      'Search interests...',
      name: 'search_for_interests',
      desc: '',
      args: [],
    );
  }

  /// `Apply`
  String get apply {
    return Intl.message('Apply', name: 'apply', desc: '', args: []);
  }

  /// `Select goals`
  String get select_goals {
    return Intl.message(
      'Select goals',
      name: 'select_goals',
      desc: '',
      args: [],
    );
  }

  /// `Goal search...`
  String get goal_search {
    return Intl.message(
      'Goal search...',
      name: 'goal_search',
      desc: '',
      args: [],
    );
  }

  /// `Profile upload error`
  String get profile_upload_error {
    return Intl.message(
      'Profile upload error',
      name: 'profile_upload_error',
      desc: '',
      args: [],
    );
  }

  /// `My complaints`
  String get my_complaints {
    return Intl.message(
      'My complaints',
      name: 'my_complaints',
      desc: '',
      args: [],
    );
  }

  /// `The question was created successfully`
  String get the_question_was_created_successfully {
    return Intl.message(
      'The question was created successfully',
      name: 'the_question_was_created_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Status updated`
  String get status_updated {
    return Intl.message(
      'Status updated',
      name: 'status_updated',
      desc: '',
      args: [],
    );
  }

  /// `No questions yet`
  String get no_questions_yet {
    return Intl.message(
      'No questions yet',
      name: 'no_questions_yet',
      desc: '',
      args: [],
    );
  }

  /// `Click "+" to create a question`
  String get click_plus_to_create_a_question {
    return Intl.message(
      'Click "+" to create a question',
      name: 'click_plus_to_create_a_question',
      desc: '',
      args: [],
    );
  }

  /// `An error has occurred`
  String get an_error_has_occurred {
    return Intl.message(
      'An error has occurred',
      name: 'an_error_has_occurred',
      desc: '',
      args: [],
    );
  }

  /// `Author:`
  String get author {
    return Intl.message('Author:', name: 'author', desc: '', args: []);
  }

  /// `Create a question`
  String get create_a_question {
    return Intl.message(
      'Create a question',
      name: 'create_a_question',
      desc: '',
      args: [],
    );
  }

  /// `Heading`
  String get heading {
    return Intl.message('Heading', name: 'heading', desc: '', args: []);
  }

  /// `Enter the title`
  String get enter_the_title {
    return Intl.message(
      'Enter the title',
      name: 'enter_the_title',
      desc: '',
      args: [],
    );
  }

  /// `Enter a description`
  String get enter_a_description {
    return Intl.message(
      'Enter a description',
      name: 'enter_a_description',
      desc: '',
      args: [],
    );
  }

  /// `Create`
  String get to_create {
    return Intl.message('Create', name: 'to_create', desc: '', args: []);
  }

  /// `Information`
  String get information {
    return Intl.message('Information', name: 'information', desc: '', args: []);
  }

  /// `Generated`
  String get generated {
    return Intl.message('Generated', name: 'generated', desc: '', args: []);
  }

  /// `Updated`
  String get updated {
    return Intl.message('Updated', name: 'updated', desc: '', args: []);
  }

  /// `Question ID`
  String get question_id {
    return Intl.message('Question ID', name: 'question_id', desc: '', args: []);
  }

  /// `Answers`
  String get answers {
    return Intl.message('Answers', name: 'answers', desc: '', args: []);
  }

  /// `Add a response`
  String get add_a_response {
    return Intl.message(
      'Add a response',
      name: 'add_a_response',
      desc: '',
      args: [],
    );
  }

  /// `No answers yet`
  String get there_are_no_answers_yet {
    return Intl.message(
      'No answers yet',
      name: 'there_are_no_answers_yet',
      desc: '',
      args: [],
    );
  }

  /// `Enter your answer...`
  String get enter_your_answer {
    return Intl.message(
      'Enter your answer...',
      name: 'enter_your_answer',
      desc: '',
      args: [],
    );
  }

  /// `AWAITING`
  String get AWAITING {
    return Intl.message('AWAITING', name: 'AWAITING', desc: '', args: []);
  }

  /// `RECEIVED`
  String get RECEIVED {
    return Intl.message('RECEIVED', name: 'RECEIVED', desc: '', args: []);
  }

  /// `RESOLVED`
  String get ITSDECIDED {
    return Intl.message('RESOLVED', name: 'ITSDECIDED', desc: '', args: []);
  }

  /// `No questions found`
  String get no_questions_found {
    return Intl.message(
      'No questions found',
      name: 'no_questions_found',
      desc: '',
      args: [],
    );
  }

  /// `Responses:`
  String get responses {
    return Intl.message('Responses:', name: 'responses', desc: '', args: []);
  }

  /// `Add a profile avatar`
  String get add_a_profile_avatar {
    return Intl.message(
      'Add a profile avatar',
      name: 'add_a_profile_avatar',
      desc: '',
      args: [],
    );
  }

  /// `Avatar selected. Confirm upload.`
  String get the_avatar_is_selected_confirm_the_upload {
    return Intl.message(
      'Avatar selected. Confirm upload.',
      name: 'the_avatar_is_selected_confirm_the_upload',
      desc: '',
      args: [],
    );
  }

  /// `Uploading an avatar...`
  String get uploading_an_avatar {
    return Intl.message(
      'Uploading an avatar...',
      name: 'uploading_an_avatar',
      desc: '',
      args: [],
    );
  }

  /// `The avatar has been uploaded successfully!`
  String get the_avatar_has_been_uploaded_successfully {
    return Intl.message(
      'The avatar has been uploaded successfully!',
      name: 'the_avatar_has_been_uploaded_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Choose an avatar`
  String get choose_an_avatar {
    return Intl.message(
      'Choose an avatar',
      name: 'choose_an_avatar',
      desc: '',
      args: [],
    );
  }

  /// `Confirm and upload your avatar`
  String get confirm_and_upload_your_avatar {
    return Intl.message(
      'Confirm and upload your avatar',
      name: 'confirm_and_upload_your_avatar',
      desc: '',
      args: [],
    );
  }

  /// `Delete an avatar`
  String get delete_an_avatar {
    return Intl.message(
      'Delete an avatar',
      name: 'delete_an_avatar',
      desc: '',
      args: [],
    );
  }

  /// `Change your avatar`
  String get change_your_avatar {
    return Intl.message(
      'Change your avatar',
      name: 'change_your_avatar',
      desc: '',
      args: [],
    );
  }

  /// `10 images`
  String get ten_images {
    return Intl.message('10 images', name: 'ten_images', desc: '', args: []);
  }

  /// `Add images to the gallery`
  String get add_images_to_the_gallery {
    return Intl.message(
      'Add images to the gallery',
      name: 'add_images_to_the_gallery',
      desc: '',
      args: [],
    );
  }

  /// `Add more images`
  String get add_more_images {
    return Intl.message(
      'Add more images',
      name: 'add_more_images',
      desc: '',
      args: [],
    );
  }

  /// `Add images`
  String get add_Images {
    return Intl.message('Add images', name: 'add_Images', desc: '', args: []);
  }

  /// `The limit of 10 images has been reached`
  String get the_limit_of_ten_images_has_been_reached {
    return Intl.message(
      'The limit of 10 images has been reached',
      name: 'the_limit_of_ten_images_has_been_reached',
      desc: '',
      args: [],
    );
  }

  /// `Go to the main screen`
  String get go_to_the_main_screen {
    return Intl.message(
      'Go to the main screen',
      name: 'go_to_the_main_screen',
      desc: '',
      args: [],
    );
  }

  /// `Uploading images`
  String get uploading_images {
    return Intl.message(
      'Uploading images',
      name: 'uploading_images',
      desc: '',
      args: [],
    );
  }

  /// `Permanent`
  String get permanent {
    return Intl.message('Permanent', name: 'permanent', desc: '', args: []);
  }

  /// `Temporary`
  String get temporary {
    return Intl.message('Temporary', name: 'temporary', desc: '', args: []);
  }

  /// `All`
  String get all {
    return Intl.message('All', name: 'all', desc: '', args: []);
  }

  /// `Delete photo`
  String get delete_photo {
    return Intl.message(
      'Delete photo',
      name: 'delete_photo',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this photo?`
  String get are_you_sure_you_want_to_delete_this_photo {
    return Intl.message(
      'Are you sure you want to delete this photo?',
      name: 'are_you_sure_you_want_to_delete_this_photo',
      desc: '',
      args: [],
    );
  }

  /// `Confirm delete`
  String get confirm_delete {
    return Intl.message(
      'Confirm delete',
      name: 'confirm_delete',
      desc: '',
      args: [],
    );
  }

  /// `Please select a city from the list`
  String get please_select_city_from_list {
    return Intl.message(
      'Please select a city from the list',
      name: 'please_select_city_from_list',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid age`
  String get enter_valid_age {
    return Intl.message(
      'Please enter a valid age',
      name: 'enter_valid_age',
      desc: '',
      args: [],
    );
  }

  /// `Minimum age is 18 years`
  String get min_age_18 {
    return Intl.message(
      'Minimum age is 18 years',
      name: 'min_age_18',
      desc: '',
      args: [],
    );
  }

  /// `Maximum age is 65 years`
  String get max_age_65 {
    return Intl.message(
      'Maximum age is 65 years',
      name: 'max_age_65',
      desc: '',
      args: [],
    );
  }

  /// `All interests loaded`
  String get all_interests_loaded {
    return Intl.message(
      'All interests loaded',
      name: 'all_interests_loaded',
      desc: '',
      args: [],
    );
  }

  /// `Interest load error`
  String get interest_load_error {
    return Intl.message(
      'Interest load error',
      name: 'interest_load_error',
      desc: '',
      args: [],
    );
  }

  /// `Purpose load error`
  String get purpose_load_error {
    return Intl.message(
      'Purpose load error',
      name: 'purpose_load_error',
      desc: '',
      args: [],
    );
  }

  /// `Try a different search query`
  String get tryDifferentSearch {
    return Intl.message(
      'Try a different search query',
      name: 'tryDifferentSearch',
      desc: '',
      args: [],
    );
  }

  /// `Nothing found`
  String get nothingFound {
    return Intl.message(
      'Nothing found',
      name: 'nothingFound',
      desc: '',
      args: [],
    );
  }

  /// `soon`
  String get soon {
    return Intl.message('soon', name: 'soon', desc: '', args: []);
  }

  /// `m`
  String get Minuttt {
    return Intl.message('m', name: 'Minuttt', desc: '', args: []);
  }

  /// `Status:`
  String get status {
    return Intl.message('Status:', name: 'status', desc: '', args: []);
  }

  /// `Report Details`
  String get reportDetails {
    return Intl.message(
      'Report Details',
      name: 'reportDetails',
      desc: '',
      args: [],
    );
  }

  /// `In processing`
  String get inProcessing {
    return Intl.message(
      'In processing',
      name: 'inProcessing',
      desc: '',
      args: [],
    );
  }

  /// `You have been blocked`
  String get youHaveBeenBlocked {
    return Intl.message(
      'You have been blocked',
      name: 'youHaveBeenBlocked',
      desc: '',
      args: [],
    );
  }

  /// `Your account will be deleted within 30 days`
  String get yourAccountWillBeDeletedWithin30Days {
    return Intl.message(
      'Your account will be deleted within 30 days',
      name: 'yourAccountWillBeDeletedWithin30Days',
      desc: '',
      args: [],
    );
  }

  /// `To unlock or find out the reason for the lock`
  String get toUnlockOrFindOutTheReasonForTheLock {
    return Intl.message(
      'To unlock or find out the reason for the lock',
      name: 'toUnlockOrFindOutTheReasonForTheLock',
      desc: '',
      args: [],
    );
  }

  /// `write to support`
  String get writeToSupport {
    return Intl.message(
      'write to support',
      name: 'writeToSupport',
      desc: '',
      args: [],
    );
  }

  /// `contact support`
  String get contactSupport {
    return Intl.message(
      'contact support',
      name: 'contactSupport',
      desc: '',
      args: [],
    );
  }

  /// `For a reason:`
  String get forAReason {
    return Intl.message(
      'For a reason:',
      name: 'forAReason',
      desc: '',
      args: [],
    );
  }

  /// `Click to change the subject`
  String get clickToChangeTheSubject {
    return Intl.message(
      'Click to change the subject',
      name: 'clickToChangeTheSubject',
      desc: '',
      args: [],
    );
  }

  /// `Connect and communicate easily`
  String get connectAndCommunicateEasily {
    return Intl.message(
      'Connect and communicate easily',
      name: 'connectAndCommunicateEasily',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `Your world of dating and communication`
  String get appTagline {
    return Intl.message(
      'Your world of dating and communication',
      name: 'appTagline',
      desc: '',
      args: [],
    );
  }

  /// `Get to know the personality — before you see the face.`
  String get appDescription {
    return Intl.message(
      'Get to know the personality — before you see the face.',
      name: 'appDescription',
      desc: '',
      args: [],
    );
  }

  /// `📃 App Description`
  String get appDescriptionTitle {
    return Intl.message(
      '📃 App Description',
      name: 'appDescriptionTitle',
      desc: '',
      args: [],
    );
  }

  /// `MNA is a unique dating app where first impressions are based on communication, not appearance. Forget endless swiping! Just press 'Search', chat anonymously, and if you both want to — open profiles and continue getting to know each other.`
  String get appDescriptionText {
    return Intl.message(
      'MNA is a unique dating app where first impressions are based on communication, not appearance. Forget endless swiping! Just press \'Search\', chat anonymously, and if you both want to — open profiles and continue getting to know each other.',
      name: 'appDescriptionText',
      desc: '',
      args: [],
    );
  }

  /// `🔧 Main Features of MNA`
  String get mainFeaturesTitle {
    return Intl.message(
      '🔧 Main Features of MNA',
      name: 'mainFeaturesTitle',
      desc: '',
      args: [],
    );
  }

  /// `Anonymous Start (Blind Chat)`
  String get featureBlindChatTitle {
    return Intl.message(
      'Anonymous Start (Blind Chat)',
      name: 'featureBlindChatTitle',
      desc: '',
      args: [],
    );
  }

  /// `Temporary chat with hidden information. Chat time is limited to 5-10 minutes.`
  String get featureBlindChatDescription {
    return Intl.message(
      'Temporary chat with hidden information. Chat time is limited to 5-10 minutes.',
      name: 'featureBlindChatDescription',
      desc: '',
      args: [],
    );
  }

  /// `Mutual Profile Reveal`
  String get featureRevealProfilesTitle {
    return Intl.message(
      'Mutual Profile Reveal',
      name: 'featureRevealProfilesTitle',
      desc: '',
      args: [],
    );
  }

  /// `Profiles open only with mutual consent of both users.`
  String get featureRevealProfilesDescription {
    return Intl.message(
      'Profiles open only with mutual consent of both users.',
      name: 'featureRevealProfilesDescription',
      desc: '',
      args: [],
    );
  }

  /// `Adding Friends`
  String get featureAddFriendsTitle {
    return Intl.message(
      'Adding Friends',
      name: 'featureAddFriendsTitle',
      desc: '',
      args: [],
    );
  }

  /// `Ability to continue communication and add to friends after profile reveal.`
  String get featureAddFriendsDescription {
    return Intl.message(
      'Ability to continue communication and add to friends after profile reveal.',
      name: 'featureAddFriendsDescription',
      desc: '',
      args: [],
    );
  }

  /// `User Profile`
  String get featureUserProfileTitle {
    return Intl.message(
      'User Profile',
      name: 'featureUserProfileTitle',
      desc: '',
      args: [],
    );
  }

  /// `Detailed user information including interests and biography.`
  String get featureUserProfileDescription {
    return Intl.message(
      'Detailed user information including interests and biography.',
      name: 'featureUserProfileDescription',
      desc: '',
      args: [],
    );
  }

  /// `🌟 Additional Features`
  String get additionalFeaturesTitle {
    return Intl.message(
      '🌟 Additional Features',
      name: 'additionalFeaturesTitle',
      desc: '',
      args: [],
    );
  }

  /// `💡 Conversation Topics`
  String get chipTopics {
    return Intl.message(
      '💡 Conversation Topics',
      name: 'chipTopics',
      desc: '',
      args: [],
    );
  }

  /// `🎭 Avatars instead of photos`
  String get chipAvatars {
    return Intl.message(
      '🎭 Avatars instead of photos',
      name: 'chipAvatars',
      desc: '',
      args: [],
    );
  }

  /// `🎲 Question of the Day`
  String get chipQuestionOfTheDay {
    return Intl.message(
      '🎲 Question of the Day',
      name: 'chipQuestionOfTheDay',
      desc: '',
      args: [],
    );
  }

  /// `🧩 Interest Matching`
  String get chipInterestMatching {
    return Intl.message(
      '🧩 Interest Matching',
      name: 'chipInterestMatching',
      desc: '',
      args: [],
    );
  }

  /// `🔔 Second Chance`
  String get chipSecondChance {
    return Intl.message(
      '🔔 Second Chance',
      name: 'chipSecondChance',
      desc: '',
      args: [],
    );
  }

  /// `🕹 Mini-games in chat`
  String get chipMiniGames {
    return Intl.message(
      '🕹 Mini-games in chat',
      name: 'chipMiniGames',
      desc: '',
      args: [],
    );
  }

  /// `🔐 Security and Privacy`
  String get securityTitle {
    return Intl.message(
      '🔐 Security and Privacy',
      name: 'securityTitle',
      desc: '',
      args: [],
    );
  }

  /// `• All chats are encrypted\n• Complaints/blocking in 1 click\n• 'Hide me from search' feature`
  String get securityText {
    return Intl.message(
      '• All chats are encrypted\n• Complaints/blocking in 1 click\n• \'Hide me from search\' feature',
      name: 'securityText',
      desc: '',
      args: [],
    );
  }

  /// `📲 Technologies`
  String get technologiesTitle {
    return Intl.message(
      '📲 Technologies',
      name: 'technologiesTitle',
      desc: '',
      args: [],
    );
  }

  /// `• Flutter (cross-platform)\n• PostgreSQL\n• Java + SpringBoot`
  String get technologiesText {
    return Intl.message(
      '• Flutter (cross-platform)\n• PostgreSQL\n• Java + SpringBoot',
      name: 'technologiesText',
      desc: '',
      args: [],
    );
  }

  /// `📞 Feedback`
  String get feedbackTitle {
    return Intl.message(
      '📞 Feedback',
      name: 'feedbackTitle',
      desc: '',
      args: [],
    );
  }

  /// `Support Email`
  String get supportEmailTitle {
    return Intl.message(
      'Support Email',
      name: 'supportEmailTitle',
      desc: '',
      args: [],
    );
  }

  /// `mna_dev@mnapp.ru`
  String get supportEmail {
    return Intl.message(
      'mna_dev@mnapp.ru',
      name: 'supportEmail',
      desc: '',
      args: [],
    );
  }

  /// `Telegram Channel`
  String get supportTelegramTitle {
    return Intl.message(
      'Telegram Channel',
      name: 'supportTelegramTitle',
      desc: '',
      args: [],
    );
  }

  /// `@meetnadev`
  String get supportTelegram {
    return Intl.message(
      '@meetnadev',
      name: 'supportTelegram',
      desc: '',
      args: [],
    );
  }

  /// `User Not Available`
  String get userNotAvailable {
    return Intl.message(
      'User Not Available',
      name: 'userNotAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Error initializing chat`
  String get error_initializing_chat {
    return Intl.message(
      'Error initializing chat',
      name: 'error_initializing_chat',
      desc: '',
      args: [],
    );
  }

  /// `СhatId not available`
  String get chat_id_not_available {
    return Intl.message(
      'СhatId not available',
      name: 'chat_id_not_available',
      desc: '',
      args: [],
    );
  }

  /// `By logging in, you agree to our `
  String get byLoggingInYouAgreeToOur {
    return Intl.message(
      'By logging in, you agree to our ',
      name: 'byLoggingInYouAgreeToOur',
      desc: '',
      args: [],
    );
  }

  /// `Privacy Policy`
  String get privacyPolicy {
    return Intl.message(
      'Privacy Policy',
      name: 'privacyPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Terms of Use`
  String get termsOfUse {
    return Intl.message('Terms of Use', name: 'termsOfUse', desc: '', args: []);
  }

  /// ` and `
  String get and {
    return Intl.message(' and ', name: 'and', desc: '', args: []);
  }

  /// `Select chat to start`
  String get select_chat_to_start {
    return Intl.message(
      'Select chat to start',
      name: 'select_chat_to_start',
      desc: '',
      args: [],
    );
  }

  /// `Select chat hint`
  String get select_chat_hint {
    return Intl.message(
      'Select chat hint',
      name: 'select_chat_hint',
      desc: '',
      args: [],
    );
  }

  /// `Select Language`
  String get selectLanguage {
    return Intl.message(
      'Select Language',
      name: 'selectLanguage',
      desc: '',
      args: [],
    );
  }

  /// `By using this app You agree to our`
  String get byUsingThisAppYouAgreeToOur {
    return Intl.message(
      'By using this app You agree to our',
      name: 'byUsingThisAppYouAgreeToOur',
      desc: '',
      args: [],
    );
  }

  /// `Particle settings loading error: $message`
  String get particleSettingsLoadingErrorMessage {
    return Intl.message(
      'Particle settings loading error: \$message',
      name: 'particleSettingsLoadingErrorMessage',
      desc: '',
      args: [],
    );
  }

  /// `Particles on the main screen`
  String get particlesOnTheMainScreen {
    return Intl.message(
      'Particles on the main screen',
      name: 'particlesOnTheMainScreen',
      desc: '',
      args: [],
    );
  }

  /// `Enable/disable particle animation`
  String get enabledisableParticleAnimation {
    return Intl.message(
      'Enable/disable particle animation',
      name: 'enabledisableParticleAnimation',
      desc: '',
      args: [],
    );
  }

  /// `I agree`
  String get iAgree {
    return Intl.message('I agree', name: 'iAgree', desc: '', args: []);
  }

  /// `I disagree`
  String get iDisagree {
    return Intl.message('I disagree', name: 'iDisagree', desc: '', args: []);
  }

  /// `Check your internet connection`
  String get checkYourInternetConnection {
    return Intl.message(
      'Check your internet connection',
      name: 'checkYourInternetConnection',
      desc: '',
      args: [],
    );
  }

  /// `Error loading rules`
  String get errorLoadingRules {
    return Intl.message(
      'Error loading rules',
      name: 'errorLoadingRules',
      desc: '',
      args: [],
    );
  }

  /// `Community Rules`
  String get communityRules {
    return Intl.message(
      'Community Rules',
      name: 'communityRules',
      desc: '',
      args: [],
    );
  }

  /// `Loading the rules...`
  String get loadingTheRules {
    return Intl.message(
      'Loading the rules...',
      name: 'loadingTheRules',
      desc: '',
      args: [],
    );
  }

  /// `Connection error. Check your internet connection`
  String get connectionErrorCheckYourInternetConnection {
    return Intl.message(
      'Connection error. Check your internet connection',
      name: 'connectionErrorCheckYourInternetConnection',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't load the rules`
  String get couldntLoadTheRules {
    return Intl.message(
      'Couldn\'t load the rules',
      name: 'couldntLoadTheRules',
      desc: '',
      args: [],
    );
  }

  /// `Choose files`
  String get chooseFiles {
    return Intl.message(
      'Choose files',
      name: 'chooseFiles',
      desc: '',
      args: [],
    );
  }

  /// `Drop files or use button below`
  String get dropFilesOrUseButtonBelow {
    return Intl.message(
      'Drop files or use button below',
      name: 'dropFilesOrUseButtonBelow',
      desc: '',
      args: [],
    );
  }

  /// `Select Media`
  String get selectMedia {
    return Intl.message(
      'Select Media',
      name: 'selectMedia',
      desc: '',
      args: [],
    );
  }

  /// `Drop files to add media`
  String get dropFilesToAddMedia {
    return Intl.message(
      'Drop files to add media',
      name: 'dropFilesToAddMedia',
      desc: '',
      args: [],
    );
  }

  /// `Maximum ${widget.maxSelection} files allowed`
  String get maximumWidgetmaxselectionFilesAllowed {
    return Intl.message(
      'Maximum \${widget.maxSelection} files allowed',
      name: 'maximumWidgetmaxselectionFilesAllowed',
      desc: '',
      args: [],
    );
  }

  /// `Failed to pick files: $e`
  String get failedToPickFilesE {
    return Intl.message(
      'Failed to pick files: \$e',
      name: 'failedToPickFilesE',
      desc: '',
      args: [],
    );
  }

  /// `No media files`
  String get noMediaFiles {
    return Intl.message(
      'No media files',
      name: 'noMediaFiles',
      desc: '',
      args: [],
    );
  }

  /// `No media available`
  String get noMediaAvailable {
    return Intl.message(
      'No media available',
      name: 'noMediaAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Permission denied`
  String get permissionDenied {
    return Intl.message(
      'Permission denied',
      name: 'permissionDenied',
      desc: '',
      args: [],
    );
  }

  /// `No media`
  String get noMedia {
    return Intl.message('No media', name: 'noMedia', desc: '', args: []);
  }

  /// `Loading error`
  String get loadingError {
    return Intl.message(
      'Loading error',
      name: 'loadingError',
      desc: '',
      args: [],
    );
  }

  /// `There are no available images`
  String get thereAreNoAvailableImages {
    return Intl.message(
      'There are no available images',
      name: 'thereAreNoAvailableImages',
      desc: '',
      args: [],
    );
  }

  /// `Uploading images`
  String get uploadingimages {
    return Intl.message(
      'Uploading images',
      name: 'uploadingimages',
      desc: '',
      args: [],
    );
  }

  /// `Images uploaded successfully`
  String get imagesuploadedsuccessfully {
    return Intl.message(
      'Images uploaded successfully',
      name: 'imagesuploadedsuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Select photos`
  String get selectPhotos {
    return Intl.message(
      'Select photos',
      name: 'selectPhotos',
      desc: '',
      args: [],
    );
  }

  /// `Drag and drop the files here`
  String get dragAndDropTheFilesHere {
    return Intl.message(
      'Drag and drop the files here',
      name: 'dragAndDropTheFilesHere',
      desc: '',
      args: [],
    );
  }

  /// `or click the + button`
  String get orClickTheButton {
    return Intl.message(
      'or click the + button',
      name: 'orClickTheButton',
      desc: '',
      args: [],
    );
  }

  /// `Select a file`
  String get selectAFile {
    return Intl.message(
      'Select a file',
      name: 'selectAFile',
      desc: '',
      args: [],
    );
  }

  /// `Select Files`
  String get selectFiles {
    return Intl.message(
      'Select Files',
      name: 'selectFiles',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't get file data`
  String get couldntGetFileData {
    return Intl.message(
      'Couldn\'t get file data',
      name: 'couldntGetFileData',
      desc: '',
      args: [],
    );
  }

  /// `An unknown error has occurred`
  String get unknownError {
    return Intl.message(
      'An unknown error has occurred',
      name: 'unknownError',
      desc: '',
      args: [],
    );
  }

  /// `No one can see you, turn on search visibility!`
  String get noOneCanSeeYouTurnOnSearchVisibility {
    return Intl.message(
      'No one can see you, turn on search visibility!',
      name: 'noOneCanSeeYouTurnOnSearchVisibility',
      desc: '',
      args: [],
    );
  }

  /// `UserData update failed`
  String get userDataUpdateFailed {
    return Intl.message(
      'UserData update failed',
      name: 'userDataUpdateFailed',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to send an optional message?`
  String get do_you_want_to_send_an_optional_message {
    return Intl.message(
      'Do you want to send an optional message?',
      name: 'do_you_want_to_send_an_optional_message',
      desc: '',
      args: [],
    );
  }

  /// `Uploading avatar`
  String get uploadingAvatar {
    return Intl.message(
      'Uploading avatar',
      name: 'uploadingAvatar',
      desc: '',
      args: [],
    );
  }

  /// `Selected Files`
  String get selectedFiles {
    return Intl.message(
      'Selected Files',
      name: 'selectedFiles',
      desc: '',
      args: [],
    );
  }

  /// `No files selected`
  String get noFilesSelected {
    return Intl.message(
      'No files selected',
      name: 'noFilesSelected',
      desc: '',
      args: [],
    );
  }

  /// `Clear All`
  String get clearAll {
    return Intl.message('Clear All', name: 'clearAll', desc: '', args: []);
  }

  /// `selected`
  String get selected {
    return Intl.message('selected', name: 'selected', desc: '', args: []);
  }

  /// `There are no images to download`
  String get thereAreNoImagesToDownload {
    return Intl.message(
      'There are no images to download',
      name: 'thereAreNoImagesToDownload',
      desc: '',
      args: [],
    );
  }

  /// `The limit of 10 images has been reached`
  String get theLimitOf10ImagesHasBeenReached {
    return Intl.message(
      'The limit of 10 images has been reached',
      name: 'theLimitOf10ImagesHasBeenReached',
      desc: '',
      args: [],
    );
  }

  /// `Error deleting all images`
  String get errorDeletingAllImages {
    return Intl.message(
      'Error deleting all images',
      name: 'errorDeletingAllImages',
      desc: '',
      args: [],
    );
  }

  /// `Image deletion error`
  String get imageDeletionError {
    return Intl.message(
      'Image deletion error',
      name: 'imageDeletionError',
      desc: '',
      args: [],
    );
  }

  /// `Avatar upload error`
  String get avatarUploadError {
    return Intl.message(
      'Avatar upload error',
      name: 'avatarUploadError',
      desc: '',
      args: [],
    );
  }

  /// `Empty avatar data`
  String get emptyAvatarData {
    return Intl.message(
      'Empty avatar data',
      name: 'emptyAvatarData',
      desc: '',
      args: [],
    );
  }

  /// `The avatar is not selected`
  String get theAvatarIsNotSelected {
    return Intl.message(
      'The avatar is not selected',
      name: 'theAvatarIsNotSelected',
      desc: '',
      args: [],
    );
  }

  /// `Empty file data`
  String get emptyFileData {
    return Intl.message(
      'Empty file data',
      name: 'emptyFileData',
      desc: '',
      args: [],
    );
  }

  /// `Image processing error`
  String get imageProcessingError {
    return Intl.message(
      'Image processing error',
      name: 'imageProcessingError',
      desc: '',
      args: [],
    );
  }

  /// `Image upload error`
  String get imageUploadError {
    return Intl.message(
      'Image upload error',
      name: 'imageUploadError',
      desc: '',
      args: [],
    );
  }

  /// `Error when clearing a temporary file`
  String get errorWhenClearingATemporaryFile {
    return Intl.message(
      'Error when clearing a temporary file',
      name: 'errorWhenClearingATemporaryFile',
      desc: '',
      args: [],
    );
  }

  /// `Close the chat`
  String get closeTheChat {
    return Intl.message(
      'Close the chat',
      name: 'closeTheChat',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load photos`
  String get failed_to_load_photos {
    return Intl.message(
      'Failed to load photos',
      name: 'failed_to_load_photos',
      desc: '',
      args: [],
    );
  }

  /// `skip`
  String get skip {
    return Intl.message('skip', name: 'skip', desc: '', args: []);
  }

  /// `A search is underway:`
  String get aSearchIsUnderway {
    return Intl.message(
      'A search is underway:',
      name: 'aSearchIsUnderway',
      desc: '',
      args: [],
    );
  }

  /// `Search mode`
  String get searchMode {
    return Intl.message('Search mode', name: 'searchMode', desc: '', args: []);
  }

  /// `current`
  String get currented {
    return Intl.message('current', name: 'currented', desc: '', args: []);
  }

  /// `Anonymous search`
  String get anonymousSearch {
    return Intl.message(
      'Anonymous search',
      name: 'anonymousSearch',
      desc: '',
      args: [],
    );
  }

  /// `Stay invisible until you want to get to know. Only you initiate contact.`
  String get anonymousSearchDescription {
    return Intl.message(
      'Stay invisible until you want to get to know. Only you initiate contact.',
      name: 'anonymousSearchDescription',
      desc: '',
      args: [],
    );
  }

  /// `Card mode`
  String get cardSwiperMode {
    return Intl.message(
      'Card mode',
      name: 'cardSwiperMode',
      desc: '',
      args: [],
    );
  }

  /// `Quick profile evaluation by swiping. A dialogue begins upon mutual agreement.`
  String get cardSwiperDescription {
    return Intl.message(
      'Quick profile evaluation by swiping. A dialogue begins upon mutual agreement.',
      name: 'cardSwiperDescription',
      desc: '',
      args: [],
    );
  }

  /// `Purchased`
  String get purchased {
    return Intl.message('Purchased', name: 'purchased', desc: '', args: []);
  }

  /// `Balance: `
  String get balance_num {
    return Intl.message('Balance: ', name: 'balance_num', desc: '', args: []);
  }

  /// `Gift Search`
  String get search_gifts {
    return Intl.message(
      'Gift Search',
      name: 'search_gifts',
      desc: '',
      args: [],
    );
  }

  /// `Rarity`
  String get rarity {
    return Intl.message('Rarity', name: 'rarity', desc: '', args: []);
  }

  /// `Gifts`
  String get gifts {
    return Intl.message('Gifts', name: 'gifts', desc: '', args: []);
  }

  /// `Default`
  String get default_sort {
    return Intl.message('Default', name: 'default_sort', desc: '', args: []);
  }

  /// `Cheap first`
  String get price_low_to_high {
    return Intl.message(
      'Cheap first',
      name: 'price_low_to_high',
      desc: '',
      args: [],
    );
  }

  /// `Expensive first`
  String get price_high_to_low {
    return Intl.message(
      'Expensive first',
      name: 'price_high_to_low',
      desc: '',
      args: [],
    );
  }

  /// `No gifts found`
  String get no_gifts_found {
    return Intl.message(
      'No gifts found',
      name: 'no_gifts_found',
      desc: '',
      args: [],
    );
  }

  /// `Administrator, Moderator, Premium`
  String get administratorModeratorPremium {
    return Intl.message(
      'Administrator, Moderator, Premium',
      name: 'administratorModeratorPremium',
      desc: '',
      args: [],
    );
  }

  /// `Administrator, Moderator`
  String get administratorModerator {
    return Intl.message(
      'Administrator, Moderator',
      name: 'administratorModerator',
      desc: '',
      args: [],
    );
  }

  /// `Administrator, Premium`
  String get administratorPremium {
    return Intl.message(
      'Administrator, Premium',
      name: 'administratorPremium',
      desc: '',
      args: [],
    );
  }

  /// `Moderator, Premium`
  String get moderatorPremium {
    return Intl.message(
      'Moderator, Premium',
      name: 'moderatorPremium',
      desc: '',
      args: [],
    );
  }

  /// `Premium`
  String get premium {
    return Intl.message('Premium', name: 'premium', desc: '', args: []);
  }

  /// `Mode not activated`
  String get modeNotActivated {
    return Intl.message(
      'Mode not activated',
      name: 'modeNotActivated',
      desc: '',
      args: [],
    );
  }

  /// `The mode is activated`
  String get theModeIsActivated {
    return Intl.message(
      'The mode is activated',
      name: 'theModeIsActivated',
      desc: '',
      args: [],
    );
  }

  /// `Verified account`
  String get verifiedAccount {
    return Intl.message(
      'Verified account',
      name: 'verifiedAccount',
      desc: '',
      args: [],
    );
  }

  /// `LIKE`
  String get like {
    return Intl.message('LIKE', name: 'like', desc: '', args: []);
  }

  /// `NOPE`
  String get nope {
    return Intl.message('NOPE', name: 'nope', desc: '', args: []);
  }

  /// `There are no more cards`
  String get thereAreNoMoreCards {
    return Intl.message(
      'There are no more cards',
      name: 'thereAreNoMoreCards',
      desc: '',
      args: [],
    );
  }

  /// `Filters`
  String get filters {
    return Intl.message('Filters', name: 'filters', desc: '', args: []);
  }

  /// `Match history`
  String get matchHistory {
    return Intl.message(
      'Match history',
      name: 'matchHistory',
      desc: '',
      args: [],
    );
  }

  /// `You don't have any matches yet`
  String get youDontHaveAnyMatchesYet {
    return Intl.message(
      'You don\'t have any matches yet',
      name: 'youDontHaveAnyMatchesYet',
      desc: '',
      args: [],
    );
  }

  /// `min. ago`
  String get minAgo {
    return Intl.message('min. ago', name: 'minAgo', desc: '', args: []);
  }

  /// `hours ago`
  String get hoursAgo {
    return Intl.message('hours ago', name: 'hoursAgo', desc: '', args: []);
  }

  /// `days ago`
  String get daysAgo {
    return Intl.message('days ago', name: 'daysAgo', desc: '', args: []);
  }

  /// `Document`
  String get document {
    return Intl.message('Document', name: 'document', desc: '', args: []);
  }

  /// `Get points quickly`
  String get getPointsQuickly {
    return Intl.message(
      'Get points quickly',
      name: 'getPointsQuickly',
      desc: '',
      args: [],
    );
  }

  /// `Couldn't show the ad`
  String get couldntShowTheAd {
    return Intl.message(
      'Couldn\'t show the ad',
      name: 'couldntShowTheAd',
      desc: '',
      args: [],
    );
  }

  /// `The ad is not ready, please try again later`
  String get theAdIsNotReadyPleaseTryAgainLater {
    return Intl.message(
      'The ad is not ready, please try again later',
      name: 'theAdIsNotReadyPleaseTryAgainLater',
      desc: '',
      args: [],
    );
  }

  /// `Error uploading user data`
  String get errorUploadingUserData {
    return Intl.message(
      'Error uploading user data',
      name: 'errorUploadingUserData',
      desc: '',
      args: [],
    );
  }

  /// `Likes history`
  String get likesHistory {
    return Intl.message(
      'Likes history',
      name: 'likesHistory',
      desc: '',
      args: [],
    );
  }

  /// `No likes yet`
  String get noLikesYet {
    return Intl.message('No likes yet', name: 'noLikesYet', desc: '', args: []);
  }

  /// `User upload error`
  String get userUploadError {
    return Intl.message(
      'User upload error',
      name: 'userUploadError',
      desc: '',
      args: [],
    );
  }

  /// `The user is not loaded. Please try again later.`
  String get userNotLoaded {
    return Intl.message(
      'The user is not loaded. Please try again later.',
      name: 'userNotLoaded',
      desc: '',
      args: [],
    );
  }

  /// `Access is denied`
  String get accessDenied {
    return Intl.message(
      'Access is denied',
      name: 'accessDenied',
      desc: '',
      args: [],
    );
  }

  /// `To use the card mode, you need to purchase Premium in the gift shop using points`
  String get premiumRequired {
    return Intl.message(
      'To use the card mode, you need to purchase Premium in the gift shop using points',
      name: 'premiumRequired',
      desc: '',
      args: [],
    );
  }

  /// `You must add at least one photo to use the card mode.`
  String get photosRequired {
    return Intl.message(
      'You must add at least one photo to use the card mode.',
      name: 'photosRequired',
      desc: '',
      args: [],
    );
  }

  /// `To use the card mode, you need to subscribe to Premium and add at least one photo.`
  String get premiumAndPhotosRequired {
    return Intl.message(
      'To use the card mode, you need to subscribe to Premium and add at least one photo.',
      name: 'premiumAndPhotosRequired',
      desc: '',
      args: [],
    );
  }

  /// `Failed to load image`
  String get failedToLoadImage {
    return Intl.message(
      'Failed to load image',
      name: 'failedToLoadImage',
      desc: '',
      args: [],
    );
  }

  /// `Purchase error`
  String get purchaseError {
    return Intl.message(
      'Purchase error',
      name: 'purchaseError',
      desc: '',
      args: [],
    );
  }

  /// `Type of gift`
  String get typeOfGift {
    return Intl.message('Type of gift', name: 'typeOfGift', desc: '', args: []);
  }

  /// `Rare`
  String get rare {
    return Intl.message('Rare', name: 'rare', desc: '', args: []);
  }

  /// `Price`
  String get price {
    return Intl.message('Price', name: 'price', desc: '', args: []);
  }

  /// `Complaint sent`
  String get complaintSent {
    return Intl.message(
      'Complaint sent',
      name: 'complaintSent',
      desc: '',
      args: [],
    );
  }

  /// `Error sending complaint`
  String get errorSendingComplaint {
    return Intl.message(
      'Error sending complaint',
      name: 'errorSendingComplaint',
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
