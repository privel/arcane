import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NavigationProvider extends ChangeNotifier {
  int _currentIndex = 0;
  bool _isDarkMode = false;
  bool _isThemeLoaded = false;

  final Map<String, int> _pathToIndex = {
    '/life-graph': 0,
    '/products': 1,
    '/projects': 2,
    '/tasks': 3,
    '/settings': 4,
  };

  final List<String> _indexToPath = [
    '/life-graph',
    '/products',
    '/projects',
    '/tasks',
    '/settings',
  ];

  int get currentIndex => _currentIndex;
  String get currentPath => _indexToPath[_currentIndex];
  bool get isDarkMode => _isDarkMode;
  bool get isThemeLoaded => _isThemeLoaded;

  NavigationProvider() {
    _loadTheme();
  }

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }

  void setPath(String path) {
    if (_pathToIndex.containsKey(path)) {
      _currentIndex = _pathToIndex[path]!;
      notifyListeners();
    }
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
