import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

ThemeData appTheme = ThemeData(
  useMaterial3: true,

  // 色設定
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.seed,
    surface: AppColors.scaffold,
  ),

  scaffoldBackgroundColor: AppColors.scaffold,

  // フォント設定
  fontFamily: GoogleFonts.yuseiMagic().fontFamily,
  // テキスト設定 /
  textTheme: const TextTheme().apply(
    bodyColor: AppColors.textMain,
    displayColor: AppColors.textMain,
  ),

  // AppBar設定
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.scaffold,
    surfaceTintColor: Colors.transparent,
    elevation: 0,
    centerTitle: true,
    iconTheme: IconThemeData(color: AppColors.textMain),
    titleTextStyle: TextStyle(
      color: AppColors.textMain,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  ),

  // FAB設定
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.fab,
    foregroundColor: Colors.white,
    shape: CircleBorder(),
  ),
  // Card設定
  cardTheme: CardThemeData(
    color: Colors.white,
    elevation: 0,
    margin: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: const BorderSide(color: Color(0xFFE0E0E0)),
    ),
  ),
);
