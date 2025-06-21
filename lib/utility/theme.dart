import 'package:flutter/material.dart';

class AppTheme {
  // الألوان الرئيسية للمشروع
  static const Color colorText = Color.fromARGB(255, 1, 54, 103);
  static const Color colorMain = Color.fromARGB(255, 31, 185, 185);
  static const Color colorLowOpacity = Color.fromARGB(103, 1, 54, 103);
  
  // ألوان إضافية
  static const Color colorSuccess = Color.fromARGB(255, 76, 175, 80);
  static const Color colorWarning = Color.fromARGB(255, 255, 152, 0);
  static const Color colorError = Color.fromARGB(255, 244, 67, 54);
  static const Color colorInfo = Color.fromARGB(255, 33, 150, 243);
  
  // ألوان الخلفية
  static const Color backgroundColor = Color.fromARGB(255, 248, 249, 250);
  static const Color cardBackground = Colors.white;
  static const Color inputBackground = Color.fromARGB(255, 250, 250, 250);
  
  // ألوان الحدود
  static const Color borderColor = Color.fromARGB(255, 224, 224, 224);
  static const Color focusedBorderColor = colorMain;
  
  // ألوان النص
  static const Color textPrimary = colorText;
  static const Color textSecondary = Color.fromARGB(255, 117, 117, 117);
  static const Color textHint = Color.fromARGB(255, 158, 158, 158);
  
  // أنماط النص
  static const TextStyle headingStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );
  
  static const TextStyle titleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );
  
  static const TextStyle bodyStyle = TextStyle(
    fontSize: 16,
    color: textPrimary,
  );
  
  static const TextStyle captionStyle = TextStyle(
    fontSize: 14,
    color: textSecondary,
  );
  
  // أنماط الأزرار
  static ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: colorMain,
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    textStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
  );
  
  static ButtonStyle secondaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: Colors.transparent,
    foregroundColor: colorMain,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: const BorderSide(color: colorMain, width: 2),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    textStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
  );
  
  // أنماط حقول الإدخال
  static InputDecoration inputDecoration({
    required String labelText,
    String? hintText,
    IconData? prefixIcon,
    IconData? suffixIcon,
    VoidCallback? onSuffixPressed,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      labelStyle: const TextStyle(
        color: textSecondary,
        fontWeight: FontWeight.w500,
      ),
      hintStyle: const TextStyle(color: textHint),
      prefixIcon: prefixIcon != null 
        ? Icon(prefixIcon, color: textSecondary)
        : null,
      suffixIcon: suffixIcon != null
        ? IconButton(
            icon: Icon(suffixIcon, color: textSecondary),
            onPressed: onSuffixPressed,
          )
        : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: focusedBorderColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: colorError),
      ),
      filled: true,
      fillColor: inputBackground,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }
  
  // أنماط البطاقات
  static BoxDecoration cardDecoration = BoxDecoration(
    color: cardBackground,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );
  
  // أنماط الحاويات
  static BoxDecoration containerDecoration = BoxDecoration(
    color: cardBackground,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: borderColor),
  );
  
  // أنماط الأيقونات
  static const IconThemeData iconTheme = IconThemeData(
    color: textSecondary,
    size: 24,
  );
  
  // أنماط الأيقونات الملونة
  static const IconThemeData primaryIconTheme = IconThemeData(
    color: colorMain,
    size: 24,
  );
  
  static const IconThemeData errorIconTheme = IconThemeData(
    color: colorError,
    size: 24,
  );
  
  static const IconThemeData successIconTheme = IconThemeData(
    color: colorSuccess,
    size: 24,
  );
  
  static const IconThemeData warningIconTheme = IconThemeData(
    color: colorWarning,
    size: 24,
  );
} 