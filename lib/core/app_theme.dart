import 'package:flutter/material.dart';
import 'app_colors.dart';

final ThemeData appTheme = ThemeData(
  useMaterial3: true, //Material3デザインルールを使う
  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.seed),
  scaffoldBackgroundColor: AppColors.scaffold,
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.fab,
  ),
  textTheme: const TextTheme().apply(
    bodyColor: AppColors.textMain,
    displayColor: AppColors.textMain,
  ),
);
