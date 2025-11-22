import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 必須
import 'package:shared_preferences/shared_preferences.dart'; // 必須
import 'core/app.dart'; // MemoMemoAppの場所
import 'core/data/memo_repository.dart'; // リポジトリの場所

void main() async {
  // 1. Flutterエンジンの初期化 (非同期処理を使う前に必須)
  WidgetsFlutterBinding.ensureInitialized();

  // 2. データの保存場所 (SharedPreferences) を準備
  final prefs = await SharedPreferences.getInstance();

  // 3. アプリ起動
  runApp(
    ProviderScope(
      overrides: [
        // ここで「準備完了したリポジトリ」をアプリ全体に配る
        memoRepositoryProvider.overrideWithValue(MemoRepository(prefs)),
      ],
      child: const MemoMemoApp(),
    ),
  );
}
