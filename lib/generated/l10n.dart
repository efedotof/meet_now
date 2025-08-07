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
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
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
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
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
    return Intl.message(
      'Username',
      name: 'usernameHint',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get passwordHint {
    return Intl.message(
      'Password',
      name: 'passwordHint',
      desc: '',
      args: [],
    );
  }

  /// `Sign in`
  String get loginButton {
    return Intl.message(
      'Sign in',
      name: 'loginButton',
      desc: '',
      args: [],
    );
  }

  /// `Sign in`
  String get signIn {
    return Intl.message(
      'Sign in',
      name: 'signIn',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Gender',
      name: 'gender',
      desc: '',
      args: [],
    );
  }

  /// `Male`
  String get male {
    return Intl.message(
      'Male',
      name: 'male',
      desc: '',
      args: [],
    );
  }

  /// `Female`
  String get female {
    return Intl.message(
      'Female',
      name: 'female',
      desc: '',
      args: [],
    );
  }

  /// `Description`
  String get description {
    return Intl.message(
      'Description',
      name: 'description',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Friendship',
      name: 'friendship',
      desc: '',
      args: [],
    );
  }

  /// `Love`
  String get love {
    return Intl.message(
      'Love',
      name: 'love',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Interests',
      name: 'interests',
      desc: '',
      args: [],
    );
  }

  /// `Sports`
  String get sports {
    return Intl.message(
      'Sports',
      name: 'sports',
      desc: '',
      args: [],
    );
  }

  /// `Games`
  String get games {
    return Intl.message(
      'Games',
      name: 'games',
      desc: '',
      args: [],
    );
  }

  /// `Books`
  String get books {
    return Intl.message(
      'Books',
      name: 'books',
      desc: '',
      args: [],
    );
  }

  /// `Music`
  String get music {
    return Intl.message(
      'Music',
      name: 'music',
      desc: '',
      args: [],
    );
  }

  /// `Your photo`
  String get yourPhoto {
    return Intl.message(
      'Your photo',
      name: 'yourPhoto',
      desc: '',
      args: [],
    );
  }

  /// `Sign up`
  String get signUp {
    return Intl.message(
      'Sign up',
      name: 'signUp',
      desc: '',
      args: [],
    );
  }

  /// `Next`
  String get next {
    return Intl.message(
      'Next',
      name: 'next',
      desc: '',
      args: [],
    );
  }

  /// `Credentials`
  String get credentials {
    return Intl.message(
      'Credentials',
      name: 'credentials',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get username {
    return Intl.message(
      'Username',
      name: 'username',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'First name',
      name: 'firstName',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Last name',
      name: 'lastName',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Age',
      name: 'age',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'City',
      name: 'city',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Search`
  String get search {
    return Intl.message(
      'Search',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `Chat`
  String get chat {
    return Intl.message(
      'Chat',
      name: 'chat',
      desc: '',
      args: [],
    );
  }

  /// `Friends`
  String get friends {
    return Intl.message(
      'Friends',
      name: 'friends',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Error',
      name: 'errorPrefix',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Tap to view',
      name: 'tapToView',
      desc: '',
      args: [],
    );
  }

  /// `Chats`
  String get chats {
    return Intl.message(
      'Chats',
      name: 'chats',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Anonymous',
      name: 'anonymous',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Timer:',
      name: 'timerSeconds',
      desc: '',
      args: [],
    );
  }

  /// `seconds`
  String get seconds {
    return Intl.message(
      'seconds',
      name: 'seconds',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continues {
    return Intl.message(
      'Continue',
      name: 'continues',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Close',
      name: 'close',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Finish',
      name: 'finish',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'typing...',
      name: 'typing',
      desc: '',
      args: [],
    );
  }

  /// `offline`
  String get offline {
    return Intl.message(
      'offline',
      name: 'offline',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'online',
      name: 'online',
      desc: '',
      args: [],
    );
  }

  /// `Error`
  String get error {
    return Intl.message(
      'Error',
      name: 'error',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get retry {
    return Intl.message(
      'Retry',
      name: 'retry',
      desc: '',
      args: [],
    );
  }

  /// `Message...`
  String get messageHint {
    return Intl.message(
      'Message...',
      name: 'messageHint',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Found',
      name: 'found',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'About App',
      name: 'aboutApp',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Russian`
  String get russian {
    return Intl.message(
      'Russian',
      name: 'russian',
      desc: '',
      args: [],
    );
  }

  /// `QR Scanner`
  String get qrScanner {
    return Intl.message(
      'QR Scanner',
      name: 'qrScanner',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Security',
      name: 'security',
      desc: '',
      args: [],
    );
  }

  /// `Theme`
  String get theme {
    return Intl.message(
      'Theme',
      name: 'theme',
      desc: '',
      args: [],
    );
  }

  /// `Support`
  String get support {
    return Intl.message(
      'Support',
      name: 'support',
      desc: '',
      args: [],
    );
  }

  /// `Exit`
  String get exit {
    return Intl.message(
      'Exit',
      name: 'exit',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Light Theme',
      name: 'lightTheme',
      desc: '',
      args: [],
    );
  }

  /// `Dark Theme`
  String get darkTheme {
    return Intl.message(
      'Dark Theme',
      name: 'darkTheme',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Current',
      name: 'currents',
      desc: '',
      args: [],
    );
  }

  /// `Primary`
  String get primary {
    return Intl.message(
      'Primary',
      name: 'primary',
      desc: '',
      args: [],
    );
  }

  /// `Background`
  String get background {
    return Intl.message(
      'Background',
      name: 'background',
      desc: '',
      args: [],
    );
  }

  /// `Text`
  String get text {
    return Intl.message(
      'Text',
      name: 'text',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'About me',
      name: 'aboutMe',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Select age',
      name: 'selectAge',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Purposes',
      name: 'purposes',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `My Profile`
  String get myProfile {
    return Intl.message(
      'My Profile',
      name: 'myProfile',
      desc: '',
      args: [],
    );
  }

  /// `View all`
  String get viewAll {
    return Intl.message(
      'View all',
      name: 'viewAll',
      desc: '',
      args: [],
    );
  }

  /// `years`
  String get years {
    return Intl.message(
      'years',
      name: 'years',
      desc: '',
      args: [],
    );
  }

  /// `Friend`
  String get friend {
    return Intl.message(
      'Friend',
      name: 'friend',
      desc: '',
      args: [],
    );
  }

  /// `QR Scanning`
  String get qrScanning {
    return Intl.message(
      'QR Scanning',
      name: 'qrScanning',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Scanned',
      name: 'scanned',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Auto Lock',
      name: 'autoLock',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Enable PIN',
      name: 'enablePin',
      desc: '',
      args: [],
    );
  }

  /// `Change PIN`
  String get changePin {
    return Intl.message(
      'Change PIN',
      name: 'changePin',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Confirm PIN',
      name: 'confirmPin',
      desc: '',
      args: [],
    );
  }

  /// `Set new PIN`
  String get setNewPin {
    return Intl.message(
      'Set new PIN',
      name: 'setNewPin',
      desc: '',
      args: [],
    );
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
    return Intl.message(
      'Confirm',
      name: 'confirm',
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
