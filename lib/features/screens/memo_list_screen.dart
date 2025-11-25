import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/provider/memo_state.dart';
import '../widgets/memo_card.dart';
import 'new_memo_modal.dart';
import 'setting_screen.dart';

class MemoListScreen extends ConsumerWidget {
  const MemoListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Riverpodの状態監視 (AsyncValue<List<Memo>>)
    final asyncMemos = ref.watch(memoNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('気分でメモメモ'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (_) => const SettingScreen()));
            },
            icon: const Icon(Icons.settings), // 色指定を削除（テーマに従う）
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 検索バー (機能は未実装の見た目だけ)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const ListTile(
                leading: Icon(Icons.search, color: Colors.black38),
                title: Text('検索', style: TextStyle(color: Colors.black38)),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // コンテンツエリア
          Expanded(
            child: Stack(
              children: [
                // 背景画像
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.15,
                    child: Image.asset('assets/images/memomemo.png'),
                  ),
                ),

                // Riverpodの状態による分岐
                asyncMemos.when(
                  data: (items) {
                    if (items.isEmpty) {
                      return const Center(child: Text('まだメモがありません'));
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, index) =>
                          MemoCard(memo: items[index]),
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                    );
                  },
                  error: (err, stack) =>
                      Center(child: Text('エラーが発生しました: $err')),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openNewMemo(context),
        child: const Icon(Icons.add, color: Colors.white), // アイコン白の方が見やすいかも
      ),
    );
  }

  void _openNewMemo(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (_) => const NewMemoModal(),
      ),
    );
  }
}
