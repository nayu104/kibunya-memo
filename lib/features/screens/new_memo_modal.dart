import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memomemo/core/domain/mood.dart';
import 'package:memomemo/core/domain/memo.dart';
import '../../core/provider/memo_state.dart';

class NewMemoModal extends ConsumerStatefulWidget {
  final Memo? initial;
  const NewMemoModal({super.key, this.initial});

  @override
  ConsumerState<NewMemoModal> createState() => _NewMemoModalState();
}

class _NewMemoModalState extends ConsumerState<NewMemoModal> {
  Mood _selected = Mood.calm;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    if (initial != null) {
      _selected = initial.mood;
      _controller.text = initial.body;
    }
  }

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 100,
        leading: TextButton(
          onPressed: () => navigator.pop(),
          child: const Text('キャンセル'),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final text = _controller.text.trim();
              if (text.isEmpty) return;

              final notifier = ref.read(memoNotifierProvider.notifier);

              if (widget.initial == null) {
                await notifier.add(body: text, mood: _selected);
              } else {
                final updated = widget.initial!.copyWith(
                  body: text,
                  mood: _selected,
                  updatedAt: DateTime.now(), // 更新日時を更新
                );
                await notifier.updateMemo(updated);
              }

              if (!mounted) return;
              navigator.pop();
            },
            child: Text(
              widget.initial == null
                  ? '${_selected.emoji} 作成'
                  : '${_selected.emoji} 保存',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            const Text('今の気分', style: TextStyle(color: Colors.black54)),
            const SizedBox(height: 8),

            // Mood Selector
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: Mood.values.map((m) {
                final selected = m == _selected;
                return ChoiceChip(
                  label: Text('${m.emoji} ${m.label}'),
                  selected: selected, // ここで選択状態を指定
                  onSelected: (_) => setState(() => _selected = m),
                  selectedColor: m.color.withAlpha(200), // ここで色を変える
                  backgroundColor: Colors.white,
                );
              }).toList(),
            ),

            const SizedBox(height: 14),
            const Text('メモ', style: TextStyle(color: Colors.black54)),
            const SizedBox(height: 8),

            // Body Input
            Expanded(
              child: TextField(
                controller: _controller,
                expands: true,
                maxLines: null,
                textAlignVertical: TextAlignVertical.top, // 上寄せ
                decoration: const InputDecoration(
                  hintText: '今、何を考えてる？',
                  border: InputBorder.none,
                ),
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
