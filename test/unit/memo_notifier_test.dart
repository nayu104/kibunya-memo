import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
//import 'package:memomemo/core/domain/memo.dart';
import 'package:memomemo/core/domain/mood.dart';
import 'package:memomemo/core/provider/memo_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // SharedPreferencesのモック（偽物）を準備
  // これがないと "MissingPluginException" エラー
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('初期状態は空であること', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    // プロバイダーの状態を読み込む
    final state = container.read(memoNotifierProvider);

    // AsyncValue.data([]) であることを確認
    expect(state.value, isEmpty);
  });

  test('メモを追加できること', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final notifier = container.read(memoNotifierProvider.notifier);

    // メモを追加
    await notifier.add(body: 'テストメモ', mood: Mood.happy);

    // 状態が更新されたか確認
    final state = container.read(memoNotifierProvider);

    // 1. エラーになっていないか
    expect(state.hasValue, true);
    // 2. リストの長さが1になっているか
    expect(state.value!.length, 1);
    // 3. 内容が正しいか
    expect(state.value!.first.body, 'テストメモ');
    expect(state.value!.first.mood, Mood.happy);
  });

  test('メモを削除できること', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier = container.read(memoNotifierProvider.notifier);

    // 1つ追加
    await notifier.add(body: '消すメモ', mood: Mood.tired);
    final addedMemo = container.read(memoNotifierProvider).value!.first;

    // 削除実行
    await notifier.delete(addedMemo.id);

    // 空になっているか確認
    final state = container.read(memoNotifierProvider);
    expect(state.value, isEmpty);
  });

  test('削除したメモを復元でき、メタデータも保持されること', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier = container.read(memoNotifierProvider.notifier);

    await notifier.add(body: '復元メモ', mood: Mood.happy);
    final original = container.read(memoNotifierProvider).value!.first;

    final removed = await notifier.delete(original.id);
    expect(removed, isNotNull);

    await notifier.restore(removed!);

    final restored = container.read(memoNotifierProvider).value!;
    expect(restored, hasLength(1));
    expect(restored.first.id, original.id);
    expect(restored.first.createdAt, original.createdAt);
    expect(restored.first.updatedAt, original.updatedAt);
  });

  test('同じメモを重複復元しないこと', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final notifier = container.read(memoNotifierProvider.notifier);

    await notifier.add(body: '重複しない', mood: Mood.calm);
    final memo = container.read(memoNotifierProvider).value!.first;

    final removed = await notifier.delete(memo.id);
    expect(removed, isNotNull);

    await notifier.restore(removed!);
    await notifier.restore(removed);

    final restored = container.read(memoNotifierProvider).value!;
    expect(restored, hasLength(1));
    expect(restored.first.id, memo.id);
  });
}
