import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_theme.dart';
import 'package:memomemo/features/memo/ui/screens/memo_list_screen.dart';
import 'storage/memo_repository.dart';
import 'state/memo_notifier.dart';

class MemoMemoApp extends StatelessWidget {
  const MemoMemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = MemoRepository();
    return ChangeNotifierProvider(
      create: (_) {
        final notifier = MemoNotifier(repo);
        notifier.init();
        return notifier;
      },
      child: MaterialApp(
        title: '気分×色メモ',
        theme: appTheme,
        home: const MemoListScreen(),
      ),
    );
  }
}
