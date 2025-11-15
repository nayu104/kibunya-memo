import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/memo_card.dart';
import '../../../../core/state/memo_notifier.dart';
import '../widgets/new_memo_modal.dart';

class MemoListScreen extends StatelessWidget {
  const MemoListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<MemoNotifier>();
    final items = notifier.items;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Large title row
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 18,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'メモ',
                    style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700),
                  ),
                  TextButton(onPressed: () {}, child: const Text('編集')),
                ],
              ),
            ),

            // Search field
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
              child: notifier.loading
                  ? const Center(child: CircularProgressIndicator())
                  : items.isEmpty
                  ? Center(
                      child: SizedBox(
                        width: 320,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(28),
                            child: Column(
                              children: const [
                                Icon(
                                  Icons.insert_drive_file_outlined,
                                  size: 40,
                                  color: Colors.black26,
                                ),
                                SizedBox(height: 12),
                                Text(
                                  'まだメモがありません',
                                  style: TextStyle(fontSize: 18),
                                ),
                                SizedBox(height: 6),
                                Text(
                                  '「+」ボタンから始めましょう',
                                  style: TextStyle(color: Colors.black45),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      itemBuilder: (context, index) =>
                          MemoCard(memo: items[index]),
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemCount: items.length,
                    ),
            ),
          ],
        ),
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
