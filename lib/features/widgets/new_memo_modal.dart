import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:memomemo/core/domain/mood.dart';
import 'package:memomemo/core/domain/memo.dart';
import '../../../../core/state/memo_notifier.dart';

class NewMemoModal extends StatefulWidget {
  final Memo? initial;
  const NewMemoModal({super.key, this.initial});

  @override
  State<NewMemoModal> createState() => _NewMemoModalState();
}

class _NewMemoModalState extends State<NewMemoModal> {
  Mood _selected = Mood.calm;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    if (initial != null) {
      _selected = initial.mood;
      _controller.text = initial.body.isNotEmpty ? initial.body : initial.title;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Fullscreen-style editor like iOS Notes
    final navigator = Navigator.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 100,
        leading: TextButton(
          onPressed: () => navigator.pop(),
          child: const Text('キャンセル', style: TextStyle(color: Colors.blue)),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final text = _controller.text.trim();
              if (text.isEmpty) return;
              final notifier = context.read<MemoNotifier>();
              if (widget.initial == null) {
                // create
                await notifier.add(text, text, _selected);
              } else {
                // update existing
                final orig = widget.initial!;
                final updated = Memo(
                  id: orig.id,
                  title: text,
                  body: text,
                  mood: _selected,
                  createdAt: orig.createdAt,
                );
                await notifier.update(updated);
              }
              if (!mounted) return;
              navigator.pop();
            },
            child: Text(
              widget.initial == null
                  ? '${_selected.emoji} 作成'
                  : '${_selected.emoji} 保存',
              style: const TextStyle(color: Colors.blue),
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
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: Mood.values.map((m) {
                final selected = m == _selected;
                return ChoiceChip(
                  label: Text('${m.emoji} ${m.label}'),
                  selected: selected,
                  onSelected: (_) => setState(() => _selected = m),
                  selectedColor: m.color.withAlpha((0.9 * 255).round()),
                  backgroundColor: Colors.white,
                );
              }).toList(),
            ),
            const SizedBox(height: 14),
            const Text('メモ', style: TextStyle(color: Colors.black54)),
            const SizedBox(height: 8),
            Expanded(
              child: TextField(
                controller: _controller,
                expands: true,
                maxLines: null,
                decoration: InputDecoration(border: InputBorder.none),
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
