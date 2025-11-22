import 'package:flutter/material.dart';
import 'package:memomemo/core/app_theme.dart';
import 'package:memomemo/features/screens/memo_list_screen.dart';

class MemoMemoApp extends StatelessWidget {
  const MemoMemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 右上の帯を消す
      title: '気分×色メモ',
      theme: appTheme, // 作成したテーマを適用
      home: const MemoListScreen(),
    );
  }
}
