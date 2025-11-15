import 'package:flutter/material.dart';
import '../../domain/models/mood.dart';

typedef MoodChanged = void Function(Mood mood);

class MoodSelector extends StatefulWidget {
  final MoodChanged? onChanged;
  const MoodSelector({super.key, this.onChanged});

  @override
  State<MoodSelector> createState() => _MoodSelectorState();
}

class _MoodSelectorState extends State<MoodSelector> {
  Mood _selected = Mood.calm;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: Mood.values.map((m) {
        final isSelected = m == _selected;
        return GestureDetector(
          onTap: () {
            setState(() => _selected = m);
            widget.onChanged?.call(m);
          },
          child: Container(
            width: 120,
            constraints: const BoxConstraints(minHeight: 72),
            decoration: BoxDecoration(
              color: isSelected ? m.color : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? Colors.orange : Colors.grey.shade200,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(m.emoji, style: const TextStyle(fontSize: 22)),
                const SizedBox(height: 6),
                Text(
                  m.label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: isSelected ? Colors.black87 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
