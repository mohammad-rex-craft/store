import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/language_provider.dart';
import '../../l10n/l10n.dart';
import '../../utility/theme.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        return PopupMenuButton<String>(
          icon: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.language, color: AppTheme.colorMain, size: 20),
            ],
          ),
          tooltip: 'Language',
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: AppTheme.cardBackground,
          onSelected: (String languageCode) {
            languageProvider.changeLanguage(languageCode);
          },
          itemBuilder: (BuildContext context) => L10n.all.map((Locale locale) {
            final isSelected =
                languageProvider.currentLocale.languageCode ==
                locale.languageCode;
            return PopupMenuItem<String>(
              value: locale.languageCode,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.colorMain.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    // Language flag/icon
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: _getLanguageColor(locale.languageCode),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          _getLanguageFlag(locale.languageCode),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Language name
                    Expanded(
                      child: Text(
                        L10n.getLanguageName(locale),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.normal,
                          color: isSelected
                              ? AppTheme.colorMain
                              : AppTheme.textPrimary,
                        ),
                      ),
                    ),
                    // Check icon for selected language
                    if (isSelected)
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppTheme.colorMain,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Color _getLanguageColor(String languageCode) {
    switch (languageCode) {
      case 'ar':
        return const Color(0xFF006C35); // Green for Arabic
      case 'en':
        return const Color(0xFF1E3A8A); // Blue for English
      case 'fr':
        return const Color(0xFFDC2626); // Red for French
      case 'de':
        return const Color.fromARGB(255, 38, 120, 220); // Red for German
      default:
        return AppTheme.colorMain;
    }
  }

  String _getLanguageFlag(String languageCode) {
    switch (languageCode) {
      case 'ar':
        return 'ع';
      case 'en':
        return 'EN';
      case 'fr':
        return 'FR';
      case 'de':
        return 'DE';
      default:
        return 'EN';
    }
  }
}
