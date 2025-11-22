import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../domain/memo.dart';
import '../domain/mood.dart';
import '../data/memo_repository.dart';

// プロバイダー定義
final memoNotifierProvider = AsyncNotifierProvider<MemoNotifier, List<Memo>>(
  () {
    return MemoNotifier();
  },
);

class MemoNotifier extends AsyncNotifier<List<Memo>> {
  @override
  Future<List<Memo>> build() async {
    return _fetchAll();
  }

  List<Memo> _fetchAll() {
    final repository = ref.read(memoRepositoryProvider);
    return repository.fetchAll();
  }

  Future<void> _saveAndRefresh(List<Memo> newMemos) async {
    final repository = ref.read(memoRepositoryProvider);
    await repository.saveAll(newMemos);
    state = AsyncData(newMemos);
  }

  /// 新規作成
  Future<void> add({required String body, Mood mood = Mood.calm}) async {
    final currentList = state.value ?? [];
    final newMemo = Memo.create(id: const Uuid().v4(), body: body, mood: mood);
    final newList = [newMemo, ...currentList];
    await _saveAndRefresh(newList);
  }

  /// 更新
  // 【修正1】名前を updateMemo に変更して衝突を回避
  Future<void> updateMemo(Memo updatedMemo) async {
    final currentList = state.value ?? [];

    final newList = [
      for (final memo in currentList)
        if (memo.id == updatedMemo.id) updatedMemo else memo,
    ];

    await _saveAndRefresh(newList);
  }

  /// 削除
  // 【修正2】削除したメモを返すように変更（UIのUndo機能のため）
  Future<Memo?> delete(String id) async {
    final currentList = state.value ?? [];

    // 削除対象を探す
    final targetIndex = currentList.indexWhere((m) => m.id == id);
    if (targetIndex == -1) return null;

    final target = currentList[targetIndex];

    // 削除実行
    final newList = currentList.where((m) => m.id != id).toList();
    await _saveAndRefresh(newList);

    return target; // 削除したデータを返す
  }
}
