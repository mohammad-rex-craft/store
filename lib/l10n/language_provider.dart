import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'l10n.dart';

class LanguageProvider extends ChangeNotifier {
  static const String _languageKey = 'selected_language';
  Locale _currentLocale = const Locale('en');

  Locale get currentLocale => _currentLocale;

  LanguageProvider() {
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString(_languageKey) ?? 'en';
    _currentLocale = L10n.getLocaleFromLanguageCode(languageCode);
    notifyListeners();
  }

  Future<void> changeLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, languageCode);
    _currentLocale = L10n.getLocaleFromLanguageCode(languageCode);
    notifyListeners();
  }

  bool isRTL() {
    return _currentLocale.languageCode == 'ar';
  }
} 