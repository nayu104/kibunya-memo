import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../domain/memo.dart';
import '../domain/mood.dart';
import '../data/memo_repository.dart';

// プロバイダー定義
// UI側からは ref.watch(memoNotifierProvider) でこのNotifierの状態（リスト）を監視します。
final memoNotifierProvider = AsyncNotifierProvider<MemoNotifier, List<Memo>>(
  () {
    return MemoNotifier();
  },
);

class MemoNotifier extends AsyncNotifier<List<Memo>> {
  /// 初期化処理（コンストラクタの代わり）
  /// このプロバイダーが初めて呼ばれた時に実行され、初期データをロードします。
  @override
  Future<List<Memo>> build() async {
    return _fetchAll();
  }

  /// 内部ヘルパー: リポジトリからデータを全件取得
  /// ref.read を使うことで、DI（依存性の注入）されたリポジトリにアクセスします。
  List<Memo> _fetchAll() {
    final repository = ref.read(memoRepositoryProvider);
    return repository.fetchAll();
  }

  /// 内部ヘルパー: データを保存し、同時に画面の状態（state）も更新する
  /// これを呼ぶだけで、UIは自動的に再描画されます。
  Future<void> _saveAndRefresh(List<Memo> newMemos) async {
    final repository = ref.read(memoRepositoryProvider);

    // 1. 永続化（スマホ本体への保存）
    await repository.saveAll(newMemos);

    // 2. メモリ上の状態更新（これをするとUIが再描画される）
    // AsyncDataでラップすることで「正常にデータがある状態」として更新
    state = AsyncData(newMemos);
  }

  /// 新規作成
  /// UIからはタイトル等のパラメータを受け取り、ここでID生成や時刻注入（Memo.create）を行う。
  /// ドメインロジック（Memoの生成責任）とアプリケーションロジック（リストへの追加）を繋ぐ場所。
  Future<void> add({required String body, Mood mood = Mood.calm}) async {
    // 現在のリストを取得（ロード中などでnullの場合は空リストとする）
    final currentList = state.value ?? [];

    // ドメイン層のファクトリを使って、完全なMemoオブジェクトを生成
    final newMemo = Memo.create(
      id: const Uuid().v4(), // ここでユニークIDを発行
      body: body,
      mood: mood,
    );

    // 新しいメモを先頭に追加（スプレッド演算子を使用）
    final newList = [newMemo, ...currentList];

    // 保存と更新を実行
    await _saveAndRefresh(newList);
  }

  /// 更新
  Future<void> updateMemo(Memo updatedMemo) async {
    final currentList = state.value ?? [];

    // リストを走査し、IDが一致するものだけ新しいオブジェクトに差し替える
    final newList = [
      for (final memo in currentList)
        if (memo.id == updatedMemo.id) updatedMemo else memo,
    ];

    await _saveAndRefresh(newList);
  }

  /// 削除に成功した場合、その削除されたMemoオブジェクトを返す。
  /// これにより、UI側（SnackBar）で「元に戻す（Undo）」機能を実装可能にしている。
  Future<Memo?> delete(String id) async {
    final currentList = state.value ?? [];

    // 削除対象が存在するか確認
    final targetIndex = currentList.indexWhere((m) => m.id == id);
    if (targetIndex == -1) return null; // 見つからなければ何もしない

    final target = currentList[targetIndex];

    // IDが一致しないものだけを残す（＝一致するものを除外する）フィルタリング処理
    final newList = currentList.where((m) => m.id != id).toList();

    await _saveAndRefresh(newList);

    return target; // 削除したデータを呼び出し元に返す
  }

  Future<void> deleteAll() async {
    final repository = ref.read(memoRepositoryProvider);
    // 1. リポジトリに削除命令（スマホのデータを消す）
    await repository.deleteAll();
    // 2. メモリ上の状態も空にする（画面を空っぽにする）
    state = const AsyncData([]);
  }
}
