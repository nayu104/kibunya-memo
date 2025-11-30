import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/app.dart';
import 'core/data/memo_repository.dart';
import 'features/screens/onboarding_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'crashlytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Crashlytics.setup();

  //  データの保存場所 (SharedPreferences) を準備
  final prefs = await SharedPreferences.getInstance();
  final isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;
  runApp(
    ProviderScope(
      overrides: [
        // ここで「準備完了したリポジトリ」をアプリ全体に配る
        memoRepositoryProvider.overrideWithValue(MemoRepository(prefs)),
      ],
      child: MemoMemoApp(isFirstLaunch: isFirstLaunch),
    ),
  );
}
