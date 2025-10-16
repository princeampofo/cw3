import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Service to manage theme preferences
class ThemeService {
  static const String _themeKey = 'isDarkMode';

  // Save theme preference
  Future<void> saveThemePreference(bool isDarkMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    debugPrint(isDarkMode ? 'Saving Dark Mode preference' : 'Saving Light Mode preference');
    await prefs.setBool(_themeKey, isDarkMode);
  }

  // Get theme preference
  Future<bool> getThemePreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    debugPrint('Loading theme preference');
    return prefs.getBool(_themeKey) ?? false; // Default to light mode
  }
}