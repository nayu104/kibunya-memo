import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../domain/models/memo.dart';
import '../../domain/models/mood.dart';
import '../../../../core/state/memo_notifier.dart';
import '../widgets/new_memo_modal.dart';

class MemoCard extends StatelessWidget {
  final Memo memo;
  const MemoCard({super.key, required this.memo});

  String _formatDate(DateTime dt) {
    final d = dt.toLocal();
    final y = d.year.toString();
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y/$m/$day';
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(memo.id),
      direction: DismissDirection.startToEnd, // swipe right to delete
      background: Container(
        padding: const EdgeInsets.only(left: 20),
        decoration: BoxDecoration(
          color: Colors.redAccent,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerLeft,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) async {
        final notifier = context.read<MemoNotifier>();
        final removed = await notifier.delete(memo.id);
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('メモを削除しました'),
            action: SnackBarAction(
              label: '元に戻す',
              onPressed: () async {
                if (removed != null) await notifier.update(removed);
              },
            ),
          ),
        );
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
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              // color badge
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: memo.mood.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              // title and preview
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      memo.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      memo.body,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // date and chevron
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatDate(memo.createdAt),
                    style: const TextStyle(fontSize: 12, color: Colors.black45),
                  ),
                  const SizedBox(height: 6),
                  const Icon(Icons.chevron_right, color: Colors.black38),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
