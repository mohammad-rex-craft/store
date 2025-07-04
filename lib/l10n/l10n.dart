import 'package:flutter/material.dart';

class L10n {
  static final all = [
    const Locale('en'),
    const Locale('ar'),
    const Locale('fr'),
    const Locale('de'),
  ];

  static String getLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'ar':
        return 'العربية';
      case 'en':
        return 'English';
      case 'fr':
        return 'Français';
      case 'de':
        return 'Deutsch';
      default:
        return 'English';
    }
  }

  static Locale getLocaleFromLanguageCode(String languageCode) {
    switch (languageCode) {
      case 'ar':
        return const Locale('ar');
      case 'en':
        return const Locale('en');
      case 'fr':
        return const Locale('fr');
      case 'de':
        return const Locale('de');
      default:
        return const Locale('en');
    }
  }
} 