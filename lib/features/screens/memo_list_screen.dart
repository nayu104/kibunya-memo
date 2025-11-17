import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/memo_card.dart';
import '../../../../core/state/memo_notifier.dart';
import '../widgets/new_memo_modal.dart';
import '../widgets/contact_url.dart';

class MemoListScreen extends StatelessWidget {
  const MemoListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<MemoNotifier>();
    final items = notifier.items;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SafeArea(
            child: Row(
              children: [
                SizedBox(width: 16),
                Text(
                  'メモ一覧',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                //   Image.asset('assets/images/logo.png', width: 2, height: 2),
                Spacer(),
                const ContactUrl(),
                SizedBox(width: 16),
              ],
            ),
          ),
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

          // Content
          Expanded(
            // ここだけ差し替え
            child: Stack(
              children: [
                // 背景画像（常に表示）
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.15, // 薄くしたいなら調整
                    child: Image.asset('assets/images/memomemo.png'),
                  ),
                ),

                // 前面コンテンツ
                if (notifier.loading)
                  const Center(child: CircularProgressIndicator())
                else if (items.isEmpty)
                  const Center(
                    child: Text('まだメモがありません'), // 好きな文言に変えていい
                  )
                else
                  ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemBuilder: (context, index) =>
                        MemoCard(memo: items[index]),
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemCount: items.length,
                  ),
              ],
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => _openNewMemo(context),
        backgroundColor: Colors.white,
        child: const Icon(Icons.add, color: Colors.blue),
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
