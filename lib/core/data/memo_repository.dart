import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/memo.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// プロバイダー定義: アプリのどこからでもリポジトリにアクセスできるようにする
final memoRepositoryProvider = Provider<MemoRepository>((ref) {
  // main.dart で override してインスタンスを渡す想定
  throw UnimplementedError('Provider was not initialized');
});

class MemoRepository {
  static const _kKey = 'memos_v1';
  final SharedPreferences _prefs;

  MemoRepository(this._prefs);

  Future<void> saveToCloud(List<Memo> memos) async {
    //　認証のフェーズ
    final auth = FirebaseAuth.instance;
    var user = auth.currentUser;

    if (user == null) {
      await auth.signInAnonymously();
      user = auth.currentUser;
    }
    if (user == null) {
      throw Exception('認証に失敗しました。ネットワーク接続を確認してください。');
    }

    // Firestoreへの保存フェーズ
    final uid = user.uid; // ユーザー固有のID
    final firestore = FirebaseFirestore.instance;

    // 一括書き込みの準備 (500件まで1回の通信で送れる)
    final batch = firestore.batch();

    final collectionRef = firestore
        .collection('users')
        .doc(uid)
        .collection('memos');

    for (final memo in memos) {
      final docRef = collectionRef.doc(memo.id);
      batch.set(docRef, memo.toJson());
    }
    await batch.commit();
  }

  /// 保存 (新規・更新・削除すべてこのメソッド経由でリスト丸ごと保存)
  Future<void> saveAll(List<Memo> memos) async {
    final raw = jsonEncode(memos.map((e) => e.toJson()).toList());
    await _prefs.setString(_kKey, raw);
  }

  /// 全件取得
  List<Memo> fetchAll() {
    final raw = _prefs.getString(_kKey);
    if (raw == null) return [];
    final List<dynamic> list = jsonDecode(raw);
    return list.map((e) => Memo.fromJson(e)).toList();
  }

  /// 全件削除
  Future<void> deleteAll() async {
    await _prefs.remove(_kKey);
  }
}
