import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../../features/memo/domain/models/memo.dart';
import '../../features/memo/domain/models/mood.dart';

class MemoRepository {
  static const _kKey = 'memos_v1';
  final Uuid _uuid = const Uuid();

  Future<List<Memo>> loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kKey);
    if (raw == null) return [];
    final List<dynamic> list = jsonDecode(raw);
    return list.map((e) => Memo.fromJson(e)).toList();
  }

  Future<void> saveAll(List<Memo> items) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(items.map((e) => e.toJson()).toList());
    await prefs.setString(_kKey, raw);
  }

  Future<Memo> create({
    required String title,
    String body = '',
    required Mood mood,
  }) async {
    final id = _uuid.v4();
    final memo = Memo(id: id, title: title, body: body, mood: mood);
    final all = await loadAll();
    all.insert(0, memo);
    await saveAll(all);
    return memo;
  }

  Future<Memo> update(Memo updated) async {
    final all = await loadAll();
    final idx = all.indexWhere((m) => m.id == updated.id);
    if (idx == -1) {
      // if not found, insert at top
      all.insert(0, updated);
    } else {
      all[idx] = updated;
    }
    await saveAll(all);
    return updated;
  }

  Future<void> delete(String id) async {
    final all = await loadAll();
    all.removeWhere((m) => m.id == id);
    await saveAll(all);
  }
}
