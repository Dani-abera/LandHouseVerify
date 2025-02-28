import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dark_theme.dart';
import 'light_theme.dart';

class ThemeProvider extends Notifier<ThemeData> {
  // Initialize the theme to light mode
  @override
  ThemeData build() => lightMode;

  // Getter to check if the current theme is dark mode
  bool get isDarkMode => state == darkMode;

  // Method to toggle between light and dark themes
  void toggleTheme() {
    state = (state == lightMode) ? darkMode : lightMode;
  }
}

final themeProvider = NotifierProvider<ThemeProvider, ThemeData>(() {
  return ThemeProvider();
});
