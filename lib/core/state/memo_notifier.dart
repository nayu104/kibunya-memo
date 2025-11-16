import 'package:flutter/foundation.dart';
import '../../features/memo/domain/models/memo.dart';
import '../../features/memo/domain/models/mood.dart';
import '../storage/memo_repository.dart';

/// `MemoNotifier` はメモ一覧のインメモリ状態を保持し、UI に通知を
/// 行うための ChangeNotifier です。
///
/// 主な責務:
/// - `init()` でリポジトリからメモ一覧を読み込む。
/// - `add` / `update` / `delete` を通じて永続化とメモ一覧の同期を行い、
///   変更があれば `notifyListeners()` で UI を更新する。
class MemoNotifier extends ChangeNotifier {
  /// 永続化用のリポジトリ。
  final MemoRepository _repo;

  /// インメモリのメモ一覧。先頭が最新のアイテムになるように管理する。
  List<Memo> items = [];

  /// 読み込み中を示すフラグ。UI 側ではこれを見てインジケータを表示する。
  bool loading = true;

  /// リポジトリを受け取って生成する。
  MemoNotifier(this._repo);

  /// 初期化処理。リポジトリからメモを読み込み、状態を更新する。
  ///
  /// 読み込み中は [loading] を true にし、終了後に false にして通知する。
  Future<void> init() async {
    loading = true;
    notifyListeners();
    items = await _repo.loadAll();
    loading = false;
    notifyListeners();
  }

  /// 新しいメモを作成して先頭に挿入する。
  ///
  /// リポジトリに永続化した結果を受け取り、`items` を更新して通知する。
  Future<void> add(String title, String body, Mood mood) async {
    final memo = await _repo.create(title: title, body: body, mood: mood);
    items.insert(0, memo);
    notifyListeners();
  }

  /// 既存メモを更新する。存在しない場合は先頭に挿入する。
  ///
  /// リポジトリに保存した後、インメモリのリストを差し替えて通知する。
  Future<void> update(Memo updated) async {
    final memo = await _repo.update(updated);
    final idx = items.indexWhere((m) => m.id == memo.id);
    if (idx == -1) {
      // 既にリストに無ければ先頭に追加する（新規扱い）。
      items.insert(0, memo);
    } else {
      // 既存の要素を置き換える。
      items[idx] = memo;
    }
    notifyListeners();
  }

  /// 指定した ID のメモを削除する。削除したメモを返すので、呼び出し側は
  /// Undo（元に戻す）等の処理に利用できる。
  Future<Memo?> delete(String id) async {
    final idx = items.indexWhere((m) => m.id == id);
    if (idx == -1) return null;
    final removed = items.removeAt(idx);
    await _repo.delete(id);
    notifyListeners();
    return removed;
  }
}
