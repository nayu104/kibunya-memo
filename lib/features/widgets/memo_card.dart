import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memomemo/core/domain/memo.dart';
import 'package:memomemo/core/domain/mood.dart';
import '../../core/provider/memo_state.dart';
import '../widgets/new_memo_modal.dart';
import '../../core/app_colors.dart';

class MemoCard extends ConsumerWidget {
  final Memo memo;
  const MemoCard({super.key, required this.memo});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: ValueKey(memo.id),
      direction: DismissDirection.endToStart,
      background: Container(),
      secondaryBackground: Container(
        color: AppColors.delete,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(Icons.delete, color: AppColors.onDelete),
      ),
      onDismissed: (_) {
        final notifier = ref.read(memoNotifierProvider.notifier);
        notifier.delete(memo.id).then((removedMemo) {
          if (removedMemo == null || !context.mounted) return;

          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('メモを削除しました'),
              action: SnackBarAction(
                label: '元に戻す',
                onPressed: () {
                  notifier.add(body: removedMemo.body, mood: removedMemo.mood);
                },
              ),
            ),
          );
        });
      },
      child: Card(
        // ここでテーマ(app_theme.dart)の設定が勝手に適用される
        clipBehavior: Clip.antiAlias, // タップ時の波紋を角丸からはみ出させない設定
        child: InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              fullscreenDialog: true,
              builder: (_) => NewMemoModal(initial: memo),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Text(memo.mood.emoji, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        memo.body,
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
