import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memomemo/core/domain/memo.dart';
import '../../core/state/memo_notifier.dart';
import '../widgets/new_memo_modal.dart';
import 'package:memomemo/core/domain/mood.dart';

class MemoCard extends ConsumerWidget {
  final Memo memo;
  const MemoCard({super.key, required this.memo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: ValueKey(memo.id),
      direction: DismissDirection.startToEnd,
      background: Container(
        padding: const EdgeInsets.only(left: 20),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerLeft,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) {
        final notifier = ref.read(memoNotifierProvider.notifier);

        // 削除実行 (Future<Memo?> が返ってくる)
        notifier.delete(memo.id).then((removedMemo) {
          if (removedMemo == null) return;
          if (!context.mounted) return;

          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('メモを削除しました'),
              action: SnackBarAction(
                label: '元に戻す',
                onPressed: () {
                  // 簡易的な復元: 同じ内容で新規作成する
                  notifier.add(body: removedMemo.body, mood: removedMemo.mood);
                },
              ),
            ),
          );
        });
      },
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (_) => NewMemoModal(initial: memo),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200), // 薄い枠線を追加
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Color badge
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: memo.mood.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),

              // Body preview
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      memo.body, // TitleではなくBodyを表示
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _formatDate(memo.updatedAt),
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final d = dt.toLocal();
    final y = d.year.toString();
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y/$m/$day';
  }
}
