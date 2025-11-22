import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/memo.dart';

// プロバイダー定義: アプリのどこからでもリポジトリにアクセスできるようにする
final memoRepositoryProvider = Provider<MemoRepository>((ref) {
  // main.dart で override してインスタンスを渡す想定
  throw UnimplementedError('Provider was not initialized');
});

class MemoRepository {
  static const _kKey = 'memos_v1';
  final SharedPreferences _prefs;

  MemoRepository(this._prefs);

  /// 全件取得
  List<Memo> fetchAll() {
    final raw = _prefs.getString(_kKey);
    if (raw == null) return [];
    final List<dynamic> list = jsonDecode(raw);
    return list.map((e) => Memo.fromJson(e)).toList();
  }

  /// 保存 (新規・更新・削除すべてこのメソッド経由でリスト丸ごと保存)
  Future<void> saveAll(List<Memo> memos) async {
    final raw = jsonEncode(memos.map((e) => e.toJson()).toList());
    await _prefs.setString(_kKey, raw);
  }
}
