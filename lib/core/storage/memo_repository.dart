import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:memomemo/core/domain/memo.dart';
import 'package:memomemo/core/domain/mood.dart';

/// 永続化レイヤー: `Memo` オブジェクトの読み書きを担当します。
///
/// - 実装はシンプルに `SharedPreferences` を採用しており、内部では
///   `List<Memo>` を JSON シリアライズして1つの文字列キーに保存します。
/// - 小さめのデータセット（このアプリのメモ一覧程度）を想定しており、
///   大量データや高頻度同時更新には最適化されていません。
/// - 外部から見える責務:
///   1. 全件読み込み (`loadAll`)
///   2. 全件保存 (`saveAll`)
///   3. 新規作成 (`create`) — 先頭に挿入して保存
///   4. 更新 (`update`) — 存在すれば置換、無ければ先頭挿入
///   5. 削除 (`delete`)
class MemoRepository {
  // SharedPreferences に保存する際のキー
  static const _kKey = 'memos_v1';

  // 新しい Memo の id を作るための UUID ジェネレータ
  final Uuid _uuid = const Uuid();

  /// 保存されているメモを全て読み出して `List<Memo>` として返す。
  ///
  /// - データがなければ空リストを返す。
  /// - 内部では JSON をデコードして `Memo.fromJson` で復元する。
  Future<List<Memo>> loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kKey);
    if (raw == null) return [];
    final List<dynamic> list = jsonDecode(raw);
    return list.map((e) => Memo.fromJson(e)).toList();
  }

  /// `items` を JSON にシリアライズして SharedPreferences に保存する。
  ///
  /// - 呼び出し側は保存の失敗（例: IO エラー）をキャッチできる。
  Future<void> saveAll(List<Memo> items) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(items.map((e) => e.toJson()).toList());
    await prefs.setString(_kKey, raw);
  }

  /// 新しいメモを作成して先頭に挿入・永続化し、作成した `Memo` を返す。
  ///
  /// - 新しい id を UUID で生成する。
  /// - 最新のメモが先頭に来るよう `insert(0, ...)` して保存する。
  Future<Memo> create({
    required String title,
    String body = '',
    required Mood mood,
  }) async {
    final id = _uuid.v4();
    final memo = Memo(id: id, title: title, body: body, mood: mood);
    // 既存の全件を読み込み、先頭に追加してから保存
    final all = await loadAll();
    all.insert(0, memo);
    await saveAll(all);
    return memo;
  }

  /// 指定の `updated` を保存する。存在すれば置換、無ければ先頭に挿入する。
  ///
  /// - この実装は楽観的で、同時更新の競合解決は行わない（最後に保存した方が勝ち）。
  Future<Memo> update(Memo updated) async {
    final all = await loadAll();
    final idx = all.indexWhere((m) => m.id == updated.id);
    if (idx == -1) {
      // 見つからなければ新規として先頭に挿入
      all.insert(0, updated);
    } else {
      // 見つかればその位置を上書き
      all[idx] = updated;
    }
    await saveAll(all);
    return updated;
  }

  /// 指定した `id` のメモを削除して保存する。
  Future<void> delete(String id) async {
    final all = await loadAll();
    all.removeWhere((m) => m.id == id);
    await saveAll(all);
  }
}
