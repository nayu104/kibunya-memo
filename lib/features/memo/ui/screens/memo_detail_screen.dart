import 'package:flutter/material.dart';
import '../../domain/models/memo.dart';
import '../../domain/models/mood.dart';

class MemoDetailScreen extends StatelessWidget {
  final Memo memo;
  const MemoDetailScreen({super.key, required this.memo});

  String _formatDate(DateTime dt) {
    final d = dt.toLocal();
    final y = d.year.toString();
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y/$m/$day';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [TextButton(onPressed: () {}, child: const Text('編集'))],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 6),
              Text(
                memo.title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    _formatDate(memo.createdAt),
                    style: const TextStyle(color: Colors.black45),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${memo.mood.emoji} ${memo.mood.label}',
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                memo.body,
                style: const TextStyle(fontSize: 17, height: 1.45),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
