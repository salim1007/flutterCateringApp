import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.dark;

  bool get isDarkMode {
    return themeMode == ThemeMode.dark;
  }

  void toogleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyThemes {
  static final darkTheme = ThemeData(
      textTheme: const TextTheme(
          headlineMedium: TextStyle(
              color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
      scaffoldBackgroundColor: Colors.grey.shade900,
      colorScheme: const ColorScheme.dark(),
      primaryColor: Colors.orangeAccent,
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.grey[800],
      ),
      cardColor: Colors.orangeAccent,
      iconTheme: const IconThemeData(color: Colors.black));

  static final lightTheme = ThemeData(
      textTheme: const TextTheme(
          headlineMedium: TextStyle(
              color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)),
      scaffoldBackgroundColor: Colors.orange[200],
      colorScheme: const ColorScheme.light(),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.orange[200],
      ),
      cardColor: Colors.orangeAccent,
      primaryColor: Colors.orangeAccent,
      iconTheme: const IconThemeData(color: Colors.black));
}
