import 'package:flutter/material.dart';
import 'package:memomemo/core/app_theme.dart';
import 'package:memomemo/features/screens/memo_list_screen.dart';
import 'package:memomemo/features/screens/onboarding_screen.dart';

class MemoMemoApp extends StatelessWidget {
  final bool isFirstLaunch;

  const MemoMemoApp({super.key, required this.isFirstLaunch});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 右上の帯を消す
      title: '気分×色メモ',
      theme: appTheme, // 作成したテーマを適用
      home: isFirstLaunch ? const OnboardingScreen() : const MemoListScreen(),
    );
  }
}
