import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class ThemeColors {
  static const darkPrimary = Color(0xffff897d);
  static const darkPrimaryContainer = Color(0xff542344);
  static const darkSecondary = Color(0xffe7bdb6);
  static const darkSecondaryContainer = Color(0xff872100);
  static const darkTertiary = Color(0xff86d2e1);
  static const darkTertiaryContainer = Color(0xff004e59);
  static const darkAppBarColor = Color(0xff872100);
  static const darkError = Color(0xffcf6679);
  static const darkErrorContainer = Color(0xff93000a);
  static const darkBackground = Color(0xff161314);
  static const darkSurfaceVariant = Color(0xff1F1A1C);
  static const darkOnSurfaceVariant = Color(0xffffedea);
  static const altSurface = Color(0xffac9e9c);
  Color fadedText = const Color(0xffffedea).withAlpha(120);
}

final ThemeData darkTheme = ThemeData(
  colorScheme: const ColorScheme.dark(
    primary: ThemeColors.darkPrimary,
    secondary: ThemeColors.darkSecondary,
    background: ThemeColors.darkBackground,
    error: ThemeColors.darkError,
    surfaceVariant: ThemeColors.darkSurfaceVariant,
    onSurfaceVariant: ThemeColors.darkOnSurfaceVariant,
    onPrimary: ThemeColors.darkOnSurfaceVariant,
    onSecondary: ThemeColors.darkOnSurfaceVariant,
    onBackground: ThemeColors.darkOnSurfaceVariant,
    onError: ThemeColors.darkErrorContainer,
  ),
  appBarTheme: const AppBarTheme(
    color: ThemeColors.darkAppBarColor,
  ),
  cardTheme: const CardTheme(
    color: ThemeColors.darkPrimaryContainer,
  ),
  dialogBackgroundColor: ThemeColors.darkSecondaryContainer,
  scaffoldBackgroundColor: ThemeColors.darkBackground,
  buttonTheme: const ButtonThemeData(
    buttonColor: ThemeColors.darkTertiary,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: ThemeColors.darkOnSurfaceVariant),
    bodyMedium: TextStyle(color: ThemeColors.darkOnSurfaceVariant),
  ),
);
