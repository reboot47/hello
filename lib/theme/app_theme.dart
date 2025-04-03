import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

/// アプリ全体のテーマを定義するクラス
class AppTheme {
  // メモリーズに保存された色彩設定
  static const Color primaryColor = Color(0xFF3bcfd4); // ターコイズ
  static const Color secondaryColor = Color(0xFF1a237e); // 濃紺
  static const Color accentColor = Color(0xFFf8bbd0); // 薄ピンク
  static const Color baseColor = Color(0xFFFFFFFF); // 白

  // その他のカラーバリエーション
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color dividerColor = Color(0xFFBDBDBD);
  static const Color errorColor = Color(0xFFB00020);
  static const Color successColor = Color(0xFF4CAF50);

  // ダークモードの色
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkTextPrimary = Color(0xFFEEEEEE);
  static const Color darkTextSecondary = Color(0xFFAAAAAA);

  /// プラットフォームに適したフォントを返す
  static String get defaultFont {
    if (kIsWeb) {
      return 'Roboto';
    } else if (Platform.isIOS || Platform.isMacOS) {
      // SF Proフォントの代わりにGoogle Fontsからアクセス可能なフォントを使用
      return 'Inter';
    } else if (Platform.isAndroid) {
      return 'Roboto';
    } else if (Platform.isWindows) {
      return 'Segoe UI';
    } else {
      return 'Roboto';
    }
  }

  /// 日本語フォントをプラットフォームに応じて返す
  static String get japaneseFont {
    if (kIsWeb) {
      return 'Noto Sans JP';
    } else if (Platform.isIOS || Platform.isMacOS) {
      return 'Hiragino Sans';
    } else if (Platform.isAndroid) {
      return 'Noto Sans JP';
    } else if (Platform.isWindows) {
      return 'Yu Gothic UI';
    } else {
      return 'Noto Sans JP';
    }
  }

  /// ライトテーマデータを取得
  static ThemeData getLightTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        onPrimary: baseColor,
        secondary: secondaryColor,
        onSecondary: baseColor,
        tertiary: accentColor,
        error: errorColor,
        background: baseColor,
        surface: baseColor,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: baseColor,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: baseColor,
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 24.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: secondaryColor,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: baseColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: dividerColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: primaryColor, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: errorColor, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: dividerColor),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 16.0,
        ),
      ),
      cardTheme: CardTheme(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        color: baseColor,
      ),
      scaffoldBackgroundColor: baseColor.withOpacity(0.95),
      textTheme: TextTheme(
        headlineLarge: GoogleFonts.inter(
          fontWeight: FontWeight.bold,
          fontSize: 32.0,
          color: textPrimary,
        ),
        headlineMedium: GoogleFonts.inter(
          fontWeight: FontWeight.bold,
          fontSize: 24.0,
          color: textPrimary,
        ),
        titleLarge: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          fontSize: 20.0,
          color: textPrimary,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16.0,
          color: textPrimary,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14.0,
          color: textSecondary,
        ),
      ),
    );
  }

  /// ダークテーマデータを取得
  static ThemeData getDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        onPrimary: darkTextPrimary,
        secondary: accentColor,
        onSecondary: darkTextPrimary,
        tertiary: accentColor.withOpacity(0.7),
        error: errorColor,
        background: darkBackground,
        surface: darkSurface,
        onBackground: darkTextPrimary,
        onSurface: darkTextPrimary,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: secondaryColor,
        foregroundColor: darkTextPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: darkTextPrimary,
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          padding: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 24.0,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accentColor,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.grey.shade700),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: primaryColor, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: errorColor, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.grey.shade700),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16.0,
          horizontal: 16.0,
        ),
        labelStyle: TextStyle(color: darkTextSecondary),
        hintStyle: TextStyle(color: darkTextSecondary),
      ),
      cardTheme: CardTheme(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        color: darkSurface,
      ),
      scaffoldBackgroundColor: darkBackground,
      textTheme: TextTheme(
        headlineLarge: GoogleFonts.inter(
          fontWeight: FontWeight.bold,
          fontSize: 32.0,
          color: darkTextPrimary,
        ),
        headlineMedium: GoogleFonts.inter(
          fontWeight: FontWeight.bold,
          fontSize: 24.0,
          color: darkTextPrimary,
        ),
        titleLarge: GoogleFonts.inter(
          fontWeight: FontWeight.w600,
          fontSize: 20.0,
          color: darkTextPrimary,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16.0,
          color: darkTextPrimary,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14.0,
          color: darkTextSecondary,
        ),
      ),
      iconTheme: IconThemeData(color: darkTextPrimary),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.disabled)) {
            return Colors.grey.shade400;
          }
          if (states.contains(MaterialState.selected)) {
            return primaryColor;
          }
          return Colors.grey.shade400;
        }),
        trackColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.disabled)) {
            return Colors.grey.shade800;
          }
          if (states.contains(MaterialState.selected)) {
            return primaryColor.withOpacity(0.5);
          }
          return Colors.grey.shade800;
        }),
      ),
    );
  }
}
