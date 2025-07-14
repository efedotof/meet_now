import 'package:flutter/material.dart';

final dartTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.black,
  colorScheme: const ColorScheme.dark(
    primary: Colors.white,
    secondary: Colors.grey,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.black,
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.grey,
    selectedIconTheme: IconThemeData(size: 24),
    unselectedIconTheme: IconThemeData(size: 20),
    showUnselectedLabels: false,
    type: BottomNavigationBarType.fixed,
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Colors.white70, fontSize: 14),
    titleLarge: TextStyle(color: Colors.white, fontSize: 18),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFF1E1E1E),
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    hintStyle: TextStyle(color: Colors.grey),
  ),
  cardTheme: const CardTheme(
    color: Color(0xFF1E1E1E),
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  ),
  iconTheme: const IconThemeData(color: Colors.white70),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: Colors.white70),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    elevation: 2,
  ),
  checkboxTheme: CheckboxThemeData(
    fillColor: WidgetStateProperty.all(Colors.white),
    checkColor: WidgetStateProperty.all(Colors.black),
  ),
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.all(Colors.white),
    trackColor: WidgetStateProperty.all(Colors.white24),
  ),
  sliderTheme: const SliderThemeData(
    activeTrackColor: Colors.white,
    inactiveTrackColor: Colors.white30,
    thumbColor: Colors.white,
  ),
  dividerTheme: const DividerThemeData(color: Colors.white10, thickness: 1),
  dialogTheme: const DialogTheme(
    backgroundColor: Color(0xFF1E1E1E),
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 18),
    contentTextStyle: TextStyle(color: Colors.white70),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  ),
  listTileTheme: const ListTileThemeData(
    iconColor: Colors.white70,
    textColor: Colors.white,
    tileColor: Color(0xFF1E1E1E),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  ),
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: Colors.grey,
    contentTextStyle: TextStyle(color: Colors.white),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  ),
  useMaterial3: true,
);

final lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  colorScheme: const ColorScheme.light(
    primary: Colors.black,
    secondary: Colors.grey,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: Colors.black,
    unselectedItemColor: Colors.grey,
    selectedIconTheme: IconThemeData(size: 24),
    unselectedIconTheme: IconThemeData(size: 20),
    showUnselectedLabels: false,
    type: BottomNavigationBarType.fixed,
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Colors.black87, fontSize: 14),
    titleLarge: TextStyle(color: Colors.black, fontSize: 18),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFFF5F5F5),
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    hintStyle: TextStyle(color: Colors.grey),
  ),
  cardTheme: const CardTheme(
    color: Color(0xFFF5F5F5),
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  ),
  iconTheme: const IconThemeData(color: Colors.black54),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: Colors.black54),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
    elevation: 2,
  ),
  checkboxTheme: CheckboxThemeData(
    fillColor: WidgetStateProperty.all(Colors.black),
    checkColor: WidgetStateProperty.all(Colors.white),
  ),
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.all(Colors.black),
    trackColor: WidgetStateProperty.all(Colors.black12),
  ),
  sliderTheme: const SliderThemeData(
    activeTrackColor: Colors.black,
    inactiveTrackColor: Colors.black26,
    thumbColor: Colors.black,
  ),
  dividerTheme: const DividerThemeData(color: Colors.black12, thickness: 1),
  dialogTheme: const DialogTheme(
    backgroundColor: Colors.white,
    titleTextStyle: TextStyle(color: Colors.black, fontSize: 18),
    contentTextStyle: TextStyle(color: Colors.black87),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  ),
  listTileTheme: const ListTileThemeData(
    iconColor: Colors.black54,
    textColor: Colors.black87,
    tileColor: Color(0xFFF5F5F5),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  ),
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: Colors.black87,
    contentTextStyle: TextStyle(color: Colors.white),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  ),
  useMaterial3: true,
);
