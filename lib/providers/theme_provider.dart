import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;

  bool get isDarkMode {
    return themeMode == ThemeMode.light;
  }

  void toogleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.light : ThemeMode.dark;
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
      hintColor: Colors.orangeAccent,
      canvasColor: Colors.grey[800],
      highlightColor: Colors.orangeAccent,
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
      hintColor: Colors.black,
      primaryColor: Colors.orangeAccent,
      canvasColor:const Color.fromARGB(255, 233, 224, 211),
      highlightColor: Colors.orange[700],
      iconTheme: const IconThemeData(color: Colors.black));
}
