import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_colors.dart';

class SettingsProvider extends ChangeNotifier {
  Color _accentColor = AppColors.neonBlue;
  String _accentName = 'Neon Blue';
  bool _isDarkMode = true;
  String _speedUnit = 'km/h';
  double _brightness = 1.0;
  String? _wallpaperPath;

  Color get accentColor => _accentColor;
  String get accentName => _accentName;
  bool get isDarkMode => _isDarkMode;
  String get speedUnit => _speedUnit;
  double get brightness => _brightness;
  String? get wallpaperPath => _wallpaperPath;

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _accentName = prefs.getString('accentName') ?? 'Neon Blue';
    _accentColor = AppColors.accentColors[_accentName] ?? AppColors.neonBlue;
    _isDarkMode = prefs.getBool('isDarkMode') ?? true;
    _speedUnit = prefs.getString('speedUnit') ?? 'km/h';
    _brightness = prefs.getDouble('brightness') ?? 1.0;
    _wallpaperPath = prefs.getString('wallpaperPath');
    notifyListeners();
  }

  Future<void> setAccentColor(String name) async {
    _accentName = name;
    _accentColor = AppColors.accentColors[name] ?? AppColors.neonBlue;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accentName', name);
    notifyListeners();
  }

  Future<void> toggleDarkMode() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }

  Future<void> setSpeedUnit(String unit) async {
    _speedUnit = unit;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('speedUnit', unit);
    notifyListeners();
  }

  Future<void> setBrightness(double value) async {
    _brightness = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('brightness', value);
    notifyListeners();
  }

  Future<void> setWallpaper(String? path) async {
    _wallpaperPath = path;
    final prefs = await SharedPreferences.getInstance();
    if (path != null) {
      await prefs.setString('wallpaperPath', path);
    } else {
      await prefs.remove('wallpaperPath');
    }
    notifyListeners();
  }
}
