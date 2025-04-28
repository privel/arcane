import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationProvider extends ChangeNotifier {
  int _currentIndex = 0;
  bool _isDarkMode = false;
  bool _isThemeLoaded = false;

  int get currentIndex => _currentIndex;
  bool get isDarkMode => _isDarkMode;
  bool get isThemeLoaded => _isThemeLoaded;

  NavigationProvider() {
    _loadTheme(); // просто вызов здесь
  }

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _saveTheme();
    notifyListeners();
  }

  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    } catch (e) {
      print('Ошибка загрузки темы: $e');
    } finally {
      _isThemeLoaded = true; // ← в любом случае завершаем
      notifyListeners();
    }
  }

  Future<void> _saveTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isDarkMode', _isDarkMode);
    } catch (e) {
      print('Ошибка при сохранении темы: $e');
    }
  }
}
